//
//  StudioStateViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-4-11.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "StudioStateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#define nameFontSize 14.0
#define stateFontSize 13.0
#define timeFontSize 13.0
@interface StudioStateViewController ()

@end

@implementation StudioStateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initURL{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"url" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *ipPath = [dic objectForKey:@"baseIp"];
    NSString *stateString = [dic objectForKey:@"studioAllStateURL"];
    
    NSString *studioAllStateURLString = [NSString stringWithFormat:@"%@%@?start=0&offset=5",ipPath,stateString];
    self.StudioAllStateURL = [NSURL URLWithString:studioAllStateURLString];
    NSLog(@"self.studioAllStateURL:%@",self.StudioAllStateURL);
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.portraitArray = [[NSMutableArray alloc]init];
    [self initURL];
    [self requestData:self.StudioAllStateURL requestTag:1];
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    
    if (request.tag == 1) {
        NSString *responseString = [request responseString];
        NSLog(@"responseString:%@",responseString);
        self.stateList = [[responseString objectFromJSONString]objectForKey:@"microBlogList"];
        NSLog(@"self.stateList:%@",self.stateList);
        [self.studioStateTableview reloadData];
    }else if(request.tag >=100){
        
        NSData *imgData = [request responseData];
        UIImage *portraitImage = [UIImage imageWithData:imgData];

        [self.portraitArray replaceObjectAtIndex:request.tag-100 withObject:portraitImage];
        [self.tableView reloadData];
    }
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //初始化头像Array
    for (int i = 0; i<[self.stateList count]; i++) {
        UIImage*nullP = [UIImage imageNamed:@"nullP.jpg"];
        [self.portraitArray addObject:nullP];
    
    }

    return [self.stateList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"studioStateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = NO;
        
        UILabel *nameLabel = [[UILabel alloc]init];
        [nameLabel setNumberOfLines:1];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:nameFontSize]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTag:1];
        [[cell contentView]addSubview:nameLabel];
        UILabel *stateLabel = [[UILabel alloc]init];
        [stateLabel setBackgroundColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0]];
        [stateLabel setFont:[UIFont systemFontOfSize:stateFontSize]];
        [stateLabel setNumberOfLines:0];
        [stateLabel setTag:2];
        [[cell contentView]addSubview:stateLabel];
        UILabel *timeLabel = [[UILabel alloc]init];
        [timeLabel setNumberOfLines:1];
        [timeLabel setFont:[UIFont systemFontOfSize:timeFontSize]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setTag:3];
        [[cell contentView]addSubview:timeLabel];
        //
        AsyncImageView *portraitView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
		portraitView.contentMode = UIViewContentModeScaleAspectFill;
		portraitView.clipsToBounds = YES;
		portraitView.tag = 4;
        portraitView.layer.borderWidth = 1.5;
        portraitView.layer.borderColor = [UIColor blackColor].CGColor;
        portraitView.layer.cornerRadius = 3.0;
		[cell addSubview:portraitView];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath{
    NSDictionary *state = [self.stateList objectAtIndex:indexPath.row];
    NSString *name = [state objectForKey:@"userName"];
    NSString *content = [state objectForKey:@"content"];
    NSDate *time = [state objectForKey:@"publishTime"];
    NSString *userPic = [state objectForKey:@"userPic"];
    //it is for test

    UILabel *nameLabel = (UILabel *)[[cell contentView]viewWithTag:1];
    [nameLabel setFrame:CGRectMake(50, 5, 120, 15)];
    [nameLabel setText:name];
    UILabel *contentLabel = (UILabel *)[[cell contentView]viewWithTag:2];
    [contentLabel setFrame:CGRectMake(50, 25, 265, 60)];
    [contentLabel setText:content];
    UILabel *timeLabel = (UILabel *)[[cell contentView]viewWithTag:3];
    [timeLabel setFrame:CGRectMake(50,15+nameLabel.frame.size.height+contentLabel.frame.size.height, 120,13)];
    [timeLabel setText:[NSString stringWithFormat:@"%@",time]];
    
	AsyncImageView *portraitView = (AsyncImageView *)[cell viewWithTag:4];
    [portraitView setFrame:CGRectMake(5, 5, 40, 40)];

    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:portraitView];
    
    //load the image
    portraitView.imageURL = [NSURL URLWithString:userPic];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

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

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
