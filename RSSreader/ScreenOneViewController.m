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
-(void)updateData:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"update gesture");
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
    
    activityIndic=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndic setFrame:CGRectMake(10, 20, 20, 20)];

	itemArray=[[NSMutableArray alloc]initWithCapacity:0];
    itemString=[[NSMutableString alloc]init];
	NSURL *url=[[NSURL alloc]initWithString:@"http://www.vz.ru/rss.xml"];
//	NSXMLParser *xmlparser=[[NSXMLParser alloc]initWithContentsOfURL:url];
    xmlparser=[[NSXMLParser alloc]initWithContentsOfURL:url];
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
#pragma uigesturerecognizer
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%ld",[gestureRecognizer state]);
    return YES;
}
#pragma mark - uiscrollview delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // тут нужно вставить апейтилку
    NSURL *url=[[NSURL alloc]initWithString:@"http://www.vz.ru/rss.xml"];
//	NSXMLParser *xmlparser=[[NSXMLParser alloc]initWithContentsOfURL:url];
    xmlparser=[[NSXMLParser alloc]initWithContentsOfURL:url];
	[xmlparser setDelegate:self];
    [self setArrayFull:nil];
    counterItem=0;
    [[self view]addSubview:activityIndic];
    [activityIndic startAnimating];
//    itemArray=[[NSMutableArray alloc]initWithCapacity:0];
	[xmlparser parse];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [[self arrayFull] count]/2;
//	return 15;
    return  [[self arrayFull]count];
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
    if ([[[self arrayFull]objectAtIndex:indexPath.row]read]==YES)
    {
        cell.textLabel.textColor=[UIColor greenColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *dt=[[DetailViewController alloc]init];
//    NSMutableArray *arr=[self arrayFull];
//    [dt setItem:[[self arrayFull]objectAtIndex:indexPath.row]];
//    dt.itemTitle=[[arr objectAtIndex:indexPath.row]title];
    [dt setItemTitle:[[[self arrayFull]objectAtIndex:[indexPath row]]title]];
    [dt setItemDescription:[[[self arrayFull]objectAtIndex:[indexPath row]]description]];
    [[[self arrayFull]objectAtIndex:[indexPath row]]setRead:YES];
    [[self tableView]reloadData];
    [[self navigationController] pushViewController:dt animated:YES];

    
    //    NSLog(@"%@",[[[self arrayFull]objectAtIndex:indexPath.row]description]);

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
//        ;
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
    NSString *descWhiteSpace=nil;
    if (itemBegin)
    {
        if (titleBegin){
            descWhiteSpace=[[string stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            [[itemArray objectAtIndex:counterItem]appendTitleFrom:string];
        }
        
        if (linkBegin) {
            descWhiteSpace=[[string stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            [[itemArray objectAtIndex:counterItem]appendLinkFrom:string];
        }
        
        if (descBegin){
            descWhiteSpace=[[string stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            [[itemArray objectAtIndex:counterItem]appendDescriptionFrom:descWhiteSpace];
        }
        
        if (categBegin) {
            descWhiteSpace=[[string stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            [[itemArray objectAtIndex:counterItem]appendCategoryFrom:string];
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
    [self setArrayFull:[itemArray copy]];

    if ([activityIndic isAnimating])
        [activityIndic stopAnimating];
    [itemArray removeAllObjects];
    [[self tableView]reloadData];


}

-(void)moveToNextScreen:(id)sender
{
    
}

@end
