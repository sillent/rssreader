//
//  Items.h
//  RSSreader
//
//  Created by Dmitry Ulyanov on 09.06.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Items : NSManagedObject

@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic) BOOL read;

@end
