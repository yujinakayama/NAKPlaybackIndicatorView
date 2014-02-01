//
//  NAPlaybackIndicatorView.h
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/27/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Values for the [state]([NAPlaybackIndicatorView state]) property.
 */
typedef NS_ENUM(NSInteger, NAPlaybackIndicatorViewState) {
    NAPlaybackIndicatorViewStateStopped = 0,
    NAPlaybackIndicatorViewStatePlaying,
    NAPlaybackIndicatorViewStatePaused
};

/**
 `NAPlaybackIndicatorView` is a view that mimics the music playback indicator in the Music.app on iOS 7.

 The view has three vertical bars and they oscillate randomly when it’s playing state.
 The color of the bars can be changed by setting `tintColor` property (`UIView`) of the receiver or its ancestor views.

 Out of the box it works well with Auto Layout system as it provides sensible layout information
 such as intrinsic content size, baseline, and priorities of content hugging / compression resistence.
 Of course, it can work with frame-based layout system also.
 */
@interface NAPlaybackIndicatorView : UIView

/**
 The current state of the receiver.

 You can control the receiver’s appearance and behavior by setting this property.

 - `NAPlaybackIndicatorViewStateStopped`:
   - If hidesWhenStopped is YES, the receiver is hidden.
   - If hidesWhenStopped is NO, the receiver shows idle bars (same as `NAPlaybackIndicatorViewStatePaused`).
 - `NAPlaybackIndicatorViewStatePlaying`: The receiver shows oscillatory animated bars.
 - `NAPlaybackIndicatorViewStatePaused`: The receiver shows idle bars.

 The initial value of this property is `NAPlaybackIndicatorViewStateStopped`.
 */
@property (nonatomic, assign) NAPlaybackIndicatorViewState state;

/**
 A boolean value that controls whether the receiver is hidden
 when the state is set to `NAPlaybackIndicatorViewStateStopped`.

 If the value of this property is `YES` (the default),
 the receiver sets its `hidden` property (`UIView`) to `YES`
 when receiver’s state is `NAPlaybackIndicatorViewStateStopped`.
 If the value of this property is `NO`, the receiver is shown when it’s stopped state.

 Note that by setting state `NAPlaybackIndicatorViewStatePlaying` or `NAPlaybackIndicatorViewStatePaused`
 the receiver will be shown automatically.
 */
@property (nonatomic, assign) BOOL hidesWhenStopped;

@end
