//
//  NAPlaybackIndicatorViewSpec.m
//  Tests
//
//  Created by Yuji Nakayama on 1/31/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <NAPlaybackIndicatorView/NAPlaybackIndicatorView.h>

SpecBegin(NAPlaybackIndicatorView)

describe(@"NAPlaybackIndicatorView", ^{
    __block NAPlaybackIndicatorView* view;

    before(^{
        view = [[NAPlaybackIndicatorView alloc] initWithFrame:CGRectZero];
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

    describe(@"-state", ^{
        context(@"initially", ^{
            it(@"is NAPlaybackIndicatorViewStateStopped", ^{
                expect(view.state).to.equal(NAPlaybackIndicatorViewStateStopped);
            });
        });
    });

    describe(@"-setState:", ^{
        it(@"sets the state", ^{
            view.state = NAPlaybackIndicatorViewStatePlaying;
            expect(view.state).to.equal(NAPlaybackIndicatorViewStatePlaying);
        });

        context(@"when NAPlaybackIndicatorViewStateStopped is passed", ^{
            it(@"stops the animation", ^{
                id mock = [OCMockObject partialMockForObject:view];
                [[mock expect] stopAnimating];

                view.state = NAPlaybackIndicatorViewStateStopped;

                [mock verify];
            });

            context(@"when -hidesWhenStopped is YES", ^{
                before(^{
                    view.hidesWhenStopped = YES;
                });

                it(@"hides the view", ^{
                    view.hidden = NO;
                    view.state = NAPlaybackIndicatorViewStateStopped;
                    expect(view.isHidden).to.equal(YES);
                });
            });

            context(@"when -hidesWhenStopped is NO", ^{
                before(^{
                    view.hidesWhenStopped = NO;
                });

                it(@"does not change the visibility", ^{
                    view.hidden = NO;
                    view.state = NAPlaybackIndicatorViewStateStopped;
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

        context(@"when NAPlaybackIndicatorViewStatePlaying is passed", ^{
            it(@"starts the animation", ^{
                id mock = [OCMockObject partialMockForObject:view];
                [[mock expect] startAnimating];

                view.state = NAPlaybackIndicatorViewStatePlaying;

                [mock verify];
            });

            itBehavesLike(@"always shows the view", ^{
                return @{ @"state" : @(NAPlaybackIndicatorViewStatePlaying) };
            });
        });

        context(@"when NAPlaybackIndicatorViewStatePaused is passed", ^{
            it(@"stops the animation", ^{
                id mock = [OCMockObject partialMockForObject:view];
                [[mock expect] stopAnimating];

                view.state = NAPlaybackIndicatorViewStatePaused;

                [mock verify];
            });

            itBehavesLike(@"always shows the view", ^{
                return @{ @"state" : @(NAPlaybackIndicatorViewStatePaused) };
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

            context(@"when -state is NAPlaybackIndicatorViewStateStopped", ^{
                it(@"shows the view", ^{
                    view.state = NAPlaybackIndicatorViewStateStopped;
                    expect(view.isHidden).to.equal(YES);
                    view.hidesWhenStopped = NO;
                    expect(view.isHidden).to.equal(NO);
                });
            });

            context(@"when -state is other than NAPlaybackIndicatorViewStateStopped", ^{
                it(@"does not change the visibility", ^{
                    view.state = NAPlaybackIndicatorViewStatePaused;
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

            context(@"when -state is NAPlaybackIndicatorViewStateStopped", ^{
                it(@"hides the view", ^{
                    view.state = NAPlaybackIndicatorViewStateStopped;
                    expect(view.isHidden).to.equal(NO);
                    view.hidesWhenStopped = YES;
                    expect(view.isHidden).to.equal(YES);
                });
            });

            context(@"when -state is other than NAPlaybackIndicatorViewStateStopped", ^{
                it(@"does not change the visibility", ^{
                    view.state = NAPlaybackIndicatorViewStatePaused;
                    expect(view.isHidden).to.equal(NO);
                    view.hidesWhenStopped = YES;
                    expect(view.isHidden).to.equal(NO);
                });
            });
        });
    });
});

SpecEnd
