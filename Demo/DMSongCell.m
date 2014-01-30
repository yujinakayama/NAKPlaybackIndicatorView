//
//  DMSongCell.m
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMSongCell.h"
#import <NAPlaybackIndicatorView/NAPlaybackIndicatorView.h>

@interface DMSongCell ()

@property (nonatomic, readonly) NAPlaybackIndicatorView* playbackIndicatorView;

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

    self.titleLabel.text = nil;
    self.durationLabel.text = nil;
    self.playbackState = DMPlaybackStateStopped;
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"|[contentView]|"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [self.titleLabel setContentHuggingPriority:1 forAxis:UILayoutConstraintAxisHorizontal];

    [self.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"|-[indicator]-[title(>=0)]-[duration]-|"
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

- (void)setPlaybackState:(DMPlaybackState)playbackState
{
    _playbackState = playbackState;

    NAPlaybackIndicatorView* playbackIndicatorView = self.playbackIndicatorView;

    if (_playbackState == DMPlaybackStateStopped) {
        playbackIndicatorView.hidden = YES;
        [playbackIndicatorView stopAnimating];
    } else {
        playbackIndicatorView.hidden = NO;
        if (_playbackState == DMPlaybackStatePlaying) {
            [playbackIndicatorView startAnimating];
        } else {
            [playbackIndicatorView stopAnimating];
        }
    }
}

@end
