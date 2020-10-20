//
//  WMenuBtn.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/20.
//  Copyright © 2016年 王子豪. All rights reserved.
//
enum{
    MenuBtnShopTag,
    MenuBtnNewsTag,
    MenuBtnRankingTag
};
#import "WMenuBtn.h"
#import "RankingViewController.h"

@interface WMenuBtn()
@end
@implementation WMenuBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBtn];
    }
    return self;
}

-(void)initBtn{
    NSArray *btnTitle = @[@"商城",@"新闻中心",@"排行榜"];
    for (int idx = 0; idx<btnTitle.count; idx++) {
        UIButton *button = [[UIButton alloc] initWithFrame:AdaptationFrame(0, idx*63, self.bounds.size.width/AdaptationWidth(), 60)];
        [button setTitle:btnTitle[idx] forState:0];
        [button setTitleColor:[UIColor whiteColor] forState:0];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.8;
        button.layer.borderWidth = 3;
        button.titleLabel.font = WFont(25);
        button.tag = idx;
        [button addTarget:self action:@selector(respondsToAllBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

#pragma mark *** events ***
-(void)respondsToAllBtn:(UIButton *)sender{
    
    NSArray *vcsArr = self.viewController.navigationController.viewControllers;
    //如果之前有push选中的某项控制器则pop到家谱服务 反之直接push
    switch (sender.tag) {
        case MenuBtnShopTag:
        {
            
           __block BOOL hasfamVC = false;
            [vcsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[ShoppingFirestViewController class]]) {
                    
                    [self.viewController.navigationController popToViewController:vcsArr[idx] animated:YES];
                    hasfamVC = true;
                }
            }];
            
            if(!hasfamVC){
            
            NSString *title = sender.titleLabel.text;
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationCodeIntoFamSevice object:nil userInfo:@{@"title":title}];
                
            }
            
        }
            break;
        case MenuBtnNewsTag:
        {
            __block BOOL hasfamVC = false;
            [vcsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NewsCenterViewController class]]) {
                    [self.viewController.navigationController popToViewController:vcsArr[idx] animated:YES];
                    hasfamVC = true;
                }
            }];
            if(!hasfamVC){
                 NSString *title = sender.titleLabel.text;
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationCodeIntoFamSevice object:nil userInfo:@{@"title":title}];
            }
        }
            break;
        case MenuBtnRankingTag:
        {
            
            __block BOOL hasfamVC = false;
            [vcsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[RankingViewController class]]) {
                    [self.viewController.navigationController popToViewController:vcsArr[idx] animated:YES];
                    hasfamVC = true;
                }
            }];

            [TCJPHTTPRequestManager POSTWithParameters:@{} requestID:GetUserId requestcode:kRequestCodegetmyzxphb success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                
                if (succe) {
                    
                    NSLog(@"%@", [NSString jsonDicWithDic:jsonDic[@"data"]]);
                    
                    if (!hasfamVC) {
                        RankingViewController *rankVc = [[RankingViewController alloc] initWithTitle:@"排行榜" image:MImage(@"chec") model:[RankingModel modelWithJSON:jsonDic[@"data"]]];
                        [self.viewController.navigationController pushViewController:rankVc animated:YES];
                        [self removeFromSuperview];
                    }
                }
                
            } failure:^(NSError *error) {
                
            }];
           
        }
            break;
            
        default:
            break;
    }
    
}

@end
