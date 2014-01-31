//
//  DMSongCell.m
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMSongCell.h"
#import "DMMediaItem.h"

#if TARGET_IPHONE_SIMULATOR
static const CGFloat kPlaybackDurationLabelRightSpacing = 15.0;
#else
static const CGFloat kPlaybackDurationLabelRightSpacing = 8.0;
#endif

@interface DMSongCell ()

@property (nonatomic, readonly) NAPlaybackIndicatorView* playbackIndicatorView;
@property (nonatomic, readonly) UILabel* albumTrackNumberLabel;
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

        _albumTrackNumberLabel = [[UILabel alloc] init];
        _albumTrackNumberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _albumTrackNumberLabel.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_albumTrackNumberLabel];

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

    NSDictionary* metrics = @{ @"spacing": @(kPlaybackDurationLabelRightSpacing) };

    // On iOS 7, the superview of contentView is not the cell!
    // http://stackoverflow.com/q/19162725
    [self.contentView.superview addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|-(0@1)-[contentView]-(0@1)-|"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [self.titleLabel setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisHorizontal];

    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|-15-[indicator]-12-[title(>=0)]-[duration]-spacing-|"
                                             options:NSLayoutFormatAlignAllBaseline
                                             metrics:metrics
                                               views:views]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.albumTrackNumberLabel
                                                                 attribute:NSLayoutAttributeLeading
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.playbackIndicatorView
                                                                 attribute:NSLayoutAttributeLeading
                                                                multiplier:1.0
                                                                  constant:0.0]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.albumTrackNumberLabel
                                                                 attribute:NSLayoutAttributeBaseline
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeBaseline
                                                                multiplier:1.0
                                                                  constant:0.0]];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:1.0]];

    [super updateConstraints];
}

- (void)setSong:(MPMediaItem*)song
{
    _song = song;

    self.albumTrackNumberLabel.text = [[self.song valueForProperty:MPMediaItemPropertyAlbumTrackNumber] stringValue];
    self.titleLabel.text = [self.song valueForProperty:MPMediaItemPropertyTitle];

    if (self.song) {
        NSTimeInterval duration = [[self.song valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
        self.durationLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                   (int32_t)duration / 60, (int32_t)duration % 60];
    } else {
        self.durationLabel.text = nil;
    }
}

- (NAPlaybackIndicatorViewState)state
{
    return self.playbackIndicatorView.state;
}

- (void)setState:(NAPlaybackIndicatorViewState)state
{
    self.playbackIndicatorView.state = state;
    self.albumTrackNumberLabel.hidden = (state != NAPlaybackIndicatorViewStateStopped);
}

@end
