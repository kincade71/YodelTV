//
//  SelectionViewDataStore.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <Foundation/Foundation.h>
#import "SelectionViewModel.h"

@interface SelectionViewDataStore : NSObject

+ (instancetype) sharedStore;
- (int) size;
- (NSString *) viewAtIndex:(int)index;
- (UIImage *) imageAtIndex:(int)index;
- (SelectionViewModel *) modelAtIndex:(int)index;

@end
