//
// Created by elfenlaid on 4/5/15.
// Copyright (c) 2015 Hellsing. All rights reserved.
//

#import "ColorModel.h"


@interface ColorModel ()
@property (nonatomic, strong, readwrite) NSArray *colors;
@property (nonatomic, strong, readwrite) UIColor *selectedColor;
@end


@implementation ColorModel

- (instancetype)initWithColors:(NSArray *)colors selectedColor:(UIColor *)selectedColor {
    self = [super init];
    if (self) {
        self.colors = colors;
        self.selectedColor = selectedColor;
    }

    return self;
}

+ (instancetype)modelWithColors:(NSArray *)colors selectedColor:(UIColor *)selectedColor {
    return [[self alloc] initWithColors:colors selectedColor:selectedColor];
}

- (instancetype)modelWithSelectedColor:(UIColor *)selectedColor {
    if ([self.selectedColor isEqual:selectedColor]) return self;

    ColorModel *model = [self copy];
    model.selectedColor = selectedColor;
    return model;
}

#pragma mark - Utils

- (id)copyWithZone:(NSZone *)zone {
    ColorModel *copy = (ColorModel *)[[[self class] alloc] init];

    if (copy != nil) {
        copy->_colors = _colors;
        copy->_selectedColor = _selectedColor;
    }

    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToModel:other];
}

- (BOOL)isEqualToModel:(ColorModel *)model {
    if (self == model)
        return YES;
    if (model == nil)
        return NO;
    if (self.colors != model.colors && ![self.colors isEqualToArray:model.colors])
        return NO;
    if (self.selectedColor != model.selectedColor && ![self.selectedColor isEqual:model.selectedColor])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = [self.colors hash];
    hash = hash * 31u + [self.selectedColor hash];
    return hash;
}


@end