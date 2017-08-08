//
//  NAKPlaybackIndicatorStyle.h
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 7/27/17.
//  Copyright © 2017 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAKPlaybackIndicatorStyle : NSObject

+ (instancetype)defaultStyle;

+ (instancetype)iOS7Style;

+ (instancetype)iOS10Style;

- (instancetype)initWithBarCount:(NSUInteger)barCount
                        barWidth:(CGFloat)barWidth
                   minBarSpacing:(CGFloat)minBarSpacing
                maxPeakBarHeight:(CGFloat)maxPeakBarHeight;

- (instancetype)initWithBarCount:(NSUInteger)barCount
                        barWidth:(CGFloat)barWidth
                   minBarSpacing:(CGFloat)minBarSpacing
                   idleBarHeight:(CGFloat)idleBarHeight
                minPeakBarHeight:(CGFloat)minPeakBarHeight
                maxPeakBarHeight:(CGFloat)maxPeakBarHeight NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) NSUInteger barCount;
@property (nonatomic, readonly) CGFloat barWidth;
@property (nonatomic, readonly) CGFloat minBarSpacing;
@property (nonatomic, readonly) CGFloat actualBarSpacing;
@property (nonatomic, readonly) CGFloat idleBarHeight;
@property (nonatomic, readonly) CGFloat minPeakBarHeight;
@property (nonatomic, readonly) CGFloat maxPeakBarHeight;

@end
