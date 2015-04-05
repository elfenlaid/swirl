//
//  ViewController.m
//  Swirl
//
//  Created by elfenlaid on 3/31/15.
//  Copyright (c) 2015 Hellsing. All rights reserved.
//

#import "Masonry.h"

#import "ViewController.h"
#import "CollectionDataSource.h"
#import "CollectionViewController.h"
#import "ColorModel.h"
#import "ColorModel.h"
#import "SWLRill.h"


@interface ViewController ()
@property (nonatomic, strong) ColorModel *colorsModel;
@end


@implementation ViewController

- (void)loadView {
    [super loadView];

    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = (CGSize){60, 60};
    CGFloat inset = 15;
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);

    CollectionDataSource *dataSource = [CollectionDataSource new];

    CollectionViewController *controller = [CollectionViewController controllerWithLayout:layout dataSource:dataSource];

    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [controller didMoveToParentViewController:self];

    __weak typeof(self) wSelf = self;
    SWLRill *dataRill = [[SWLRill alloc] initWithBlock:^id {
        return wSelf.colorsModel.colors;
    }];
    [dataRill addDependencyWithObject:self keyPath:NSStringFromSelector(@selector(colorsModel))];
    dataSource.dataRill = dataRill;

    SWLRill *selectedItemRill = [[SWLRill alloc] initWithBlock:^id {
        return wSelf.colorsModel.selectedColor;
    }];
    [selectedItemRill addDependencyWithObject:self keyPath:NSStringFromSelector(@selector(colorsModel))];
    controller.selectedItemRill = selectedItemRill;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *randomColors = [self createColorsArrayWithItemCount:120];
    self.colorsModel = [ColorModel modelWithColors:randomColors selectedColor:nil];

    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(selectRandomColor) userInfo:nil repeats:YES];
}

- (void)selectRandomColor {
    id color = self.colorsModel.colors[arc4random() % self.colorsModel.colors.count];
    self.colorsModel = [self.colorsModel modelWithSelectedColor:color];
}

- (NSArray *)createColorsArrayWithItemCount:(NSUInteger)count {
    NSMutableArray *colors = [NSMutableArray new];
    for (NSUInteger i = 0; i < count; ++i) {
        UIColor *color = [UIColor colorWithRed:arc4random() % 256 / 255.f
                                         green:arc4random() % 256 / 255.f
                                          blue:arc4random() % 256 / 255.f
                                         alpha:1.0];
        [colors addObject:color];
    }
    return colors;
}

@end
