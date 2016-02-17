//
//  SelectionViewController.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import "SelectionViewController.h"
#import "SelectionViewDataStore.h"
#import "SelectionViewCell.h"
#import "BrowseViewController.h"
#import "PhotoController.h"
#import "Flurry.h"

@interface SelectionViewController ()

@end

@implementation SelectionViewController

static NSString * const reuseIdentifier = @"SVCell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"SelectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[SelectionViewDataStore sharedStore] size];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Set the cell up with the model that pertains to it
    [cell setupWithModel:[[SelectionViewDataStore sharedStore] modelAtIndex:(int)indexPath.row]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectionViewModel *model = [[SelectionViewDataStore sharedStore] modelAtIndex:(int)indexPath.row];
    [Flurry logEvent:@"ViewSelection" withParameters:@{@"view":model.targetView,
                                                       @"IsRandom":(model.isRandom) ? @"YES" : @"NO"}];
    if(model.isRandom)
    {
        PhotoController *controller = [self.storyboard instantiateViewControllerWithIdentifier:model.targetView];
        [controller setUpWithPhoto:[[FlickrDataStore sharedStore] getRandomPhoto] forRandom:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        BrowseViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:model.targetView];
        [self.navigationController pushViewController:controller animated:YES];
    }
    return YES;
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSLog(@"SETTING SIZE FOR ITEM AT INDEX %d", indexPath.row);
    CGSize mElementSize = CGSizeMake(300, 300);
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(280,660,0,0);  // top, left, bottom, right
}

@end
