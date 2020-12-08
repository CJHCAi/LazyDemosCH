//
//  SectionView.m
//  仿淘宝
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "SectionView.h"
#define Image(name) [UIImage imageNamed:name]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface SectionView ()

{
    UIButton *SelectedCircelBtn;
    
    NSString *SelectType;
}

@end

@implementation SectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        //单个section全选按钮
        SelectedCircelBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        [SelectedCircelBtn addTarget:self action:@selector(SlelctedAll) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:SelectedCircelBtn];
        
        //商店
        UIImageView *StoreIcon = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(SelectedCircelBtn.frame) + 5, 12.5, 15, 15)];
        StoreIcon.image = Image(@"RecomLB_TotalRank_Norecm_icon");
        [self addSubview:StoreIcon];
        
        UIButton *SelectedStoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(StoreIcon.frame) + 5, 12.5, 200, 15)];
        [SelectedStoreBtn setTitle:[NSString stringWithFormat:@"韩SHOW潮流男装%ld >",_Section] forState:UIControlStateNormal];
        [SelectedStoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        SelectedStoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        SelectedStoreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        SelectedStoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:SelectedStoreBtn];
        
        //编辑按钮
        UIButton *EditBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 12.5, 30, 15)];
        [EditBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [EditBtn addTarget:self action:@selector(EditAction) forControlEvents:UIControlEventTouchUpInside];
        [EditBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        EditBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:EditBtn];
        
    }
    return self;
}

-(void)InfuseData:(NSString *)selected
{
    NSString *ImageString = @"check_box_nor";
    if ([selected isEqualToString:@"1"]){
        ImageString = @"check_box_sel";
    }
    
    SelectType = selected;
    
    [SelectedCircelBtn setImage:Image(ImageString) forState:UIControlStateNormal];

}
//是否选中 当前section中的所有row
-(void)SlelctedAll
{
    if ([SelectType isEqualToString:@"0"]) {
        [self.delegate SelectedSection:_Section];

    }else{
        [self.delegate SelectedSectionCancel:_Section];
    }
}

-(void)EditAction
{
    [self.delegate SelectedEdit:_Section];
}
@end
