//
//  NewActivityTableViewController.m
//  BackPacker
//
//  Created by 聂 亚杰 on 13-5-9.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "NewActivityTableViewController.h"
#import "ActivityDatePickerViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
@interface NewActivityTableViewController ()

@end

@implementation NewActivityTableViewController

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
    NSString *commitAString = [dic objectForKey:@"newActivityURL"];
    
    self.commitActivityBaseURLString = [NSString stringWithFormat:@"%@%@",ipPath,commitAString];
    
}

-(void)requestData:(NSURL *)requestURL{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:requestURL];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.navBar setTintColor:[UIColor colorWithRed:5.0/255.0 green:111.0/255.0 blue:209.0/255.0 alpha:1.0]];
    self.myTableView.touchDelegate =self;
    
    [self initURL];
}
#pragma ASIHttpRequest Delegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"commitSuccess");
    NSString *response = request.responseString;
    NSLog(@"newActivityResponse:%@",response);
    NSDictionary *dic = [response objectFromJSONString];
    NSString *i = [dic objectForKey:@"errorMsg"];
    NSLog(@"%@",i);
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"commitFailed");
}

- (IBAction)newActivityFinished:(id)sender {
    
    //connection
    UILabel * warnLabel1 = (UILabel *)[self.myTableView viewWithTag:21];
    if (warnLabel1 != nil) {
        [warnLabel1 removeFromSuperview];
    }
    
    NSUserDefaults * defaults =[NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults valueForKey:@"userId"];
    
    NSString *nameA = self.nameTextField.text;
    NSString *typeA = self.typeTextField.text;
    NSString *startTimeA = self.acitivityStartDate.text;
    NSString *durationA = self.activityDuration.text;
    NSString *jionEndTimeA = self.jionEndTime.text;
    NSString *maxNumA = self.maxNum.text;
    
    if ([nameA isEqual:@""] || [typeA isEqual:@""]||[startTimeA isEqual:@""] || [durationA isEqual:@""] || [jionEndTimeA isEqual:@""]  || [maxNumA isEqual:@""]) {
        UILabel * warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 400, 280, 25)];
        [warnLabel setTextAlignment:NSTextAlignmentCenter];
        [warnLabel setTag:21];
        [warnLabel setTextColor:[UIColor redColor]];
        [warnLabel setText:@"请将信息补充完整"];
        warnLabel.backgroundColor = [UIColor clearColor];
        [self.myTableView addSubview:warnLabel];
    } else {
        NSString *nameAE = [nameA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *typeAE = [typeA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *startTimeAE = [startTimeA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *jionEndTimeAE = [jionEndTimeA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *commitURLString = [NSString stringWithFormat:@"%@?activity.userId=%@&activity.name=%@&activity.applyEndTime=%@&activity.maxPersonNum=%@&activity.startTime=%@&activity.duration=%@&activity.content=%@",self.commitActivityBaseURLString,userId,nameAE,jionEndTimeAE,maxNumA,startTimeAE,durationA,typeAE];
        NSLog(@"commitNewActivityURL:%@",commitURLString);
        [self requestData:[NSURL URLWithString:commitURLString]];
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
}

- (IBAction)newActivityClosed:(id)sender {
    UILabel * warnLabel1 = (UILabel *)[self.myTableView viewWithTag:21];
    if (warnLabel1 != nil) {
        [warnLabel1 removeFromSuperview];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editDidEnd:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)nextEdit:(id)sender {
    [self.typeTextField becomeFirstResponder];
}

- (IBAction)editDate:(id)sender {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma passValueDelegate
-(void)setvalue:(NSString *)value senderTag:(NSString *)senderTag{
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([senderTag isEqualToString:@"1"]) {
        self.acitivityStartDate.text = value;
    }else{
        self.jionEndTime.text = value;
    }
}

#pragma touchDelegate
-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.maxNum resignFirstResponder];
    [self.activityDuration resignFirstResponder];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIButton *senderB =(UIButton *)sender;
    int senderTag = senderB.tag;
    NSLog(@"senderTag:%d",senderTag);
    ActivityDatePickerViewController *datePickerVC = segue.destinationViewController;
    [datePickerVC setLaunchB:[NSString stringWithFormat:@"%d",senderTag]];
    [datePickerVC setActivityVC:self];
}
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    switch (section) {
//        case 1:
//            return 2;
//            break;
//        case 2:
//            return 2;
//            break;
//        case 3:
//            return 1;
//            break;
//        default:
//            return 0;
//            break;
//    }
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
