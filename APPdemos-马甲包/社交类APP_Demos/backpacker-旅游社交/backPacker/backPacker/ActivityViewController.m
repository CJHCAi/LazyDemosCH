//
//  ActivityViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-10.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initURL{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"url" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *ipPath = [dic objectForKey:@"baseIp"];
    NSString *allAString = [dic objectForKey:@"allActivityURL"];
    NSString *userAString = [dic objectForKey:@"userActivityURL"];
    self.activityBaseURLString = [NSString stringWithFormat:@"%@%@",ipPath,allAString];
    self.userActivityBaseURLString = [NSString stringWithFormat:@"%@%@",ipPath,userAString];
    NSLog(@"self.studioAllStateURL:%@",self.activityBaseURLString);
}

-(void)requestData:(NSURL *)requestURL requestTag:(int)tag{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request setDelegate:self];
    [request setTag:tag];
    [request startAsynchronous];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:5.0/255.0 green:111.0/255.0 blue:209.0/255.0 alpha:1.0]];
    
    //set segmentTextColor
    UIFont *Boldfont = [UIFont systemFontOfSize:14.0f];
    NSDictionary *normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont,UITextAttributeFont,[UIColor darkGrayColor],UITextAttributeTextColor,nil];
    
    [self.segment_activity setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    
    UIFont *Boldfont2 = [UIFont systemFontOfSize:14.0f];
    NSDictionary *selectedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:Boldfont2,UITextAttributeFont,[UIColor colorWithRed:223.0/255.0 green:102.0/255.0 blue:5.0/255.0 alpha:1.0],UITextAttributeTextColor,nil];
    
    [self.segment_activity setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    
    [self initURL];
    NSURL *allAURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?start=0&length=3",self.activityBaseURLString]];
    [self requestData:allAURL requestTag:1];
}

-(void)viewWillAppear:(BOOL)animated{
    int selectedIndex = self.segment_activity.selectedSegmentIndex;
    NSURL * requestURL;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userId"];
    switch (selectedIndex) {
        case 0:
            requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?start=0&length=3",self.activityBaseURLString]];
            [self requestData:requestURL requestTag:1];
            break;
        case 1:
            
            break;
        case 2:
            requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@&start=0&length=3 ",self.userActivityBaseURLString,userId]];
            [self requestData:requestURL requestTag:3];
            break;
    
        default:
            break;
    }
}

#pragma asiHttpRequestDelegate

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *response = [request responseString];
    NSLog(@"response:%@",response);
    NSMutableDictionary *dic = [response objectFromJSONString];
    self.activityList =[dic objectForKey:@"activityList"];
    NSLog(@"activityList:%@",self.activityList);
    [self.myTableView reloadData];
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"tableCell count:%d",[self.activityList count]);
    return [self.activityList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"activityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath{
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    UILabel *startTimeLabel = (UILabel *)[cell viewWithTag:2];
    UILabel *stateLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *userLabel = (UILabel *)[cell viewWithTag:4];
    
    NSDictionary *cellData = [self.activityList objectAtIndex:indexPath.row];
    NSNumber *activityId = [cellData objectForKey:@"id"];
    NSString *activityName = [cellData objectForKey:@"name"];
    NSString *startTime = [cellData objectForKey:@"startTime"];
    NSString *status = [cellData objectForKey:@"status"];
    NSString *userName = [cellData objectForKey:@"userName"];
    
    [nameLabel setText:activityName];
    [startTimeLabel setText:startTime];
    [stateLabel setText:status];
    [userLabel setText:userName];
    [cell setTag:activityId.intValue];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activitySegmentPressed:(id)sender {
    
}

@end
