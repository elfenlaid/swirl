//
// Created by elfenlaid on 4/4/15.
// Copyright (c) 2015 Hellsing. All rights reserved.
//

#import "Masonry.h"

#import "CollectionViewController.h"
#import "CollectionDataSource.h"
#import "SWLRill.h"
#import "SWLSink.h"


@interface CollectionViewController() <UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) CollectionDataSource *dataSource;
@property (nonatomic, strong) SWLRill *selectedItemRill;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SWLSink *selectedItemSink;
@end


@implementation CollectionViewController

+ (instancetype)controllerWithLayout:(UICollectionViewLayout *)layout dataSource:(CollectionDataSource *)dataSource {
    return [[self alloc] initWithLayout:layout dataSource:dataSource];
}

- (instancetype)initWithLayout:(UICollectionViewLayout *)layout dataSource:(CollectionDataSource *)dataSource {
    NSParameterAssert(layout);
    NSParameterAssert(dataSource);

    self = [super init];
    if (self) {
        self.layout = layout;
        self.dataSource = dataSource;

        __weak typeof(self) wSelf = self;
        self.selectedItemSink = [[SWLSink alloc] initWithBlock:^{
            id item = wSelf.selectedItemRill.value;
            NSIndexPath *path = [wSelf.dataSource indexPathForItem:item];
            if (path) {
                [wSelf.collectionView selectItemAtIndexPath:path animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
            }
        }];

        [self.selectedItemSink addRillDependency:self.dataSource.reloadItemsRill];
    }

    return self;
}

- (void)setSelectedItemRill:(SWLRill *)selectedItemRill {
    [self.selectedItemSink removeRillDependency:self.selectedItemRill];
    [self.selectedItemSink addRillDependency:selectedItemRill];
    _selectedItemRill = selectedItemRill;
    [self.selectedItemSink sink];
}

- (void)loadView {
    [super loadView];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    collectionView.dataSource = self.dataSource;
    collectionView.delegate = self;
    [self.dataSource registerCollectionView:collectionView];

    [self.view addSubview:collectionView];

    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.collectionView = collectionView;
}

@end