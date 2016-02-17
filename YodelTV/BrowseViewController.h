//
//  BrowseViewController.h
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "FlickrDataStore.h"

@interface BrowseViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FlickrDataStoreDelegate>


@end

