/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FlutterCallkitPlugin.h"
#import "NullChecks.h"
#import "FCXCallControllerManager.h"
#import "FCXProviderManager.h"
#import "FCXTransactionManager.h"
#import "FCXActionManager.h"
#import "CXCallUpdate+ConvertToDictionary.h"
#import "FlutterError+FlutterCallKitError.h"
#import "FlutterMethodCall+MethodType.h"
#import "FCXIdentifiablePhoneNumber.h"

@interface FlutterCallkitPlugin ()

@property(strong, nonatomic, nullable) NSObject<FlutterPluginRegistrar> *registrar;
@property(strong, nonatomic, nullable, readonly) CXCallController *callController;
@property(strong, nonatomic, nullable, readonly) CXProvider *provider;
@property(strong, nonatomic, nonnull) FCXCallControllerManager *callControllerManager;
@property(strong, nonatomic, nonnull) FCXProviderManager *providerManager;
@property(strong, nonatomic, nonnull) FCXTransactionManager *transactionManager;
@property(strong, nonatomic, nonnull) FCXActionManager *actionManager;
@property(strong, nonatomic, nullable) dispatch_block_t pushProcessingCompletion;

@property(strong, nonatomic, nullable) FlutterEventChannel *eventChannel;
@property(strong, nonatomic, nullable) FlutterEventSink eventSink;

@end

@implementation FlutterCallkitPlugin

- (CXProvider *)provider {
    return self.providerManager.provider;
}

- (CXCallController *)callController {
    return self.callControllerManager.callController;
}

+ (FlutterCallkitPlugin *)sharedInstance {
    return [FlutterCallkitPlugin sharedPluginWithRegistrar:nil];
}

+ (instancetype)sharedPluginWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    static FlutterCallkitPlugin *instance;
    static dispatch_once_t initToken;
    dispatch_once(&initToken, ^{
        instance = [[FlutterCallkitPlugin alloc] init];
    });
    if (registrar) {
        instance.registrar = registrar;
        instance.eventChannel = [FlutterEventChannel eventChannelWithName:@"plugins.voximplant.com/plugin_events"
                                                          binaryMessenger:registrar.messenger];
        [instance.eventChannel setStreamHandler:instance];
        instance.callControllerManager = [[FCXCallControllerManager alloc] initWithMessenger:registrar.messenger];
        instance.transactionManager = [[FCXTransactionManager alloc] init];
        instance.actionManager = [[FCXActionManager alloc] init];
        instance.providerManager = [[FCXProviderManager alloc] initWithMessenger:registrar.messenger
                                                          providerCreatedHandler:^(CXProvider * _Nonnull provider) {
            [instance.transactionManager configureWithProvider:provider];
            [instance.actionManager configureWithProvider:provider];
        }];
    }
    return instance;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"plugins.voximplant.com/flutter_callkit"
                                                                binaryMessenger:[registrar messenger]];
    FlutterCallkitPlugin *instance = [FlutterCallkitPlugin sharedPluginWithRegistrar:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call isMethodCallOfType:FCXMethodTypeProvider]) {
        [self.providerManager handleMethodCall:call.excludingType result:result];

    } else if ([call isMethodCallOfType:FCXMethodTypeCallController]) {
        [self.callControllerManager handleMethodCall:call.excludingType result:result];

    } else if ([call isMethodCallOfType:FCXMethodTypeTransaction]) {
        [self.transactionManager handleMethodCall:call.excludingType result:result];

    } else if ([call isMethodCallOfType:FCXMethodTypeAction]) {
        [self.actionManager handleMethodCall:call.excludingType result:result];

    } else if ([call isMethodCallOfType:FCXMethodTypePlugin]) {
        [self handlePluginMethodCall:call.excludingType result:result];

    } else {
        result([FlutterError errorImplementationNotFoundForMethod:call.method]);
    }
}

