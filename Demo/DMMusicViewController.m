//
//  DMMusicViewController.m
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMMusicViewController.h"
#import "DMMusicPlayerController.h"
#import "DMMediaItem.h"
#import "DMSongCell.h"

@interface DMMusicViewController ()

@property (nonatomic, readonly) MPMusicPlayerController* musicPlayer;
@property (nonatomic, readonly) NSArray* collections;
@property (nonatomic, readonly) NSArray* collectionSections;
@property (nonatomic, readonly) NSArray* sectionIndexTitles;

@property (nonatomic, readonly) NSArray<NSDictionary*>* styles;
@property (nonatomic, readonly) UISegmentedControl* styleSegmentedControl;
@property (nonatomic, readonly) UIBarButtonItem* playBarButtonItem;
@property (nonatomic, readonly) UIBarButtonItem* pauseBarButtonItem;

@end

@implementation DMMusicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareMediaPlayer];
    [self prepareUI];
}

- (void)prepareMediaPlayer
{
#if TARGET_IPHONE_SIMULATOR
    NSMutableArray* songs = [NSMutableArray array];

    for (NSInteger i = 1; i <= 20; i++) {
        [songs addObject:[DMMediaItem randomSongWithAlbumTrackNumber:i]];
    }

    MPMediaItemCollection* collection = [MPMediaItemCollection collectionWithItems:songs];
    _collections = @[collection];

    _musicPlayer = (MPMusicPlayerController*)[DMMusicPlayerController iPodMusicPlayer];
    _musicPlayer.nowPlayingItem = songs.firstObject;
#else
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
            MPMediaQuery* query = [MPMediaQuery albumsQuery];
            _collections = query.collections;
            _collectionSections = query.collectionSections;

            NSMutableArray* sectionIndexTitles = [NSMutableArray array];
            for (MPMediaQuerySection* section in _collectionSections) {
                [sectionIndexTitles addObject:section.title];
            }
            _sectionIndexTitles = sectionIndexTitles;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];

    _musicPlayer = [MPMusicPlayerController systemMusicPlayer];
#endif

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayerDidChangeNowPlayingItem:)
                                                 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                               object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(musicPlayerDidChangePlaybackState:)
                                                 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                               object:self.musicPlayer];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
}

- (void)prepareUI
{
    _styles = @[
        @{ @"style": [NAKPlaybackIndicatorViewStyle iOS7Style],  @"text": @"iOS 7 Style" },
        @{ @"style": [NAKPlaybackIndicatorViewStyle iOS10Style], @"text": @"iOS 10 Style" }
    ];

    _styleSegmentedControl = [[UISegmentedControl alloc] initWithItems:[self styleTexts]];
    [self.styleSegmentedControl addTarget:self
                                   action:@selector(styleSegmentedControlValueDidChange:)
                         forControlEvents:UIControlEventValueChanged];
    self.styleSegmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.styleSegmentedControl;

    _playBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                       target:self
                                                                       action:@selector(playBarButtonItemDidPush:)];

    _pauseBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                                                                        target:self
                                                                        action:@selector(pauseBarButtonItemDidPush:)];

    [self updateRightBarButtonItem];

    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 15.0, 0.0, 15.0);
}

