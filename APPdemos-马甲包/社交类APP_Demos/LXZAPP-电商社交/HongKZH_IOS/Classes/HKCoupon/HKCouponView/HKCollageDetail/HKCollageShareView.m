//
//  HKCollageShareView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/2.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCollageShareView.h"
#import "UIButton+LXMImagePosition.h"
//#import "HKShareBaseModel.h"
#import "HKShareBaseModel.h"
#define path 15
#define lineoff 30
#define BtnW 44
@interface HKCollageShareView ()

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *actionSheetView;

@property (nonatomic, assign, getter = isShow) BOOL show;
@property (nonatomic, assign) CGFloat actionSheetHeight;

@end


@implementation HKCollageShareView
+ (void)showSelfBotomWithselectSheetBlock:(ShareSheetDidSelectSheetBlock)selectSheetBlock shareModel:(HKShareBaseModel*)model{
    
    [[[self alloc] initWithselectSheetBlock:selectSheetBlock shareModel:model] show];
}
+ (void)showSelfBotomWithselectSheetBlock:(ShareSheetDidSelectSheetBlock)selectSheetBlock {
    
    [[[self alloc] initWithselectSheetBlock:selectSheetBlock] show];
}
- (instancetype)initWithselectSheetBlock:(ShareSheetDidSelectSheetBlock)selectSheetBlock shareModel:(HKShareBaseModel*)model
{
    self = [super initWithFrame:ScreenRect];
    if (self) {
        
        _selectSheetBlock = selectSheetBlock;
        [self setupCoverView];
        [self setupActionSheetView];
        self.sharM = model;
    }
    return self;
}
- (instancetype)initWithselectSheetBlock:(ShareSheetDidSelectSheetBlock)selectSheetBlock;
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
    _actionSheetHeight = 186+SafeAreaBottomHeight;
    _coverView = [[UIView alloc] initWithFrame:self.bounds];
    _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _coverView.alpha = 0;
    
    [self addSubview:_coverView];
}
#pragma mark 布局子视图
-(void)setupActionSheetView {
    _actionSheetView = [[UIView alloc] init];
    _actionSheetView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), _actionSheetHeight);
    _actionSheetView.backgroundColor =[UIColor colorFromHexString:@"fefefe"] ;
    [self addSubview:_actionSheetView];
    
    NSArray * shareTitlesImage =@[@"pdxq_hy",@"pdxq_wx",@"pdxq_pyq",@"pdxq_qq"];
    NSArray *shareTitleLabel =@[@"好友",@"微信好友",@"朋友圈",@"QQ好友"];
    //分享到
    UILabel *shareTitleL =[[UILabel alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,45)];
    [AppUtils getConfigueLabel:shareTitleL font:[UIFont boldSystemFontOfSize:15] aliment:NSTextAlignmentCenter textcolor:RGB(51,51,51) text:@"分享到"];
    [_actionSheetView addSubview:shareTitleL];
    UIView *lineOne =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(shareTitleL.frame),kScreenWidth,1)];
    lineOne.backgroundColor = RGB(226,226, 226);
    [_actionSheetView addSubview:lineOne];
   //滑动scrollView
    UIScrollView *scroll =[[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(lineOne.frame),kScreenWidth,90)];
    scroll.backgroundColor =RGB(255,255, 255);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.scrollEnabled = NO;
    [_actionSheetView addSubview:scroll];
    CGFloat lineOff = (kScreenWidth -path*2-5*BtnW)/4;
    for (int i=0; i<shareTitleLabel.count; i++) {
        UIButton * shareB =[UIButton buttonWithType:UIButtonTypeCustom];
        shareB.frame = CGRectMake(path+(BtnW+lineOff)*i,14,BtnW,BtnW+20);
        [shareB setTitle:shareTitleLabel[i] forState:UIControlStateNormal];
        shareB.titleLabel.font =PingFangSCMedium10;
        [shareB setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
        [shareB setImage:[UIImage imageNamed:shareTitlesImage[i]] forState:UIControlStateNormal];
        shareB.tag =1000+i;
        [shareB setImagePosition:LXMImagePositionTop spacing:6
         ];
        [shareB addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
        [scroll addSubview:shareB];
    }
//    [scroll setContentSize:CGSizeMake(path*2+BtnW*5+lineoff*4,CGRectGetHeight(scroll.frame))];
    UIView *lineTwo =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(scroll.frame),kScreenWidth,1)];
    lineTwo.backgroundColor =RGB(226,226,226);
    
    [_actionSheetView addSubview:lineTwo];
    
    UIButton *cancleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0,CGRectGetMaxY(lineTwo.frame),kScreenWidth,49);
    [_actionSheetView addSubview:cancleBtn];
    [AppUtils getButton:cancleBtn font:PingFangSCMedium16 titleColor:RGB(51,51,51) title:@"取消"];
    [cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Show and dismiss
#pragma mark - Touches action
-(void)shareClick:(UIButton *)setShare {
    switch (setShare.tag -1000) {
        case 0:{
          self.sharM.platform =SSDKPlatformTypeUnknown;
        }
            break;
//        case 1:
//        {
//           self.sharM.platform =SSDKPlatformTypeSinaWeibo;
//        }break;
        case 1:
        {
            if (![WXApi isWXAppInstalled]) {
                [self dismiss];
                [EasyShowTextView showText:@"您未安装微信"];
                return;
            }
            self.sharM.platform =SSDKPlatformSubTypeWechatSession;
        }
            break;
        case 2:
        {
            if (![WXApi isWXAppInstalled]) {
                [self dismiss];
                [EasyShowTextView showText:@"您未安装微信"];
                return;
            }
            self.sharM.platform =SSDKPlatformSubTypeWechatTimeline;
        }
            break;
        case 3:
        {
            if (![TencentOAuth iphoneQQInstalled]) {
                [self dismiss];
                 [EasyShowTextView showText:@"您未安装QQ"];
                return;
            }
            self.sharM.platform = SSDKPlatformSubTypeQQFriend;
        }
            break;
        default:
            break;
    }
    [self dismiss];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:_coverView];
    if (!CGRectContainsPoint(_actionSheetView.frame, touchPoint)) {
        [self dismiss];
    }
}
#pragma mark - Show and dismiss

- (void)show {    if(self.isShow) {
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
@end
