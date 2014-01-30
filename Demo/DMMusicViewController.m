//
//  DMMusicViewController.m
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMMusicViewController.h"
#import "DMSongCell.h"
#import <NAPlaybackIndicatorView/NAPlaybackIndicatorView.h>

@interface DMMusicViewController ()

@property (nonatomic, assign) DMPlaybackState playbackState;
@property (nonatomic, strong) NSIndexPath* playingIndexPath;

@end

@implementation DMMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Music";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"Cell";

    DMSongCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    if (!cell) {
        cell = [[DMSongCell alloc] initWithReuseIdentifier:kCellIdentifier];
    }

    cell.titleLabel.text = [NSString stringWithFormat:@"Song %d", indexPath.row];
    cell.durationLabel.text = [NSString stringWithFormat:@"%d:%02d", arc4random_uniform(13), arc4random_uniform(60)];

    if (self.playingIndexPath && [indexPath compare:self.playingIndexPath] == NSOrderedSame) {
        cell.playbackState = self.playbackState;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMSongCell* selectedCell = (DMSongCell*)[tableView cellForRowAtIndexPath:indexPath];

    if (self.playingIndexPath && [indexPath compare:self.playingIndexPath] == NSOrderedSame) {
        if (self.playbackState == DMPlaybackStatePlaying) {
            selectedCell.playbackState = DMPlaybackStatePaused;
        } else {
            selectedCell.playbackState = DMPlaybackStatePlaying;
        }
    } else {
        if (self.playingIndexPath) {
            DMSongCell* previousPlayingCell = (DMSongCell*)[tableView cellForRowAtIndexPath:self.playingIndexPath];
            previousPlayingCell.playbackState = DMPlaybackStateStopped;
        }
        selectedCell.playbackState = DMPlaybackStatePlaying;
        self.playingIndexPath = indexPath;
    }

    self.playbackState = selectedCell.playbackState;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
