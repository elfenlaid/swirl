//
//  SWLRill.h
//  Swirl
//
//  Created by elfenlaid on 3/31/15.
//  Copyright (c) 2015 Hellsing. All rights reserved.
//

@import Foundation;

typedef id (^SWLRillCallback)();


@interface SWLRill : NSObject <NSCopying>

@property (atomic, strong, readonly) id value;

- (instancetype)initWithBlock:(SWLRillCallback)block;

- (void)addDependencyWithObject:(id)object keyPath:(NSString *)path;
- (void)removeDependencyWithObject:(id)object keyPath:(NSString *)path;

- (void)rill;

@end
