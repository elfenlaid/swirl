//
// Created by elfenlaid on 4/4/15.
// Copyright (c) 2015 Hellsing. All rights reserved.
//

#import <KVOController/FBKVOController.h>
#import "_SWLRillDependency.h"


@interface _SWLRillDependency ()
@property (nonatomic, strong, readwrite) id object;
@property (nonatomic, copy, readwrite) NSString *keyPath;
@property (nonatomic, strong, readwrite) FBKVOController *controller;
@end

@implementation _SWLRillDependency

- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath controller:(FBKVOController *)controller {
    self = [super init];
    if (self) {
        self.object = object;
        self.keyPath = keyPath;
        self.controller = controller;
    }

    return self;
}

+ (instancetype)dependencyWithObject:(id)object keyPath:(NSString *)keyPath controller:(FBKVOController *)controller {
    return [[self alloc] initWithObject:object keyPath:keyPath controller:controller];
}

- (BOOL)isDependencyForObject:(id)object withKeyPath:(NSString *)keyPath {
    BOOL isDependency = [self.object isEqual:object] && (keyPath == nil || [self.keyPath isEqual:keyPath]);
    return isDependency;
}

@end