- (void)handlePluginMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *method = call.method;
    if ([@"processPushCompletion" isEqualToString:method]) {
        if (self.pushProcessingCompletion) {
            self.pushProcessingCompletion();
            result(nil);
        } else {
            result([FlutterError errorPushCompletionNotFound]);
        }

    } else if ([@"getBlockedPhoneNumbers" isEqualToString:method]) {
        if (!self.getBlockedPhoneNumbers) {
            result([FlutterError errorHandlerIsNotRegistered:@"getBlockedPhoneNumbers"]);
            return;
        }
        NSArray<FCXCallDirectoryPhoneNumber *> *blockedNumbers = self.getBlockedPhoneNumbers();
        __block NSMutableArray<NSNumber *> *phoneNumbers = [NSMutableArray array];
        [blockedNumbers enumerateObjectsUsingBlock:^(FCXCallDirectoryPhoneNumber * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
            [phoneNumbers addObject:[NSNumber numberWithLongLong:number.number]];
        }];
        result(phoneNumbers);

    } else if ([@"addBlockedPhoneNumbers" isEqualToString:method]) {
        NSArray<NSNumber *> *numbers = call.arguments;
        if (isNull(numbers)) {
            result([FlutterError errorInvalidArguments:@"numbers must not be null"]);
            return;
        }
        __block NSMutableArray<FCXCallDirectoryPhoneNumber *> *phoneNumbers = [NSMutableArray array];
        [numbers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
            [phoneNumbers addObject:[[FCXCallDirectoryPhoneNumber alloc] initWithNumber:(number.longLongValue)]];
        }];
        if (self.didAddBlockedPhoneNumbers) {
            self.didAddBlockedPhoneNumbers(phoneNumbers);
            result(nil);
        } else {
            result([FlutterError errorHandlerIsNotRegistered:@"didAddBlockedPhoneNumbers"]);
        }

    } else if ([@"removeBlockedPhoneNumbers" isEqualToString:method]) {
        NSArray<NSNumber *> *numbers = call.arguments;
        if (isNull(numbers)) {
            result([FlutterError errorInvalidArguments:@"numbers must not be null"]);
            return;
        }
        __block NSMutableArray<FCXCallDirectoryPhoneNumber *> *phoneNumbers = [NSMutableArray array];
        [numbers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
            [phoneNumbers addObject:[[FCXCallDirectoryPhoneNumber alloc] initWithNumber:(number.longLongValue)]];
        }];
        if (self.didRemoveBlockedPhoneNumbers) {
            self.didRemoveBlockedPhoneNumbers(phoneNumbers);
            result(nil);
        } else {
            result([FlutterError errorHandlerIsNotRegistered:@"didRemoveBlockedPhoneNumbers"]);
        }

    } else if ([@"removeAllBlockedPhoneNumbers" isEqualToString:method]) {
        if (self.didRemoveAllBlockedPhoneNumbers) {
            self.didRemoveAllBlockedPhoneNumbers();
            result(nil);
        } else {
            result([FlutterError errorHandlerIsNotRegistered:@"didRemoveAllBlockedPhoneNumbers"]);
        }

    } else if ([@"getIdentifiablePhoneNumbers" isEqualToString:method]) {
        if (!self.getIdentifiablePhoneNumbers) {
            result([FlutterError errorHandlerIsNotRegistered:@"getIdentifiablePhoneNumbers"]);
            return;
        }
        NSArray<FCXIdentifiablePhoneNumber *> *identifiableNumbers = self.getIdentifiablePhoneNumbers();
        __block NSMutableArray<NSDictionary *> *phoneNumbers = [NSMutableArray array];
        [identifiableNumbers enumerateObjectsUsingBlock:^(FCXIdentifiablePhoneNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            dictionary[@"number"] = [NSNumber numberWithLongLong:obj.number];
            dictionary[@"label"] = obj.label;
            [phoneNumbers addObject:dictionary];
        }];
        result(phoneNumbers);

    } else if ([@"addIdentifiablePhoneNumbers" isEqualToString:method]) {
        NSArray<NSDictionary *> *numbers = call.arguments;
        if (isNull(numbers)) {
            result([FlutterError errorInvalidArguments:@"numbers must not be null"]);
            return;
        }
        __block NSMutableArray<FCXIdentifiablePhoneNumber *> *identifiableNumbers = [NSMutableArray array];
        [numbers enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number = obj[@"number"];
            __auto_type identifiableNumber = [[FCXIdentifiablePhoneNumber alloc] initWithNumber:number.longLongValue
                                                                                          label:obj[@"label"]];
            [identifiableNumbers addObject:identifiableNumber];
        }];
        if (self.didAddIdentifiablePhoneNumbers) {
            self.didAddIdentifiablePhoneNumbers(identifiableNumbers);
            result(nil);
        } else {
            result([FlutterError errorHandlerIsNotRegistered:@"didAddIdentifiablePhoneNumbers"]);
        }

    } else if ([@"removeIdentifiablePhoneNumbers" isEqualToString:method]) {
        NSArray<NSNumber *> *numbers = call.arguments;
        if (isNull(numbers)) {
            result([FlutterError errorInvalidArguments:@"numbers must not be null"]);
            return;
        }
        __block NSMutableArray<FCXCallDirectoryPhoneNumber *> *phoneNumbers = [NSMutableArray array];
        [numbers enumerateObjectsUsingBlock:^(NSNumber * _Nonnull number, NSUInteger idx, BOOL * _Nonnull stop) {
            [phoneNumbers addObject:[[FCXCallDirectoryPhoneNumber alloc] initWithNumber:(number.longLongValue)]];
        }];
        if (self.didRemoveIdentifiablePhoneNumbers) {
            self.didRemoveIdentifiablePhoneNumbers(phoneNumbers);
            result(nil);
        } else {
            result([FlutterError errorHandlerIsNotRegistered:@"didRemoveIdentifiablePhoneNumbers"]);
        }

    } else if ([@"removeAllIdentifiablePhoneNumbers" isEqualToString:method]) {
        if (self.didRemoveAllIdentifiablePhoneNumbers) {
            self.didRemoveAllIdentifiablePhoneNumbers();
            result(nil);
        } else {
            result([FlutterError errorHandlerIsNotRegistered:@"didRemoveAllIdentifiablePhoneNumbers"]);
        }
        
    } else if ([@"openSettings" isEqualToString:method]) {
        if (@available(iOS 13.4, *)) {
            [CXCallDirectoryManager.sharedInstance openSettingsWithCompletionHandler:^(NSError * _Nullable error) {
                if (error) {
                    result([FlutterError errorFromCallKitError:error]);
                } else {
                    result(nil);
                }
            }];
        } else {
            result([FlutterError errorLowiOSVersionWithMinimal:@"13.4"]);
        }

    } else if ([@"reloadExtension" isEqualToString:method]) {
        NSString *extensionIdentifier = call.arguments;
        if (isNull(extensionIdentifier)) {
            result([FlutterError errorInvalidArguments:@"extensionIdentifier must not be null"]);
            return;
        }
        [CXCallDirectoryManager.sharedInstance reloadExtensionWithIdentifier:extensionIdentifier
                                                           completionHandler:^(NSError * _Nullable error) {
            if (error) {
                result([FlutterError errorFromCallKitError:error]);
            } else {
                result(nil);
            }
        }];

    } else if ([@"getEnabledStatus" isEqualToString:method]) {
        NSString *extensionIdentifier = call.arguments;
        if (isNull(extensionIdentifier)) {
            result([FlutterError errorInvalidArguments:@"extensionIdentifier must not be null"]);
            return;
        }
        [CXCallDirectoryManager.sharedInstance getEnabledStatusForExtensionWithIdentifier:extensionIdentifier
                                                                        completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error)
         {
            if (error) {
                result([FlutterError errorFromCallKitError:error]);
            } else {
                result([self convertEnableStatusToNumber:enabledStatus]);
            }
        }];
    }
}

