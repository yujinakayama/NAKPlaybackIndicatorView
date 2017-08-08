//
//  NAKPlaybackIndicatorViewStyle.m
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 7/27/17.
//  Copyright © 2017 Yuji Nakayama. All rights reserved.
//

#import "NAKPlaybackIndicatorViewStyle.h"

@implementation NAKPlaybackIndicatorViewStyle

+ (instancetype)defaultStyle
{
    return [self iOS7Style];
}

+ (instancetype)iOS7Style
{
    return [[self alloc] init];
}

+ (instancetype)iOS10Style
{
    return [[self alloc] initWithBarCount:4
                                 barWidth:2.8
                            minBarSpacing:1.7
                         maxPeakBarHeight:12.0];
}

- (instancetype)init
{
    return [self initWithBarCount:3
                         barWidth:3.0
                    minBarSpacing:1.5
                 maxPeakBarHeight:12.0];
}

- (instancetype)initWithBarCount:(NSUInteger)barCount
                        barWidth:(CGFloat)barWidth
                   minBarSpacing:(CGFloat)minBarSpacing
                maxPeakBarHeight:(CGFloat)maxPeakBarHeight
{
    return [self initWithBarCount:barCount
                         barWidth:barWidth
                    minBarSpacing:minBarSpacing
                    idleBarHeight:round(barWidth)
                 minPeakBarHeight:maxPeakBarHeight / 2
                 maxPeakBarHeight:maxPeakBarHeight];
}

- (instancetype)initWithBarCount:(NSUInteger)barCount
                        barWidth:(CGFloat)barWidth
                   minBarSpacing:(CGFloat)minBarSpacing
                   idleBarHeight:(CGFloat)idleBarHeight
                minPeakBarHeight:(CGFloat)minPeakBarHeight
                maxPeakBarHeight:(CGFloat)maxPeakBarHeight
{
    self = [super init];
    if (self) {
        _barCount = barCount;
        _barWidth = barWidth;
        _minBarSpacing = minBarSpacing;
        _idleBarHeight = idleBarHeight;
        _minPeakBarHeight = minPeakBarHeight;
        _maxPeakBarHeight = maxPeakBarHeight;
    }
    return self;
}

- (CGFloat)actualBarSpacing
{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    return floor((self.minBarSpacing + self.barWidth) * screenScale) / screenScale - self.barWidth;
}

@end
