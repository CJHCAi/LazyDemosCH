//
//  KeyView.m
//  fuck_key
//
//  Created by 姬拉～ on 2016/12/22.
//  Copyright © 2016年 姬拉～. All rights reserved.
//

#import "KeyView.h"

//本地获取
#define XBGetUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

@implementation KeyView
{
    UILabel*tishi;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self initui];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
-(void)initui
{
    tishi=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    tishi.text=@"每秒发送：10次";
    [self addSubview:tishi];
    
    UISlider* mySlider =[[UISlider alloc] initWithFrame:CGRectMake(30,40,300,30)];
    mySlider.minimumValue=1;
    mySlider.maximumValue=50;
    mySlider.value = 10.0;
    [self addSubview:mySlider];
    [mySlider addTarget:self action:@selector(editValue:) forControlEvents:UIControlEventValueChanged];
    
    NSString *firstName =XBGetUserDefaults(@"JILA");
    
    UITextView*text1=[[UITextView alloc]initWithFrame:CGRectMake(10, 80, 340, 50)];
    text1.text=firstName&&firstName.length>0?firstName:@"你看我打字快不快？";
    text1.keyboardType=UIKeyboardTypeNumberPad;
    text1.layer.borderColor=[UIColor grayColor].CGColor;
    text1.layer.borderWidth=0.5;
    [self addSubview:text1];
    self.textstr=text1;
    
    UIButton *begin=[UIButton buttonWithType:UIButtonTypeSystem];
    begin.frame=CGRectMake(220, 10, 100, 40);
    [begin setBackgroundColor:[UIColor redColor]];
    [begin setTitle:@"奔跑吧姬拉" forState:UIControlStateNormal];
    [begin setTitle:@"奔跑吧姬拉" forState:UIControlStateHighlighted];
    [self addSubview:begin];
    self.beginbutton=begin;
    
    UIButton *begin2=[UIButton buttonWithType:UIButtonTypeSystem];
    begin2.frame=CGRectMake(210, 150, 100, 40);
    [begin2 setBackgroundColor:[UIColor grayColor]];
    [begin2 setTitle:@"切换键盘" forState:UIControlStateNormal];
    [begin2 setTitle:@"切换键盘" forState:UIControlStateHighlighted];
    [self addSubview:begin2];
    self.beginbutton2=begin2;
}
-(void)editValue:(UISlider*)sender
{
    tishi.text=[NSString stringWithFormat:@"每秒发送%d次",(int)sender.value];
    self.value=sender.value;
}
@end
