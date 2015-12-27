//
//  NAKPlaybackIndicatorView.m
//  PlaybackIndicator
//
//  Created by Yuji Nakayama on 1/27/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "NAKPlaybackIndicatorView.h"
#import "NAKPlaybackIndicatorContentView.h"


NSString * const kBarCount = @"kBarCount";
NSString * const kBarWidth = @"kBarWidth";
NSString * const kBarIdleHeight = @"kBarIdleHeight";
NSString * const kHorizontalBarSpacing = @"kHorizontalBarSpacing";
NSString * const kRetinaHorizontalBarSpacing = @"kRetinaHorizontalBarSpacing";
NSString * const kBarMinPeakHeight = @"kBarMinPeakHeight";
NSString * const kBarMaxPeakHeight = @"kBarMaxPeakHeight";


@interface NAKPlaybackIndicatorView ()

@property (nonatomic, strong) NAKPlaybackIndicatorContentView *contentView;

@end

@implementation NAKPlaybackIndicatorView

#pragma mark - Initialization

- (instancetype)initWithConfigDictionary:(NSDictionary *)configDictionary{
    self = [super init];
    if(self){
        [self commonInitWithDictionary:configDictionary];
    }
    return self;
}

+ (NSDictionary *)defaultConfigDictionary{
    return [NAKPlaybackIndicatorContentView defaultConfig];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)commonInitWithDictionary:(NSDictionary *)dict
{
    self.layer.masksToBounds = YES;
    
    self.contentView = [[NAKPlaybackIndicatorContentView alloc] initWithConfigDictionary:dict];
    [self addSubview:self.contentView];
    
    self.state = NAKPlaybackIndicatorViewStateStopped;
    self.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize contentSize = [self.contentView contentSize];
    
    [self.contentView setFrame:CGRectMake(floorf(self.bounds.size.width/2.0-contentSize.width/2.0), floorf(self.bounds.size.height/2.0-contentSize.height/2.0), contentSize.width, contentSize.height)];
}

- (CGSize )sizeThatFits:(CGSize)size{
    return [self.contentView sizeThatFits:size];
}

#pragma mark - Properties

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped
{
    _hidesWhenStopped = hidesWhenStopped;

    if (self.state == NAKPlaybackIndicatorViewStateStopped) {
        self.hidden = self.hidesWhenStopped;
    }
}

- (void)setState:(NAKPlaybackIndicatorViewState)state
{
    _state = state;

    if (self.state == NAKPlaybackIndicatorViewStateStopped) {
        [self stopAnimating];
        if (self.hidesWhenStopped) {
            self.hidden = YES;
        }
    } else {
        if (self.state == NAKPlaybackIndicatorViewStatePlaying) {
            [self startAnimating];
        } else if (self.state == NAKPlaybackIndicatorViewStatePaused) {
            [self stopAnimating];
        }
        self.hidden = NO;
    }
}

#pragma mark - Helpers

- (void)startAnimating
{
    if (self.contentView.isOscillating) {
        return;
    }

    [self.contentView stopDecay];
    [self.contentView startOscillation];
}

- (void)stopAnimating
{
    if (!self.contentView.isOscillating) {
        return;
    }

    [self.contentView stopOscillation];
    [self.contentView startDecay];
}

#pragma mark - Notification

- (void)applicationWillEnterForeground:(NSNotification*)notification
{
    // When an app entered background, UIKit removes all animations
    // even if it's an infinite animation.
    // So we restart the animation here if it should be when the app came back to foreground.
    if (self.state == NAKPlaybackIndicatorViewStatePlaying) {
        [self.contentView stopOscillation];
        [self.contentView stopDecay];
        [self startAnimating];
    }
}

@end
