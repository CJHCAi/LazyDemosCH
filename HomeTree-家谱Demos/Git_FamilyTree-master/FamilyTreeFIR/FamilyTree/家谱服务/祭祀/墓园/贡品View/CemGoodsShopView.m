//
//  CemGoodsShopView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CemGoodsShopView.h"
#import "AllGoodsView.h"
#import "CemGoodsShopModel.h"

@interface CemGoodsShopView()

@end
@implementation CemGoodsShopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    //背景
    
    UIView *halfBlackView = [[UIView alloc] initWithFrame:self.bounds];
    halfBlackView.backgroundColor = [UIColor blackColor];
    halfBlackView.alpha = 0.75;
    [self addSubview:halfBlackView];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 72*AdaptationWidth(), Screen_width-40, 842*AdaptationWidth())];
    backImage.image = MImage(@"ghg_bg");
    backImage.userInteractionEnabled = YES;
    [self addSubview:backImage];
    //确定和返回按钮
    NSArray *name = @[@"确定",@"返回"];
    for (int idx = 0; idx<name.count; idx++) {
        UIButton *clicBtn = [UIButton new];
        [clicBtn setBackgroundColor:[UIColor redColor]];
        if (idx==1) {
            [clicBtn setBackgroundColor:LH_RGBCOLOR(74, 88, 94)];
        }
        [clicBtn setTitle:name[idx] forState:0];
        clicBtn.layer.cornerRadius = 2;
        clicBtn.tag = idx;
        clicBtn.titleLabel.font = MFont(30*AdaptationWidth());
        [clicBtn addTarget:self action:@selector(respondsTogoodsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [backImage addSubview:clicBtn];
        clicBtn.sd_layout.leftSpaceToView(backImage,130*AdaptationWidth()+idx*232*AdaptationWidth()).bottomSpaceToView(backImage,70*AdaptationWidth()).widthIs(160*AdaptationWidth()).heightIs(61*AdaptationWidth());
    }
    
    //贡品
    self.singleGoods = [[AllGoodsView alloc ] initWithFrame:AdaptationFrame(60, 60, 520, 618)];
    [backImage addSubview:self.singleGoods];
    
}

-(void)respondsTogoodsBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
        {
            [self removeFromSuperview];
            //MYLog(@"%@",((AllGoodsView *)self.singleGoods).isSelectedGoodsArr);
            [self uploadToBuyCemGoods:[((AllGoodsView *)self.singleGoods).isSelectedGoodsArr copy]];
            
        }
            break;
        case 1:
        {
            [self removeFromSuperview];
        }
            break;
        default:
            break;
    }
}

//上传购买的贡品
-(void)uploadToBuyCemGoods:(NSArray<CemGoodsShopModel *> *)goodsArr{
    MYLog(@"%@",goodsArr);
    NSMutableArray *arr = [@[] mutableCopy];
    for (CemGoodsShopModel *good in goodsArr) {
        NSDictionary *dic = @{@"coid":@(good.CoId),
                              @"coprid":@(good.CoprId),
                              @"cnt":@1};
        [arr addObject:dic];
    }
    MYLog(@"%@",arr);
    NSDictionary *logDic = @{@"CeId":@(self.CeId),@"JS":arr};
    WK(weakSelf);
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeRitual success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            //刷新贡品摆放界面
            [weakSelf.delegate uploadGoodsToRefreshcemGoods:goodsArr];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
}


@end
