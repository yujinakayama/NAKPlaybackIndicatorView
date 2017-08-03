//
//  DMSongCell.h
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NAKPlaybackIndicatorView.h"

@class DMMediaItem;

@interface DMSongCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, strong) MPMediaItem* song;
@property (nonatomic, assign) NAKPlaybackIndicatorViewState state;

@end
