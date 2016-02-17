//
//  Photo.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InterestingPhotos.h"

@class Photo;

@protocol PhotoDelegate <NSObject>

- (void) imagesLoaded:(Photo *)photo;

@end

@interface Photo : NSObject

@property(nonatomic, weak) id<PhotoDelegate> delegate;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *largeImage;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL loaded;
@property (nonatomic) BOOL invalid;

- (instancetype) setupWithPhotoModel:(PhotoModel *)model;
@end
