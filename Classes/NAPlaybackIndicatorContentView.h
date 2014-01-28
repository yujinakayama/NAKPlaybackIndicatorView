//
//  NAPlaybackIndicatorContentView.h
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/28/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NAPlaybackIndicatorContentView : UIView

- (void)startOscillation;
- (void)stopOscillation;
- (void)startDecay;
- (void)stopDecay;

@end
