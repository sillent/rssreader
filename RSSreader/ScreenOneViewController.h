//
//  ScreenOneViewController.h
//  RSSreader
//
//  Created by Dmitry Ulyanov on 05.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "DetailViewController.h"

@interface ScreenOneViewController : UITableViewController <NSXMLParserDelegate>

@property (strong,nonatomic) UITableViewCell *tcell;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
//@property (strong,nonatomic) NSString *channelTitle;


//@property (strong,nonatomic) NSMutableString *itemString;
@property (copy,nonatomic) NSMutableArray *arrayFull;


-(void)moveToNextScreen:(id)sender;

@end
