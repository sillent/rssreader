//
//  ScreenOneViewController.m
//  RSSreader
//
//  Created by Dmitry Ulyanov on 05.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import "ScreenOneViewController.h"

@interface ScreenOneViewController ()
{
//	NSArray *cellArray;
	__strong NSMutableArray *itemArray;
    Item *item;
    BOOL isLoadRss;
    NSMutableString *itemString;
    NSInteger counterItem;

    BOOL itemBegin;
    BOOL titleBegin;
    BOOL linkBegin;
    BOOL descBegin;
    BOOL categBegin;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoadRss=NO;
    
    // xml initial checkbox
    itemBegin=NO;
    titleBegin=NO;
    linkBegin=NO;
    descBegin=NO;
    categBegin=NO;
    counterItem=0;
    
	itemArray=[[NSMutableArray alloc]initWithCapacity:0];
    itemString=[[NSMutableString alloc]init];
	NSURL *url=[[NSURL alloc]initWithString:@"http://www.vz.ru/rss.xml"];
	NSXMLParser *xmlparser=[[NSXMLParser alloc]initWithContentsOfURL:url];
	[xmlparser setDelegate:self];
	[xmlparser parse];
//	[self setTitle:@"Взгляд"];
	
	

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self arrayFull] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // Configure the cell...
//    cell.textLabel.text=[[itemArray objectAtIndex:0] title];
	cell.textLabel.textColor=[UIColor blueColor];
    [[cell textLabel]setFont:[UIFont systemFontOfSize:14.0]];
    [[cell textLabel]setNumberOfLines:2];
	cell.textLabel.text=[[[self  arrayFull] objectAtIndex:[indexPath row]] title];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dt=[[DetailViewController alloc]init];
//    NSMutableArray *arr=[self arrayFull];
//    dt.itemTitle=[[arr objectAtIndex:indexPath.row]title];
//    [dt setItemTitle:[[[self arrayFull]objectAtIndex:[indexPath row]]title]];
//    [dt setItemDescription:[[[self arrayFull]objectAtIndex:[indexPath row]]title]];
//    [[self navigationController] pushViewController:dt animated:YES];
    NSLog(@"%@",[[[self arrayFull]objectAtIndex:indexPath.row]description]);

}
/**/
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
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
        ;
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
		
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (itemBegin)
    {
        if (titleBegin)
            [[itemArray objectAtIndex:counterItem]appendTitleFrom:string];
        
        if (linkBegin)
            [[itemArray objectAtIndex:counterItem]appendLinkFrom:string];
            
        if (descBegin)
            [[itemArray objectAtIndex:counterItem]appendDescriptionFrom:string];
        
        if (categBegin)
            [[itemArray objectAtIndex:counterItem]appendCategoryFrom:string];
    }
}
-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *cdata=[[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self setArrayFull:[itemArray copy]];
    itemArray=nil;
    [[self tableView]reloadData];
    NSLog(@"count: %lu",(unsigned long)[itemArray count]);

}

-(void)moveToNextScreen:(id)sender
{
    
}

@end
