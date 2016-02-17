//
//  FlickrData.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "FlickrDataStore.h"
#import "InterestingPhotos.h"
#import "Photo.h"
#import "Flurry.h"

#define kDefaultSize 34

@interface FlickrDataStore ()

// store is an array of NSDictionaries that contains an image
// UIImage data object as well as a url NSString
@property (nonatomic, strong) NSMutableArray <Photo *> *store;
@property (nonatomic) int size;
@property (nonatomic, strong) InterestingPhotos *interestingPhotos;
@property (nonatomic, strong) NSArray *defaults;

@end

@implementation FlickrDataStore

+ (instancetype) sharedStore
{
    static FlickrDataStore *sharedStore = nil;
    if(!sharedStore)
    {
        sharedStore = [[FlickrDataStore alloc] initPrivate:kDefaultSize];
    }
    
    return sharedStore;
}

- (instancetype) initPrivate:(int)size
{
    self = [super init];
    
    if(self)
    {
        self.store = [[NSMutableArray alloc] init];
        self.size = size;
        [self loadStore];
        [self loadDefaultStore];
    }
    
    return self;
}

- (Photo *) getPhotoAtIndex:(NSInteger)index
{
    Photo *photo = nil;
    if(index < [self.store count])
    {
        photo = [self.store objectAtIndex:index];
    }
    
    return photo;
}

- (void) loadStore
{
    [Flurry logEvent:@"LoadingFlickrStore"
      withParameters:@{@"size":[NSString stringWithFormat:@"%d", self.size]}];
    
    InterestingPhotos* interestingPhotos = [self loadInterestingPhotos:self.size];
    
    for(int i = 0; i < self.size; i++)
    {
        // Get the inexed photo for the store
        PhotoModel *photo = [interestingPhotos.photos.photo objectAtIndex:i];
        Photo *p = [[Photo alloc] init];
        p.delegate = self;
        [p setupWithPhotoModel:photo];
        [self.store addObject:p];
    }
}

// TODO Make this more flexible.  Allow more images, different pages, perhaps different streams.
// TODO Play with licenses...  Creative Commons would be the best.
- (InterestingPhotos *) loadInterestingPhotos:(int)number
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=56f7971ad069fb124148f32613ba0bec&date=2016-01-09&per_page=%@&format=json&nojsoncallback=1&license=4",
                           [NSString stringWithFormat:@"%d", number]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *jsonResponse = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    InterestingPhotos *iPhotos = [[InterestingPhotos alloc] initWithString:jsonResponse error:nil];
    return iPhotos;
}

- (void) loadDefaultStore
{
    self.defaults = @[@"carolinabeach", @"cherrystone", @"empire", @"lauden", @"moon", @"purpletree"];
    
    for (NSString *defaultName in self.defaults) {
        NSString *pathString = [NSString stringWithFormat:@"images/%@", defaultName];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:pathString ofType:@"JPG"]];
        Photo *p = [[Photo alloc] init];
        p.thumbnail = image;
        p.largeImage = image;
        p.loaded = YES;
        p.title = defaultName;
        [self.store addObject:p];
        [self imagesLoaded:p];
    }
}

- (void) imagesLoaded:(Photo *)photo
{
    // If the image is not valid, toss it out
    if(photo.invalid)
    {
        [self.store removeObject:photo];
        photo = nil;
    }else{
        // Notify the listener of a new image
        if(self.delegate && [self.delegate respondsToSelector:@selector(photoIsAvailable:)])
        {
            [self.delegate photoIsAvailable:photo];
        }
    }
}

- (Photo *) getRandomPhoto
{
    NSUInteger storeCount = self.store.count;
    int imageIndex = -1;
    do{
        imageIndex = arc4random_uniform((unsigned int)self.store.count);
    }
    while(imageIndex >= storeCount && [self.store objectAtIndex:imageIndex].loaded);
    
    return [self.store objectAtIndex:imageIndex];
}

- (int) getIndexOfPhoto:(Photo *)photo
{
    for(int i = 0; i < self.store.count; i++)
    {
        if([self.store objectAtIndex:i] == photo)
            return i;
    }
    
    return -1;
}

@end
