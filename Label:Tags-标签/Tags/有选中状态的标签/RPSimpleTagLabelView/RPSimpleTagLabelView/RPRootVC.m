//
//  RPRootVC.m
//  RPSimpleTagLabelView
//
//  Created by Tao on 2019/1/7.
//  Copyright © 2019年 Tao. All rights reserved.
//

#import "RPRootVC.h"
#import "UIView+Ext.h"
#import "NSString+Extension.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height
#define GlobalFont(fontsize) [UIFont systemFontOfSize:fontsize]

@interface RPRootVC ()

@end

@implementation RPRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"RPSimpleTagLabelView";
    [self createUI];
}

- (void)createUI
{
    NSArray * tagArr = [NSArray arrayWithObjects:@"时间机器",@"世界大战",@"机器人",@"2001：太空奥德赛",@"银河系漫游指南",@"沙丘",@"隐形人",@"海底两万里",@"三体",@"华氏451度",@"火星编年史",@"球状闪电",@"科幻",@"当夜空吞噬星光的时候",@"寂",@"神经漫游者",@"与吾同在",@"北京折叠",@"幻想曲",@"地心漫游记",@"环游地球80天",@"寻",@"星球大战系列多部曲", nil];
    CGFloat tagBtnX = 16;
    CGFloat tagBtnY = 150;
    for (int i= 0; i<tagArr.count; i++) {
        
        CGSize tagTextSize = [tagArr[i] sizeWithFont:GlobalFont(14) maxSize:CGSizeMake(Width-32-32, 30)];
        if (tagBtnX+tagTextSize.width+30 > Width-32) {
            
            tagBtnX = 16;
            tagBtnY += 30+15;
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.tag = 100+i;
        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+30, 30);
        [tagBtn setTitle:tagArr[i] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagBtn.titleLabel.font = GlobalFont(14);
        tagBtn.layer.cornerRadius = 15;
        tagBtn.layer.masksToBounds = YES;
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:tagBtn];
        
        tagBtnX = CGRectGetMaxX(tagBtn.frame)+10;
    }
}
- (void)tagBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) [btn setBackgroundColor:[UIColor orangeColor]];
    if (!btn.selected) [btn setBackgroundColor:[UIColor clearColor]];
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
