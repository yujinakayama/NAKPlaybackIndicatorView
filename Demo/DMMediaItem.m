//
//  DMSong.m
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMMediaItem.h"

static NSString* const kLipsum =
@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, "
@"sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
@"Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
@"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
@"Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

@interface DMMediaItem ()

@property (nonatomic, readonly) NSDictionary* properties;

@end

@implementation DMMediaItem

+ (instancetype)randomSongWithAlbumTrackNumber:(NSUInteger)albumTrackNumber
{
    return [[self alloc] initWithTitle:[self randomTitle]
                      playbackDuration:[self randomPlaybackDuration]
                      albumTrackNumber:albumTrackNumber];
}

+ (NSString*)randomTitle
{
    NSInteger wordCount = arc4random_uniform(4) + 1;
    NSMutableArray* words = [NSMutableArray array];

    for (NSInteger i = 0; i < wordCount; i++) {
        NSUInteger index = arc4random_uniform((u_int32_t)[self vocabulary].count);
        NSString* word = [self vocabulary][index];
        [words addObject:word];
    }

    return [[words componentsJoinedByString:@" "] capitalizedString];
}

+ (NSTimeInterval)randomPlaybackDuration
{
    return arc4random_uniform(60 * 13);
}

+ (NSArray*)vocabulary
{
    static NSArray* vocabulary;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vocabulary = [kLipsum componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(NSString* string, NSDictionary *bindings) {
            return string.length > 0;
        }];
        vocabulary = [vocabulary filteredArrayUsingPredicate:predicate];
    });

    return vocabulary;
}

- (id)initWithTitle:(NSString *)title
   playbackDuration:(NSTimeInterval)playbackDuration
   albumTrackNumber:(NSUInteger)albumTrackNumber
{
    self = [super init];
    if (self) {
        _properties = @{ MPMediaItemPropertyPersistentID     : @((uint64_t)self),
                         MPMediaItemPropertyTitle            : title,
                         MPMediaItemPropertyAlbumTrackNumber : @(albumTrackNumber),
                         MPMediaItemPropertyPlaybackDuration : @(playbackDuration),
                         MPMediaItemPropertyAlbumArtist      : @"An Artist",
                         MPMediaItemPropertyAlbumTitle       : @"An Album" };
    }
    return self;
}

- (id)copy
{
    return self;
}

- (id)valueForProperty:(NSString *)property
{
    return self.properties[property];
}

@end
