//
//  Item.h
//  RSSreader
//
//  Created by Dmitry on 11.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property (nonatomic,strong) NSMutableString *title;
@property (nonatomic,strong) NSMutableString *link;
@property (nonatomic,strong) NSMutableString *category;
@property (nonatomic,strong) NSMutableString *description;
@property (nonatomic) BOOL read;
-(id)init;
-(void)appendTitleFrom:(NSString *)string;
-(void)appendLinkFrom:(NSString *)string;
-(void)appendCategoryFrom:(NSString *)string;
-(void)appendDescriptionFrom:(NSString *)string;

@end
