//
//  NAPlaybackIndicatorView.h
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/27/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAPlaybackIndicatorView : UIView

/**
 Starts the oscillating animation of the bars.
 */
- (void)startAnimating;

/**
 Stop the oscillating animation of the bars.
 */
- (void)stopAnimating;

/**
 Whether the receiver is animating.
 */
@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@end
