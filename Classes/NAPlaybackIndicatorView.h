//
//  NAPlaybackIndicatorView.h
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/27/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NAPlaybackIndicatorViewState) {
    NAPlaybackIndicatorViewStateStopped = 0,
    NAPlaybackIndicatorViewStatePlaying,
    NAPlaybackIndicatorViewStatePaused
};

@interface NAPlaybackIndicatorView : UIView

@property (nonatomic, assign) NAPlaybackIndicatorViewState state;
@property (nonatomic, assign) BOOL hidesWhenStopped;

@end
