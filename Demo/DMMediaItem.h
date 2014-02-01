//
//  DMSong.h
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

/**
 A duck-typed MPMediaItem.
 */
@interface DMMediaItem : NSObject

+ (instancetype)randomSongWithAlbumTrackNumber:(NSUInteger)albumTrackNumber;

- (id)initWithTitle:(NSString *)title
   playbackDuration:(NSTimeInterval)playbackDuration
   albumTrackNumber:(NSUInteger)albumTrackNumber;

- (id)valueForProperty:(NSString*)property;

@end
