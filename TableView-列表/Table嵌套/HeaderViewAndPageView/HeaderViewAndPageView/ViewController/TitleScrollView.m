//
//  TitleScrollView.m
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//
#import "TitleScrollView.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TitleScrollView ()

@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIView * selectedView;
@property (strong,nonatomic)UIButton * tmpBtn;
@end

@implementation TitleScrollView

-(id)initWithFrame:(CGRect)frame{

    
    self = [super initWithFrame:frame];
    NSArray *arr =@[@"全部",@"香港",@"首尔",@"曼谷",@"巴厘岛",@"普吉岛",@"九寨沟"];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, frame.origin.y, KScreenWidth, frame.size.height)];
        self.scrollView.contentSize = CGSizeMake(20+(20+KScreenWidth/5) *arr.count,0);
         self.scrollView.showsHorizontalScrollIndicator =NO;
         self.scrollView.tag =12;
        [ self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
         self.scrollView.delegate = self;
        self.scrollView.scrollEnabled = YES;
        _scrollView.directionalLockEnabled =YES;
//        self.scrollView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        for(NSInteger i = 0; i < arr.count; i++){
        
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((KScreenWidth/5 +20)*i+20, 5, KScreenWidth/5, 30);
            btn.tag = i+1;
            if (btn.tag == 1) {
                btn.selected = YES;
                _tmpBtn =btn;
            }
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
           
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"buttonBg"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor;
            btn.layer.borderWidth =0.5f;
            btn.layer.cornerRadius =2.0f;
            
            [self.scrollView addSubview:btn];
        
        }
    [self addSubview:self.scrollView];
   }
  return self;
    
}


-(void)btnClick:(UIButton * )sender{
    
   sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 1:
            {
                NSLog(@"第一个按钮的tag值---====%ld",(long)sender.tag);
              
            }
            break;
        case 2:
        {
            NSLog(@"第二个按钮的tag值---====%ld",(long)sender.tag);
        }
            break;
        case 3:
        {
            NSLog(@"第三按钮的tag值---====%ld",(long)sender.tag);
        }
            break;
        case 4:
        {
            NSLog(@"第四个按钮的tag值---====%ld",(long)sender.tag);
        }
            break;
        case 5:
        {
            NSLog(@"第五个按钮的tag值---====%ld",(long)sender.tag);
        }
            break;
        case 6:
        {
            NSLog(@"第六个按钮的tag值---====%ld",(long)sender.tag);
        }
            break;
        case 7:
        {
            NSLog(@"第七个按钮的tag值---====%ld",(long)sender.tag);
        }
            break;
            
        default:
            break;
    }
    if (_tmpBtn == nil){
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender){
        sender.selected = YES;
        
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil){
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

@end
