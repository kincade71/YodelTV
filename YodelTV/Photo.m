//
//  Photo.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "InterestingPhotos.h"

@interface Photo ()

@property (nonatomic) BOOL thumbnailLoaded;
@property (nonatomic) BOOL largeImageLoaded;

@end

@implementation Photo

- (instancetype) setupWithPhotoModel:(PhotoModel *)model
{
    self.loaded = NO;
    self.thumbnailLoaded = NO;
    self.largeImageLoaded = NO;
    self.invalid = NO;
    self.owner = model.owner;
    self.title = model.title;
    [self loadImages:model];
    return self;
}

- (void) loadImages:(PhotoModel *)model
{
    // Get the URLs for the images
    NSURL *thumbnailUrl = [self convertPhotoModelToUrl:model forSize:@"m"];
    NSURL *largeImageUrl = [self convertPhotoModelToUrl:model forSize:@"h"];
    
    NSURLRequest *thumbnailRequest = [NSURLRequest requestWithURL:thumbnailUrl];
    NSURLRequest *largeImageRequest = [NSURLRequest requestWithURL:largeImageUrl];
    
    // Create the session and make the calls
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:thumbnailRequest completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error)
    {
        UIImage *image = [[UIImage alloc] initWithData:data];
        self.thumbnail = image;
        self.thumbnailLoaded = YES;
        if(!self.thumbnail)
        {
            // NSLog([NSString stringWithFormat:@"thumbnail is invalid for URL: %@", thumbnailUrl]);
            // Perhaps consider reloading a new image if this occurs...
        }
        [self checkCompletion];
    }] resume];
    
    [[session dataTaskWithRequest:largeImageRequest completionHandler:^(NSData *data,
                                                                       NSURLResponse *response,
                                                                       NSError *error)
      {
          // We need to check if the response is the "this doesn't exist" URL
          if(![response.URL isEqual:[NSURL URLWithString:@"https://s.yimg.com/pw/images/en-us/photo_unavailable_h.png"]])
          {
              UIImage *image = [[UIImage alloc] initWithData:data];
              self.largeImage = image;
              self.largeImageLoaded = YES;
              if(!self.largeImage)
              {
                  // NSLog([NSString stringWithFormat:@"large image is invalid for URL:  %@", largeImageUrl]);
                  // Perhaps consider reloading a new image if this occurs...
              }
          }else{
              self.invalid = YES;
          }
          [self checkCompletion];
      }] resume];
}

- (NSURL *) convertPhotoModelToUrl:(PhotoModel *)photo forSize:(NSString *)size
{
    // The following will return the original image size
    // https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
    // Source: https://www.flickr.com/services/api/misc.urls.html
    
    NSString *urlString = [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_%@.jpg",
                           [NSString stringWithFormat:@"%d", photo.farm],
                           photo.server,
                           photo.id,
                           photo.secret,
                           size];
    return [NSURL URLWithString:urlString];
}

- (void) checkCompletion
{
    if((self.thumbnailLoaded && self.largeImageLoaded) || self.invalid)
    {
        self.loaded = YES;
        // Notify the listener of a new image
        if(self.delegate && [self.delegate respondsToSelector:@selector(imagesLoaded:)])
        {
            [self.delegate imagesLoaded:self];
        }
    }
}

@end
