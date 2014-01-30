//
//  DMMusicViewController.m
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMMusicViewController.h"
#import <NAPlaybackIndicatorView/NAPlaybackIndicatorView.h>
#import "DMSong.h"
#import "DMSongCell.h"

@interface DMMusicViewController ()

@property (nonatomic, readonly) NSArray* songs;
@property (nonatomic, assign) NAPlaybackIndicatorViewState playbackState;
@property (nonatomic, strong) NSIndexPath* playingIndexPath;

@end

@implementation DMMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Music";
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);

    [self prepareSongs];
}

- (void)prepareSongs
{
    NSMutableArray* songs = [NSMutableArray array];

    for (NSInteger i = 0; i < 20; i++) {
        [songs addObject:[DMSong randomSong]];
    }

    _songs = songs;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellIdentifier = @"Cell";

    DMSongCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    if (!cell) {
        cell = [[DMSongCell alloc] initWithReuseIdentifier:kCellIdentifier];
    }

    cell.song = self.songs[indexPath.row];

    if (self.playingIndexPath && [indexPath compare:self.playingIndexPath] == NSOrderedSame) {
        cell.playbackIndicatorView.state = self.playbackState;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DMSongCell* selectedCell = (DMSongCell*)[tableView cellForRowAtIndexPath:indexPath];

    if (self.playingIndexPath && [indexPath compare:self.playingIndexPath] == NSOrderedSame) {
        if (self.playbackState == NAPlaybackIndicatorViewStatePlaying) {
            selectedCell.playbackIndicatorView.state = NAPlaybackIndicatorViewStatePaused;
        } else {
            selectedCell.playbackIndicatorView.state = NAPlaybackIndicatorViewStatePlaying;
        }
    } else {
        if (self.playingIndexPath) {
            DMSongCell* previousPlayingCell = (DMSongCell*)[tableView cellForRowAtIndexPath:self.playingIndexPath];
            previousPlayingCell.playbackIndicatorView.state = NAPlaybackIndicatorViewStateStopped;
        }
        selectedCell.playbackIndicatorView.state = NAPlaybackIndicatorViewStatePlaying;
        self.playingIndexPath = indexPath;
    }

    self.playbackState = selectedCell.playbackIndicatorView.state;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
