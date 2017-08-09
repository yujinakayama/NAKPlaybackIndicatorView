//
//  NAKPlaybackIndicatorViewStyle.h
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 7/27/17.
//  Copyright © 2017 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAKPlaybackIndicatorViewStyle : NSObject

+ (instancetype)defaultStyle;

+ (instancetype)iOS7Style;

+ (instancetype)iOS10Style;

- (instancetype)initWithBarCount:(NSUInteger)barCount
                        barWidth:(CGFloat)barWidth
                   maxBarSpacing:(CGFloat)maxBarSpacing
                maxPeakBarHeight:(CGFloat)maxPeakBarHeight;

- (instancetype)initWithBarCount:(NSUInteger)barCount
                        barWidth:(CGFloat)barWidth
                   maxBarSpacing:(CGFloat)maxBarSpacing
                   idleBarHeight:(CGFloat)idleBarHeight
                minPeakBarHeight:(CGFloat)minPeakBarHeight
                maxPeakBarHeight:(CGFloat)maxPeakBarHeight NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSUInteger barCount;
@property (nonatomic, readonly) CGFloat barWidth;
@property (nonatomic, readonly) CGFloat maxBarSpacing;
@property (nonatomic, readonly) CGFloat actualBarSpacing;
@property (nonatomic, readonly) CGFloat idleBarHeight;
@property (nonatomic, readonly) CGFloat minPeakBarHeight;
@property (nonatomic, readonly) CGFloat maxPeakBarHeight;

@end
