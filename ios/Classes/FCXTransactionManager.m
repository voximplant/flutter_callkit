/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "FCXTransactionManager.h"
#import "CXAction+ConvertToDictionary.h"
#import "FlutterError+FlutterCallKitError.h"
#import "NullChecks.h"

@interface FCXTransactionManager ()

@property(strong, nonatomic, nonnull) FlutterCallkitPlugin* plugin;

@end


@implementation FCXTransactionManager

- (instancetype)initWithPlugin:(FlutterCallkitPlugin *)plugin {
    self = [super init];
    if (self) {
        self.plugin = plugin;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!self.plugin.provider) {
        result([FlutterError errorProviderMissing]);
        return;
    }
    
    NSString *method = call.method;
    
    if ([@"Transaction.getActions" isEqualToString:method]) {
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
        
        for (CXTransaction* pendingTransaction in self.plugin.provider.pendingTransactions) {
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
    }
    
    else {
        result([FlutterError errorImplementationNotFoundForMethod:method]);
    }
}

@end
