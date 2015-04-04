//
//  SinkTests.m
//  Swirl
//
//  Created by elfenlaid on 4/4/15.
//  Copyright (c) 2015 Hellsing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SWLSink.h"
#import "SWLRill.h"
#import "KVOObject.h"


@interface SinkTests : XCTestCase

@end

@implementation SinkTests

- (void)testManualSink {
    XCTestExpectation *sinkExpectation = [self expectationWithDescription:@"manual call"];

    SWLSink *sink = [[SWLSink alloc] initWithBlock:^{
        [sinkExpectation fulfill];
    }];

    [sink sink];

    [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testAddRillDependency {
    XCTestExpectation *sinkExpectation = [self expectationWithDescription:@"rill"];

    SWLSink *sink = [[SWLSink alloc] initWithBlock:^{
        [sinkExpectation fulfill];
    }];

    SWLRill *rill = [[SWLRill alloc] initWithBlock:nil];
    [sink addRillDependency:rill];

    KVOObject *object = [KVOObject new];
    [rill addDependencyWithObject:object keyPath:NSStringFromSelector(@selector(number))];
    object.number = @0;

    [self waitForExpectationsWithTimeout:0 handler:nil];
}

- (void)testRemoveRillDependency {
    SWLSink *sink = [[SWLSink alloc] initWithBlock:^{
        XCTFail(@"shouldn't be called");
    }];

    SWLRill *rill = [[SWLRill alloc] initWithBlock:nil];
    [sink addRillDependency:rill];
    [sink removeRillDependency:rill];

    KVOObject *object = [KVOObject new];
    [rill addDependencyWithObject:object keyPath:NSStringFromSelector(@selector(number))];
    object.number = @0;
}

@end
