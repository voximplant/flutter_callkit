/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterError (FlutterCallKitError)

+ (instancetype)errorProviderConfigurationNotFound;
+ (instancetype)errorProviderMissing;
+ (instancetype)errorCallControllerMissing;
+ (instancetype)errorTransactionNotFound;
+ (instancetype)errorBuildingAction;
+ (instancetype)errorActionNotFound;
+ (instancetype)errorUUIDNotFound;
+ (instancetype)errorBuildingUUID;
+ (instancetype)errorCallUpdateNotFound;
+ (instancetype)errorPushCompletionNotFound;
+ (instancetype)errorImplementationNotFoundForMethod:(NSString *)method;
+ (instancetype)errorFromCallKitError:(NSError *)error;
+ (instancetype)errorInvalidArguments:(NSString *)reason;
+ (instancetype)errorHandlerIsNotRegistered:(NSString *)handler;
+ (instancetype)errorLowiOSVersionWithMinimal:(NSString *)minimal;

@end

NS_ASSUME_NONNULL_END
