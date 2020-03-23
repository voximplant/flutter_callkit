/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "FlutterError+FlutterCallKitError.h"
#import <CallKit/CallKit.h>

@implementation FlutterError (FlutterCallKitError)

+ (instancetype)errorProviderConfigurationNotFound {
    return [FlutterError errorWithCode:@"ERROR_CONFIGURATION_NOT_FOUND"
                               message:@"Provider Configuration was nil in received data"
                               details:nil];
}

+ (instancetype)errorProviderMissing {
    return [FlutterError errorWithCode:@"ERROR_PROVIDER_MISSING"
                               message:@"CXProvider instance was'nt found"
                               details:nil];
}

+ (instancetype)errorCallControllerMissing {
    return [FlutterError errorWithCode:@"ERROR_CALL_CONTROLLER_MISSING"
                               message:@"CXCallController instance was'nt found"
                               details:nil];
}

+ (instancetype)errorTransactionNotFound {
    return [FlutterError errorWithCode:@"ERROR_TRANSACTION_NOT_FOUND"
                               message:@"CXTransaction with given UUID was'nt found"
                               details:nil];
}

+ (instancetype)errorBuildingAction {
    return [FlutterError errorWithCode:@"ERROR_BUILDING_ACTION"
                               message:@"failed to build CXAction from given data"
                               details:nil];
}

+ (instancetype)errorActionNotFound {
    return [FlutterError errorWithCode:@"ERROR_ACTION_NOT_FOUND"
                               message:@"CXAction with given UUID was'nt found"
                               details:nil];
}

+ (instancetype)errorBuildingUUID {
    return [FlutterError errorWithCode:@"ERROR_BUILDING_UUID"
                               message:@"failed to build NSUUID from NSString"
                               details:nil];
}

+ (instancetype)errorUUIDNotFound {
    return [FlutterError errorWithCode:@"ERROR_UUID_NOT_FOUND"
                               message:@"UUID field was nil in received data"
                               details:nil];
}

+ (instancetype)errorCallUpdateNotFound {
    return [FlutterError errorWithCode:@"ERROR_CALL_UPDATE_NOT_FOUND"
                               message:@"CallUpdate was nil in received data"
                               details:nil];
}

+ (instancetype)errorPushCompletionNotFound {
    return [FlutterError errorWithCode:@"ERROR_PUSH_COMPLETION_NOT_FOUND"
                               message:@"PushProcessingCompletion was'nt found"
                               details:nil];
}

+ (instancetype)errorImplementationNotFoundForMethod:(NSString *)method {
    return [FlutterError errorWithCode:@"ERROR_IMPLEMENTATION_NOT_FOUND"
                               message:[NSString stringWithFormat:@"Could'nt find implementation for the method %@ in native code", method]
                               details:nil];
}

+ (instancetype)errorFromCallKitError:(NSError *)error {
    NSString *errorCode = [self parseCodeFromError:error];
    return [FlutterError errorWithCode:errorCode != nil ? errorCode : @"ERROR_UNKNOWN"
                               message:error.localizedDescription
                               details:nil];
}

+ (nullable NSString *)parseCodeFromError:(NSError *)error {
    NSErrorDomain domain = error.domain;
    
    if ([domain isEqualToString:CXErrorDomain]) {
        switch (error.code) {
            case 0:
                return @"ERROR_UNKNOWN";
            case 1:
                return @"ERROR_UNENTITLED";
            case 2:
                return @"ERROR_INVALID_ARGUMENT";
            default:
                return nil;
        }
    } else if ([domain isEqualToString:CXErrorDomainIncomingCall]) {
        switch (error.code) {
            case 0:
                return @"ERROR_UNKNOWN";
            case 1:
                return @"ERROR_UNENTITLED";
            case 2:
                return @"ERROR_CALLUUID_ALREADY_EXISTS";
            case 3:
                return @"ERROR_FILTERED_BY_DO_NOT_DISTURB";
            case 4:
                return @"ERROR_FILTERED_BY_BLOCK_LIST";
            default:
                return nil;
        }
    } else if ([domain isEqualToString:CXErrorDomainRequestTransaction]) {
        switch (error.code) {
            case 0:
                return @"ERROR_UNKNOWN";
            case 1:
                return @"ERROR_UNENTITLED";
            case 2:
                return @"ERROR_UNKNOWN_CALL_PROVIDER";
            case 3:
                return @"ERROR_EMPTY_TRANSACTION";
            case 4:
                return @"ERROR_UNKNOWN_CALLUUID";
            case 5:
                return @"ERROR_CALLUUID_ALREADY_EXISTS";
            case 6:
                return @"ERROR_INVALID_ACTION";
            case 7:
                return @"ERROR_MAXIMUM_CALL_GROUPS_REACHED";
            default:
                return nil;
        }
    } else {
        return nil;
    }
}


@end
