//
//  DetailController.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "DetailController.h"
#import "DetailCell.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface DetailController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) UIImageView *myImageView;

@end

@implementation DetailController

{
    CGRect frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.title = [NSString stringWithFormat:@"%@", _model.title];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    [self.tableView registerClass:[DetailCell class] forCellReuseIdentifier:@"detailCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:244 / 255.0 blue:238 / 255.0 alpha:1];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat down = scrollView.contentOffset.y;
    if (down > 0) {
        return;
    }
    CGRect tempFrame;
    tempFrame.size.height = frame.size.height - down * 2;// 系数 决定速度
    tempFrame.size.width = frame.size.width - down * 2;
    tempFrame.origin.x = frame.origin.x + down;
    tempFrame.origin.y = frame.origin.y + down * 2;
    self.myImageView.frame = tempFrame;
}

- (void)share:(UIBarButtonItem *)barButton
{
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"我在SeeFood中发现了一个超棒的菜谱《%@》,%@", _model.title, _model.imtro]
                                     images:@[_model.albums[0]]
                                        url:nil
                                      title:_model.title
                                       type:SSDKContentTypeImage];
    
    //进行分享
    [ShareSDK showShareEditor:SSDKPlatformTypeSinaWeibo
           otherPlatformTypes:@[@(SSDKPlatformTypeTencentWeibo), @(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)]
                  shareParams:shareParams
          onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end)
     {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_myImageView == nil) {
        frame = cell.myImageView.frame;
        self.myImageView = cell.myImageView;
    }
    
    cell.model = _model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DetailCell rowHeight:_model] + 50;
}

@end
