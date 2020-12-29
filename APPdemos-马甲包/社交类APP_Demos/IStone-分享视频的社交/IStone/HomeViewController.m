//
//  HomeViewController.m
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "HomeViewController.h"

#import "VideoCell.h"

#import "HomeDetail_1ViewController.h"


@interface HomeViewController ()



@end

@implementation HomeViewController

@synthesize table_1Controller = _table_1Controller;
@synthesize table_2Controller = _table_2Controller;
@synthesize segmentedControl = _segmentedControl;

- (void)awakeFromNib
{
    [super awakeFromNib];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    _table_1Controller = [[Table_1Controller alloc] init];
//    _table_2Controller = [[Table_2Controller alloc] init];
//    
//    [self setViewControllers:@[_table_1Controller, _table_2Controller]];
//    
//    [self setSelectedViewControllerIndex:0];
    
    [self setViewControllers:@[[self.storyboard instantiateViewControllerWithIdentifier:@"Table_1Controller"], [self.storyboard instantiateViewControllerWithIdentifier:@"Table_2Controller"]]];
    [self setSelectedViewControllerIndex:0];
    
//    _table_1Controller = [[Table_1Controller alloc] init];
//    _table_2Controller = [[Table_2Controller alloc] init];
//    
//    NSArray *titles = @[@"热门", @"话题"];
//    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:7];
//    
//    _table_1Controller.title = titles[0];
//    _table_2Controller.title = titles[1];
//    
//    [viewControllers addObject:_table_1Controller];
//    [viewControllers addObject:_table_2Controller];
//    
//    NSLog(@"%@", self.viewControllers);
//    
//    self.viewControllers = viewControllers;
//    
//     NSLog(@"%@", self.viewControllers);
    
    
    
//    NSLog(@"%@", self.navigationController);
    
//    NSArray *buttons = [NSArray arrayWithObjects:@"热门",@"话题", nil];
    
//    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:buttons];
//    self.navigationItem.titleView = segmentedControl;
    
//    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"热门", @"话题"]];
//    [segmentedControl setFrame:CGRectMake(110, 76, 100, 30)];
    
//    [segmentedControl setBackgroundColor:[UIColor colorWithRed:57/255.0 green:204/255.0 blue:230/255.0 alpha:1.0]];
//    [segmentedControl setTextColor:[UIColor whiteColor]];
//    [segmentedControl setSelectionIndicatorColor:[UIColor colorWithRed:80/255.0 green:227/255.0 blue:194/255.0 alpha:1.0]];
//    [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorFillsSegment];

//    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    [segmentedControl setTag:1];
    
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, 320, 640)];
//    
//    _tableView.delegate = self;
//    
//    _tableView.dataSource = self;
//    
//    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
//    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"热门",@"话题"]];
//    
//    self.segmentedControl = _segmentedControl;
//    
//    self.navigationItem.titleView = _segmentedControl;
//   
//    [_segmentedControl addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventValueChanged];
    
    
}

-(void) pressed:(id) sender {
    int selectedIndex = [self.segmentedControl selectedSegmentIndex];

    if (selectedIndex == 0) {
        
        NSLog(@"0");
        
    } else {
        
        NSLog(@"1");
    }
    
    
}

//- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//	NSLog(@"Selected index %li (via UIControlEventValueChanged)", (long)segmentedControl.selectedIndex);
//    if (segmentedControl.selectedIndex == 0) {
//        
//        [self.view addSubview: _tableView];
//        
//    } else {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 300, 300)];
//        view.backgroundColor = [UIColor redColor];
//        [self.view addSubview: view];
//    }
//}

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
        colorForCell = [UIColor colorWithRed:87/255.0 green:87/255.0 blue:225/255.0 alpha:1.0];
    }
    else if (indexPath.row%10 == 1)
    {
        colorForCell = [UIColor colorWithRed:14/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    }
    else if (indexPath.row%10 == 2)
    {
        colorForCell = [UIColor colorWithRed:41/255.0 green:172/255.0 blue:226/255.0 alpha:1.0];
    }
    else if (indexPath.row%10 == 3)
    {
        colorForCell = [UIColor colorWithRed:83/255.0 green:200/255.0 blue:255/255.0 alpha:1.0];
    }
    else if (indexPath.row%10 == 4) // green
    {
        colorForCell = [UIColor colorWithRed:64/255.0 green:218/255.0 blue:90/255.0 alpha:1.0];
    }
    else if (indexPath.row%10 == 5)
    {
        colorForCell = [UIColor colorWithRed:143/255.0 green:144/255.0 blue:147/255.0 alpha:1.0];
    }
    else if (indexPath.row%10 == 6)
    {
        colorForCell = [UIColor colorWithRed:254/255.0 green:203/255.0 blue:8/255.0 alpha:1.0];
    }
    else if (indexPath.row%10 == 7) // 橙黄
    {
        colorForCell = [UIColor colorWithRed:253/255.0 green:149/255.0 blue:7/255.0 alpha:1.0];
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
    
    [[self navigationController] pushViewController:detail_1ViewController animated:NO];

    
    
}

// 删掉头视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex {
//    
//
//}

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
