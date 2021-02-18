//
//  ChooseBtnView.m
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ChooseBtnView.h"

@interface ChooseBtnView ()
/**
 *  活跃榜
 */
@property (strong,nonatomic) UIButton *activeBtn;
/**
 *  人数榜
 */
@property (strong,nonatomic) UIButton *persoNumberBtn;
/**
 *  众筹榜
 */
@property (strong,nonatomic) UIButton *crowdfundingBtn;

@end

@implementation ChooseBtnView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor =[UIColor clearColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    CGFloat w = self.frame.size.width;
    _activeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (w-12)/3, 34)];
    [self addSubview:_activeBtn];
    _activeBtn.layer.cornerRadius = 4;
    _activeBtn.tag = 1;
    [_activeBtn setTitle:@"活跃榜" forState:BtnNormal];
    _activeBtn.titleLabel.font = MFont(15);
    [_activeBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _activeBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
    [_activeBtn addTarget:self action:@selector(change:) forControlEvents:BtnTouchUpInside];

    _persoNumberBtn = [[UIButton alloc]initWithFrame:CGRectMake((w-12)/3+4, 0, (w-12)/3, 34)];
    [self addSubview:_persoNumberBtn];
    _persoNumberBtn.tag = 2;
    _persoNumberBtn.layer.cornerRadius = 4;
    [_persoNumberBtn setTitle:@"人数榜" forState:BtnNormal];
    _persoNumberBtn.titleLabel.font = MFont(15);
    [_persoNumberBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _persoNumberBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
    [_persoNumberBtn addTarget:self action:@selector(change:) forControlEvents:BtnTouchUpInside];

    _crowdfundingBtn = [[UIButton alloc]initWithFrame:CGRectMake((w-12)/1.5+8, 0, (w-12)/3, 34)];
    [self addSubview:_crowdfundingBtn];
    _crowdfundingBtn.tag = 3;
    _crowdfundingBtn.layer.cornerRadius = 4;
    [_crowdfundingBtn setTitle:@"众筹榜" forState:BtnNormal];
    _crowdfundingBtn.titleLabel.font = MFont(15);
    [_crowdfundingBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _crowdfundingBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
    [_crowdfundingBtn addTarget:self action:@selector(change:) forControlEvents:BtnTouchUpInside];


}

-(void)change:(UIButton*)sender{

    switch (sender.tag) {
        case 1:
        {
            [_activeBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            _activeBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
            [_persoNumberBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _persoNumberBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            [_crowdfundingBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _crowdfundingBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            
        }
            break;
        case 2:
        {
            [_activeBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _activeBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            [_persoNumberBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            _persoNumberBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
            [_crowdfundingBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _crowdfundingBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
                    }
            break;
        case 3:
        {
            [_activeBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _activeBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            [_persoNumberBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _persoNumberBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            [_crowdfundingBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            _crowdfundingBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
            
        }
            break;
        case 4:
        {
            [_activeBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _activeBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            [_persoNumberBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _persoNumberBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            [_crowdfundingBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            _crowdfundingBtn.backgroundColor = LH_RGBCOLOR(190, 190, 190);
            
        }
            break;
        default:
            break;
    }
    [self.delegate chooseType:sender];
}

@end
