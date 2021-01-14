/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FCXCallDirectoryPhoneNumber.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCXIdentifiablePhoneNumber: FCXCallDirectoryPhoneNumber

@property(nonatomic, strong, readonly) NSString *label;

- (instancetype)initWithNumber:(CXCallDirectoryPhoneNumber)number NS_UNAVAILABLE;
- (instancetype)initWithNumber:(CXCallDirectoryPhoneNumber)number label:(NSString *)label;

@end

NS_ASSUME_NONNULL_END
