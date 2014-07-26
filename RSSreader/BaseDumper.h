//
//  BaseDumper.h
//  uSSR
//
//  Created by Dmitry Ulyanov on 21.07.14.
//  Copyright (c) 2014 Pork Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class Item;
@interface BaseDumper : NSObject
{
    sqlite3 *_dataBase;
    Item *item;
    NSMutableArray *retArr;
}
-(id)init;
-(void)closeDatabase;
-(BOOL)saveToBaseFromArray:(NSArray *)array;
-(BOOL)isGuidAlreadyExistInBd:(unsigned long)guid;
-(NSArray *)returnAllFromBase;
-(void)cleanOldRecord;
-(void)changeRead:(BOOL)read in:(NSInteger *)row;
@end
