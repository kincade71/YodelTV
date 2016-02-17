//
//  SelectionViewModel.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import "SelectionViewModel.h"

@implementation SelectionViewModel

- (id) initWithName:(NSString *)name withImage:(UIImage *)image withTargetView:(NSString *)targetView isRandom:(BOOL)random
{
    self = [super init];
    self.name = name;
    self.image = image;
    self.targetView = targetView;
    self.isRandom = random;
    return self;
}

@end
