/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "NSISO8601DateFormatter+WithoutMS.h"

@implementation NSISO8601DateFormatter (WithoutMS)

+ (NSDate *)dateFromStringWithoutMS:(NSString *)string {
    NSISO8601DateFormatter *formatter = [NSISO8601DateFormatter new];
    NSArray<NSString *> *stringComponents = [string componentsSeparatedByString:@"."];
    NSString *correctString = stringComponents.count > 1
        ? [stringComponents.firstObject stringByAppendingString:@"Z"]
        : string;
    return [formatter dateFromString:correctString];
}

@end
