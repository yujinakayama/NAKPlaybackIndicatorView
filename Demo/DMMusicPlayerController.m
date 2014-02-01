//
//  DMMusicPlayerController.m
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/31/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMMusicPlayerController.h"

@interface DMMusicPlayerController ()

@property (nonatomic, assign, readwrite) MPMusicPlaybackState playbackState;

@end

@implementation DMMusicPlayerController

+ (instancetype)iPodMusicPlayer
{
    static DMMusicPlayerController* instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _playbackState = MPMusicPlaybackStateStopped;
    }
    return self;
}

- (void)play
{
    self.playbackState = MPMusicPlaybackStatePlaying;
}

- (void)pause
{
    self.playbackState = MPMusicPlaybackStatePaused;
}

- (void)stop
{
    self.playbackState = MPMusicPlaybackStateStopped;
}


- (void)setPlaybackState:(MPMusicPlaybackState)playbackState
{
    BOOL changed = (_playbackState != playbackState);

    _playbackState = playbackState;

    if (changed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                            object:self];
    }
}

- (void)setNowPlayingItem:(MPMediaItem *)nowPlayingItem
{
    BOOL changed = (_nowPlayingItem != nowPlayingItem);

    _nowPlayingItem = nowPlayingItem;

    if (changed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                            object:self];
    }
}

#pragma mark - Ignore invocations for non-existent method

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // Just ignore
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    static NSMethodSignature* fakeSignature;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        const char* types = [NSString stringWithFormat:@"%s%s%s",
                             @encode(void), // return type
                             @encode(id),   // self
                             @encode(SEL)   // selector
                             ].UTF8String;
        fakeSignature = [NSMethodSignature signatureWithObjCTypes:types];
    });

    return fakeSignature;
}

@end
