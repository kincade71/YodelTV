//
//  SelectionViewModel.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SelectionViewModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *targetView;
@property (nonatomic) BOOL isRandom;

- (id) initWithName:(NSString *)name withImage:(UIImage *)image withTargetView:(NSString *)targetView isRandom:(BOOL)random;

@end
