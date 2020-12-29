//
//  FriendsViewController.m
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "FriendsViewController.h"

#import "VideoCell.h"

#import "HomeDetail_1ViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(IBAction)showMenu {
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark UITableView delegate and dataSource

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.praiseLabel.text = @"29";
    cell.videoImageView.image = [UIImage imageNamed:@"water_1"];
    cell.titleLabel.text = @"水是生命之源";
    cell.iconView.image = [UIImage imageNamed:@"user"];
    
    UIColor *colorForCell = nil;
    
    if (indexPath.row%10 == 0) {
        colorForCell = [UIColor colorWithRed:87/255.0 green:87/255.0 blue:225/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 1)
    {
        colorForCell = [UIColor colorWithRed:14/255.0 green:122/255.0 blue:255/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 2)
    {
        colorForCell = [UIColor colorWithRed:41/255.0 green:172/255.0 blue:226/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 3)
    {
        colorForCell = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:255/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 4) // green
    {
        colorForCell = [UIColor colorWithRed:64/255.0 green:218/255.0 blue:90/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 5)
    {
        colorForCell = [UIColor colorWithRed:143/255.0 green:144/255.0 blue:147/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 6)
    {
        colorForCell = [UIColor colorWithRed:254/255.0 green:203/255.0 blue:8/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 7) // 橙黄
    {
        colorForCell = [UIColor colorWithRed:253/255.0 green:149/255.0 blue:7/255.0 alpha:0.5];
    }
    else if (indexPath.row%10 == 8)
    {
        colorForCell = [UIColor colorWithRed:253/255.0 green:61/255.0 blue:40/255.0 alpha:0.4];
    }
    else if (indexPath.row%10 == 9)
    {
        colorForCell = [UIColor colorWithRed:251/255.0 green:48/255.0 blue:83/255.0 alpha:0.4];
    }
    cell.backgroundColor = colorForCell;

    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    HomeDetail_1ViewController *detail_1ViewController = [[HomeDetail_1ViewController alloc] init];
    
    [[self navigationController] pushViewController:detail_1ViewController animated:YES];
    //
    //    ViewController *viewController = [[ViewController alloc] init];
    //
    //
    //    [[self navigationController] pushViewController:viewController animated:YES
    //     ];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
