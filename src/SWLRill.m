//
//  SWLRill.m
//  Swirl
//
//  Created by elfenlaid on 3/31/15.
//  Copyright (c) 2015 Hellsing. All rights reserved.
//

#import <KVOController/FBKVOController.h>

#import "SWLRill.h"
#import "_SWLRillDependency.h"


@interface SWLRill ()
@property (nonatomic, copy) SWLRillCallback block;
@property (nonatomic, strong) NSLock *valueLock;
@property (nonatomic, strong) NSMutableArray *dependencies;
@property (nonatomic, strong) NSLock *dependenciesLock;
@end


@implementation SWLRill

- (instancetype)init {
    self = [super init];
    if (self) {
        self.valueLock = [NSLock new];
        self.dependencies = [NSMutableArray new];
        self.dependenciesLock = [NSLock new];
    }

    return self;
}

- (instancetype)initWithBlock:(SWLRillCallback)block {
    self = [self init];
    if (self) {
        self.block = block;
        if (!self.block) {
            self.block = (id)^{return nil;};
        }
    }

    return self;
}

- (void)rill {
    [self willChangeValueForKey:NSStringFromSelector(@selector(value))];
    [self didChangeValueForKey:NSStringFromSelector(@selector(value))];
}

#pragma mark - Value handling

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"value"]) return NO;
    return [super automaticallyNotifiesObserversForKey:key];
}

- (id)value {
    __block id value;
    [self dispatchInValueLock:^{
        value = self.block();
    }];
    return value;
}

- (void)dispatchInValueLock:(void (^)())block {
    [self.valueLock lock];
    block();
    [self.valueLock unlock];
}

#pragma mark - Dependencies handling

- (void)addDependencyWithObject:(id)object keyPath:(NSString *)path {
    NSParameterAssert(object);
    NSParameterAssert(path);

    if (!object || !path) return;

    FBKVOController *controller = [FBKVOController controllerWithObserver:self];
    [controller observe:object 
                keyPath:path 
                options:NSKeyValueObservingOptionNew 
                  block:^(SWLRill *rill, __unused id obj, __unused NSDictionary *change) {
                      [rill rill];
                  }];

    _SWLRillDependency *dependency = [_SWLRillDependency dependencyWithObject:object keyPath:path controller:controller];
    [self dispatchInDependencyLock:^{
        [self.dependencies addObject:dependency];
    }];
}

- (void)removeDependencyWithObject:(id)object keyPath:(NSString *)path {
    [self dispatchInDependencyLock:^{
        NSMutableArray *dependencies = [NSMutableArray new];
        for (_SWLRillDependency *dep in self.dependencies) {
            if ([dep isDependencyForObject:object withKeyPath:path]) {
                // Don't wait for autorelease pool and stop observing manually
                // to prevent observing calls in the current run loop
                [dep stopObserving];
            } else {
                [dependencies addObject:dep];
            }
        }

        self.dependencies = dependencies;
    }];
}

- (void)dispatchInDependencyLock:(void (^)())block {
    [self.dependenciesLock lock];
    block();
    [self.dependenciesLock unlock];
}

#pragma mark - Copying

- (id)copyWithZone:(NSZone *)zone {
    SWLRill *copy = (SWLRill *) [[[self class] alloc] init];

    if (copy != nil) {
        copy.block = self.block;
    }

    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;

    return [self isEqualToRill:other];
}

- (BOOL)isEqualToRill:(SWLRill *)rill {
    if (self == rill)
        return YES;
    if (rill == nil)
        return NO;
    if (self.block != rill.block)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return (NSUInteger) self.block;
}

@end
