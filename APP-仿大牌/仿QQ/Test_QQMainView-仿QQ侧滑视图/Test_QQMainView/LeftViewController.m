//
//  LeftViewController.m
//  Text_QQMainView
//
//  Created by jaybin on 15/4/18.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import "LeftViewController.h"
#import "CommonTools.h"

@interface LeftViewController (){
    UITableView *myTableView;
    NSMutableArray *dataSource;
}

@end

@implementation LeftViewController
@synthesize cellSelectedBolck=_cellSelectedBolck;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.view.frame = CGRectMake(0, 0, 320 * 0.78, SCREEM_HEIGHT);
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20.0/320*SCREEM_WIDTH, 65.0/568.0*SCREEM_HEIGHT, 50, 50)];
    [headImage setImage:[UIImage imageNamed:@"gold"]];
    [self.view addSubview:headImage];
    
    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(90.0/320*SCREEM_WIDTH, 70.0/568.0*SCREEM_HEIGHT, 50, 20)];
    nameLbl.text = @"微夏";
    [nameLbl setTextColor:[UIColor whiteColor]];
    [self.view addSubview:nameLbl];
    
    //init TableView
    dataSource = [NSMutableArray arrayWithObjects:@"开通会员", @"QQ钱包", @"网上营业厅", @"个性装扮", @"我的收藏", @"我的相册", @"我的文件", nil];
    float height = SCREEM_HEIGHT < 500 ? SCREEM_HEIGHT * (568 - 221) / 568 : 347;
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160.0/568.0*SCREEM_HEIGHT, self.view.frame.size.width, height)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableFooterView = [UIView new];
    [myTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:myTableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    static NSString *tableViewCellIdentifier = @"CellIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.imageView setImage:[UIImage imageNamed:@"qq"]];
    [cell.textLabel setText:[dataSource objectAtIndex:indexPath.row]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _cellSelectedBolck([dataSource objectAtIndex:indexPath.row]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
