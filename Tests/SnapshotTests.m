//
//  SnapshotTests.m
//  Tests
//
//  Created by Yuji Nakayama on 1/22/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

#import "NAKPlaybackIndicatorView.h"

@interface SnapshotTests : FBSnapshotTestCase

@end

@implementation SnapshotTests {
    NAKPlaybackIndicatorView* _view;
}

- (void)setUp
{
    [super setUp];

    // Flip this to YES to record images in the reference image directory.
    // You need to do this the first time you create a test and whenever you change the snapshotted views.
    // Be careful not to commit with recordMode on though, or your tests will never fail.
    self.recordMode = NO;

    _view = [[NAKPlaybackIndicatorView alloc] initWithFrame:[self minimumFrame]];
    _view.state = NAKPlaybackIndicatorViewStatePaused;
}

- (void)testPausedContent
{
    FBSnapshotVerifyView(_view, nil);
}

- (void)testConteredContentPositionInLargeFrame
{
    _view = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
    _view.state = NAKPlaybackIndicatorViewStatePaused;
    FBSnapshotVerifyView(_view, nil);
}

- (void)testClippedContentInSmallFrame
{
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 20.0, 20.0)];

    _view = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectMake(5.0, 5.0, 10.0, 10.0)];
    _view.state = NAKPlaybackIndicatorViewStatePaused;
    [baseView addSubview:_view];

    FBSnapshotVerifyView(baseView, nil);
}

- (void)testTintColor
{
    _view.tintColor = [self musicAppTintColor];
    FBSnapshotVerifyView(_view, nil);
}

- (void)testSuperviewTintColor
{
    UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    baseView.tintColor = [self musicAppTintColor];

    [baseView addSubview:_view];

    // It seems the superview's tint color is not propagated in the current run loop.
    // FBSnapshotVerifyView(_view, nil);
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
