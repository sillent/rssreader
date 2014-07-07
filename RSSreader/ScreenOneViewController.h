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

@interface ScreenOneViewController : UITableViewController <NSXMLParserDelegate,UIGestureRecognizerDelegate>

@property (strong,nonatomic) UITableViewCell *tcell;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property (copy,nonatomic) NSMutableArray *arrayFull;
//@property (weak, nonatomic) IBOutlet UIView *reloadView;

// gesture
@property (nonatomic) UISwipeGestureRecognizer *swipeReload;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

-(void)loadContent;
-(void)moveToNextScreen:(id)sender;
-(void)updateData:(UISwipeGestureRecognizer *)sender;
@end
