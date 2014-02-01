//
//  DMMusicPlayerController.h
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/31/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

/**
 A duck-typed MPMusicPlayerController.
 */
@interface DMMusicPlayerController : NSObject

+ (instancetype)iPodMusicPlayer;

- (void)play;
- (void)pause;
- (void)stop;

@property (nonatomic, readonly) MPMusicPlaybackState playbackState;
@property (nonatomic, copy) MPMediaItem* nowPlayingItem;


@end
