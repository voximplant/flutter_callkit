/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "FlutterCallkitPlugin.h"
#import "NullChecks.h"
#import "FCXCallControllerManager.h"
#import "FCXProviderManager.h"
#import "FCXTransactionManager.h"
#import "FCXActionManager.h"
#import "CXCallUpdate+ConvertToDictionary.h"
#import "FlutterError+FlutterCallKitError.h"

typedef NSString *FCXMethodType NS_TYPED_ENUM;
static FCXMethodType const FCXMethodTypeProvider = @"Provider";
static FCXMethodType const FCXMethodTypeCallController = @"CallController";
static FCXMethodType const FCXMethodTypeAction = @"Action";
static FCXMethodType const FCXMethodTypeTransaction = @"Transaction";

@interface FlutterCallkitPlugin ()

@property(strong, nonatomic, nullable) NSObject<FlutterPluginRegistrar> *registrar;
@property(strong, nonatomic, nullable) CXCallController *callController;
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

+ (instancetype)sharedPluginWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    static FlutterCallkitPlugin *instance;
    static dispatch_once_t initToken;
    dispatch_once(&initToken, ^{
        instance = [FlutterCallkitPlugin new];
    });
    if (registrar) {
        [instance updateWithRegistrar:registrar
                             provider:instance.providerManager.provider];
    }
    return instance;
}

- (void)updateWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
                   provider:(CXProvider *)provider {
    self.registrar = registrar;
    self.eventChannel = [FlutterEventChannel eventChannelWithName:@"plugins.voximplant.com/plugin_events"
                                                  binaryMessenger:registrar.messenger];
    [self.eventChannel setStreamHandler:self];
    self.callControllerManager = [[FCXCallControllerManager alloc] initWithPlugin:self];
    self.providerManager = [[FCXProviderManager alloc] initWithPlugin:self];
    if (provider) {
        [self.providerManager configureWithProvider:provider];
    }
    self.transactionManager = [[FCXTransactionManager alloc] initWithPlugin:self];
    self.actionManager = [[FCXActionManager alloc] initWithPlugin:self];
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"plugins.voximplant.com/flutter_callkit"
                                                                binaryMessenger:[registrar messenger]];
    FlutterCallkitPlugin* instance = [FlutterCallkitPlugin sharedPluginWithRegistrar:registrar];
    
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([self isMethodCallOfType:FCXMethodTypeProvider call:call]) {
        [self.providerManager handleMethodCall:call result:result];
        
    } else if ([self isMethodCallOfType:FCXMethodTypeCallController call:call]) {
        [self.callControllerManager handleMethodCall:call result:result];
        
    } else if ([self isMethodCallOfType:FCXMethodTypeTransaction call:call]) {
        [self.transactionManager handleMethodCall:call result:result];
        
    } else if ([self isMethodCallOfType:FCXMethodTypeAction call:call]) {
        [self.actionManager handleMethodCall:call result:result];
        
    } else if ([call.method isEqualToString:@"processPushCompletion"]) {
        if (self.pushProcessingCompletion) {
            self.pushProcessingCompletion();
            result(nil);
        } else {
            result([FlutterError errorPushCompletionNotFound]);
        }
    } else {
        result([FlutterError errorImplementationNotFoundForMethod:call.method]);
    }
}

- (BOOL)isMethodCallOfType:(FCXMethodType)type call:(FlutterMethodCall *)call {
    NSString *separator = @".";
    NSString *methodName = call.method;
    NSArray<NSString *> *methodNameComponents = [methodName componentsSeparatedByString:separator];
    
    return isNotNull(methodNameComponents) && methodNameComponents.firstObject
    ? [methodNameComponents.firstObject isEqualToString:type]
    : NO;
}

+ (BOOL)hasCallWithUUID:(nonnull NSUUID *)UUID {
    FlutterCallkitPlugin *plugin = [FlutterCallkitPlugin sharedPluginWithRegistrar:nil];
    if (!plugin.callController.callObserver.calls || plugin.callController.callObserver.calls.count == 0) {
        return false;
    }
    for (CXCall *call in plugin.callController.callObserver.calls) {
        if ([call.UUID isEqual:UUID]) {
            return true;
        }
    }
    return false;
}

+ (void)reportNewIncomingCallWithUUID:(nonnull NSUUID *)UUID
                           callUpdate:(nonnull CXCallUpdate *)callUpdate
                providerConfiguration:(nonnull CXProviderConfiguration *)providerConfiguration
             pushProcessingCompletion:(nullable dispatch_block_t)pushProcessingCompletion {
    FlutterCallkitPlugin *plugin = [FlutterCallkitPlugin sharedPluginWithRegistrar:nil];
    plugin.pushProcessingCompletion = pushProcessingCompletion;
    [plugin.providerManager configureWithProviderConfiguration:providerConfiguration];
    [plugin.provider reportNewIncomingCallWithUUID:UUID
                                            update:callUpdate
                                        completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Flutter CallKit: reportNewIncomingCallWithUUID error > %@", error.localizedDescription);
        } else {
            if (plugin.eventSink) {
                plugin.eventSink(@{
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
