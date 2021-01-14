/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FlutterCallkitPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCXCallDirectoryPhoneNumber: NSObject

@property(nonatomic, readonly) CXCallDirectoryPhoneNumber number;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNumber:(CXCallDirectoryPhoneNumber)number;

@end

NS_ASSUME_NONNULL_END
