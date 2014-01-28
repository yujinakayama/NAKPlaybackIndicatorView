//
//  NAPlaybackIndicatorView.h
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/27/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAPlaybackIndicatorView : UIView

- (void)startAnimating;
- (void)stopAnimating;

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

@end
