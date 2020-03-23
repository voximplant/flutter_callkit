/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "FCXProviderManager.h"
#import "CXCallUpdate+ConvertToDictionary.h"
#import "CXProviderConfiguration+ConvertToDictionary.h"
#import "CXAction+ConvertToDictionary.h"
#import "FlutterError+FlutterCallKitError.h"
#import "CXTransaction+ConvertToDictionary.h"
#import "NullChecks.h"
#import "NSISO8601DateFormatter+WithoutMS.h"

@interface FCXProviderManager()

@property(strong, nonatomic, nullable) CXProvider *provider;
@property(strong, nonatomic, nullable) FlutterEventChannel *eventChannel;
@property(strong, nonatomic, nullable) FlutterEventSink eventSink;

@end


@implementation FCXProviderManager

NSString *const CALL_UPDATE = @"callUpdate";
NSString *const EVENT = @"event";

- (instancetype)initWithPlugin:(FlutterCallkitPlugin *)plugin {
    self = [super init];
    if (self) {
        self.eventChannel = [FlutterEventChannel eventChannelWithName:@"plugins.voximplant.com/provider_events"
                                                      binaryMessenger:plugin.registrar.messenger];
        [self.eventChannel setStreamHandler:self];
    }
    return self;
}

- (void)configureWithProviderConfiguration:(CXProviderConfiguration *)configuration {
    if (self.provider) {
        [self.provider setConfiguration:configuration];
    } else {
        self.provider = [[CXProvider alloc] initWithConfiguration:configuration];
        [self.provider setDelegate:self queue:nil];
    }
}

- (void)configureWithProvider:(CXProvider *)provider {
    self.provider = provider;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *method = call.method;
    
    // handled separately because it is only case with no existing provider needed
    if ([@"Provider.configure" isEqualToString:method]) {
        NSDictionary *data = call.arguments;
        if (isNull(data)) {
            result([FlutterError errorProviderConfigurationNotFound]);
            return;
        }
        [self configureWithProviderConfiguration:[[CXProviderConfiguration alloc] initWithDictionary:data]];
        result(nil);
        return;
    }
    
    if (!self.provider) {
        result([FlutterError errorProviderMissing]);
        return;
    }
    
    // handled separately because it is only cases with no UUID needed
    if ([@"Provider.getPendingTransactions" isEqualToString:method]) {
        NSMutableArray *transactions = [NSMutableArray new];
        for (CXTransaction *transaction in self.provider.pendingTransactions) {
            [transactions addObject:[transaction toDictionary]];
        }
        result(transactions);
        return;
        
    }
    
    if ([@"Provider.invalidate" isEqualToString:method]) {
        [self.provider invalidate];
        result(nil);
        return;
    }
    
    NSDictionary *data = call.arguments;
    NSString *UUIDString = data[@"uuid"];
    if (isNull(UUIDString)) {
        result([FlutterError errorUUIDNotFound]);
        return;
    }
    NSUUID *UUID = [[NSUUID alloc] initWithUUIDString:UUIDString];
    if (!UUID) {
        result([FlutterError errorBuildingUUID]);
        return;
    }
    
    if ([@"Provider.reportNewIncomingCall" isEqualToString:method]) {
        NSDictionary *callUpdateDictionary = data[CALL_UPDATE];
        if (isNull(callUpdateDictionary)) {
            result([FlutterError errorCallUpdateNotFound]);
            return;
        }
        [self.provider reportNewIncomingCallWithUUID:UUID
                                              update:[[CXCallUpdate alloc] initWithDictionary:callUpdateDictionary]
                                          completion:^(NSError * _Nullable error) {
            result(error ? [FlutterError errorFromCallKitError:error] : nil);
        }];
        
    } else if ([@"Provider.reportCallUpdated" isEqualToString:method]) {
        NSDictionary *callUpdateDictionary = data[CALL_UPDATE];
        if (isNull(callUpdateDictionary)) {
            result([FlutterError errorCallUpdateNotFound]);
            return;
        }
        [self.provider reportCallWithUUID:UUID
                                  updated:[[CXCallUpdate alloc] initWithDictionary:callUpdateDictionary]];
        result(nil);
        
    } else if ([@"Provider.reportCallEnded" isEqualToString:method]) {
        NSString *dateEndedString = data[@"dateEnded"];
        NSDate *dateEnded;
        if (isNotNull(dateEndedString)) {
            dateEnded = [NSISO8601DateFormatter dateFromStringWithoutMS:dateEndedString];
        }
        [self.provider reportCallWithUUID:UUID
                              endedAtDate:dateEnded
                                   reason:[self convertNumberToCallEndedReason:data[@"endedReason"]]];
        result(nil);
        
    } else if ([@"Provider.reportOutgoingCall" isEqualToString:method]) {
        NSString *dateStartedConnectingString = data[ @"dateStartedConnecting"];
        NSDate *dateStartedConnecting;
        if (isNotNull(dateStartedConnectingString)) {
            dateStartedConnecting = [NSISO8601DateFormatter dateFromStringWithoutMS:dateStartedConnectingString];
        }
        [self.provider reportOutgoingCallWithUUID:UUID
                          startedConnectingAtDate:dateStartedConnecting];
        result(nil);
        
    } else if ([@"Provider.reportOutgoingCallConnected" isEqualToString:method]) {
        NSString *dateConnectedString = data[@"dateConnected"];
        NSDate *dateConnected;
        if (isNotNull(dateConnectedString)) {
            dateConnected = [NSISO8601DateFormatter dateFromStringWithoutMS:dateConnectedString];
        }
        [self.provider reportOutgoingCallWithUUID:UUID
                                  connectedAtDate:dateConnected];
        result(nil);
        
    } else {
        result([FlutterError errorImplementationNotFoundForMethod:method]);
    }
}

