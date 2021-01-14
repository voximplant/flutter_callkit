/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FCXTransactionManager.h"
#import "CXAction+ConvertToDictionary.h"
#import "FlutterError+FlutterCallKitError.h"
#import "NullChecks.h"

@interface FCXTransactionManager ()

@property(strong, nonatomic, nonnull, readonly) CXProvider *provider;

@end

@implementation FCXTransactionManager

- (void)configureWithProvider:(CXProvider *)provider {
    _provider = provider;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!_provider) {
        result([FlutterError errorProviderMissing]);
        return;
    }
    
    NSString *method = call.method;
    
    if ([@"getActions" isEqualToString:method]) {
        NSDictionary *data = call.arguments;
        
        NSString *transactionUUIDString = data[@"transactionUuid"];
        if (isNull(transactionUUIDString)) {
            result([FlutterError errorUUIDNotFound]);
            return;
        }
        NSUUID *transactionUUID = [[NSUUID alloc] initWithUUIDString:transactionUUIDString];
        if (!transactionUUID) {
            result([FlutterError errorBuildingUUID]);
            return;
        }
        
        for (CXTransaction* pendingTransaction in _provider.pendingTransactions) {
            if ([pendingTransaction.UUID isEqual:transactionUUID]) {
                NSMutableArray *actions = [NSMutableArray new];
                for (CXAction *action in pendingTransaction.actions) {
                    [actions addObject:[action toDictionary]];
                }
                result(actions);
                return;
            }
        }
        result([FlutterError errorTransactionNotFound]);
    } else {
        result([FlutterError errorImplementationNotFoundForMethod:method]);
    }
}

@end
