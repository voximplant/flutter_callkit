/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "CXHandle+ConvertToDictionary.h"
#import "NullChecks.h"

@implementation CXHandle (ConvertToDictionary)

NSString *const TYPE = @"type";
NSString *const VALUE = @"value";

- (nullable instancetype)initWithDictionary:(NSDictionary *)data {
    if (isNull(data)) { return nil; }
    
    NSString *value = data[VALUE];
    if (isNull(value) || value.length == 0) { return nil; }

    self = [self initWithType:[self convertNumberToHandleType:data[TYPE]]
                        value:value];
    return self;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *data = [NSMutableDictionary new];
    
    data[TYPE] = [self convertHandleTypeToNumber:self.type];
    data[VALUE] = self.value;
    
    return data;
}

- (CXHandleType)convertNumberToHandleType:(NSNumber *)number {
    switch ([number intValue]) {
        case 0: return CXHandleTypeGeneric;
        case 1: return CXHandleTypePhoneNumber;
        case 2: return CXHandleTypeEmailAddress;
        default: return CXHandleTypeGeneric;
    }
}

- (NSNumber *)convertHandleTypeToNumber:(CXHandleType)type {
    switch (type) {
        case CXHandleTypeGeneric: return [NSNumber numberWithInt:0];
        case CXHandleTypePhoneNumber: return [NSNumber numberWithInt:1];
        case CXHandleTypeEmailAddress: return [NSNumber numberWithInt:2];
    }
}

@end
