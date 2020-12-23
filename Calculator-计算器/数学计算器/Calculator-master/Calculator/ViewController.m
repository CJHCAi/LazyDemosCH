//
//  ViewController.m
//  Calculator
//
//  Created by liaosipei on 15/8/20.
//  Copyright (c) 2015年 liaosipei. All rights reserved.
//

#import "ViewController.h"
#import "CalculateMethod.h"
#import <math.h>

@interface ViewController (){
    long double currentNumber;
    CalculateMethod *calMethod;
    int totalDecimals;//总位数，规定计算位数最多16位
    BOOL isdecimal; //是否是小数
    int decimals;   //小数位数
    int op;
}
-(void)displayString:(NSString *)str withMethod:(NSString *)method;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *leadingSpace;

-(void)processDigit:(int)digit;
-(void)processOp:(int)theOp;
-(void)clear;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化各参数
    totalDecimals=0;
    isdecimal=NO;
    decimals=0;
    op=0;
    [self displayString:@"0" withMethod:@"cover"];
    calMethod=[[CalculateMethod alloc]init];
    self.additionalOptions.frame=CGRectMake(-396, 267, 396, 300);
    [self.view addSubview:self.additionalOptions];
    
    UILabel *paddingView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 267)];
    paddingView.backgroundColor=[UIColor clearColor];
    self.portraitDisplay.leftView=paddingView;
    self.portraitDisplay.leftViewMode=UITextFieldViewModeAlways;
    self.portraitDisplay.rightView=paddingView;
    self.portraitDisplay.rightViewMode=UITextFieldViewModeAlways;
    //给各个按钮加上点击事件
    for(UIButton *btn in self.allButtons)
    {
        [btn addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)clickButtons:(UIButton *)btn
{
    int digit=(int)btn.tag;
    if(digit==-1 && isdecimal==NO)   //若点击了小数点“.”
    {
        isdecimal=YES;
        [self displayString:@"." withMethod:@"add"];
    }
    else if(digit>=0 && digit<=9 && totalDecimals<=15)   //若点击了数字键
    {
        totalDecimals++;
        [self processDigit:digit];
            
    }else if(digit==10)
        [self clear];
    else if(digit>=11 && digit<=17)
    {
        [self processOp:digit];
    }

    
}

-(void)processDigit:(int)digit
{
    if(currentNumber==0 && isdecimal==NO)
        [self displayString:[NSString stringWithFormat:@"%i",digit] withMethod:@"cover"];
    else
        [self displayString:[NSString stringWithFormat:@"%i",digit] withMethod:@"add"];
    
    if(isdecimal==NO)
        if(currentNumber>=0)
            currentNumber=currentNumber*10+digit;
        else
            currentNumber=currentNumber*10-digit;
    else
    {
        decimals++;
        if(currentNumber>=0)
            currentNumber=currentNumber+digit*pow(10, (-1)*decimals);
        else
            currentNumber=currentNumber-digit*pow(10, (-1)*decimals);
    }
    NSLog(@"%.18Lf",currentNumber);
    
}

-(void)processOp:(int)theOp
{
    switch (theOp) {
        case 11:    //按下“+/-”
            if(currentNumber>=0)
            {
                NSMutableString *negative=[NSMutableString stringWithString:@"-"];
                [negative appendString:self.portraitDisplay.text];
                [self displayString:negative withMethod:@"cover"];
            }else
            {
                NSMutableString *positive=[NSMutableString stringWithString:self.portraitDisplay.text];
                [positive deleteCharactersInRange:NSMakeRange(0,1)];
                [self displayString:positive withMethod:@"cover"];
            }
            currentNumber=-currentNumber;
            break;
        case 12:    //按下“％”
            currentNumber=currentNumber*0.01;
            [self displayString:[NSString stringWithFormat:@"%Lg",currentNumber] withMethod:@"cover"];
            totalDecimals=(int)self.portraitDisplay.text.length-1;
            decimals=(int)self.portraitDisplay.text.length-(int)[self.portraitDisplay.text rangeOfString:@"."].location-1;
            if([self.portraitDisplay.text rangeOfString:@"."].length>0)
                isdecimal=YES;
            break;
        case 13:    //按下“÷”
        case 14:    //按下“×”
        case 15:    //按下“-”
        case 16:    //按下“+”
            totalDecimals=0;
            if(op==0)
            {
                op=theOp;
                calMethod.operand1=currentNumber;
                currentNumber=0;
            }else
            {
                calMethod.operand2=currentNumber;
                currentNumber=[calMethod performOperation:op];
                [self displayString:[NSString stringWithFormat:@"%Lg",currentNumber] withMethod:@"cover"];
                calMethod.operand1=calMethod.result;
                currentNumber=0;
                op=theOp;
            }
            break;
        case 17:    //按下“=”
            totalDecimals=0;
            calMethod.operand2=currentNumber;
            currentNumber=[calMethod performOperation:op];
            [self displayString:[NSString stringWithFormat:@"%Lg",currentNumber] withMethod:@"cover"];
            calMethod.operand1=calMethod.result;
            op=0;
            break;
        default:
            break;
    }
    //NSLog(@"%.18Lf",currentNumber);
}

-(void)clear
{
    op=0;
    currentNumber=0;
    totalDecimals=0;
    isdecimal=NO;
    decimals=0;
    [self displayString:@"0" withMethod:@"cover"];
}

-(void)displayString:(NSString *)str withMethod:(NSString *)method
{
    NSMutableString *displayString=[NSMutableString stringWithString:self.portraitDisplay.text];
    if([method isEqualToString:@"cover"])   //覆盖
        displayString=[NSMutableString stringWithString:str];
    else if([method isEqualToString:@"add"])    //追加
        [displayString appendString:str];
    else
        NSLog(@"Error: 不存在此方法！");
    self.portraitDisplay.text=displayString;
}

#pragma mark - 横屏处理

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    if(orientation==UIDeviceOrientationPortrait)    //竖屏
    {
        for (NSLayoutConstraint* temp in self.leadingSpace) {
            temp.constant = 0;
        }
        self.height.constant = 267;
        
        [UIView beginAnimations:@"position1" context:nil];
        [UIView setAnimationDuration:0.3];
        self.additionalOptions.frame=CGRectMake(-396, 267, 396, 300);
        [UIView commitAnimations];
    }
    if (orientation==UIDeviceOrientationLandscapeLeft || orientation==UIDeviceOrientationLandscapeRight)//横屏
    {
        for (NSLayoutConstraint* temp in self.leadingSpace) {
            temp.constant = 396;
        }
        self.height.constant = 75;
        
        [UIView beginAnimations:@"position2" context:nil];
        [UIView setAnimationDuration:0.3];
        self.additionalOptions.frame=CGRectMake(0, 75, 396, 300);
        [UIView commitAnimations];
    }
}

@end

