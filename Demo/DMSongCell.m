//
//  DMSongCell.m
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMSongCell.h"
#import <NAPlaybackIndicatorView/NAPlaybackIndicatorView.h>
#import "DMSong.h"

@interface DMSongCell ()

@property (nonatomic, readonly) UILabel* titleLabel;
@property (nonatomic, readonly) UILabel* durationLabel;

@end

@implementation DMSongCell

- (id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _playbackIndicatorView = [[NAPlaybackIndicatorView alloc] init];
        _playbackIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_playbackIndicatorView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self.contentView addSubview:_titleLabel];

        _durationLabel = [[UILabel alloc] init];
        _durationLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _durationLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:_durationLabel];

        [self prepareForReuse];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    self.song = nil;
    self.playbackIndicatorView.state = NAPlaybackIndicatorViewStateStopped;
}

- (void)updateConstraints
{
    NSDictionary* views = @{ @"contentView" : self.contentView,
                             @"indicator"   : self.playbackIndicatorView,
                             @"title"       : self.titleLabel,
                             @"duration"    : self.durationLabel };

    // On iOS 7, the superview of contentView is not the cell!
    // http://stackoverflow.com/q/19162725
    [self.contentView.superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0@1)-[contentView]-(0@1)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [self.titleLabel setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisHorizontal];

    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[indicator]-[title(>=0)]-[duration]-15-|"
                                             options:NSLayoutFormatAlignAllBaseline
                                             metrics:nil
                                               views:views]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:1.0]];

    [super updateConstraints];
}

- (void)setSong:(DMSong *)song
{
    _song = song;

    self.titleLabel.text = _song.title;

    if (_song) {
        self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                   (int32_t)song.duration / 60, (int32_t)song.duration % 60];
    } else {
        self.durationLabel.text = nil;
    }
}

@end
