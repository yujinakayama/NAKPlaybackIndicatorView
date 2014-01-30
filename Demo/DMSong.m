//
//  DMSong.m
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMSong.h"

@implementation DMSong

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
