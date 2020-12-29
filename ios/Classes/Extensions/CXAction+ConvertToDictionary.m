/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "CXAction+ConvertToDictionary.h"
#import "CXHandle+ConvertToDictionary.h"
#import "NullChecks.h"

@implementation CXAction (ConvertToDictionary)

NSString *const ACTION_TYPE = @"type";
NSString *const COMPLETE = @"complete";
NSString *const ACTION_CALL_UUID = @"callUuid";
NSString *const HANDLE = @"handle";
NSString *const VIDEO = @"video";
NSString *const CALL_UUID_TO_GROUP = @"callUUIDToGroupWith";
NSString *const MUTED = @"muted";
NSString *const ACTION_ON_HOLD = @"onHold";
NSString *const DIGITS = @"digits";
NSString *const DTMF_TYPE = @"playDTMFCallActionType";
NSString *const CONTACT_ID = @"contactIdentifier";

- (nullable instancetype)initWithDictionary:(NSDictionary *)data {
    // substring used to remove "F" from FCX prefix of Dart class names
    NSString *type = [data[ACTION_TYPE] substringFromIndex:1];
    if (isNull(type)) {
        return nil;
    }
    
    if ([type isEqualToString:NSStringFromClass(CXAction.class)]) {
        return [self init];
    }
    
    NSString *callUUIDString = data[ACTION_CALL_UUID];
    if (isNull(callUUIDString)) {
        return nil;
    }
    NSUUID *callUUID = [[NSUUID alloc] initWithUUIDString:callUUIDString];
    if (isNull(callUUID)) {
        return nil;
    }
    
    if ([type isEqualToString:NSStringFromClass(CXCallAction.class)]) {
        self = [[CXCallAction alloc] initWithCallUUID:callUUID];
        
    } else if ([type isEqualToString:NSStringFromClass(CXStartCallAction.class)]) {
        CXHandle *handle = [[CXHandle alloc] initWithDictionary:data[HANDLE]];
        if (!handle) { return nil; }
        CXStartCallAction *action = [[CXStartCallAction alloc] initWithCallUUID:callUUID handle:handle];
        NSString *contactIdentifier = data[CONTACT_ID];
        if (contactIdentifier) {
            action.contactIdentifier = contactIdentifier;
        }
        action.video = [data[VIDEO] boolValue];
        self = action;

    } else if ([type isEqualToString:NSStringFromClass(CXAnswerCallAction.class)]) {
        self = [[CXAnswerCallAction alloc] initWithCallUUID:callUUID];
        
    } else if ([type isEqualToString:NSStringFromClass(CXEndCallAction.class)]) {
        self = [[CXEndCallAction alloc] initWithCallUUID:callUUID];
        
    } else if ([type isEqualToString:NSStringFromClass(CXSetGroupCallAction.class)]) {
        NSString *UUIDToGroupWithString = data[CALL_UUID_TO_GROUP];
        if (isNull(UUIDToGroupWithString)) {
            self = [[CXSetGroupCallAction alloc] initWithCallUUID:callUUID callUUIDToGroupWith:nil];
        } else {
            NSUUID *UUIDToGroupWith = [[NSUUID alloc] initWithUUIDString:UUIDToGroupWithString];
            self = [[CXSetGroupCallAction alloc] initWithCallUUID:callUUID callUUIDToGroupWith:UUIDToGroupWith];
        }
        
    } else if ([type isEqualToString:NSStringFromClass(CXSetMutedCallAction.class)]) {
        self = [[CXSetMutedCallAction alloc] initWithCallUUID:callUUID
                                                        muted:[data[MUTED] boolValue]];
        
    } else if ([type isEqualToString:NSStringFromClass(CXSetHeldCallAction.class)]) {
        self = [[CXSetHeldCallAction alloc] initWithCallUUID:callUUID
                                                      onHold:[data[ACTION_ON_HOLD] boolValue]];
        
    } else if ([type isEqualToString:NSStringFromClass(CXPlayDTMFCallAction.class)]) {
        NSString *digits = data[DIGITS];
        if (isNull(digits)) { return nil; }
        self = [[CXPlayDTMFCallAction alloc] initWithCallUUID:callUUID
                                                       digits:digits
                                                         type:[self convertNumberToCallActionType:data[DTMF_TYPE]]];
    }
    
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    data[ACTION_TYPE] = NSStringFromClass(self.class);
    data[COMPLETE] = [NSNumber numberWithBool:self.complete];
    data[@"uuid"] = self.UUID.UUIDString;
    data[@"timeoutDate"] = [[NSISO8601DateFormatter new] stringFromDate:self.timeoutDate];
    
    if ([self isKindOfClass:CXCallAction.class]) {
        CXCallAction *castedSelf = (CXCallAction *)self;
        data[ACTION_CALL_UUID] = castedSelf.callUUID.UUIDString;
        
        if ([self isKindOfClass:CXStartCallAction.class]) {
            CXStartCallAction *castedSelf = (CXStartCallAction *)self;
            data[HANDLE] = castedSelf.handle.toDictionary;
            data[CONTACT_ID] = castedSelf.contactIdentifier;
            data[VIDEO] = [NSNumber numberWithBool:castedSelf.video];
            
        } else if ([self isKindOfClass:CXSetGroupCallAction.class]) {
            CXSetGroupCallAction *castedSelf = (CXSetGroupCallAction *)self;
            data[CALL_UUID_TO_GROUP] = castedSelf.callUUIDToGroupWith.UUIDString;
            
        } else if ([self isKindOfClass:CXSetMutedCallAction.class]) {
            CXSetMutedCallAction *castedSelf = (CXSetMutedCallAction *)self;
            data[MUTED] = [NSNumber numberWithBool:castedSelf.muted];
            
        } else if ([self isKindOfClass:CXSetHeldCallAction.class]) {
            CXSetHeldCallAction *castedSelf = (CXSetHeldCallAction *)self;
            data[ACTION_ON_HOLD] = [NSNumber numberWithBool:castedSelf.onHold];
            
        } else if ([self isKindOfClass:CXPlayDTMFCallAction.class]) {
            CXPlayDTMFCallAction *castedSelf = (CXPlayDTMFCallAction *)self;
            data[DIGITS] = castedSelf.digits;
            data[DTMF_TYPE] = [self convertCallActionTypeToNumber:castedSelf.type];
        }
    }
    
    return data;
}

- (CXPlayDTMFCallActionType)convertNumberToCallActionType:(NSNumber *)number {
    switch ([number intValue]) {
        case 0: return CXPlayDTMFCallActionTypeSingleTone;
        case 1: return CXPlayDTMFCallActionTypeSoftPause;
        case 2: return CXPlayDTMFCallActionTypeHardPause;
        default: return CXPlayDTMFCallActionTypeSingleTone;
    }
}

- (NSNumber *)convertCallActionTypeToNumber:(CXPlayDTMFCallActionType)type {
    switch (type) {
        case CXPlayDTMFCallActionTypeSingleTone: return [NSNumber numberWithInt:0];
        case CXPlayDTMFCallActionTypeSoftPause: return [NSNumber numberWithInt:1];
        case CXPlayDTMFCallActionTypeHardPause: return [NSNumber numberWithInt:2];
    }
}

@end