- (NSNumber *)convertEnableStatusToNumber:(CXCallDirectoryEnabledStatus)status {
    switch (status) {
        case CXCallDirectoryEnabledStatusUnknown: return [NSNumber numberWithInt:0];
        case CXCallDirectoryEnabledStatusDisabled: return [NSNumber numberWithInt:1];
        case CXCallDirectoryEnabledStatusEnabled: return [NSNumber numberWithInt:2];
    }
}

- (BOOL)hasCallWithUUID:(NSUUID *)UUID {
    if (!self.callController.callObserver.calls || self.callController.callObserver.calls.count == 0) {
        return false;
    }
    for (CXCall *call in self.callController.callObserver.calls) {
        if ([call.UUID isEqual:UUID]) {
            return true;
        }
    }
    return false;
}

- (void)reportNewIncomingCallWithUUID:(NSUUID *)UUID
                           callUpdate:(CXCallUpdate *)callUpdate
                providerConfiguration:(CXProviderConfiguration *)providerConfiguration
             pushProcessingCompletion:(dispatch_block_t)pushProcessingCompletion
{
    _pushProcessingCompletion = pushProcessingCompletion;
    [_providerManager configureWithProviderConfiguration:providerConfiguration];
    __weak typeof(self) wSelf = self;
    [self.provider reportNewIncomingCallWithUUID:UUID
                                          update:callUpdate
                                      completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Flutter CallKit: reportNewIncomingCallWithUUID error > %@", error.localizedDescription);
        } else {
            __strong typeof(wSelf) sSelf = wSelf;
            if (sSelf.eventSink) {
                sSelf.eventSink(@{
                    @"event": @"didDisplayIncomingCall",
                    @"uuid": UUID.UUIDString,
                    @"callUpdate": [callUpdate toDictionary]
                });
            }
        }
    }];
}

#pragma mark - FlutterStreamHandler -
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}

@end
