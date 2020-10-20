//
//  ViewController.m
//  弹幕
//
//  Created by 伍宏彬 on 15/10/13.
//  Copyright (c) 2015年 伍宏彬. All rights reserved.
//

#import "ViewController.h"
#import "HBdansView.h"
#import "UIView+WHB.h"
#import "HBdansLable.h"


@interface ViewController ()
{
    HBdansView *_dansView;
    HBdansView *_randomDansView;
    HBdansLable *_randomLable;
    
}
@property (weak, nonatomic) IBOutlet UIButton *beginBtn;



@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
//    0.弹幕
    NSMutableArray *dans = [self contents];
    
    _dansView = [[HBdansView alloc] initDansViewFrame:CGRectMake(0, 20, self.view.width, 44) contents:dans];
    _dansView.backgroundColor = [UIColor lightGrayColor];
    _dansView.textColor = [UIColor redColor];
    [self.view addSubview:_dansView];
    
    
    
    _randomDansView = [[HBdansView alloc] initWithFrame:CGRectMake(0, 84, self.view.width, 320)];
    _randomDansView.countInScreen = 3;
    _randomDansView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_randomDansView];
    

    
}

/*
 这里有两种方式去展示弹幕
  1.begin1方法
    来一条弹幕信息，就添加进去，准备显示一条。
  2.begin2方法
    显示固定内容，给一个装有文字的数组，就不用管了。自己播放
    
  注意:这两种都是内容全部播完了就自动停止了，不会一直轮播。
 **/
- (IBAction)begin1:(id)sender {
    
    
    static int a = 0;
    a++;
    [_randomDansView addRandomText:[NSString stringWithFormat:@"好不下个安师大哈送打电话地球哦我当前。。。%d",a]];
}
- (IBAction)begin2:(id)sender {
    
    
    [_dansView starDans];
}
#pragma mark - getter
- (NSMutableArray *)contents
{
    NSString *text1 = @"text1";
    NSString *text2 = @"text2";
    NSString *text3 = @"text3";
    NSString *text4 = @"text4";
    NSString *text5 = @"text5";
    NSString *text6 = @"text6";
    NSString *text7 = @"text7";
    NSArray *array = [NSArray arrayWithObjects:text1,text2,text3,text4,text5,text6,text7, nil];
    return [array mutableCopy];
}

@end
