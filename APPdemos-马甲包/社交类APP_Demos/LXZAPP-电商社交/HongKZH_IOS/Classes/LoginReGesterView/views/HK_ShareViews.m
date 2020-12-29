//
//  HK_ShareViews.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_ShareViews.h"
#define margin 60
#import "HK_ImageTitleBtn.h"
@interface HK_ShareViews ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *actionSheetView;

@property (nonatomic, assign, getter = isShow) BOOL show;
@property (nonatomic, assign) CGFloat actionSheetHeight;

@end

@implementation HK_ShareViews
{
    UIButton * btn;
}
+ (void)showSelfBotomWithselectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock {
 
    [[[self alloc] initWithselectSheetBlock:selectSheetBlock] show];
}
- (instancetype)initWithselectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock;
{
    self = [super initWithFrame:ScreenRect];
    if (self) {
       
        _selectSheetBlock = selectSheetBlock;
          [self setupCoverView];
          [self setupActionSheetView];
    }
    return self;
}
- (void)setupCoverView {
    _actionSheetHeight = 150;
    _coverView = [[UIView alloc] initWithFrame:self.bounds];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _coverView.alpha = 0;
    [self addSubview:_coverView];
}

-(void)setupActionSheetView {
    _actionSheetView = [[UIView alloc] init];    _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
    _actionSheetView.backgroundColor =[UIColor colorFromHexString:@"fefefe"] ;
    [self addSubview:_actionSheetView];
    
    NSArray * shareTitlesImage =@[@"003_wx_",@"003_qq_",@"003_word_"];
    NSArray *shareTitleLabel =@[@"微信",@"QQ",@"账号密码"];
    UIImage * btnImage =[UIImage imageNamed:@"003_wx_"];
    CGFloat btnW = btnImage.size.width;
    CGFloat btnLine =((kScreenWidth - margin*2)-shareTitleLabel.count * btnW) /(shareTitleLabel.count-1);
    for (int i=0; i< shareTitleLabel.count; i++) {
        HK_ImageTitleBtn * shareBtn =[[HK_ImageTitleBtn alloc] initWithFrame:CGRectMake(margin+i*(btnW + btnLine),20,btnW,60)];
        //shareBtn.buttonType =
        [AppUtils getButton:shareBtn font:PingFangSCRegular10 titleColor:[UIColor colorFromHexString:@"333333"] title:shareTitleLabel[i]];
        shareBtn.imageV.image =[UIImage imageNamed:shareTitlesImage[i]];
        shareBtn.labelV.text = shareTitleLabel[i];
//        shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0,0,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//        shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0,0,-50,10);//设置title在button上的
        shareBtn.tag = i+1;
        [shareBtn addTarget:self action:@selector(shareSomethings:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn = shareBtn;
        }
        [_actionSheetView addSubview:shareBtn];
    }
    UIView *lineB =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(btn.frame)+20,kScreenWidth,1)];
    lineB.backgroundColor = RGB(242,242,242);
    [_actionSheetView addSubview:lineB];
 //取消
    UIButton *cancleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_actionSheetView addSubview:cancleBtn];
    [AppUtils getButton:cancleBtn font:PingFangSCRegular16 titleColor:[UIColor colorFromHexString:@"333333"] title:@"取消"];
    [cancleBtn addTarget:self action:@selector(shareSomethings:) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.tag = 4;
    cancleBtn.frame = CGRectMake(0,100,kScreenWidth,50);
    
}
-(void)shareSomethings:(UIButton *)sender {
    if (_selectSheetBlock) {
        _selectSheetBlock(sender.tag);
    }
     [self dismiss];
}
#pragma mark - Show and dismiss
#pragma mark - Touches action

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_coverView];
    if (!CGRectContainsPoint(_actionSheetView.frame, touchPoint)) {
        [self dismiss];
    }
}
#pragma mark - Show and dismiss

- (void)show {
    
    if(self.isShow) {
        return;
    }
    self.show = YES;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
                         self.coverView.alpha = 1.0;
                         self.actionSheetView.transform = CGAffineTransformMakeTranslation(0, -self.actionSheetHeight);
                     } completion:nil];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                        self.coverView.alpha = 0;
                         self.actionSheetView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
-(void)setSelectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock{
    __weak ActionSheetDidSelectSheetBlock blcok = selectSheetBlock;
    _selectSheetBlock = blcok;
}
@end
