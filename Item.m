//
//  Item.m
//  RSSreader
//
//  Created by Dmitry on 11.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import "Item.h"

@implementation Item
-(id)init
{
    if (self=[super init])
    {
        [self setTitle:[[NSMutableString alloc]init]];
        [self setLink:[[NSMutableString alloc]init]];
        [self setCategory:[[NSMutableString alloc]init]];
        [self setDescription:[[NSMutableString alloc]init]];
    }
    return self;
}
-(void)appendTitleFrom:(NSString *)string
{
    [[self title]appendString:string];
}
-(void)appendLinkFrom:(NSString *)string
{
    [[self link]appendString:string];
}
-(void)appendDescriptionFrom:(NSString *)string
{
    [[self description]appendString:string];
}
-(void)appendCategoryFrom:(NSString *)string
{
    [[self category]appendString:string];
}

@end
