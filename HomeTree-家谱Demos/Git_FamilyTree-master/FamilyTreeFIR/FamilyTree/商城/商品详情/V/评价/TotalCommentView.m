//
//  TotalCommentView.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "TotalCommentView.h"
#import "ChooseCommentView.h"

@interface TotalCommentView()<ChooseCommentViewDelegate>

@property (strong,nonatomic) ChooseCommentView *chooseCommentV;

@end

@implementation TotalCommentView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initView{
    _commentNumberLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 20)];
    [self addSubview:_commentNumberLb];
    _commentNumberLb.font = MFont(16);
    _commentNumberLb.backgroundColor = [UIColor clearColor];
    _commentNumberLb.textAlignment = NSTextAlignmentLeft;
    float value = 97.5;
    _commentNumberLb.text = [NSString stringWithFormat:@"%.1f%%好评",value];
   //评价星级视图。。可以用封装好的替换
    _starV = [[StarView alloc]initWithFrame:CGRectMake(CGRectXW(_commentNumberLb)+5, 14, 85, 17)];
    [self addSubview:_starV];


    _chooseCommentV = [[ChooseCommentView alloc]initWithFrame:CGRectMake(0, CGRectYH(_commentNumberLb), __kWidth, 85)];
    [self addSubview:_chooseCommentV];
    _chooseCommentV.delegate = self;
    _chooseCommentV.backgroundColor = [UIColor clearColor];
    [_chooseCommentV.AllcommentBtn setTitle:@"全部(1075)" forState:BtnNormal];
    [_chooseCommentV.goodCommentBtn setTitle:@"好评(1048)" forState:BtnNormal];
    [_chooseCommentV.middleCommentBtn setTitle:@"中评(8)" forState:BtnNormal];
    [_chooseCommentV.badCommentBtn setTitle:@"差评(19)" forState:BtnNormal];
    [_chooseCommentV.imgBtn setTitle:@"有图(28)" forState:BtnNormal];
    [_chooseCommentV updateFrame];//
}

-(void)selcetComment:(UIButton *)sender{
    [self.delegate selectCommentType:sender];
}

@end
