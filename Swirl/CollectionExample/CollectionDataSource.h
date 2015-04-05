//
// Created by elfenlaid on 4/4/15.
//
// All Hail AppCode.
//

@import UIKit;
@class SWLRill;
@class SWLSink;


@interface CollectionDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong, readonly) SWLRill *reloadItemsRill;

- (void)registerCollectionView:(UICollectionView *)collectionView;
- (void)setDataRill:(SWLRill *)dataRill;

- (NSIndexPath *)indexPathForItem:(id)item;

@end