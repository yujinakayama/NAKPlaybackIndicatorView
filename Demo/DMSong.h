//
//  DMSong.h
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMSong : NSObject

+ (instancetype)randomSong;

- (id)initWithTitle:(NSString*)title duration:(NSTimeInterval)duration;

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSTimeInterval duration;

@end
