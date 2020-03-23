/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "CXCallUpdate+ConvertToDictionary.h"
#import "CXHandle+ConvertToDictionary.h"
#import "NullChecks.h"

@implementation CXCallUpdate (ConvertToDictionary)

NSString *const REMOTE_HANDLE = @"remoteHandle";
NSString *const LOCALIZED_CALLER_NAME = @"localizedCallerName";
NSString *const SUPPORTS_HOLDING = @"supportsHolding";
NSString *const SUPPORTS_GROUPING = @"supportsGrouping";
NSString *const SUPPORTS_UNGROUPING = @"supportsUngrouping";
NSString *const SUPPORTS_DTMF = @"supportsDTMF";
NSString *const HAS_VIDEO = @"hasVideo";

- (instancetype)initWithDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        CXHandle *remoteHandle = [[CXHandle alloc] initWithDictionary:data[REMOTE_HANDLE]];
        if (isNotNull(remoteHandle)) {
            self.remoteHandle = remoteHandle;
        }
        
        NSString *localizedName = data[LOCALIZED_CALLER_NAME];
        if (isNotNull(localizedName)) {
            self.localizedCallerName = localizedName;
        }
        
        NSNumber *supportsHolding = data[SUPPORTS_HOLDING];
        if (isNotNull(supportsHolding)) {
            self.supportsHolding = [supportsHolding boolValue];
        }
        
        NSNumber *supportsGrouping = data[SUPPORTS_GROUPING];
        if (isNotNull(supportsGrouping)) {
            self.supportsGrouping = [supportsGrouping boolValue];
        }
        
        NSNumber *supportsUngrouping = data[SUPPORTS_UNGROUPING];
        if (isNotNull(supportsUngrouping)) {
            self.supportsUngrouping = [supportsUngrouping boolValue];
        }
        
        NSNumber *supportsDTMF = data[SUPPORTS_DTMF];
        if (isNotNull(supportsDTMF)) {
            self.supportsDTMF = [supportsDTMF boolValue];
        }
        
        NSNumber *hasVideo = data[HAS_VIDEO];
        if (isNotNull(hasVideo)) {
            self.hasVideo = [hasVideo boolValue];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *data = [NSMutableDictionary new];
    if (self.remoteHandle) {
        data[REMOTE_HANDLE] = [self.remoteHandle toDictionary];
    }
    if (self.localizedCallerName) {
        data[LOCALIZED_CALLER_NAME] = self.localizedCallerName;
    }
    data[SUPPORTS_HOLDING] = [NSNumber numberWithBool:self.supportsHolding];
    data[SUPPORTS_GROUPING] = [NSNumber numberWithBool:self.supportsGrouping];
    data[SUPPORTS_UNGROUPING] = [NSNumber numberWithBool:self.supportsUngrouping];
    data[SUPPORTS_DTMF] = [NSNumber numberWithBool:self.supportsDTMF];
    data[HAS_VIDEO] = [NSNumber numberWithBool:self.hasVideo];
    return data;
}

@end
