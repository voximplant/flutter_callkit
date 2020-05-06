/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import <Flutter/Flutter.h>
#import <CallKit/CallKit.h>

NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(10.0))
@interface FlutterCallkitPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>

@property(strong, nonatomic, nullable, readonly) NSObject<FlutterPluginRegistrar> *registrar;
@property(strong, nonatomic, nullable, readonly) CXProvider *provider;

+ (BOOL)hasCallWithUUID:(nonnull NSUUID *)UUID;

+ (void)reportNewIncomingCallWithUUID:(nonnull NSUUID *)UUID
                           callUpdate:(nonnull CXCallUpdate *)callUpdate
                providerConfiguration:(nonnull CXProviderConfiguration *)providerConfiguration
             pushProcessingCompletion:(nullable dispatch_block_t)pushProcessingCompletion;

@end
NS_ASSUME_NONNULL_END
