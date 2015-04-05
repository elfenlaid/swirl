//
// Created by elfenlaid on 4/4/15.
//
// All Hail AppCode.
//

@import UIKit;
@class CollectionDataSource;
@class SWLRill;


@interface CollectionViewController : UIViewController

+ (instancetype)controllerWithLayout:(UICollectionViewLayout *)layout dataSource:(CollectionDataSource *)dataSource;

- (void)setSelectedItemRill:(SWLRill *)selectedItemRill;

@end