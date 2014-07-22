//
//  BaseDumper.h
//  uSSR
//
//  Created by Dmitry Ulyanov on 21.07.14.
//  Copyright (c) 2014 Pork Industries. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface BaseDumper : NSObject
{
    sqlite3 *_dataBase;
}
-(id)init;
-(void)closeDatabase;
-(BOOL)saveToBaseFrom:(NSDictionary *)dictionary;
-(BOOL)isGuidAlreadyExist:(NSDictionary *)dictionary;


@end
