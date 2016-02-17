//
//  InterestingPhotos.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol PhotoModel
@end

@interface PhotoModel : JSONModel
@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* owner;
@property (strong, nonatomic) NSString* secret;
@property (strong, nonatomic) NSString* server;
@property (assign, nonatomic) int farm;
@property (strong, nonatomic) NSString* title;
@property (assign, nonatomic) BOOL ispublic;
@property (assign, nonatomic) BOOL isfriend;
@property (assign, nonatomic) BOOL isfamily;
@end



@protocol PhotoPageModel
@end

@interface PhotoPageModel : JSONModel
@property (assign, nonatomic) int page;
@property (assign, nonatomic) int pages;
@property (assign, nonatomic) int perpage;
@property (assign, nonatomic) int total;
@property (strong, nonatomic) NSArray<PhotoModel>* photo;
@end



@protocol InterestingPhotoModel
@end

@interface InterestingPhotos : JSONModel
@property (strong, nonatomic) PhotoPageModel* photos;
@end

