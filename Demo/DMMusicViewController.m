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
@property (nonatomic, assign) DMPlaybackState playbackState;
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
        DMSong* song = [[DMSong alloc] initWithTitle:[NSString stringWithFormat:@"Song %d", i]
                                            duration:arc4random_uniform(60 * 13)];
        [songs addObject:song];
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
