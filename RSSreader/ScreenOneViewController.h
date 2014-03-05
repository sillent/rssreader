//
//  ScreenOneViewController.h
//  RSSreader
//
//  Created by Dmitry Ulyanov on 05.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenOneViewController : UITableViewController
@property (strong,nonatomic) UITableViewCell *tcell;
- (IBAction)addNewFeed:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end
