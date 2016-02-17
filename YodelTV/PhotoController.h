//
//  PhotoController.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoController : UIViewController

- (void) setUpWithPhoto:(Photo *)photo;
- (void) setUpWithPhoto:(Photo *)photo forRandom:(BOOL)random;

@end
