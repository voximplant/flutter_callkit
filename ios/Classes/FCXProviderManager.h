/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FlutterCallkitPlugin.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(10.0))
@interface FCXProviderManager : NSObject<FlutterStreamHandler, CXProviderDelegate>

@property (strong, nonatomic, nullable, readonly) CXProvider *provider;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger
           providerCreatedHandler:(void (^)(CXProvider *provider))providerCreatedHandler;
- (void)configureWithProviderConfiguration:(CXProviderConfiguration *)configuration;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
