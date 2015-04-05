//
// Created by elfenlaid on 4/4/15.
// Copyright (c) 2015 Hellsing. All rights reserved.
//

#import "CollectionDataSource.h"
#import "SWLRill.h"
#import "SWLSink.h"
#import "CollectionCell.h"


@interface CollectionDataSource ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) SWLRill *dataRill;
@property (nonatomic, strong) SWLSink *dataSink;
@property (nonatomic, strong, readwrite) SWLRill *reloadItemsRill;
@end


@implementation CollectionDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        __weak typeof(self) wSelf = self;
        self.dataSink = [[SWLSink alloc] initWithBlock:^{
            wSelf.data = wSelf.dataRill.value;
        }];
        self.reloadItemsRill = [[SWLRill alloc] initWithBlock:nil];
    }

    return self;
}

- (void)registerCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:[CollectionCell reuseIdentifier]];
    self.collectionView = collectionView;
}

- (void)setData:(NSArray *)dataArray {
    _data = dataArray;
    [self.collectionView reloadData];
    [self.reloadItemsRill rill];
}

- (void)setDataRill:(SWLRill *)dataRill {
    [self.dataSink removeRillDependency:self.dataRill];
    [self.dataSink addRillDependency:dataRill];
    _dataRill = dataRill;
    [self.dataSink sink];
}

#pragma mark - Data utils

- (NSIndexPath *)indexPathForItem:(id)item {
    if (!self.data) return nil;
    
    NSUInteger itemIndex = [self.data indexOfObject:item];
    if (itemIndex == NSNotFound) return nil;
    
    return [NSIndexPath indexPathForRow:itemIndex inSection:0];
}

- (id)itemAtIndexPath:(NSIndexPath *)path {
    if ((NSUInteger)path.row >= self.data.count) return nil;
    return self.data[(NSUInteger) path.row];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CollectionCell reuseIdentifier] forIndexPath:indexPath];
    cell.color = [self itemAtIndexPath:indexPath];
    return cell;
}

@end