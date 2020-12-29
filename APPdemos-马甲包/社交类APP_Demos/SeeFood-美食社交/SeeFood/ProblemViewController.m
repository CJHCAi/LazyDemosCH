//
//  ProblemViewController.m
//  通讯userInformationPage
//
//  Created by lanou on 15/11/27.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "ProblemViewController.h"
#import "PrefixHeader.pch"
#import "UIImageView+WebCache.h"
#import "ShakeViewController.h"
#import "UIView+UIView_Frame.h"
@interface ProblemViewController () <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSString *numb;

@end
static NSString *cellIdentifier=@"cell";
@implementation ProblemViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-49) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    //注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    if(indexPath.row==0)
    {
        //跳转到摇一摇界面
        ShakeViewController *shake=[[ShakeViewController alloc]init];
        [self.navigationController pushViewController:shake animated:YES];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(indexPath.row==0)
    {
        cell.textLabel.text=@"摇一摇";
    }
    return cell;
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
