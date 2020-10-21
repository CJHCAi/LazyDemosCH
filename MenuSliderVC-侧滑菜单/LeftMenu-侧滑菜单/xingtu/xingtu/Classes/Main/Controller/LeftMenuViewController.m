//
//  LeftMenuViewController.m
//  shoppingcentre
//
//  Created by Wondergirl on 16/6/16.
//  Copyright © 2016年 Wondergirl. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "JWTHomeViewController.h"
#import "LeftMenuTV.h"
//#import "SecondViewController.h"
#import "AppDelegate.h"

#define ViewW (ScreenW-100)//屏幕宽
#define ViewH self.view.bounds.size.height//屏幕高
//static NSString * const BaoyuCellReuseId = @"baoyucell";
@interface LeftMenuViewController ()

@end
@interface LeftMenuViewController ()

//@property (nonatomic,strong) LeftMenuTV *tabelView;

@property (nonatomic,strong) NSArray *tabelArr;
@end
@implementation LeftMenuViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(40, 40, 40);
    [self createView];

}
-(void)createView{
    LeftMenuTV * tabelView1 = [[LeftMenuTV alloc]initWithFrame:CGRectMake(20,20,ViewW-20,ViewH-55-20)];
    tabelView1.backgroundColor=[UIColor clearColor];
    
    
 //  =======================
        //       创建底部view的按钮
    
        //  设置按钮边框颜色
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){1,1,1,0.2});
    
        UIButton *personalCenterBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,ViewW/2,55)];
        [personalCenterBtn setTitle:@"个人中心" forState:UIControlStateNormal];
        [personalCenterBtn setImage:[UIImage imageNamed:@"menu_icon_user_grey"] forState:UIControlStateNormal];
        [personalCenterBtn.layer setBorderWidth:1.0]; //边框宽度
        [personalCenterBtn.layer setBorderColor:colorref];//边框颜色
        personalCenterBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    
        //        [setBtn addTarget:self action:@selector(didSetBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *myFavoriteBtn=[[UIButton alloc]initWithFrame:CGRectMake(ViewW/2,0,ViewW/2,55)];
        [myFavoriteBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
        [myFavoriteBtn setImage:[UIImage imageNamed:@"menu_icon_collect_grey"] forState:UIControlStateNormal];
        [myFavoriteBtn.layer setBorderWidth:1.0]; //边框宽度
        [myFavoriteBtn.layer setBorderColor:colorref];//边框颜色
        myFavoriteBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    
        //        创建透明view上的底部view
        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0,ViewH-55,ViewW, 55)];
        footView.backgroundColor=[UIColor clearColor];
        
        [footView addSubview:personalCenterBtn];
        [footView addSubview:myFavoriteBtn];
        // =====================================
        [self.view addSubview:tabelView1];
        [self.view addSubview:footView];
        
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
