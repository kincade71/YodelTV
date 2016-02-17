//
//  SelectionViewDataStore.m
//  YodelTV
//
//  Copyright 2015 Yahoo Inc.
//  Licensed under the terms of the zLib license. Please see LICENSE file in the project root for terms.
//

#import <UIKit/UIKit.h>
#import "SelectionViewDataStore.h"
#import "SelectionViewModel.h"
#import "Flurry.h"

@interface SelectionViewDataStore ()

@property (nonatomic, strong) NSMutableArray *store;

@end

@implementation SelectionViewDataStore

+ (instancetype) sharedStore
{
    static SelectionViewDataStore *sharedStore = nil;
    if(!sharedStore)
    {
        sharedStore = [[SelectionViewDataStore alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype) initPrivate
{
    self = [super init];
    
    if(self)
    {
        self.store = [[NSMutableArray alloc] init];
        [self loadStore];
    }
    
    return self;
}

- (void) loadStore
{
    [Flurry logEvent:@"LoadingSelectionViewStore"];
    [self.store addObject:[[SelectionViewModel alloc] initWithName:@"Random"
                                                         withImage:[UIImage imageNamed:@"random"]
                                                     withTargetView:@"PhotoController"
                                                          isRandom:YES]];
    [self.store addObject:[[SelectionViewModel alloc] initWithName:@"Browse"
                                                         withImage:[UIImage imageNamed:@"browse"]
                                                    withTargetView:@"BrowseViewController"
                                                          isRandom:NO]];
}

- (int) size
{
    return (int)[self.store count];
}

- (SelectionViewModel *) modelAtIndex:(int)index
{
    return [self.store objectAtIndex:index];
}

- (NSString *) viewAtIndex:(int)index
{
    NSString *view = nil;
    if(index < [self.store count]){
        SelectionViewModel *model = [self.store objectAtIndex:index];
        view = model.name;
    }
    return view;
}

- (UIImage *) imageAtIndex:(int)index
{
    UIImage *image = nil;
    if(index < [self.store count]){
        SelectionViewModel *model = [self.store objectAtIndex:index];
        image = model.image;
    }
    return image;
}

@end