#pragma mark - CXProviderDelegate -
- (void)providerDidBegin:(CXProvider *)provider {
    if (self.eventSink) {
        self.eventSink(@{
            EVENT: @"providerDidBegin",
        });
    }
}

- (void)providerDidReset:(nonnull CXProvider *)provider {
    if (self.eventSink) {
        self.eventSink(@{
            EVENT: @"providerDidReset",
        });
    }
}

- (void)provider:(CXProvider *)provider timedOutPerformingAction:(CXAction *)action {
    if (self.eventSink) {
        self.eventSink(@{
            EVENT: @"timedOutPerformingAction",
            @"action": [action toDictionary]
        });
    }
}

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession {
    if (self.eventSink) {
        self.eventSink(@{
            EVENT: @"didActivateAudioSession"
        });
    }
}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession {
    if (self.eventSink) {
        self.eventSink(@{
            EVENT: @"didDeactivateAudioSession"
        });
    }
}

- (BOOL)provider:(CXProvider *)provider executeTransaction:(CXTransaction *)transaction {
    if (self.eventSink) {
        self.eventSink(@{
            EVENT: @"executeTransaction",
            @"transaction": [transaction toDictionary]
        });
    }
    return true;
}

#pragma mark - FlutterStreamHandler -
- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    self.eventSink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments
                                        eventSink:(nonnull FlutterEventSink)events {
    self.eventSink = events;
    return nil;
}

#pragma mark - Private -
- (CXCallEndedReason)convertNumberToCallEndedReason:(NSNumber *)number {
    switch ([number intValue]) {
        case 0: return CXCallEndedReasonFailed;
        case 1: return CXCallEndedReasonRemoteEnded;
        case 2: return CXCallEndedReasonUnanswered;
        case 3: return CXCallEndedReasonAnsweredElsewhere;
        case 4: return CXCallEndedReasonDeclinedElsewhere;
        default: return CXCallEndedReasonFailed;
    }
}

@end
