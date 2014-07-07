//
//  DetailViewController.h
//  RSSreader
//
//  Created by Dmitry on 13.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
@interface DetailViewController : UIViewController

@property (copy,nonatomic) Item *item;
@property (nonatomic,strong) NSString *itemTitle;
@property (nonatomic) NSString *itemDescription;
@property (nonatomic) NSString *itemLink;
@property (nonatomic) UITextField *textField;
-(void)customBack;
@end
