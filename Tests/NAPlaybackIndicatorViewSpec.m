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
#import <NAPlaybackIndicatorView/NAPlaybackIndicatorView.h>

SpecBegin(NAPlaybackIndicatorView)

describe(@"NAPlaybackIndicatorView", ^{
    describe(@"-intrinsicContentSize", ^{
        __block NAPlaybackIndicatorView* view;

        before(^{
            view = [[NAPlaybackIndicatorView alloc] initWithFrame:CGRectZero];
        });

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
});

SpecEnd
