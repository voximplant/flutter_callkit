/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "include/flutter_callkit_voximplant/FCXCallDirectoryPhoneNumber.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FCXCallDirectoryPhoneNumber

- (instancetype)initWithNumber:(CXCallDirectoryPhoneNumber)number {
    if (self = [super init]) {
        _number = number;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
