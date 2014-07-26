//
//  BaseDumper.m
//  uSSR
//
//  Created by Dmitry Ulyanov on 21.07.14.
//  Copyright (c) 2014 Pork Industries. All rights reserved.
//

#import "BaseDumper.h"
#import "Item.h"

@implementation BaseDumper
-(id)init
{
    if (self=[super init]) {
        NSString *dirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath=[[NSString stringWithString:dirPath] stringByAppendingPathComponent:@"ussr.sqlite3"];
        NSFileManager *fmg=[NSFileManager defaultManager];
        
        if ([fmg fileExistsAtPath:dbPath]==NO) {
            const char *dbCpath=[dbPath UTF8String];
            if (sqlite3_open(dbCpath, &_dataBase)==SQLITE_OK) {
                char *erms;
                const char *statement="CREATE TABLE IF NOT EXISTS data (id INTEGER PRIMARY KEY AUTOINCREMENT, guid INTEGER UNIQUE, link TEXT, title TEXT, category TEXT, desc TEXT, pubDate TEXT, read INTEGER DEFAULT 0)";
                if (sqlite3_exec(_dataBase, statement, nil, nil, &erms)!=SQLITE_OK)
                    NSLog(@"error on creating database %s", erms);
                
            }
        }
        else
        {
            const char *dbCpath=[dbPath UTF8String];
            if (sqlite3_open(dbCpath, &_dataBase)!=SQLITE_OK)
                NSLog(@"something happened when opening database");
        }
        NSLog(@"%@", dbPath);
    }
    return self;
}
-(BOOL)isGuidAlreadyExistInBd:(unsigned long)guid
{

    size_t allocateMemoryForQuery=strlen("select id from data where guid=")+10;
    char *query=malloc(allocateMemoryForQuery);
    snprintf(query, allocateMemoryForQuery, "select guid from data where guid=%lu", guid);
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_dataBase, query, -1, &statement, nil)==SQLITE_OK)
    {
        if (sqlite3_step(statement)==SQLITE_ROW)
        {
            unsigned long i=sqlite3_column_int(statement, 0);
            sqlite3_finalize(statement);
            if (i == guid)
            {
                free(query);
                return YES;
            }
            else
            {
                free(query);
                return NO;
            }
        }
    }
    free(query);
    return NO;
}


-(BOOL)saveToBaseFromArray:(NSArray *)array
{
	for (Item *it in array) {
		unsigned long guid=[[it guid]integerValue];
		const char *link=[[it link]cStringUsingEncoding:NSUTF8StringEncoding];
		NSData *titleD=[[it title]dataUsingEncoding:NSUTF8StringEncoding];
		NSString *titleS=[titleD base64EncodedStringWithOptions:0];
		NSData *descD=[[it description]dataUsingEncoding:NSUTF8StringEncoding];
		NSString *descS=[descD base64EncodedStringWithOptions:0];
		const char *title=[titleS cStringUsingEncoding:NSUTF8StringEncoding];
		const char *desc=[descS cStringUsingEncoding:NSUTF8StringEncoding];
		const char *category=[[it category]cStringUsingEncoding:NSUTF8StringEncoding];
		const char *pubDate=[[it pubDate] cStringUsingEncoding:NSUTF8StringEncoding];

		size_t allocateMemoryForQuery=strlen(link)+strlen(title)+strlen(category)+strlen(desc)+strlen(pubDate)+110;
		char *errmsg;
		if (![self isGuidAlreadyExistInBd:guid])
		{
			char *query=malloc(allocateMemoryForQuery);
			snprintf(query, allocateMemoryForQuery, "insert into data (guid,link,title,category,desc,pubDate) values (%lu,'%s','%s','%s','%s','%s')",guid, link,title,category,desc,pubDate);
			if (sqlite3_exec(_dataBase, query, nil, nil, &errmsg)==SQLITE_OK) {
					free(query);
			}
			else
				NSLog(@"%s",errmsg);
		}
	}
	return YES;
}
-(NSArray *)returnAllFromBase
{
    retArr=[[NSMutableArray alloc]initWithCapacity:0];
    const char *query="select * from data order by guid DESC limit 100";
    sqlite3_stmt *statement;
    if (_dataBase)
    {
        if (sqlite3_prepare_v2(_dataBase, query, -1, &statement, nil)==SQLITE_OK)
        {
            while (sqlite3_step(statement)==SQLITE_ROW)
            {
                item=[[Item alloc]init];
                const char *guid=(char *)sqlite3_column_text(statement,1); // старт с 1, потому что 0 - id.
                const char *link=(char *)sqlite3_column_text(statement, 2);
                const char *title=(char *)sqlite3_column_text(statement, 3);
                const char *category=(char *)sqlite3_column_text(statement, 4);
                const char *desc=(char *)sqlite3_column_text(statement, 5);
                const char *pubDate=(char *)sqlite3_column_text(statement, 6);
                int read=sqlite3_column_int(statement, 7);
                NSString *titleencoded=[NSString stringWithCString:title encoding:NSUTF8StringEncoding];
                NSData *titleD=[[NSData alloc]initWithBase64EncodedString:titleencoded options:NSDataBase64DecodingIgnoreUnknownCharacters];
                item.title=[[NSMutableString alloc]initWithData:titleD encoding:NSUTF8StringEncoding];
                item.link=(NSMutableString *)[NSString stringWithCString:link encoding:NSUTF8StringEncoding];
                NSString *descencoded=[NSString stringWithCString:desc encoding:NSUTF8StringEncoding];
                NSData *descD=[[NSData alloc]initWithBase64EncodedString:descencoded options:NSDataBase64DecodingIgnoreUnknownCharacters];
                item.description=[[NSMutableString alloc]initWithData:descD encoding:NSUTF8StringEncoding];
                item.pubDate=(NSMutableString *)[NSString stringWithCString:pubDate encoding:NSUTF8StringEncoding];
                item.category=(NSMutableString *)[NSString stringWithCString:category encoding:NSUTF8StringEncoding];
                item.guid=(NSMutableString *)[NSString stringWithCString:guid encoding:NSUTF8StringEncoding];
                if (read==1)
                    item.read=YES;
                else
                    item.read=NO;
                [retArr addObject:item];
                item=nil;
            }
            sqlite3_finalize(statement);
        }
    }
	[self closeDatabase];
    return retArr;
}
-(void)cleanOldRecord
{
    const char *query="delete from data where guid not in ( select guid from data order by guid DESC limit 100 )";
    if (_dataBase)
    {
        if (sqlite3_exec(_dataBase, query, nil, nil, nil)!=SQLITE_OK)
            NSLog(@"cannot remove old write");
    }
}
-(void)changeRead:(BOOL)read in:(NSInteger *)row
{
	//TODO не до конца имплементированный метод
    int i;
    if (read==YES) {
        i=1;
    }
    else
        i=0;
	if (_dataBase)
	{

	}
}
-(void)closeDatabase
{
    int retVal=sqlite3_close(_dataBase);
    if (retVal==SQLITE_BUSY)
        NSLog(@"bad, don't close bd, because BD is BUSY");
    else if (retVal==SQLITE_OK)
        NSLog(@"good, bd closed OK");
}

@end
