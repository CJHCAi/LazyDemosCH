//
//  HK_VipUserHeadview.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_VipUserHeadview.h"
#import "HK_NewTitleView.h"
#define  pathSide 15
#define  sideline 10
@interface HK_VipUserHeadview ()<SDCycleScrollViewDelegate>
//220
@property (nonatomic, strong)SDCycleScrollView  *scollView;
@property (nonatomic, strong)NSMutableArray * sectionArr;
@property (nonatomic, strong)UIScrollView *typeScrollView;
@end

@implementation HK_VipUserHeadview

-(NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        _sectionArr =[[NSMutableArray alloc] init];
    }
    return _sectionArr;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = MainColor
      [self addSubview:self.scollView];
      [self setSubViews];
        [self addSubview:self.typeScrollView];
    }
    return  self;
    
}
-(SDCycleScrollView *)scollView {
    if (!_scollView) {
        _scollView =[SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0,0,kScreenWidth,200) delegate:self placeholderImage:nil];
    }
    return _scollView;
}

-(void)setSubViews {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0,150,kScreenWidth,70);
    [self.scollView addSubview:effectView];
}
-(void)setResponse:(HKNewPerSonTypeResponse *)response {
    
    NSArray *imagePicArr = response.data.carousels;
    NSMutableArray * pic =[[NSMutableArray alloc] init];
    for (HKNewPesonCorel * model in imagePicArr) {
        [pic addObject:model.imgSrc];
    }
    self.scollView.imageURLStringsGroup = pic;
    CGFloat sectionW =(kScreenWidth -pathSide *2 -sideline)/2;
    CGFloat sectionH = 56;
    //抢购..
    self.typeScrollView.contentSize = CGSizeMake(sectionW*response.data.types.count+pathSide*(response.data.types.count), 70);
    for (int i=0; i<response.data.types.count; i++) {
        HK_NewTitleView * newT =[[HK_NewTitleView alloc] initWithFrame:CGRectMake(pathSide+i*(sectionW+sideline),12.5,sectionW,sectionH)];
        newT.userInteractionEnabled = YES;
        newT.layer.cornerRadius =5;
        newT.layer.masksToBounds =YES;
        newT.tag =100+i;
        UITapGestureRecognizer *tapMew =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newActionClick:)];
        [newT addGestureRecognizer:tapMew];
        HKNewPerSonType *model = [response.data.types objectAtIndex:i];
        newT.model = model;
        [self.sectionArr addObject:newT];
        [self.typeScrollView addSubview:newT];
    }
}
-(void)newActionClick:(UITapGestureRecognizer *)tap {
    HK_NewTitleView * viewT =(HK_NewTitleView*)tap.view;
  //   NSInteger tag = viewT.tag -100+1;
    if (self.delegete && [self.delegete respondsToSelector:@selector(clickHeaderSectionWithTypeId:withTag:)]) {
        [self.delegete clickHeaderSectionWithTypeId:viewT.model.typeId withTag:viewT.model.sortDate];
    }
    for (HK_NewTitleView * secV in self.sectionArr) {
        //抢购中的..
        if (secV.model.sortDate>=0) {
            [secV setDuringShopNomalUI];
        }else {
            [secV setAfterLaterNomalUI];
        }
    }
    if (viewT.model.sortDate>=0) {
        [viewT setDuringShopSelectUI];
    }else {
        [viewT setAfterLaterSelectUI];
    }
}
-(UIScrollView *)typeScrollView{
    if (!_typeScrollView) {
        _typeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 150, kScreenWidth, 70)];
        _typeScrollView.bounces = NO;
        _typeScrollView.showsVerticalScrollIndicator = NO;
        _typeScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _typeScrollView;
}
@end
