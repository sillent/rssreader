//
//  DetailViewController.m
//  RSSreader
//
//  Created by Dmitry on 13.03.14.
//  Copyright (c) 2014 MegaFon. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)customBack
{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem]setHidesBackButton:YES];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithTitle:@"Назад" style:UIBarButtonItemStyleBordered target:self action:@selector(customBack)];
    [[self navigationItem]setLeftBarButtonItem:backButton];
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    CGFloat xi=self.view.bounds.origin.x;
    CGFloat yi=self.view.bounds.origin.y;
    CGFloat hi=self.view.bounds.size.height;
    CGFloat wi=self.view.bounds.size.width;
    UIWebView *webviewMain=[[UIWebView alloc]initWithFrame:CGRectMake(xi, yi, wi, hi)];
    [[self navigationItem]setTitle:@"Взгляд"];
    [[self view]addSubview:webviewMain];
    [webviewMain loadHTMLString:_itemDescription baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
