//
//  FlickrImageViewCell.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "FlickrImageViewCell.h"

@interface FlickrImageViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) Photo *photo;

@end

@implementation FlickrImageViewCell

- (void) setupWithPhoto:(Photo *)photo
{
    [self.imageView setImage:photo.thumbnail];
    [self.title setText:photo.title];
    self.imageView.adjustsImageWhenAncestorFocused = YES;
    self.photo = photo;
}

- (void) update
{
    [self.imageView setImage:self.photo.thumbnail];
}

@end
