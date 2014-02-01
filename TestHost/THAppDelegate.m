//
//  THAppDelegate.m
//  NAKPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/29/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import "THAppDelegate.h"

@implementation THAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [self createViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIViewController*)createViewController
{
    UIViewController* viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view.backgroundColor = [UIColor whiteColor];

    UILabel* label = [self createLabel];
    [viewController.view addSubview:label];

    [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                                       toItem:viewController.view
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:0.9
                                                                     constant:0.0]];
    [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:viewController.view
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0.0]];
    [viewController.view addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:viewController.view
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:0.0]];

    return viewController;
}

- (UILabel*)createLabel
{
    UILabel* label = [[UILabel alloc] init];
    label.text = @"This empty app is a test host which the unit tests will be injected so that views work properly. "
                 @"See “Test Host” build setting of the unit test target.";
    label.font = [UIFont systemFontOfSize:15.0];
    label.numberOfLines = 0;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

@end
