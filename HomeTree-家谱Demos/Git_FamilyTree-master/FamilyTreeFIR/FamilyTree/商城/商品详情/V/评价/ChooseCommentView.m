//
//  ChooseCommentView.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ChooseCommentView.h"

@interface ChooseCommentView()

@property (strong,nonatomic) NSArray *btnArr;

@end


@implementation ChooseCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
#pragma mark ==根据按钮字符串大小获取宽度==
-(CGFloat)widthWithBtn:(UIButton *)sender{
    NSString *str = sender.titleLabel.text;
    CGFloat Width;
    if (str.length >5) {
        Width = 60+5*(str.length-5);
    }else{
        Width = 60;
    }
    [sender setTitle:str forState:BtnNormal];
    return Width;
}
#pragma mar ==更新按钮的约束==
- (void)updateFrame{
    _AllcommentBtn.frame = CGRectMake(15, 10, [self widthWithBtn:_AllcommentBtn], 28);
    _goodCommentBtn.frame = CGRectMake(CGRectXW(_AllcommentBtn)+8, 10, [self widthWithBtn:_goodCommentBtn], 28);
    _middleCommentBtn.frame =CGRectMake(CGRectXW(_goodCommentBtn)+8, 10, [self widthWithBtn:_middleCommentBtn], 28);
    if (CGRectXW(_badCommentBtn)>__kWidth-15) {
        _badCommentBtn.frame = CGRectMake(15, CGRectYH(_AllcommentBtn)+10, [self widthWithBtn:_badCommentBtn], 28);
        _imgBtn.frame = CGRectMake(CGRectXW(_badCommentBtn)+8, CGRectYH(_AllcommentBtn)+10, [self widthWithBtn:_imgBtn], 28);
    }else{
        _badCommentBtn.frame = CGRectMake(CGRectXW(_middleCommentBtn)+8, 10, [self widthWithBtn:_badCommentBtn], 28);
        _imgBtn.frame = CGRectMake(15, CGRectYH(_AllcommentBtn)+10, [self widthWithBtn:_imgBtn], 28);
    }
}

- (void)initView{
    _AllcommentBtn = [[UIButton alloc]init];
    [self addSubview:_AllcommentBtn];
    _AllcommentBtn.tag = 11;
    _AllcommentBtn.titleLabel.font = MFont(13);
    [_AllcommentBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _AllcommentBtn.backgroundColor = [UIColor whiteColor];
    _AllcommentBtn.layer.cornerRadius = 4;
    _AllcommentBtn.layer.borderWidth = 1;
    _AllcommentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_AllcommentBtn addTarget:self action:@selector(commentSelect:) forControlEvents:BtnTouchUpInside];

    _goodCommentBtn = [[UIButton alloc]init];
    [self addSubview:_goodCommentBtn];
    _goodCommentBtn.tag = 12;
    _goodCommentBtn.titleLabel.font = MFont(13);
    [_goodCommentBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _goodCommentBtn.backgroundColor = [UIColor whiteColor];
    _goodCommentBtn.layer.cornerRadius = 4;
    _goodCommentBtn.layer.borderWidth = 1;
    _goodCommentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_goodCommentBtn addTarget:self action:@selector(commentSelect:) forControlEvents:BtnTouchUpInside];

    _middleCommentBtn = [[UIButton alloc]init];
    [self addSubview:_middleCommentBtn];
    _middleCommentBtn.tag = 13;
    _middleCommentBtn.titleLabel.font = MFont(13);
    [_middleCommentBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _middleCommentBtn.backgroundColor = [UIColor whiteColor];
    _middleCommentBtn.layer.cornerRadius = 4;
    _middleCommentBtn.layer.borderWidth = 1;
    _middleCommentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_middleCommentBtn addTarget:self action:@selector(commentSelect:) forControlEvents:BtnTouchUpInside];

    _badCommentBtn = [[UIButton alloc]init];
    [self addSubview:_badCommentBtn];
    _badCommentBtn.tag = 14;
    _badCommentBtn.titleLabel.font = MFont(13);
    [_badCommentBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _badCommentBtn.backgroundColor = [UIColor whiteColor];
    _badCommentBtn.layer.cornerRadius = 4;
    _badCommentBtn.layer.borderWidth = 1;
    _badCommentBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_badCommentBtn addTarget:self action:@selector(commentSelect:) forControlEvents:BtnTouchUpInside];

    _imgBtn = [[UIButton alloc]init];
    [self addSubview:_imgBtn];
    _imgBtn.tag = 15;
    _imgBtn.titleLabel.font = MFont(13);
    [_imgBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
    _imgBtn.backgroundColor = [UIColor whiteColor];
    _imgBtn.layer.cornerRadius = 4;
    _imgBtn.layer.borderWidth = 1;
    _imgBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_imgBtn addTarget:self action:@selector(commentSelect:) forControlEvents:BtnTouchUpInside];

    _btnArr = @[_AllcommentBtn,_goodCommentBtn,_middleCommentBtn,_badCommentBtn,_imgBtn];
}
#pragma mark  ==按钮点击效果切换==
-(void)commentSelect:(UIButton *)sender{
    for (UIButton *btn in _btnArr) {
        if (btn == sender) {
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            btn.layer.borderColor = [UIColor redColor].CGColor;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor blackColor] forState:BtnNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    [self.delegate selcetComment:sender];
}



@end
