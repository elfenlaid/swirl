//
//  SWLSink.h
//  Swirl
//
//  Created by elfenlaid on 3/31/15.
//  Copyright (c) 2015 Hellsing. All rights reserved.
//

@import Foundation;

@class SWLRill;

typedef void (^SWLSinkCallback)();


@interface SWLSink : NSObject

- (instancetype)initWithBlock:(SWLSinkCallback)block;

- (void)addRillDependency:(SWLRill *)rill;
- (void)removeRillDependency:(SWLRill *)rill;

- (void)sink;

@end
