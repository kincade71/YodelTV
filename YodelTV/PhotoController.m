//
//  PhotoController.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import "PhotoController.h"
#import "FlickrDataStore.h"
#import "Flurry.h"

@interface PhotoController ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) Photo *photoModel;
@property (nonatomic) BOOL random;

@end

@implementation PhotoController
{
    dispatch_source_t _timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setImage:self.photoModel.largeImage];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.backgroundColor = [UIColor blackColor];
    
    // We want to know how long folks are viewing the photos, so set up a timed event here.
    [Flurry logEvent:@"PhotoView" timed:YES];
    
    if(self.random)
    {
        [Flurry logEvent:@"RandomPhotoFetch"];
        [self engageTimer];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    // End our timed event
    [Flurry endTimedEvent:@"PhotoView" withParameters:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpWithPhoto:(Photo *)photo
{
    self.photoModel = photo;
    self.random = NO;
}

- (void) setUpWithPhoto:(Photo *)photo forRandom:(BOOL)random
{
    [self setUpWithPhoto:photo];
    self.random = random;
}

- (void) engageTimer
{
    dispatch_queue_t backgroundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, backgroundQueue);
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), 30 * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
    dispatch_source_set_event_handler(_timer, ^{
        [Flurry logEvent:@"RandomPhotoFetch"];
        // Update the photo
        self.photoModel = [[FlickrDataStore sharedStore] getRandomPhoto];
        
        // This next call seems to take a while to affect the UI, wonder how to speed it up...
        // Takes around 8 to 10 seconds, currently
        [self.imageView setImage:self.photoModel.largeImage];
    });
    dispatch_resume(_timer);
}

@end
