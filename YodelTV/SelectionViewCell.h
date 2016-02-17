//
//  SelectionViewCell.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "SelectionViewModel.h"

@interface SelectionViewCell : UICollectionViewCell

// You know, I probably don't need to store this...
@property (nonatomic, weak) SelectionViewModel *model;

- (void) setupWithModel:(SelectionViewModel *)model;

@end
