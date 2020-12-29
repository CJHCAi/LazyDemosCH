//
//  HKGroupMainerView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGroupMainerView.h"
#import "UIButton+LXMImagePosition.h"
#import "HKPostDetailResponse.h"
#import "HKUserContentReportController.h"
#import "HKMyCircleViewModel.h"
#import "HKMyPostViewModel.h"
#import "HKPostDetailViewController.h"
#define path 15
#define lineoff 30
#define BtnW 44

@interface HKGroupMainerView ()
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, assign, getter = isShow) BOOL show;
@property (nonatomic, assign) CGFloat actionSheetHeight;
@property (nonatomic, strong)HKPostDetailViewController *vc ;
@property (nonatomic, strong)NSMutableArray *btnSs;
@end


@implementation HKGroupMainerView

+ (void)showGroupItemWithselectSheetBlock:(groupMianerBlock)selectSheetBlock postModel:(HKPostDetailData*)model andController:(UIViewController *)controller{
  
   return  [[[self alloc] initWithselectSheetBlock:selectSheetBlock postModel:model andController:controller] show];
}

- (instancetype)initWithselectSheetBlock:(groupMianerBlock)selectSheetBlock postModel:(HKPostDetailData*)model andController:(UIViewController *)controller
{
    self = [super initWithFrame:ScreenRect];
    if (self) {
        
        _vc = controller;
        _model =model;
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
    
    NSArray * shareTitlesImage =@[@"fxreport",@"fxjing",@"fxtop",@"fxnotice",@"fxdelsc"];
    NSString * seletStr = self.model.isSelected.intValue ? @"取消精选":@"设置精选";
    NSString * topStr   = self.model.isTop.intValue ? @"取消置顶":@"设为置顶";
    NSString * noticeStr  = self.model.isNotice.intValue ? @"取消公告":@"设为公告";
    NSArray *shareTitleLabel =@[@"举报",seletStr,topStr,noticeStr,@"删除"];
    //分享到
    UILabel *shareTitleL =[[UILabel alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,45)];
    [AppUtils getConfigueLabel:shareTitleL font:[UIFont boldSystemFontOfSize:15] aliment:NSTextAlignmentCenter textcolor:RGB(51,51,51) text:@"功能选项"];
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
        [self.btnSs addObject:shareB];
    }
    UIView *lineTwo =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(scroll.frame),kScreenWidth,1)];
    lineTwo.backgroundColor =RGB(226,226,226);
    
    [_actionSheetView addSubview:lineTwo];
    
    UIButton *cancleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0,CGRectGetMaxY(lineTwo.frame),kScreenWidth,49);
    [_actionSheetView addSubview:cancleBtn];
    [AppUtils getButton:cancleBtn font:PingFangSCMedium16 titleColor:RGB(51,51,51) title:@"取消"];
    [cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

-(NSMutableArray *)btnSs {
    if (!_btnSs) {
        _btnSs =[[NSMutableArray alloc] init];
    }
    return _btnSs;
}
-(void)shareClick:(UIButton *)setShare {
    switch (setShare.tag-1000) {
        case  0:
        {
            [self dismiss];
            HKUserContentReportController * reportVc =[[HKUserContentReportController alloc] init];
            [self.vc.navigationController pushViewController:reportVc animated:YES];
        }
            break;
         case 1:
        {
            if (!self.model.isCircleUser.intValue) {
                [EasyShowTextView showText:@"不是群主,无法操作"];
                return;
            }
            NSString * selectStr = self.model.isSelected.intValue ? @"0":@"1";
            [HKMyCircleViewModel setPostSelectdWithState:selectStr andPostId:self.model.postId success:^(HKBaseResponeModel *responde) {
                [self dismiss];
                if (responde.responeSuc) {
                    UIButton *sender =[self.btnSs objectAtIndex:setShare.tag-1000];
                    self.model.isSelected = selectStr.intValue ? @"1":@"0";
                    NSString * success  = self.model.isSelected.intValue? @"取消精选":@"设置精选";
                    [EasyShowTextView showText:@"操作成功"];
                    [sender setTitle:success forState:UIControlStateNormal];
                }else {
                    [EasyShowTextView showText:@"操作失败"];
                }
            }];
        }
            break;
       case 2:
        {
            if (!self.model.isCircleUser.intValue) {
                [EasyShowTextView showText:@"不是群主,无法操作"];
                return;
            }
            NSString * selectStr = self.model.isTop.intValue ? @"0":@"1";
            [HKMyCircleViewModel setPostTopWithState:selectStr  andPostId:self.model.postId success:^(HKBaseResponeModel *responde) {
                [self dismiss];
                if (responde.responeSuc) {
                    UIButton *sender =[self.btnSs objectAtIndex:setShare.tag-1000];
                    self.model.isTop = selectStr.intValue ? @"1":@"0";
                    NSString * success  = self.model.isTop.intValue? @"取消置顶":@"设置置顶";
                    [sender setTitle:success forState:UIControlStateNormal];
                    [EasyShowTextView showText:@"操作成功"];
                }else {
                    [EasyShowTextView showText:@"操作失败"];
                }
            }];
            
        }
            break;
            
        case 3:
        {
            if (!self.model.isCircleUser.intValue) {
                [EasyShowTextView showText:@"不是群主,无法操作"];
                return;
            }
            NSString * selectStr = self.model.isNotice.intValue ? @"0":@"1";
            [HKMyCircleViewModel setNoticeWithState:selectStr  andPostId:self.model.postId success:^(HKBaseResponeModel *responde) {
                [self dismiss];
                if (responde.responeSuc) {
                    UIButton *sender =[self.btnSs objectAtIndex:setShare.tag-1000];
                    self.model.isNotice = selectStr.intValue ? @"1":@"0";
                    NSString * success  = self.model.isNotice.intValue? @"取消公告":@"设置公告";
                    [sender setTitle:success forState:UIControlStateNormal];
                    [EasyShowTextView showText:@"操作成功"];
                }else {
                    [EasyShowTextView showText:@"操作失败"];
                }
            }];
        }
            break;
        case 4:
        {
            if (!self.model.isCircleUser.intValue) {
                [EasyShowTextView showText:@"不是群主,无法操作"];
                return;
             }
            [HKMyPostViewModel deletePostWithPostId:self.model.postId andType:@"2" success:^(HKBaseResponeModel *responde) {
                [self dismiss];
                if (responde.responeSuc) {
                    if (self.vc.block) {
                        self.vc.block();
                    }
                    [self.vc.navigationController popViewControllerAnimated:YES];
                }else {
                    [EasyShowTextView showText:@"操作失败"];
                }
            }];
        }
            break;
        default:
            break;
    }
}
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
@end
