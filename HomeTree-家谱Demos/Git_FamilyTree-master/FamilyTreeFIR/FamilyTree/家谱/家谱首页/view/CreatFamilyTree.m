//
//  CreatFamilyTree.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CreatFamilyTree.h"
@interface CreatFamilyTree()
/**背景*/
@property (nonatomic,strong) UIView *clearView;

@end
@implementation CreatFamilyTree

- (instancetype)initWithFrame:(CGRect)frame withType:(CreatefamilyTreeType)type
{
    self = [super initWithFrame:frame];
    if (self) {

        _type = type;
        
        if (type == CreatefamilyTreeTypeThreeBtn) {
            [self addSubview:self.clearView];
            [self initWithThreeBtnType];
        }else if(type == CreatefamilyTreeTypeTwoBtn){
            self.frame = AdaptationFrame(143, 627, 406, 195);
            [self initWithTwoBtnType];
        }
        
    }
    return self;
}
//有家谱两个按钮
-(void)initWithTwoBtnType{
    [self addSubview:[self createBtnWithFrame:AdaptationFrame(54, 32, 110, 121) image:MImage(@"noJP_cj") withTag:0]];
    [self addSubview:[self createBtnWithFrame:AdaptationFrame(240, 32, 110, 121) image:MImage(@"noJP_add")withTag:1]];
}
//没家谱三个按钮
-(void)initWithThreeBtnType{
    [self.clearView addSubview:[self createBtnWithFrame:AdaptationFrame(206, 34, 110, 121) image:MImage(@"noJP_cj") withTag:0]];
    [self.clearView addSubview:[self createBtnWithFrame:AdaptationFrame(55, 210, 110, 121) image:MImage(@"noJP_add")withTag:1]];
    [self.clearView addSubview:[self createBtnWithFrame:AdaptationFrame(360, 210, 110, 121) image:MImage(@"haveJP_gl") withTag:2]];
}
-(UIButton *)createBtnWithFrame:(CGRect)frame image:(UIImage *)btnImage withTag:(NSInteger)tag{
    UIButton *buttn = [[UIButton alloc] initWithFrame:frame];
    [buttn setImage:btnImage forState:0];
    buttn.tag = tag;
    [buttn addTarget:self action:@selector(respondsToCreateTreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    return buttn;
}

#pragma mark *** events ***
-(void)respondsToCreateTreeBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(CreateFamilyTree:didSelectedBtn:)]) {
        [_delegate CreateFamilyTree:self didSelectedBtn:sender];
    }
}
#pragma mark *** getters ***
-(UIView *)clearView{
    if (!_clearView) {
        _clearView = [[UIView alloc] initWithFrame:AdaptationFrame(62, 495, 517, 373)];
        _clearView.layer.cornerRadius = 20.0f;
        _clearView.layer.masksToBounds = YES;
        _clearView.backgroundColor = [UIColor blackColor];
        _clearView.alpha = 0.8;
        _clearView.userInteractionEnabled = true;
    }
    return _clearView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"%f--%f", touchPoint.x,touchPoint.y);
    if ((touchPoint.x<self.clearView.frame.origin.x||
         touchPoint.x>self.clearView.frame.origin.x+self.clearView.bounds.size.width)||
        (touchPoint.y>self.clearView.frame.origin.y+self.clearView.bounds.size.height||
         touchPoint.y<self.clearView.frame.origin.y)) {
        
        [self removeFromSuperview];

    }
}
@end
