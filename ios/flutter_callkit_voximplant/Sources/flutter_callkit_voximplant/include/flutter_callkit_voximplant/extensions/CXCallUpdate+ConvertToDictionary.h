/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import <CallKit/CallKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXCallUpdate (ConvertToDictionary)

- (instancetype)initWithDictionary:(NSDictionary *)data;

- (NSDictionary *)toDictionary;

@end

NS_ASSUME_NONNULL_END
