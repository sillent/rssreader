//
//  ScreenOneViewController.m
//  RSSreader
//
//  Created by Dmitry Ulyanov on 05.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import "ScreenOneViewController.h"
#import "AppDelegate.h"

@interface ScreenOneViewController ()
{
//	NSArray *cellArray;
	__strong NSMutableArray *itemArray;
    Item *item;
    BOOL isLoadRss;
    NSMutableString *itemString;
    NSInteger counterItem;
    
    BaseDumper *bd;


    BOOL itemBegin;
    BOOL titleBegin;
    BOOL linkBegin;
    BOOL descBegin;
    BOOL categBegin;
    BOOL pubDateBegin;
    BOOL guidBegin;
    
    BOOL parseOK;
    BOOL loadBegin;
    NSXMLParser *xmlparser;
    
    UIActivityIndicatorView *activityIndic;
}
@end

@implementation ScreenOneViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)loadContent
{
    if (loadBegin==NO) {
        loadBegin=YES;
        isLoadRss=NO;
        // xml initial checkbox
        itemBegin=NO;
        titleBegin=NO;
        linkBegin=NO;
        descBegin=NO;
        categBegin=NO;
        pubDateBegin=NO;
        guidBegin=NO;
        counterItem=0;
    
        activityIndic=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndic setFrame:CGRectMake(10, 20, 20, 20)];
        if (bd)
        {
//            [bd closeDatabase];
            bd=nil;
        }
        bd=[[BaseDumper alloc]init];    // BaseDumper initializing
        [bd cleanOldRecord];
        itemArray=[[NSMutableArray alloc]initWithCapacity:0];
        itemString=[[NSMutableString alloc]init];
        NSURL *url=[[NSURL alloc]initWithString:@"http://www.vz.ru/rss.xml"];
        xmlparser=[[NSXMLParser alloc]initWithContentsOfURL:url];
        [xmlparser setDelegate:self];
        // загружаем параллельно отображению вьюхи
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            parseOK=[xmlparser parse];
            if (!parseOK)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                UIAlertView *alw=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"ошибка загрузки данных" delegate:self cancelButtonTitle:@"Принять" otherButtonTitles:nil, nil];
                    [alw show];
                });
                
            }
        });
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
        NSLog(@"Good bye");
        exit(0);
}
- (void)viewDidLoad 
{
    [super viewDidLoad];
	UIBarButtonItem *barBit=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateDataFromButton:)];
    [[self navigationItem]setRightBarButtonItem:barBit animated:YES];
//	[buttonReload ]
    [[self navigationItem]setTitle:@"Взгляд"];
    loadBegin=NO;
    [self loadContent];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - uiscrollview delegate

-(void)updateDataFromButton:(id)sender
{
    [self loadContent];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[self arrayFull]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	cell.textLabel.textColor=[UIColor blackColor];
    [[cell textLabel]setFont:[UIFont systemFontOfSize:14.0]];
    [[cell textLabel]setNumberOfLines:2];
	cell.textLabel.text=[[[self  arrayFull] objectAtIndex:[indexPath row]] title];
    if ([[[self arrayFull]objectAtIndex:indexPath.row]read]==YES)
    {
        cell.textLabel.textColor=[UIColor grayColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dt=[[DetailViewController alloc]init];
    
    [dt setItemTitle:[[[self arrayFull]objectAtIndex:[indexPath row]]title]];
    [dt setItemDescription:[[[self arrayFull]objectAtIndex:[indexPath row]]description]];
    [[[self arrayFull]objectAtIndex:[indexPath row]]setRead:YES];
    [[self tableView]reloadData];
    [[self navigationController] pushViewController:dt animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma XMLParsers implements
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"])
    {
        [itemArray addObject:[[Item alloc]init]];
        itemBegin=YES;
    }
    if ([elementName isEqualToString:@"title"])
    {
        titleBegin=YES;
    }
    if ([elementName isEqualToString:@"description"])
    {
        descBegin=YES;
    }
    if ([elementName isEqualToString:@"link"])
    {
        linkBegin=YES;
    }
    if ([elementName isEqualToString:@"category"])
    {
        categBegin=YES;
    }
    if ([elementName isEqualToString:@"pubDate"])
    {
        pubDateBegin=YES;
    }
    if ([elementName isEqualToString:@"guid"]) {
        guidBegin=YES;
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        itemBegin=NO;
        counterItem++;
    }
    if ([elementName isEqualToString:@"title"])
    {
        titleBegin=NO;
    }
    if ([elementName isEqualToString:@"description"])
    {
        descBegin=NO;
    }
    if ([elementName isEqualToString:@"link"])
    {
        linkBegin=NO;
    }
    if ([elementName isEqualToString:@"category"])
    {
        categBegin=NO;
    }
    if ([elementName isEqualToString:@"pubDate"]) {
        pubDateBegin=NO;
    }
    if ([elementName isEqualToString:@"guid"]) {
        guidBegin=NO;
    }
		
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *descWhiteSpace=nil;
    if (itemBegin)
    {
        if (titleBegin){
            [[itemArray objectAtIndex:counterItem]appendTitleFrom:string];
        }
        if (linkBegin) {
            [[itemArray objectAtIndex:counterItem]appendLinkFrom:string];
        }
        if (descBegin){
            descWhiteSpace=[[string stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
            [[itemArray objectAtIndex:counterItem]appendDescriptionFrom:descWhiteSpace];
        }
        if (categBegin) {
            [[itemArray objectAtIndex:counterItem]appendCategoryFrom:string];
        }
        if (pubDateBegin) {
            [[itemArray objectAtIndex:counterItem]appendPubDate:string];
        }
        if (guidBegin) {
            [[itemArray objectAtIndex:counterItem]appendGuidFrom:string];
        }
    }
}
-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    __unused NSString *cdata=[[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
}
-(void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
	
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [bd saveToBaseFromArray:itemArray];
    [self setArrayFull:[bd returnAllFromBase]];
    [itemArray removeAllObjects];
    // обновляем табличное представление в главном потоке
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([activityIndic isAnimating])
            [activityIndic stopAnimating];
        [[self tableView]reloadData];
    });
    loadBegin=NO;
}


@end