- (void)dealloc
{
    [self.musicPlayer endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableview data source and delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.collections.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MPMediaItemCollection* collection = self.collections[section];
    MPMediaItem* representativeItem = collection.representativeItem;
    return [NSString stringWithFormat:@"%@ – %@",
            [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle],
            [representativeItem valueForProperty:MPMediaItemPropertyAlbumArtist]];
}

#if !TARGET_IPHONE_SIMULATOR
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    MPMediaQuerySection* section = self.collectionSections[index];
    return section.range.location;
}
#endif

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MPMediaItemCollection* collection = self.collections[section];
    return collection.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = [self currentStyleText];

    DMSongCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell) {
        cell = [[DMSongCell alloc] initWithPlaybackIndicatorViewStyle:[self currentStyle] reuseIdentifier:cellIdentifier];
    }

    cell.song = [self songAtIndexPath:indexPath];
    [self updatePlaybackIndicatorOfCell:cell];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPMediaItem* song = [self songAtIndexPath:indexPath];

    if (self.musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        [self playSongAtIndexPath:indexPath];
    } else if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
        if ([self isNowPlayingSong:song]) {
            [self.musicPlayer play];
        } else {
            [self playSongAtIndexPath:indexPath];
        }
    } else {
        if ([self isNowPlayingSong:song]) {
            [self.musicPlayer pause];
        } else {
            [self playSongAtIndexPath:indexPath];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helpers

- (NSMutableArray<NSString*>*)styleTexts
{
    NSMutableArray<NSString*>* styleTexts = [NSMutableArray arrayWithCapacity:self.styles.count];
    for (NSDictionary* dictionary in self.styles) {
        [styleTexts addObject:dictionary[@"text"]];
    }
    return styleTexts;
}

- (NAKPlaybackIndicatorViewStyle*)currentStyle
{
    return self.styles[self.styleSegmentedControl.selectedSegmentIndex][@"style"];
}

- (NSString*)currentStyleText
{
    return self.styles[self.styleSegmentedControl.selectedSegmentIndex][@"text"];
}

- (MPMediaItem*)songAtIndexPath:(NSIndexPath*)indexPath
{
    MPMediaItemCollection* collection = self.collections[indexPath.section];
    return collection.items[indexPath.row];
}

- (void)playSongAtIndexPath:(NSIndexPath*)indexPath
{
    MPMediaItemCollection* album = self.collections[indexPath.section];

    [self.musicPlayer pause];
    [self.musicPlayer setQueueWithItemCollection:album];
    // set this property to that item while the music player is stopped or paused.
    self.musicPlayer.nowPlayingItem = album.items[indexPath.row];
    [self.musicPlayer play];
}

- (BOOL)isNowPlayingSong:(MPMediaItem*)song
{
    uint64_t targetID = [[song valueForProperty:MPMediaItemPropertyPersistentID] unsignedLongLongValue];
    uint64_t nowPlayingID = [[self.musicPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyPersistentID] unsignedLongLongValue];
    return targetID == nowPlayingID;
}

- (void)updatePlaybackIndicatorOfVisibleCells
{
    for (DMSongCell* cell in self.tableView.visibleCells) {
        [self updatePlaybackIndicatorOfCell:cell];
    }
}

- (void)updatePlaybackIndicatorOfCell:(DMSongCell*)cell
{
    if ([self isNowPlayingSong:cell.song]) {
        if (self.musicPlayer.playbackState == MPMusicPlaybackStatePaused) {
            cell.state = NAKPlaybackIndicatorViewStatePaused;
        } else if (self.musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
            cell.state = NAKPlaybackIndicatorViewStateStopped;
        } else {
            cell.state = NAKPlaybackIndicatorViewStatePlaying;
        }
    } else {
        cell.state = NAKPlaybackIndicatorViewStateStopped;
    }
}

- (void)updateRightBarButtonItem
{
    if (self.musicPlayer.playbackState == MPMusicPlaybackStatePlaying) {
        self.navigationItem.rightBarButtonItem = self.pauseBarButtonItem;
    } else {
        self.navigationItem.rightBarButtonItem = self.playBarButtonItem;
    }
}

#pragma mark - Notifications

- (void)musicPlayerDidChangeNowPlayingItem:(NSNotification*)notification
{
    [self updatePlaybackIndicatorOfVisibleCells];
}

- (void)musicPlayerDidChangePlaybackState:(NSNotification*)notification
{
    [self updatePlaybackIndicatorOfVisibleCells];
    [self updateRightBarButtonItem];
}

#pragma mark - Actions

- (void)styleSegmentedControlValueDidChange:(id)sender
{
    [self.tableView reloadData];
}

- (void)playBarButtonItemDidPush:(id)sender
{
    [self.musicPlayer play];
}

- (void)pauseBarButtonItemDidPush:(id)sender
{
    [self.musicPlayer pause];
}

@end
