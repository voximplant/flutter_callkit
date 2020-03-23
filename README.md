# flutter_callkit

Flutter SDK for CallKit integration to Flutter applications on iOS

Supported on iOS >= 10

## Install
1. Add `flutter_callkit` as a dependency in your pubspec.yaml file.

2. Add the following entry to your `Info.plist` file, located in `<project root>/ios/Runner/Info.plist`:
```
<key>UIBackgroundModes</key>
<array>
	<string>voip</string>
</array>
```
This entry required for CallKit to work

## Usage

API of the SDK is designed as close as possible to CallKit iOS Framework.

CallKit documentation can be found [here](https://developer.apple.com/documentation/callkit)

A few differences explained:

- Use reportNewIncomingCallWithUUID native iOS method of FlutterCallkitPlugin to report new incoming call received via VoIP push notification
- Use FCXPlugin.didDisplayIncomingCall (dart) handle incoming call reported with reportNewIncomingCallWithUUID
- Use FCXPlugin.logLevel (dart) to adjust logging
- Use FCXPlugin.processPushCompletion (dart) to execute completion block received from push (iOS 11+ only)
- FCXCallController and FCXProvider are only allowed in single instance (use it as a singletone)

#### Initialization
```dart
import 'package:flutter_callkit/flutter_callkit.dart';

// init main plugin class:
FCXPlugin _plugin = FCXPlugin();
// init main CallKit classes:
FCXProvider _provider = FCXProvider();
FCXCallController _callController = FCXCallController();
// at this point CallKit classes are not ready yet
// configure it to use:
try {
  await _callController.configure();
  await _provider.configure(FCXProviderConfiguration('ExampleLocalizedName'));
} catch (_) {
  // handle exception
}
```

#### Making outgoing calls
To make an outgoing call, an app requests a FCXStartCallAction object from its FCXCallController object.
The action consists of a UUID to uniquely identify the call and a FCXHandle object to specify the recipient.
```dart
Future<void> makeCall(String contactName, String uuid) async {
  FCXHandle handle = FCXHandle(FCXHandleType.Generic, contactName);
  FCXStartCallAction action = FCXStartCallAction(uuid, handle);
  await _callController.requestTransactionWithAction(action);
}
```

After the recipient answers the call, the system calls the provider's performAnswerCallAction method.
In your implementation of that method, configure an AVAudioSession and call the fulfill() method 
on the action object when finished.

```dart
_provider.performAnswerCallAction = (answerCallAction) async {
  // configure audio session
  await answerCallAction.fulfill();
};
```

#### Receiving an Incoming Call

Using the information provided by the external notification, 
the app creates a UUID and a CXCallUpdate object to uniquely identify the call and the caller,
and passes them both to the provider using the reportNewIncomingCall() method.

```dart
Future<void> handleIncomingCall(String contactName, String uuid) async {
  FCXCallUpdate callUpdate = FCXCallUpdate(localizedCallerName: contactName);
  await _provider.reportNewIncomingCall(uuid, callUpdate);
}
```

After the call is connected, the system calls the performStartCallAction method of the provider.
In your implementation, this method responsible for configuring an AVAudioSession
and calling fulfill() on the action when finished.

```dart
_provider.performStartCallAction = (startCallAction) async {
  // configure audio session
  await startCallAction.fulfill();
};
```

#### Handling push notifications

Note: This SDK is not related to PushKit

Push handling must be done through native iOS code due to [iOS 13 PushKit VoIP restrictions](https://developer.apple.com/documentation/pushkit/pkpushregistrydelegate/2875784-pushregistry).

Flutter CallKit SDK has built-in reportNewIncomingCallWithUUID:callUpdate:providerConfiguration:pushProcessingCompletion:) method (iOS) to correctly work with it

```objective-c
#import <Flutter/Flutter.h>
#import <FlutterCallkitPlugin.h>
#import <PushKit/PushKit.h>
#import <CallKit/CallKit.h>

@interface AppDelegate : FlutterAppDelegate<PKPushRegistryDelegate>

@end

@implementation AppDelegate

// 1. override PKPushRegistryDelegate methods
- (void)             pushRegistry:(PKPushRegistry *)registry 
didReceiveIncomingPushWithPayload:(PKPushPayload *)payload 
                          forType:(PKPushType)type {
    [self processPushWithPayload:payload.dictionaryPayload 
            andCompletionHandler:nil];
}

- (void)             pushRegistry:(PKPushRegistry *)registry 
didReceiveIncomingPushWithPayload:(PKPushPayload *)payload
                          forType:(PKPushType)type 
            withCompletionHandler:(void (^)(void))completion {
    [self processPushWithPayload:payload.dictionaryPayload
            andCompletionHandler:completion];
}

// 2. process push
-(void)processPushWithPayload:(NSDictionary *)payload 
         andCompletionHandler:(dispatch_block_t)completion {
    // 3. get uuid and other needed information from payload
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:payload[@"UUID"]];
    NSString *localizedName = payload[@"identifier"];
    // 4. prepare call update
    CXCallUpdate *callUpdate = [CXCallUpdate new];
    callUpdate.localizedCallerName = localizedName;
    // 5. prepare provider configuration
    CXProviderConfiguration *configuration = 
        [[CXProviderConfiguration alloc] 
              initWithLocalizedName:@"ExampleLocalizedName"];
    // 6. send it to plugin
    [FlutterCallkitPlugin reportNewIncomingCallWithUUID:UUID
                                             callUpdate:callUpdate
                                  providerConfiguration:configuration
                               pushProcessingCompletion:completion];
}
@end
```

At this point CallKit will be set up to handle incoming call and will present its UI.

didDisplayIncomingCall of FCXPlugin will be called in dart code.

Call processPushCompletion from dart code once call successfully connected.
