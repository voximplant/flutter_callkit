/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "FlutterCallkitPlugin.h"
#import <CallKit/CallKit.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(10.0))
@interface FCXProviderManager : NSObject<FlutterStreamHandler, CXProviderDelegate>

@property(strong, nonatomic, nullable, readonly) CXProvider *provider;

- (instancetype)initWithPlugin:(FlutterCallkitPlugin *)plugin;
- (void)configureWithProviderConfiguration:(CXProviderConfiguration *)configuration;
- (void)configureWithProvider:(CXProvider *)provider;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
