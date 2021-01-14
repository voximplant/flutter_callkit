/*
*  Copyright (c) 2011-2021, Zingaya, Inc. All rights reserved.
*/

#import "FlutterMethodCall+MethodType.h"

@implementation FlutterMethodCall (MethodType)

- (BOOL)isMethodCallOfType:(FCXMethodType)type {
    NSArray<NSString *> *methodNameComponents = [self.method componentsSeparatedByString:@"."];
    return methodNameComponents && methodNameComponents.firstObject
    ? [methodNameComponents.firstObject isEqualToString:type]
    : NO;
}

- (FlutterMethodCall *)excludingType {
    NSArray<NSString *> *methodNameComponents = [self.method componentsSeparatedByString:@"."];
    NSString *method = methodNameComponents && methodNameComponents.count > 0
    ? methodNameComponents[1]
    : self.method;

    return [FlutterMethodCall methodCallWithMethodName:method arguments:self.arguments];
}

@end
