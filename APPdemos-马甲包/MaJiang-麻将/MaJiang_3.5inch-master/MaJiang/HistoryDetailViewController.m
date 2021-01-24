//
//  HistoryDetailViewController.m
//  MaJiang
//
//  Created by yu_hao on 1/18/14.
//  Copyright (c) 2014 yu_hao. All rights reserved.
//

#import "HistoryDetailViewController.h"

@interface HistoryDetailViewController ()

@end

@implementation HistoryDetailViewController

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
    
    //self.pointsArray = [[NSMutableArray alloc] init];
    //self.eventArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.eventArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HistoryDetailCell";
    HistoryDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        NSLog(@"找不到cell");
    }
    
    // Configure the cell...
    cell.pointsLabel.text = [self.pointsArray objectAtIndex:indexPath.row];
    cell.eventLabel.text = [self.eventArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
