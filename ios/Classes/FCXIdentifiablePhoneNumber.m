/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FCXIdentifiablePhoneNumber.h"

NS_ASSUME_NONNULL_BEGIN

@implementation FCXIdentifiablePhoneNumber

- (instancetype)initWithNumber:(CXCallDirectoryPhoneNumber)number label:(NSString *)label {
    if (self = [super initWithNumber:number]) {
        _label = label;
    }
    return self;
}

@end

NS_ASSUME_NONNULL_END
