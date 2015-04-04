//
//  RillTests.m
//  Swirl
//
//  Created by elfenlaid on 4/4/15.
//  Copyright (c) 2015 Hellsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KVOController/FBKVOController.h>
#import "SWLRill.h"

@interface KVOObject : NSObject
@property (nonatomic, strong) NSNumber *number;
@end

@implementation KVOObject
@end

@interface RillTests : XCTestCase

@end

@implementation RillTests

- (void)testAddDependency {
    SWLRill *rill = [[SWLRill alloc] initWithBlock:nil];

    XCTestExpectation *callExpectation = [self expectationWithDescription:@"call on dependency"];
    FBKVOController *controller = [FBKVOController controllerWithObserver:self];
    [controller observe:rill
                keyPath:NSStringFromSelector(@selector(value))
                options:NSKeyValueObservingOptionNew
                  block:^(id observer, id r, NSDictionary *change) {
                      [callExpectation fulfill];
                  }];

    KVOObject *object = [KVOObject new];
    [rill addDependencyWithObject:object keyPath:NSStringFromSelector(@selector(number))];
    object.number = @0;

    [self waitForExpectationsWithTimeout:0.1 handler:nil];
}

- (void)testRemoveDependency {
    SWLRill *rill = [[SWLRill alloc] initWithBlock:nil];

    FBKVOController *controller = [FBKVOController controllerWithObserver:self];
    [controller observe:rill
                keyPath:NSStringFromSelector(@selector(value))
                options:NSKeyValueObservingOptionNew
                  block:^(id observer, id r, NSDictionary *change) {
                      XCTFail(@"shouldn't be called");
                  }];

    KVOObject *object = [KVOObject new];
    [rill addDependencyWithObject:object keyPath:NSStringFromSelector(@selector(number))];
    [rill removeDependencyWithObject:object keyPath:NSStringFromSelector(@selector(number))];
    object.number = @0;

    [rill addDependencyWithObject:object keyPath:NSStringFromSelector(@selector(number))];
    [rill removeDependencyWithObject:object keyPath:nil];
    object.number = @0;

    XCTAssert(YES, @"Pass");
}


- (void)testValue {
    SWLRill *rill = [[SWLRill alloc] initWithBlock:^id {
        return @"testValue";
    }];

    XCTAssertEqual(rill.value, @"testValue", @"should return right value");
}

@end
