//
//  DMSong.m
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMSong.h"

static NSString* const kLipsum =
@"Lorem ipsum dolor sit amet, consectetur adipisicing elit, "
@"sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
@"Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
@"Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
@"Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

@implementation DMSong

+ (instancetype)randomSong
{
    return [[self alloc] initWithTitle:[self randomTitle] duration:[self randomDuration]];
}

+ (NSString*)randomTitle
{
    NSInteger wordCount = arc4random_uniform(4) + 1;
    NSMutableArray* words = [NSMutableArray array];

    for (NSInteger i = 0; i < wordCount; i++) {
        NSString* word = [self vocabulary][arc4random_uniform([self vocabulary].count)];
        [words addObject:word];
    }

    return [[words componentsJoinedByString:@" "] capitalizedString];
}

+ (NSTimeInterval)randomDuration
{
    return arc4random_uniform(60 * 13);
}

+ (NSArray*)vocabulary
{
    static NSArray* vocabulary;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vocabulary = [kLipsum componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]];
        vocabulary = [vocabulary filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString* string, NSDictionary *bindings) {
            return string.length > 0;
        }]];
    });

    return vocabulary;
}

- (id)initWithTitle:(NSString *)title duration:(NSTimeInterval)duration
{
    self = [super init];
    if (self) {
        _title = title;
        _duration = duration;
    }
    return self;
}

@end
