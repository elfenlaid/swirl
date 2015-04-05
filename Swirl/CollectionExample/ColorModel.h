//
// Created by elfenlaid on 4/5/15.
//
// All Hail AppCode.
//

@import UIKit;


@interface ColorModel : NSObject <NSCopying>

@property (nonatomic, strong, readonly) NSArray *colors;
@property (nonatomic, strong, readonly) UIColor *selectedColor;

+ (instancetype)modelWithColors:(NSArray *)colors selectedColor:(UIColor *)selectedColor;

- (instancetype)modelWithSelectedColor:(UIColor *)selectedColor;

@end