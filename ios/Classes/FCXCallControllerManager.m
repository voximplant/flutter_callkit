/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "FCXCallControllerManager.h"
#import "CXAction+ConvertToDictionary.h"
#import "FlutterError+FlutterCallKitError.h"
#import "CXCall+ConvertToDictionary.h"
#import "NullChecks.h"

@interface FCXCallControllerManager ()

@property(strong, nonatomic, nullable) CXCallController *callController;
@property(strong, nonatomic, nullable) FlutterEventChannel *eventChannel;
@property(strong, nonatomic, nullable) FlutterEventSink eventSink;

@end


@implementation FCXCallControllerManager

- (instancetype)initWithPlugin:(FlutterCallkitPlugin *)plugin {
    self = [super init];
    if (self) {
        self.eventChannel = [FlutterEventChannel eventChannelWithName:@"plugins.voximplant.com/call_controller_events"
                                                      binaryMessenger:plugin.registrar.messenger];
        [self.eventChannel setStreamHandler:self];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *method = call.method;
    
    if ([@"CallController.configure" isEqualToString:method]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.callController = [CXCallController new];
            [self.callController.callObserver setDelegate:self queue:nil];
        });
        result(nil);
        
    } else if ([@"CallController.requestTransactionWithAction" isEqualToString:method]) {
        NSDictionary *data = call.arguments;
        [self requestTransactionWithActionDictionary:data result:result];
        
    } else if ([@"CallController.requestTransactionWithActions" isEqualToString:method]) {
        NSArray *data = call.arguments;
        [self requestTransactionWithActionsArray:data result:result];
        
    } else if ([@"CallController.getCalls" isEqualToString:method]) {
        NSMutableArray <NSDictionary *> *calls = [NSMutableArray new];
        for (CXCall *call in self.callController.callObserver.calls) {
            [calls addObject:[call toDictionary]];
        }
        result(calls);
    }
    
    else {
        result([FlutterError errorImplementationNotFoundForMethod:method]);
    }
}

#pragma mark - CXCallObserverDelegate -
- (void)callObserver:(nonnull CXCallObserver *)callObserver callChanged:(nonnull CXCall *)call {
    if (self.eventSink) {
        self.eventSink(@{
            @"event": @"callChanged",
            @"call": [call toDictionary]
        });
    }
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

#pragma mark - Private -
- (void)requestTransactionWithActionDictionary:(NSDictionary *)actionDictionary
                                        result:(FlutterResult)result
{
    if (!self.callController) {
        result([FlutterError errorCallControllerMissing]);
        return;
    }
    
    CXAction *action = [[CXAction alloc] initWithDictionary:actionDictionary];
    
    if (isNull(action)) {
        result([FlutterError errorBuildingAction]);
        return;
    }
    
    if (@available(iOS 11.0, *)) {
        [self.callController requestTransactionWithAction:action
                                               completion:^(NSError * _Nullable error) {
            result(error ? [FlutterError errorFromCallKitError:error] : nil);
        }];
        
    } else {
        [self.callController requestTransaction:[[CXTransaction alloc] initWithAction:action]
                                     completion:^(NSError * _Nullable error) {
            result(error ? [FlutterError errorFromCallKitError:error] : nil);
        }];
    }
}

- (void)requestTransactionWithActionsArray:(NSArray *)actionsArray
                                    result:(FlutterResult)result
{
    if (!self.callController) {
        result([FlutterError errorCallControllerMissing]);
        return;
    }
    
    if (isNull(actionsArray) || actionsArray.count == 0) {
        result([FlutterError errorBuildingAction]);
        return;
    }
    
    NSMutableArray *actions = [NSMutableArray new];
    
    for (NSDictionary *actionDictionary in actionsArray) {
        if (isNotNull(actionDictionary)) {
            [actions addObject:[[CXAction alloc] initWithDictionary:actionDictionary]];
        }
    }

    if (actions.count == 0) {
        result([FlutterError errorBuildingAction]);
        return;
    }
    
    if (@available(iOS 11.0, *)) {
        [self.callController requestTransactionWithActions:actions
                                                completion:^(NSError * _Nullable error) {
            result(error ? [FlutterError errorFromCallKitError:error] : nil);
        }];
    } else {
        [self.callController requestTransaction:[[CXTransaction alloc] initWithActions:actions]
                                     completion:^(NSError * _Nullable error) {
            result(error ? [FlutterError errorFromCallKitError:error] : nil);
        }];
    }
}

@end


