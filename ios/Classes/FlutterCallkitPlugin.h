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

+ (void)reportNewIncomingCallWithUUID:(NSUUID *)UUID
                           callUpdate:(CXCallUpdate *)callUpdate
                providerConfiguration:(CXProviderConfiguration *)providerConfiguration
             pushProcessingCompletion:(dispatch_block_t)pushProcessingCompletion;

@end
NS_ASSUME_NONNULL_END
