/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FCXActionManager.h"
#import "CXAction+ConvertToDictionary.h"
#import "FlutterError+FlutterCallKitError.h"
#import "NullChecks.h"
#import "NSISO8601DateFormatter+WithoutMS.h"

@interface FCXActionManager ()

@property(strong, nonatomic, nonnull, readonly) CXProvider *provider;

@end

@implementation FCXActionManager

- (void)configureWithProvider:(CXProvider *)provider {
    _provider = provider;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!_provider) {
        result([FlutterError errorProviderMissing]);
        return;
    }
    
    NSString *method = call.method;
    
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
    
    if ([@"fulfill" isEqualToString:method]) {
        CXAction *action = [self findActionWithUUID:UUID];
        if (action) {
            [action fulfill];
            result(nil);
        } else {
            result([FlutterError errorActionNotFound]);
        }
        
    } else if ([@"fulfillWithDateConnected" isEqualToString:method]) {
        CXAction *action = [self findActionWithUUID:UUID];
        if (action && [action isKindOfClass:CXAnswerCallAction.class]) {
            NSString *dateConnectedString = data[@"dateConnected"];
            NSDate *dateConnected = isNotNull(dateConnectedString)
                ? [NSISO8601DateFormatter dateFromStringWithoutMS:dateConnectedString]
                : [NSDate new];
            CXAnswerCallAction *castedAction = (CXAnswerCallAction *)action;
            [castedAction fulfillWithDateConnected:dateConnected];
            result(nil);
        } else {
            result([FlutterError errorActionNotFound]);
        }
        
    } else if ([@"fulfillWithDateEnded" isEqualToString:method]) {
        CXAction *action = [self findActionWithUUID:UUID];
        if (action && [action isKindOfClass:CXEndCallAction.class]) {
            NSString *dateEndedString = data[@"dateEnded"];
            NSDate *dateEnded = isNotNull(dateEndedString)
                ? [NSISO8601DateFormatter dateFromStringWithoutMS:dateEndedString]
                : [NSDate new];
            CXEndCallAction *castedAction = (CXEndCallAction *)action;
            [castedAction fulfillWithDateEnded:dateEnded];
            result(nil);
        } else {
            result([FlutterError errorActionNotFound]);
        }
        
    } else if ([@"fulfillWithDateStarted" isEqualToString:method]) {
        CXAction *action = [self findActionWithUUID:UUID];
        if (action && [action isKindOfClass:CXStartCallAction.class]) {
            NSString *dateStartedString = data[@"dateStarted"];
            NSDate *dateStarted = isNotNull(dateStartedString)
                ? [NSISO8601DateFormatter dateFromStringWithoutMS:dateStartedString]
                : [NSDate new];
            CXStartCallAction *castedAction = (CXStartCallAction *)action;
            [castedAction fulfillWithDateStarted:dateStarted];
            result(nil);
        } else {
            result([FlutterError errorActionNotFound]);
        }
        
    } else if ([@"fail" isEqualToString:method]) {
        CXAction *action = [self findActionWithUUID:UUID];
        if (action) {
            [action fail];
            result(nil);
        } else {
            result([FlutterError errorActionNotFound]);
        }
    }
    
    else {
        result([FlutterError errorImplementationNotFoundForMethod:method]);
    }
}

#pragma mark - Private -
- (nullable CXAction *)findActionWithUUID:(NSUUID *)UUID {
    NSArray <CXTransaction *> *pendingTransactions = _provider.pendingTransactions;
    
    if (pendingTransactions.count == 0) {
        return nil;
    }
    
    NSMutableArray *pendingActions = [NSMutableArray new];
    for (CXTransaction *transaction in pendingTransactions) {
        [pendingActions addObjectsFromArray:transaction.actions];
    }
    
    if (pendingActions.count == 0) {
        return nil;
    }
    
    for (CXAction *pendingAction in pendingActions) {
        if ([pendingAction.UUID isEqual:UUID]) {
            return pendingAction;
        }
    }
    
    return nil;
}

@end
