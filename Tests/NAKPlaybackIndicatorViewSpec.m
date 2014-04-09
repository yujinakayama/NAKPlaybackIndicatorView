//
//  NAKPlaybackIndicatorViewSpec.m
//  Tests
//
//  Created by Yuji Nakayama on 1/31/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "NAKPlaybackIndicatorView.h"
#import "NAKPlaybackIndicatorContentView.h"

static void NAKRemoveAllAnimationsRecursively(CALayer* layer)
{
    [layer removeAllAnimations];
    for (CALayer* sublayer in layer.sublayers) {
        NAKRemoveAllAnimationsRecursively(sublayer);
    }
}

@interface NAKPlaybackIndicatorView (Internal)

@property (nonatomic, readonly) NAKPlaybackIndicatorContentView* contentView;

@end

SpecBegin(NAKPlaybackIndicatorView)

describe(@"NAKPlaybackIndicatorView", ^{
    __block NAKPlaybackIndicatorView* view;

    before(^{
        view = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectZero];
    });

    describe(@"-intrinsicContentSize", ^{
        it(@"returns minimum size to display the content", ^{
            CGSize expectedSize;

            if ([UIScreen mainScreen].scale == 2.0) {
                expectedSize = CGSizeMake(12.0, 12.0);
            } else {
                expectedSize = CGSizeMake(13.0, 12.0);
            }

            expect([view intrinsicContentSize]).to.equal(expectedSize);
        });
    });

    describe(@"-sizeToFit", ^{
        it(@"resizes the view to fit to the content", ^{
            UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];

            view = [[NAKPlaybackIndicatorView alloc] initWithFrame:CGRectMake(10.0, 10.0, 50.0, 50.0)];
            [baseView addSubview:view];

            CGRect expectedRect;

            if ([UIScreen mainScreen].scale == 2.0) {
                expectedRect = CGRectMake(10.0, 10.0, 12.0, 12.0);
            } else {
                expectedRect = CGRectMake(10.0, 10.0, 13.0, 12.0);
            }

            [view sizeToFit];

            expect(view.frame).to.equal(expectedRect);
        });
    });

    describe(@"-state", ^{
        context(@"initially", ^{
            it(@"is NAKPlaybackIndicatorViewStateStopped", ^{
                expect(view.state).to.equal(NAKPlaybackIndicatorViewStateStopped);
            });
        });
    });

    describe(@"-setState:", ^{
        it(@"sets the state", ^{
            view.state = NAKPlaybackIndicatorViewStatePlaying;
            expect(view.state).to.equal(NAKPlaybackIndicatorViewStatePlaying);
        });

        context(@"when NAKPlaybackIndicatorViewStateStopped is passed", ^{
            it(@"stops the animation", ^{
                id mock = [OCMockObject partialMockForObject:view];
                [[mock expect] stopAnimating];

                view.state = NAKPlaybackIndicatorViewStateStopped;

                [mock verify];
            });

            context(@"when -hidesWhenStopped is YES", ^{
                before(^{
                    view.hidesWhenStopped = YES;
                });

                it(@"hides the view", ^{
                    view.hidden = NO;
                    view.state = NAKPlaybackIndicatorViewStateStopped;
                    expect(view.isHidden).to.equal(YES);
                });
            });

            context(@"when -hidesWhenStopped is NO", ^{
                before(^{
                    view.hidesWhenStopped = NO;
                });

                it(@"does not change the visibility", ^{
                    view.hidden = NO;
                    view.state = NAKPlaybackIndicatorViewStateStopped;
                    expect(view.isHidden).to.equal(NO);
                });
            });
        });

        sharedExamples(@"always shows the view", ^(NSDictionary *data) {
            context(@"when -hidesWhenStopped is YES", ^{
                before(^{
                    view.hidesWhenStopped = YES;
                });

                it(@"shows the view", ^{
                    view.hidden = YES;
                    view.state = [data[@"state"] integerValue];
                    expect(view.isHidden).to.equal(NO);
                });
            });

            context(@"when -hidesWhenStopped is NO", ^{
                before(^{
                    view.hidesWhenStopped = NO;
                });

                it(@"shows the view", ^{
                    view.hidden = YES;
                    view.state = [data[@"state"] integerValue];
                    expect(view.isHidden).to.equal(NO);
                });
            });
        });

        context(@"when NAKPlaybackIndicatorViewStatePlaying is passed", ^{
            it(@"starts the animation", ^{
                id mock = [OCMockObject partialMockForObject:view];
                [[mock expect] startAnimating];

                view.state = NAKPlaybackIndicatorViewStatePlaying;

                [mock verify];
            });

            itBehavesLike(@"always shows the view", ^{
                return @{ @"state" : @(NAKPlaybackIndicatorViewStatePlaying) };
            });
        });

        context(@"when NAKPlaybackIndicatorViewStatePaused is passed", ^{
            it(@"stops the animation", ^{
                id mock = [OCMockObject partialMockForObject:view];
                [[mock expect] stopAnimating];

                view.state = NAKPlaybackIndicatorViewStatePaused;

                [mock verify];
            });

            itBehavesLike(@"always shows the view", ^{
                return @{ @"state" : @(NAKPlaybackIndicatorViewStatePaused) };
            });
        });
    });

    describe(@"-isHidden", ^{
        context(@"initially", ^{
            it(@"is YES", ^{
                expect(view.isHidden).to.equal(YES);
            });
        });
    });

    describe(@"-hidesWhenStopped", ^{
        context(@"initially", ^{
            it(@"is YES", ^{
                expect(view.hidesWhenStopped).to.equal(YES);
            });
        });
    });

    describe(@"-setHidesWhenStopped:", ^{
        it(@"sets the boolean", ^{
            view.hidesWhenStopped = NO;
            expect(view.hidesWhenStopped).to.equal(NO);
        });

        context(@"when changed from YES to NO", ^{
            before(^{
                view.hidesWhenStopped = YES;
            });

            context(@"when -state is NAKPlaybackIndicatorViewStateStopped", ^{
                it(@"shows the view", ^{
                    view.state = NAKPlaybackIndicatorViewStateStopped;
                    expect(view.isHidden).to.equal(YES);
                    view.hidesWhenStopped = NO;
                    expect(view.isHidden).to.equal(NO);
                });
            });

            context(@"when -state is other than NAKPlaybackIndicatorViewStateStopped", ^{
                it(@"does not change the visibility", ^{
                    view.state = NAKPlaybackIndicatorViewStatePaused;
                    expect(view.isHidden).to.equal(NO);
                    view.hidesWhenStopped = NO;
                    expect(view.isHidden).to.equal(NO);
                });
            });
        });

        context(@"when changed from NO to YES", ^{
            before(^{
                view.hidesWhenStopped = NO;
            });

            context(@"when -state is NAKPlaybackIndicatorViewStateStopped", ^{
                it(@"hides the view", ^{
                    view.state = NAKPlaybackIndicatorViewStateStopped;
                    expect(view.isHidden).to.equal(NO);
                    view.hidesWhenStopped = YES;
                    expect(view.isHidden).to.equal(YES);
                });
            });

            context(@"when -state is other than NAKPlaybackIndicatorViewStateStopped", ^{
                it(@"does not change the visibility", ^{
                    view.state = NAKPlaybackIndicatorViewStatePaused;
                    expect(view.isHidden).to.equal(NO);
                    view.hidesWhenStopped = YES;
                    expect(view.isHidden).to.equal(NO);
                });
            });
        });
    });

    context(@"when an app has entered background and came back to foreground", ^{
        context(@"when -state is NAKPlaybackIndicatorViewStatePlaying", ^{
            it(@"restarts the animation which is removed by UIKit when the app entered background", ^{
                view.state = NAKPlaybackIndicatorViewStatePlaying;
                expect(view.contentView.isOscillating).to.equal(YES);

                NAKRemoveAllAnimationsRecursively(view.layer); // Emulate removal of animations by UIKit
                expect(view.contentView.isOscillating).to.equal(NO);

                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification
                                                                    object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification
                                                                    object:nil];
                expect(view.contentView.isOscillating).to.equal(YES);
            });
        });

        context(@"when -state is other than NAKPlaybackIndicatorViewStatePlaying", ^{
            it(@"does nothing", ^{
                view.state = NAKPlaybackIndicatorViewStatePaused;
                expect(view.contentView.isOscillating).to.equal(NO);

                NAKRemoveAllAnimationsRecursively(view.layer); // Emulate removal of animations by UIKit
                expect(view.contentView.isOscillating).to.equal(NO);

                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification
                                                                    object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidBecomeActiveNotification
                                                                    object:nil];
                expect(view.contentView.isOscillating).to.equal(NO);
            });
        });
    });
});

SpecEnd
