//
//  LeftMenuTV.m
//  shoppingcentre
//
//  Created by Wondergirl on 16/6/19.
//  Copyright © 2016年 Wondergirl. All rights reserved.
//

#import "LeftMenuTV.h"
#import "LeftMenuModel.h"
#import "JWTHomeViewController.h"
#import "LeftSlideViewController.h"
//#import "AppDelegate.h"
#import "JWTCJZCViewController.h"
//#import "MyNavigationController.h"

@interface LeftMenuTV ()<UITableViewDataSource,UITableViewDelegate>

//myplist
@property (nonatomic, strong) NSArray *leftMenuArr;

@property(nonatomic, assign) NSInteger previousRow;

@end
@implementation LeftMenuTV

//懒加载
-(NSArray *)leftMenuArr{
    
    if (_leftMenuArr == nil) {
        
        NSArray *dictArr=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LeftMenu.plist" ofType:nil]];
        
        NSMutableArray *tempArr=[NSMutableArray array];
        
        for (NSDictionary *dict in dictArr) {
            
            LeftMenuModel *leftmenu=[LeftMenuModel leftmenuWithDict:dict];
            
            [tempArr addObject:leftmenu];
            
        }
        _leftMenuArr=tempArr;
    }
    return _leftMenuArr;
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    //    设置代理和数据源
    self.delegate=self;
    self.dataSource=self;
    
    self.rowHeight=50;
    
    self.separatorStyle=NO;
    return  self;
}

//实现数据源方法
-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftMenuArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellID];
        
    }
    
    
    LeftMenuModel *model=self.leftMenuArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.image=[UIImage imageNamed:model.icon];
    
    cell.textLabel.text=model.name;
    
    cell.textLabel.font=[UIFont systemFontOfSize:16 weight:50];
    
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    cell.backgroundColor=[UIColor clearColor];
    
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftSlideViewController * leftSlideView =  (LeftSlideViewController *) [[[[UIApplication sharedApplication]delegate]window]rootViewController];
    UITabBarController * tab  = (UITabBarController *)leftSlideView.mainVC;
    [leftSlideView closeLeftView];
    UINavigationController * navi = (UINavigationController *)tab.selectedViewController;
    
    
    if (indexPath.row==0) {
        

        JWTHomeViewController * homeVC = [[JWTHomeViewController alloc] init];
        
        [navi pushViewController:homeVC animated:YES];
    }
    else if (indexPath.row==1) {
        
         JWTCJZCViewController * secondVC = [[JWTCJZCViewController alloc] init];
       
        [navi pushViewController:secondVC animated:YES];

        
    }
    else{
        
        NSLog(@"vv=%ld",(long)indexPath.section);
    }
    
    
    
}
@end
