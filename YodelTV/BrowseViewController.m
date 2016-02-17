//
//  ViewController.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import "BrowseViewController.h"
#import "FlickrDataStore.h"
#import "Photo.h"
#import "FlickrImageViewCell.h"
#import "PhotoController.h"
#import "Flurry.h"

@interface BrowseViewController ()

//@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@end

@implementation BrowseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the collection view
    [self.collectionView registerNib:[UINib nibWithNibName:@"FlickrImageViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"classCell"];
    self.collectionView.backgroundColor = [UIColor blackColor];
    
    // Set all the delegates
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [FlickrDataStore sharedStore].delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 32;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlickrImageViewCell *cell = [self.collectionView  dequeueReusableCellWithReuseIdentifier:@"classCell" forIndexPath:indexPath];
    Photo *photo = [[FlickrDataStore sharedStore] getPhotoAtIndex:indexPath.row];
    [cell setupWithPhoto:photo];
    return cell;
}

#pragma <FlickrDataStoreDelegate>

- (void) photoIsAvailable:(Photo *)photo
{
    [Flurry logEvent:@"LoadingBrowseViewCellImage"];
    // Find the photo's index, then update that cell's images.
    int photoIndex = [[FlickrDataStore sharedStore] getIndexOfPhoto:photo];
    FlickrImageViewCell *cell = (FlickrImageViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:photoIndex inSection:0]];
    
    // Since we are altering the UI from a background thread, we need to
    // get a hold of the main thread from which to do the UI modifications
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell update];
    });
}

#pragma mark <UICollectionViewDelegate>

 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [Flurry logEvent:@"SelectedImageFromBrowseView"];
     PhotoController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoController"];
     [controller setUpWithPhoto:[[FlickrDataStore sharedStore] getPhotoAtIndex:indexPath.row]];
     [self.navigationController pushViewController:controller animated:YES];
     return YES;
 }

- (BOOL) collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
