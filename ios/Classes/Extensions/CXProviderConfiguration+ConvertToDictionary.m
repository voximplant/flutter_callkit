/*
*  Copyright (c) 2011-2020, Zingaya, Inc. All rights reserved.
*/

#import "CXProviderConfiguration+ConvertToDictionary.h"
#import "NullChecks.h"

@implementation CXProviderConfiguration (ConvertToDictionary)

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [self initWithLocalizedName:data[@"localizedName"]];
    if (self) {
        NSString *ringtoneSound = data[@"ringtoneSound"];
        if (isNotNull(ringtoneSound)) {
            self.ringtoneSound = ringtoneSound;
        }

        NSString *imageName = data[@"iconTemplateImageName"];
        if (isNotNull(imageName)) {
            NSData *image = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
            if (image) {
                self.iconTemplateImageData = image;
            }
        }

        self.maximumCallGroups = [data[@"maximumCallGroups"] intValue];

        self.maximumCallsPerCallGroup = [data[@"maximumCallsPerCallGroup"] intValue];

        if (@available(iOS 11.0, *)) {
            self.includesCallsInRecents = [data[@"includesCallsInRecents"] boolValue];
        }

        self.supportsVideo = [data[ @"supportsVideo"] boolValue];

        NSSet<NSNumber *> *supportedHandleTypes = data[@"supportedHandleTypes"];
        if (isNotNull(supportedHandleTypes)) {
            self.supportedHandleTypes = [self getHandleTypesFromSet:supportedHandleTypes];
        }
    }
    return self;
}

- (NSSet<NSNumber *> *) getHandleTypesFromSet:(NSSet<NSNumber *> *)set {
    NSMutableSet<NSNumber *> * handleTypes = [NSMutableSet new];
    for (NSNumber *value in set) {
        int correctValue = [value intValue] + 1;
        [handleTypes addObject:[NSNumber numberWithInt:correctValue]];
    }
    return handleTypes;
}

@end
