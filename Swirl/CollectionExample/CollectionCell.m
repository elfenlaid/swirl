//
// Created by elfenlaid on 4/5/15.
// Copyright (c) 2015 Hellsing. All rights reserved.
//

#import "CollectionCell.h"


@interface CollectionCell()
@property (nonatomic, strong) UIColor *color;
@end


@implementation CollectionCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self.class);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateColor];
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self updateColor];
}

- (void)updateColor {
    self.contentView.backgroundColor = self.selected ? [UIColor whiteColor] : self.color;
}

@end