//
// Created by elfenlaid on 4/4/15.
//
// All Hail AppCode.
//


@import Foundation;
@class FBKVOController;

@interface _SWLRillDependency : NSObject

+ (instancetype)dependencyWithObject:(id)object keyPath:(NSString *)keyPath controller:(FBKVOController *)controller;

- (BOOL)isDependencyForObject:(id)object withKeyPath:(NSString *)keyPath;

@end