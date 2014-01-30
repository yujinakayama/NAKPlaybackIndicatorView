//
//  NAPlaybackIndicatorView.m
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/27/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "NAPlaybackIndicatorView.h"
#import "NAPlaybackIndicatorContentView.h"

@interface NAPlaybackIndicatorView ()

@property (nonatomic, readonly) NAPlaybackIndicatorContentView* contentView;
@property (nonatomic, readwrite, getter = isAnimating) BOOL animating;

@end

@implementation NAPlaybackIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _contentView = [[NAPlaybackIndicatorContentView alloc] init];
    [self addSubview:_contentView];

    // Custom views should set default values for both orientations on creation,
    // based on their content, typically to NSLayoutPriorityDefaultLow or NSLayoutPriorityDefaultHigh.
    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

    [self setNeedsUpdateConstraints];

    self.state = NAPlaybackIndicatorViewStateStopped;
    self.hidesWhenStopped = YES;
}

- (void)updateConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];

    [super updateConstraints];
}

- (CGSize)intrinsicContentSize
{
    return [self.contentView intrinsicContentSize];
}

- (UIView*)viewForBaselineLayout
{
    return self.contentView;
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;

    if (self.state == NAPlaybackIndicatorViewStateStopped) {
        self.hidden = self.hidesWhenStopped;
    }
}

- (void)setState:(NAPlaybackIndicatorViewState)state
{
    _state = state;

    if (self.state == NAPlaybackIndicatorViewStateStopped) {
        [self stopAnimating];
        if (self.hidesWhenStopped) {
            self.hidden = YES;
        }
    } else {
        if (self.state == NAPlaybackIndicatorViewStatePlaying) {
            [self startAnimating];
        } else if (self.state == NAPlaybackIndicatorViewStatePaused) {
            [self stopAnimating];
        }
        self.hidden = NO;
    }
}

- (void)startAnimating
{
    if (self.isAnimating) {
        return;
    }

    self.animating = YES;

    [self.contentView stopDecay];
    [self.contentView startOscillation];
}

- (void)stopAnimating
{
    if (!self.isAnimating) {
        return;
    }

    self.animating = NO;

    [self.contentView stopOscillation];
    [self.contentView startDecay];
}

@end
