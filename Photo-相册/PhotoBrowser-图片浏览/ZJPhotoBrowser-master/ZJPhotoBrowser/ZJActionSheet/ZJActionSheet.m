//
//  ZJActionSheet.m
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/14.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import "ZJActionSheet.h"

@interface ZJActionSheet ()<ZJActionDelegate>

@property (nonatomic, strong) UIView *actionBackView;


@end

static CGFloat cancelButtonSpace = 10;
@implementation ZJActionSheet

- (instancetype)initWithFrame:(CGRect)frame {
    
   self = [super initWithFrame:CGRectMake(0, 0, kZJActionScreenWidth, kZJActionScreenHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        //添加单击消失
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapAction)];
        oneTap.numberOfTapsRequired = 1;
        oneTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:oneTap];
        
        //添加取消按钮
        ZJAction* cancelAction =  [[ZJAction alloc] initWithTitle:@"取消" action:nil];
        [self addAction:cancelAction];
        
    }
    return self;
    
    
    // Do any additional setup after loading the view.
    
}

- (void)addActionViews {

    //添加测试按钮

    CGFloat actionsHeight = self.actionArray.count * kZJActionHeight + cancelButtonSpace;
    self.actionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , self.frame.size.width, actionsHeight)];
    [self addSubview:_actionBackView];
    
    for (int i = 0; i < self.actionArray.count; i ++) {
        
        ZJAction *action = self.actionArray[i];
        CGFloat actionY ;
        if (i == 0) {
            actionY = actionsHeight - kZJActionHeight;
        }else {
            actionY = actionsHeight - kZJActionHeight*(i+1) -cancelButtonSpace;
        }
        
        action.frame = CGRectMake(action.frame.origin.x, actionY, action.frame.size.width, action.frame.size.height);
        [self.actionBackView addSubview:action];;
        
        //画条线
        if ( i>0 && i<self.actionArray.count) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, actionY, action.frame.size.width, 0.5)];
            lineView.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
            [self.actionBackView addSubview:lineView];
        }
    }

}

- (NSMutableArray *)actionArray {

    if (_actionArray == nil) {
        
        _actionArray = [[NSMutableArray alloc] initWithCapacity:1];
        
    }
    return _actionArray;
}

//消失
- (void)oneTapAction {
    [UIView animateWithDuration:0.3 animations:^{
        
        _actionBackView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#pragma mark - 外部接口
//添加时间
- (void)addAction:(ZJAction *)action {

    [self.actionArray addObject:action];
    action.delegate = self;
}
//显示视图
- (void)show {

    [self addActionViews];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _actionBackView.transform = CGAffineTransformMakeTranslation(0, -_actionBackView.frame.size.height);
    }];
    
}

#pragma mark - ZJActionDelegate
- (void)didSelectedZJAction:(ZJAction *)action {

    //执行传入block
    if (action.action) {
        
        action.action();
    }
    //隐藏按钮
    [self oneTapAction];
    
    
}


//获取顶层的viewController
- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
