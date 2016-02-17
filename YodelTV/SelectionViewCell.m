//
//  SelectionViewCell.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import "SelectionViewCell.h"
#import "SelectionViewModel.h"

@interface SelectionViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *viewNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *icon;

@end

@implementation SelectionViewCell

- (void) setupWithModel:(SelectionViewModel *)model
{
    self.model = model;
    [self setUpWithViewName:model.name andImage:model.image];
}

- (void) setUpWithViewName:(NSString *)viewName andImage:(UIImage *)image
{
    [self.viewNameLabel setText:viewName];
    self.viewNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.icon setImage:image];
    self.icon.adjustsImageWhenAncestorFocused = YES;
}

@end
