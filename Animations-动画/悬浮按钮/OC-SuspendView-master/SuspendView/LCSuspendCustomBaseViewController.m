//
//  LCSuspendCustomBaseViewController.m
//  LuochuanAD
//
//  Created by care on 17/5/8.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import "LCSuspendCustomBaseViewController.h"
#import "LCSuspendCustomView.h"

@interface LCSuspendCustomBaseViewController ()<SuspendCustomViewDelegate>
{
    CGFloat viewWidth;
    CGFloat viewHeight;
}
@property (nonatomic, strong) UIWindow *customWindow;
@property (nonatomic, strong) LCSuspendCustomView *customView;
@end

@implementation LCSuspendCustomBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame=CGRectZero;
    [self performSelector:@selector(createBaseUI) withObject:nil afterDelay:1];
    
}
- (void)createBaseUI{
    if (_suspendType==BUTTON) {
        viewWidth=80;
        viewHeight=80;
    }else if (_suspendType==IMAGEVIEW){
        viewWidth=100;
        viewHeight=100;
    }else if (_suspendType==GIF){
        viewWidth=100;
        viewHeight=100;
        
    }else if (_suspendType==MUSIC){
        viewWidth=150;
        viewHeight=100;
    }else if (_suspendType==VIDEO){
        viewWidth=200;
        viewHeight=150;
    }else if (_suspendType==SCROLLVIEW){
        viewWidth=200;
        viewHeight=200;
    }else if (_suspendType==OTHERVIEW){
        viewWidth=100;
        viewHeight=100;
    }
    NSString *type=[NSString stringWithFormat:@"%ld",(long)_suspendType];
    _customView=[self createCustomViewWithType:type];
    _customWindow=[self createCustomWindow];
    
    [_customWindow addSubview:_customView];
    [_customWindow makeKeyAndVisible];
    
}
- (LCSuspendCustomView *)createCustomViewWithType:(NSString *)type{
    if (!_customView) {
        _customView=[[LCSuspendCustomView alloc]init];
        _customView.viewWidth=viewWidth;
        _customView.viewHeight=viewHeight;
        [_customView initWithSuspendType:type];
        _customView.frame=CGRectMake(0, 0, viewWidth, viewHeight);
        _customView.suspendDelegate=self;
        _customView.rootView=self.view.superview;
    }

    return _customView;
}
- (UIWindow *)createCustomWindow{
    if (!_customWindow) {
        _customWindow=[[UIWindow alloc]init];
        _customWindow.frame=CGRectMake(WINDOWS.width-viewWidth,WINDOWS.height-viewHeight-49, viewWidth, viewHeight);
        _customWindow.windowLevel=UIWindowLevelAlert+1;
        _customWindow.backgroundColor=[UIColor clearColor];
        
    }
    return _customWindow;
}



#pragma mark --SuspendCustomViewDelegate



- (void)suspendCustomViewClicked:(id)sender{
    NSLog(@"此处判断点击 还可以通过suspenType类型判断");
    LCSuspendCustomView *suspendCustomView=(LCSuspendCustomView *)sender;
    for (UIView *subView in suspendCustomView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            NSLog(@"点击了按钮");
            suspendCustomView.customButton.selected=!suspendCustomView.customButton.selected;
            if (suspendCustomView.customButton.selected==YES) {
             [suspendCustomView.customButton setBackgroundImage:[UIImage imageNamed:@"button_on"] forState:UIControlStateNormal];
            }else{
            [suspendCustomView.customButton setBackgroundImage:[UIImage imageNamed:@"button_out"] forState:UIControlStateNormal];
            }

        }else if([subView isKindOfClass:[UIImageView class]]){
        
            NSLog(@"点击了图片");
        }else if([subView isKindOfClass:[UIWebView class]]){
            
            NSLog(@"点击了Gif");
        }else if([subView isKindOfClass:[UIScrollView class]]){
            suspendCustomView.customScrollView.scrollEnabled=!suspendCustomView.customScrollView.scrollEnabled;
            if (suspendCustomView.customScrollView.scrollEnabled) {
                suspendCustomView.customScrollView.backgroundColor=[UIColor greenColor];
            }else{
                suspendCustomView.customScrollView.backgroundColor=[UIColor grayColor];
            }
            
            NSLog(@"点击了scrollView,通过点击,决定是否滚动");
        }else if([subView isKindOfClass:[UIView class]]){
            NSLog(@"点击了自定义view");
        
        }

        
    }
    
    
    
}
- (void)dragToTheLeft{
    NSLog(@"左划到左边框了");

}
- (void)dragToTheRight{
    NSLog(@"右划到右边框了");

}
- (void)dragToTheTop{
    NSLog(@"上滑到顶部了");

}
- (void)dragToTheBottom{
    NSLog(@"下滑到底部了");


}

@end
