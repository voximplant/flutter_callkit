/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "FlutterCallkitPlugin.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(10.0))
@interface FCXTransactionManager : NSObject

- (instancetype)initWithPlugin:(FlutterCallkitPlugin *)plugin;
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
