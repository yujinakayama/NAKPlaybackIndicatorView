//
//  DMAppDelegate.m
//  Demo
//
//  Created by Yuji Nakayama on 1/30/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "DMAppDelegate.h"
#import "DMMusicViewController.h"

@implementation DMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Music.app color
    self.window.tintColor = [UIColor colorWithHue:0.968 saturation:0.827 brightness:1.000 alpha:1.000];

    DMMusicViewController* musicViewController = [[DMMusicViewController alloc] init];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:musicViewController];
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];

    return YES;
}

@end
