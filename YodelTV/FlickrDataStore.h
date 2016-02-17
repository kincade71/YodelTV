//
//  FlickrData.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import "InterestingPhotos.h"
#import "Photo.h"

@class FlickrDataStore;

@protocol FlickrDataStoreDelegate <NSObject>

- (void) photoIsAvailable:(Photo *)photo;

@end

@interface FlickrDataStore : NSObject <PhotoDelegate>

@property(nonatomic, weak) id<FlickrDataStoreDelegate> delegate;

+ (instancetype) sharedStore;
- (int) size;
- (Photo *) getPhotoAtIndex:(NSInteger) index;
- (Photo *) getRandomPhoto;
- (int) getIndexOfPhoto:(Photo *)photo;

@end
