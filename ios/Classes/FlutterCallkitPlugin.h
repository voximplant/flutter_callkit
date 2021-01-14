/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import <Flutter/Flutter.h>
#import <CallKit/CallKit.h>
@class FCXCallDirectoryPhoneNumber;
@class FCXIdentifiablePhoneNumber;

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(10.0))
@interface FlutterCallkitPlugin : NSObject<FlutterPlugin, FlutterStreamHandler>

@property(strong, nonatomic, readonly, class) FlutterCallkitPlugin *sharedInstance;

@property(strong, nonatomic, nullable) NSArray<FCXCallDirectoryPhoneNumber *> *(^getBlockedPhoneNumbers)(void);
@property(strong, nonatomic, nullable) void(^didAddBlockedPhoneNumbers)(NSArray<FCXCallDirectoryPhoneNumber *> *numbers);
@property(strong, nonatomic, nullable) void(^didRemoveBlockedPhoneNumbers)(NSArray<FCXCallDirectoryPhoneNumber *> *numbers);
@property(strong, nonatomic, nullable) void(^didRemoveAllBlockedPhoneNumbers)(void);

@property(strong, nonatomic, nullable) NSArray<FCXIdentifiablePhoneNumber *> *(^getIdentifiablePhoneNumbers)(void);
@property(strong, nonatomic, nullable) void(^didAddIdentifiablePhoneNumbers)(NSArray<FCXIdentifiablePhoneNumber *> *numbers);
@property(strong, nonatomic, nullable) void(^didRemoveIdentifiablePhoneNumbers)(NSArray<FCXCallDirectoryPhoneNumber *> *numbers);
@property(strong, nonatomic, nullable) void(^didRemoveAllIdentifiablePhoneNumbers)(void);

- (BOOL)hasCallWithUUID:(NSUUID *)UUID;

- (void)reportNewIncomingCallWithUUID:(NSUUID *)UUID
                           callUpdate:(CXCallUpdate *)callUpdate
                providerConfiguration:(CXProviderConfiguration *)providerConfiguration
             pushProcessingCompletion:(nullable dispatch_block_t)pushProcessingCompletion;

- (instancetype)init NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END
