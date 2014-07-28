//
//  ScreenOneViewController.h
//  RSSreader
//
//  Created by Dmitry Ulyanov on 05.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Items.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "BaseDumper.h"

@interface ScreenOneViewController : UITableViewController <NSXMLParserDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) UITableViewCell *tcell;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (copy,nonatomic) NSArray *arrayFull;
// gesture
@property (nonatomic) UISwipeGestureRecognizer *swipeReload;


-(void)loadContent;

-(void)updateDataFromButton:(id)sender;
//-(BOOL)saveToBaseFrom:(NSDictionary *)dictionary;
@end
