//
//  NMLeftViewController.m
//  XBNetMusic
//
//  Created by 小白 on 15/12/3.
//  Copyright (c) 2015年 小白. All rights reserved.
//

#import "NMLeftViewController.h"
#import "UIView+Extension.h"

#import "NMImageView.h"
#import "NMLeftTableViewController.h"
#import "NMLeftTableView.h"
@interface NMLeftViewController ()

@end

@implementation NMLeftViewController

-(void)setupImageView{
//    UIImageView *imageView = [[UIImageView alloc]init];
//    
//  
//    
//    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], @"1706442046308354.jpg"];
//   
//    imageView.image = [UIImage imageWithContentsOfFile:path];
//    
//    
//    XBlog(@"image = %@",imageView.image);
//    
//    imageView.frame = CGRectMake(0, 0, LeftViewWidth, ImageViewHeigth);
//    [self.view addSubview:imageView];
    
    NMImageView *imageView = [[NMImageView alloc] initWithFrame:CGRectMake(0, 0, LeftViewWidth, ImageViewHeigth)];
   // imageView.frame = CGRectMake(0, 0, LeftViewWidth, ImageViewHeigth);
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    
}


-(void)setupTableView{
    NSLog(@"self.view  %f",self.view.width);
//    NMLeftTableViewController *controller = [[NMLeftTableViewController alloc] init];
//    controller.tableView.frame = CGRectMake(0, ImageViewHeigth, self.view.width, 800);//外面设置了大小
//  
    
    
    NMLeftTableView *tableView = [[NMLeftTableView alloc] init];
    tableView.frame = CGRectMake(0, ImageViewHeigth, self.view.width, 800);//外面设置了大小
    //controller.view.x = 0;
    

    
    
    
    
    [self.view addSubview:tableView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉全部的cell质检的横线
   // self.tableView.bounces = NO;//多余不能超出来，就是上下两个不能滑出来
    
    [self setupImageView];
    [self setupTableView];
    
    
}


//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 200;
//    if (section == 0)
//        return CGFLOAT_MIN;
//    return tableView.sectionHeaderHeight;
//}






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
