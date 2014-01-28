//
//  NAMasterViewController.h
//  NAPlaybackIndicatorView
//
//  Created by Yuji Nakayama on 1/29/14.
//  Copyright (c) 2014 Yuji Nakayama. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NADetailViewController;

@interface NAMasterViewController : UITableViewController

@property (strong, nonatomic) NADetailViewController *detailViewController;

@end
