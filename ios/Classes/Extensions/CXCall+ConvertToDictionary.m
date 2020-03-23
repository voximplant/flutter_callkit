/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "CXCall+ConvertToDictionary.h"

@implementation CXCall (ConvertToDictionary)

- (NSDictionary *)toDictionary {
    NSMutableDictionary *data = [NSMutableDictionary new];
    data[@"uuid"] = self.UUID.UUIDString;
    data[@"outgoing"] = [NSNumber numberWithBool:self.outgoing];
    data[@"onHold"] = [NSNumber numberWithBool:self.onHold];
    data[@"hasConnected"] = [NSNumber numberWithBool:self.hasConnected];
    data[@"hasEnded"] = [NSNumber numberWithBool:self.hasEnded];
    return data;
}

@end
