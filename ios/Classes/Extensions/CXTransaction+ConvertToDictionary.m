/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "CXTransaction+ConvertToDictionary.h"
#import "CXAction+ConvertToDictionary.h"

@implementation CXTransaction (ConvertToDictionary)

- (NSDictionary *)toDictionary {
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    data[@"uuid"] = self.UUID.UUIDString;
    data[@"complete"] = [NSNumber numberWithBool:self.complete];
    NSMutableArray *actions = [NSMutableArray new];
    for (CXAction *action in self.actions) {
        [actions addObject:[action toDictionary]];
    }
    data[@"actions"] = actions;
    return data;
}

@end
