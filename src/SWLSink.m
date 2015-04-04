//
//  SWLSink.m
//  Swirl
//
//  Created by elfenlaid on 3/31/15.
//  Copyright (c) 2015 Hellsing. All rights reserved.
//

#import <KVOController/FBKVOController.h>

#import "SWLSink.h"
#import "SWLRill.h"


@interface SWLSink ()
@property (nonatomic, copy) SWLSinkCallback block;
@property (nonatomic, retain) NSMutableDictionary *dependencies;
@property (nonatomic, strong) NSLock *dependenciesLock;
@end


@implementation SWLSink

- (instancetype)initWithBlock:(SWLSinkCallback)block {
    if (!block) return nil;
    
    self = [super init];
    if (self) {
        self.block = block;
        self.dependenciesLock = [NSLock new];
        self.dependencies = [NSMutableDictionary dictionary];
    }

    return self;
}

- (void)sink {
    self.block();
}

- (void)addRillDependency:(SWLRill *)rill {
    FBKVOController *controller = [FBKVOController controllerWithObserver:self];
    [controller observe:rill
                keyPath:NSStringFromSelector(@selector(value))
                options:NSKeyValueObservingOptionNew
                  block:^(SWLSink *sink, __unused id object, __unused NSDictionary *change) {
                      sink.block();
                  }];

    [self dispatchInLock:^{
        self.dependencies[rill] = controller;
    }];
}

- (void)removeRillDependency:(SWLRill *)rill {
    [self dispatchInLock:^{
        [self.dependencies removeObjectForKey:rill];
    }];
}

- (void)dispatchInLock:(void (^)())block {
    [self.dependenciesLock lock];
    if (block) block();
    [self.dependenciesLock unlock];
}

@end
