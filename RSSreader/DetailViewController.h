//
//  DetailViewController.h
//  RSSreader
//
//  Created by Dmitry on 13.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic,strong) NSString *itemTitle;
@property (nonatomic) NSString *itemDescription;
@property (nonatomic) NSString *itemLink;

@end
