//
//  DMSongCell.h
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@class DMMediaItem;
@class NAPlaybackIndicatorView;

@interface DMSongCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, strong) MPMediaItem* song;
@property (nonatomic, readonly) NAPlaybackIndicatorView* playbackIndicatorView;

@end
