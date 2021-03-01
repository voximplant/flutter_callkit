/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString *FCXMethodType NS_TYPED_ENUM;
static FCXMethodType const FCXMethodTypeProvider = @"Provider";
static FCXMethodType const FCXMethodTypeCallController = @"CallController";
static FCXMethodType const FCXMethodTypeAction = @"Action";
static FCXMethodType const FCXMethodTypeTransaction = @"Transaction";
static FCXMethodType const FCXMethodTypePlugin = @"Plugin";

@interface FlutterMethodCall (FCXMethodType)

@property (nonatomic, readonly) FlutterMethodCall *excludingType;

- (BOOL)isMethodCallOfType:(FCXMethodType)type;

@end

NS_ASSUME_NONNULL_END
