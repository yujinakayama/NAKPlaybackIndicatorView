//
//  SnapshotTests.m
//  Tests
//
//  Created by Yuji Nakayama on 1/22/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import <NAPlaybackIndicatorView/NAPlaybackIndicatorView.h>

@interface SnapshotTests : FBSnapshotTestCase

@end

@implementation SnapshotTests

- (void)setUp
{
    [super setUp];

    // Flip this to YES to record images in the reference image directory.
    // You need to do this the first time you create a test and whenever you change the snapshotted views.
    // Be careful not to commit with recordMode on though, or your tests will never fail.
    self.recordMode = NO;
}

- (void)testIdleStateContent
{
    NAPlaybackIndicatorView* view = [[NAPlaybackIndicatorView alloc] initWithFrame:[self minimumFrame]];
    FBSnapshotVerifyView(view, nil);
}

- (void)testConteredContentPositionInLargeFrame
{
    NAPlaybackIndicatorView* view = [[NAPlaybackIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    FBSnapshotVerifyView(view, nil);
}

- (void)testTintColor
{
    NAPlaybackIndicatorView* view = [[NAPlaybackIndicatorView alloc] initWithFrame:[self minimumFrame]];
    view.tintColor = [self musicAppTintColor];
    FBSnapshotVerifyView(view, nil);
}

- (void)testSuperviewTintColor
{
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    baseView.tintColor = [self musicAppTintColor];

    NAPlaybackIndicatorView* view = [[NAPlaybackIndicatorView alloc] initWithFrame:[self minimumFrame]];
    [baseView addSubview:view];

    FBSnapshotVerifyView(view, nil);
}

- (CGRect)minimumFrame
{
    return CGRectMake(0.0, 0.0, 13.0, 12.0);
}

- (UIColor*)musicAppTintColor
{
    return [UIColor colorWithHue:0.968 saturation:0.827 brightness:1.000 alpha:1.000];
}

@end
