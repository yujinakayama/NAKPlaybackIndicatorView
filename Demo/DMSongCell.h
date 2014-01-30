//
//  DMSongCell.h
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMPlaybackState) {
    DMPlaybackStateStopped = 0,
    DMPlaybackStatePlaying,
    DMPlaybackStatePaused
};

@class DMSong;
@class NAPlaybackIndicatorView;

@interface DMSongCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@property (nonatomic, strong) DMSong* song;
@property (nonatomic, assign) DMPlaybackState playbackState;

@end
