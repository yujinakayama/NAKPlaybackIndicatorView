//
//  NAKPlaybackIndicatorContentView.m
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/28/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "NAKPlaybackIndicatorContentView.h"

static const CFTimeInterval kMinBaseOscillationPeriod = 0.6;
static const CFTimeInterval kMaxBaseOscillationPeriod = 0.8;
static NSString* const kOscillationAnimationKey = @"oscillation";

static const CFTimeInterval kDecayDuration = 0.3;
static NSString* const kDecayAnimationKey = @"decay";

@interface NAKPlaybackIndicatorContentView ()

@property (nonatomic, readonly) NSArray<CALayer*>* barLayers;
@property (nonatomic, assign) BOOL hasInstalledConstraints;

@end

@implementation NAKPlaybackIndicatorContentView

#pragma mark - Initialization

- (instancetype)initWithStyle:(NAKPlaybackIndicatorViewStyle*)style
{
    self = [super init];
    if (self) {
        _style = style;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self prepareBarLayers];
        [self tintColorDidChange];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)prepareBarLayers
{
    NSMutableArray<CALayer*>* barLayers = [NSMutableArray array];
    CGFloat xOffset = 0.0;

    for (NSInteger i = 0; i < self.style.barCount; i++) {
        CALayer* layer = [self createBarLayerWithXOffset:xOffset];
        [barLayers addObject:layer];
        [self.layer addSublayer:layer];
        xOffset = CGRectGetMaxX(layer.frame) + self.style.actualBarSpacing;
    }

    _barLayers = barLayers;
}

- (CALayer*)createBarLayerWithXOffset:(CGFloat)xOffset
{
    CALayer* layer = [CALayer layer];

    layer.anchorPoint = CGPointMake(0.0, 1.0); // At the bottom-left corner
    layer.position = CGPointMake(xOffset, self.style.maxPeakBarHeight); // In superview's coordinate
    layer.bounds = CGRectMake(0.0, 0.0, self.style.barWidth, self.style.idleBarHeight);// In its own coordinate
    layer.allowsEdgeAntialiasing = YES;

    return layer;
}

#pragma mark - Tint Color

- (void)tintColorDidChange
{
    for (CALayer* layer in self.barLayers) {
        layer.backgroundColor = self.tintColor.CGColor;
    }
}

#pragma mark - Auto Layout

- (CGSize)intrinsicContentSize
{
    CGRect unionFrame = CGRectZero;

    for (CALayer* layer in self.barLayers) {
        unionFrame = CGRectUnion(unionFrame, layer.frame);
    }

    return unionFrame.size;
}

- (void)updateConstraints
{
    if (!self.hasInstalledConstraints) {
        CGSize size = [self intrinsicContentSize];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:size.width]];

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:size.height]];

        self.hasInstalledConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - Animations

- (void)startOscillation
{
    CFTimeInterval basePeriod = kMinBaseOscillationPeriod + (drand48() * (kMaxBaseOscillationPeriod - kMinBaseOscillationPeriod));

    for (CALayer* layer in self.barLayers) {
        [self startOscillatingBarLayer:layer basePeriod:basePeriod];
    }
}

- (void)stopOscillation
{
    for (CALayer* layer in self.barLayers) {
        [layer removeAnimationForKey:kOscillationAnimationKey];
    }
}

- (BOOL)isOscillating
{
    CAAnimation* animation = [self.barLayers.firstObject animationForKey:kOscillationAnimationKey];
    return (animation != nil);
}

- (void)startDecay
{
    for (CALayer* layer in self.barLayers) {
        [self startDecayingBarLayer:layer];
    }
}

- (void)stopDecay
{
    for (CALayer* layer in self.barLayers) {
        [layer removeAnimationForKey:kDecayAnimationKey];
    }
}

- (void)startOscillatingBarLayer:(CALayer*)layer basePeriod:(CFTimeInterval)basePeriod
{
    // arc4random_uniform() will return a uniformly distributed random number **less** upper_bound.
    CGFloat peakHeight = self.style.minPeakBarHeight + arc4random_uniform(self.style.maxPeakBarHeight - self.style.minPeakBarHeight + 1);

    CGRect toBounds = layer.bounds;
    toBounds.size.height = peakHeight;

    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:layer.bounds];
    animation.toValue = [NSValue valueWithCGRect:toBounds];
    animation.repeatCount = HUGE_VALF; // Forever
    animation.autoreverses = YES;
    animation.duration = (basePeriod / 2) * (self.style.maxPeakBarHeight / peakHeight);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

    [layer addAnimation:animation forKey:kOscillationAnimationKey];
}

- (void)startDecayingBarLayer:(CALayer*)layer
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:((CALayer*)layer.presentationLayer).bounds];
    animation.toValue = [NSValue valueWithCGRect:layer.bounds];
    animation.duration = kDecayDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    [layer addAnimation:animation forKey:kDecayAnimationKey];
}

@end
