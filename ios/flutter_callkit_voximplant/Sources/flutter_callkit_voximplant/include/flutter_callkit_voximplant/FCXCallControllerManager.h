/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FlutterCallkitPlugin.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(10.0))
@interface FCXCallControllerManager : NSObject<FlutterStreamHandler, CXCallObserverDelegate>

@property(strong, nonatomic, nullable, readonly) CXCallController *callController;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
