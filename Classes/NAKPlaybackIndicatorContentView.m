//
//  NAKPlaybackIndicatorContentView.m
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/28/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "NAKPlaybackIndicatorContentView.h"
#import "NAKPlaybackIndicatorView.h"
/*
static const NSInteger kBarCount = 4;

static const CGFloat kBarWidth = 2.0;
static const CGFloat kBarIdleHeight = 3.0;

static const CGFloat kHorizontalBarSpacing = 2.0; // Measured on iPad 2 (non-Retina)
static const CGFloat kRetinaHorizontalBarSpacing = 1.5; // Measured on iPhone 5s (Retina)

static const CGFloat kBarMinPeakHeight = 6.0;
static const CGFloat kBarMaxPeakHeight = 12.0;
*/


static const CFTimeInterval kMinBaseOscillationPeriod = 0.6;
static const CFTimeInterval kMaxBaseOscillationPeriod = 0.8;

static NSString* const kOscillationAnimationKey = @"oscillation";

static const CFTimeInterval kDecayDuration = 0.3;
static NSString* const kDecayAnimationKey = @"decay";

@interface NAKPlaybackIndicatorContentView (){
    BOOL _isOscillating;

    NSInteger _barCount;
    CGFloat _barWidth;
    CGFloat _barIdleHeight;
    CGFloat _horizontalBarSpacing;
    CGFloat _retinaHorizontalBarSpacing;
    CGFloat _barMinPeakHeight;
    CGFloat _barMaxPeakHeight;
}

@property (nonatomic, readonly) NSArray* barLayers;

@end

@implementation NAKPlaybackIndicatorContentView

#pragma mark - Initialization


- (instancetype)initWithConfigDictionary:(NSDictionary *)configDictionary{
    self = [super init];
    if (self) {
       
        _barCount = [[configDictionary objectForKey:kBarCount] integerValue];
        _barWidth = [[configDictionary objectForKey:kBarWidth] floatValue];
        _barIdleHeight = [[configDictionary objectForKey:kBarIdleHeight] floatValue];
        _horizontalBarSpacing = [[configDictionary objectForKey:kHorizontalBarSpacing] floatValue];
        _retinaHorizontalBarSpacing = [[configDictionary objectForKey:kRetinaHorizontalBarSpacing] floatValue];
        _barMinPeakHeight = [[configDictionary objectForKey:kBarMinPeakHeight] floatValue];
        _barMaxPeakHeight = [[configDictionary objectForKey:kBarMaxPeakHeight] floatValue];
        
        _isOscillating = NO;
        
        [self prepareBarLayers];
        [self tintColorDidChange];
    }
    return self;
}

+ (NSDictionary *)defaultConfig{
    return @{kBarCount:@(4),
             kBarWidth:@(2.0),
             kBarIdleHeight:@(3.0),
             kHorizontalBarSpacing:@(2.0),
             kRetinaHorizontalBarSpacing:@(1.5),
             kBarMinPeakHeight:@(6.0),
             kBarMaxPeakHeight:@(12.0)};
}

- (void)prepareBarLayers
{
    NSMutableArray* barLayers = [NSMutableArray array];
    CGFloat xOffset = 0.0;

    for (NSInteger i = 0; i < _barCount; i++) {
        CALayer* layer = [self createBarLayerWithXOffset:xOffset];
        [barLayers addObject:layer];
        [self.layer addSublayer:layer];
        xOffset = CGRectGetMaxX(layer.frame) + [self horizontalBarSpacing];
    }

    _barLayers = barLayers;
}

- (CALayer*)createBarLayerWithXOffset:(CGFloat)xOffset
{
    CALayer* layer = [CALayer layer];

    layer.anchorPoint = CGPointMake(0.0, 1.0); // At the bottom-left corner
    layer.position = CGPointMake(xOffset, _barMaxPeakHeight); // In superview's coordinate
    layer.bounds = CGRectMake(0.0, 0.0, _barWidth, _barIdleHeight);// In its own coordinate

    return layer;
}

- (CGFloat)horizontalBarSpacing
{
    if ([UIScreen mainScreen].scale == 2.0) {
        return _retinaHorizontalBarSpacing;
    } else {
        return _horizontalBarSpacing;
    }
}

#pragma mark - Tint Color

- (void)tintColorDidChange
{
    for (CALayer* layer in self.barLayers) {
        layer.backgroundColor = self.tintColor.CGColor;
    }
}

#pragma mark - Auto Layout

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize cs = [self contentSize];
    return cs;
}

- (CGSize)contentSize{
    CGRect unionFrame = CGRectZero;
    for (CALayer* layer in self.barLayers) {
        unionFrame = CGRectUnion(unionFrame, layer.frame);
    }
    return unionFrame.size;
}


#pragma mark - Animations

- (void)startOscillation
{
    CFTimeInterval basePeriod = kMinBaseOscillationPeriod + (drand48() * (kMaxBaseOscillationPeriod - kMinBaseOscillationPeriod));

    for (CALayer* layer in self.barLayers) {
        [self startOscillatingBarLayer:layer basePeriod:basePeriod];
    }
    _isOscillating = YES;
}

- (void)stopOscillation
{
    for (CALayer* layer in self.barLayers) {
        [layer removeAnimationForKey:kOscillationAnimationKey];
    }
    _isOscillating = NO;
}

- (BOOL)isOscillating
{
    return _isOscillating;
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
    CGFloat peakHeight = _barMinPeakHeight + arc4random_uniform(_barMaxPeakHeight - _barMinPeakHeight + 1);

    CGRect toBounds = layer.bounds;
    toBounds.size.height = peakHeight;

    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:layer.bounds];
    animation.toValue = [NSValue valueWithCGRect:toBounds];
    animation.repeatCount = HUGE_VALF; // Forever
    animation.autoreverses = YES;
    animation.duration = (basePeriod / 2) * (_barMaxPeakHeight / peakHeight);
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
