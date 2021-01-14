/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSISO8601DateFormatter (WithoutMS)

+ (nullable NSDate *)dateFromStringWithoutMS:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
