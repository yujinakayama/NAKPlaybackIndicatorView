//
//  NAKPlaybackIndicatorContentView.h
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/28/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NAKPlaybackIndicatorViewStyle.h"

/**
 This is an internal private class. Do not use this class directly.
 */
@interface NAKPlaybackIndicatorContentView : UIView

// We don't specify NS_DESIGNATED_INITIALIZER since this is an internal private class.
- (instancetype)initWithStyle:(NAKPlaybackIndicatorViewStyle*)style;

- (void)startOscillation;
- (void)stopOscillation;
- (BOOL)isOscillating;

- (void)startDecay;
- (void)stopDecay;

@property (nonatomic, readonly) NAKPlaybackIndicatorViewStyle* style;

@end
