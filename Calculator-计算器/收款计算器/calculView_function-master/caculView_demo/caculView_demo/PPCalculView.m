//
//  PPCalculView.m
//  amezMall_New
//
//  Created by Liao PanPan on 2017/4/24.
//  Copyright © 2017年 Liao PanPan. All rights reserved.
//

#import "PPCalculView.h"
#import "UIView+PPAddition.h"
#define lineWidth 0.5
#define kNorMoneyLabelStr @"应收金额: ￥0.00"
#define WPHexColorA(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:(a)]


#define WPHexColor(hex) WPHexColorA(hex,1.0f)
// 色值
#define WPRGBColorA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define WPRGBColor(r,g,b) WPRGBColorA(r,g,b,1.0f)

@interface PPCalculView ()
{
    
    
    NSMutableString *historyStr;   //顶部历史记录数字
    
    NSMutableString *_calculateShowPattern;
    
    NSMutableArray  *_operators;
     BOOL _flag;
     BOOL _error;

    UIView *_container;
    int n;
    
    UILabel *moneyLabel;   //应收金额
}

@property (strong, nonatomic) UILabel *historyLabel;

@property (strong, nonatomic) UILabel *calculatePanel;

@property(nonatomic,copy)getMoneyBlock block;


@end


@implementation PPCalculView

-(void)getMoneyClick:(getMoneyBlock)block
{
    self.block=block;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _flag = YES;
        _error = NO;

       
//        _calculatePanel.adjustsLetterSpacingToFitWidth = YES;
        
        historyStr=@"".mutableCopy;
        _calculateShowPattern=@"".mutableCopy;
        
        
        
        
        [self configUI];
        _operators = [NSMutableArray array];
    
    }
    return self;
}


- (IBAction)calculate:(UIButton *)sender {
    
    UIButton *btn=(UIButton *)sender;
    
    NSArray *firstArr=@[@"00",@"+",@".",@"←"];  //首字母输入要忽略的字符
    
    NSArray *LastArr=@[@"+",@"."];  //不能连续输入的字符
    
    NSArray *zeroArr=@[@"+",@"←"];  // 在.00之后可以点击的字符
    
    if (historyStr.length>=3) {
        //x.00 之后不能再输入数字
        NSString *dot=[historyStr substringWithRange:NSMakeRange(historyStr.length-3, 1)];
        
        if ([dot isEqualToString:@"."]&&![zeroArr containsObject:btn.titleLabel.text]&&![[historyStr substringWithRange:NSMakeRange(historyStr.length-1, 1)] isEqualToString:@"+"]) {
            
            return;
        }
        
        NSLog(@"------%@",dot);
    }
    
    
    if (historyStr.length>=2) {
        NSString *dot=[historyStr substringWithRange:NSMakeRange(historyStr.length-2, 1)];
        if ([dot isEqualToString:@"."]&&[btn.titleLabel.text isEqualToString:@"00"]) {
            return;
        }
        
    }
    
    
    if (historyStr.length==0) {
        //首字符
        if([firstArr containsObject:btn.titleLabel.text]){
            return;
        }
        
    }else{
        
        if ([LastArr containsObject:[historyStr substringFromIndex:historyStr.length-1]]) {
            
            if ([LastArr containsObject:btn.titleLabel.text]) {
                
                return;
            }
            
        }
        
        
    }
    
    if ([btn.titleLabel.text isEqualToString:@"收款"]) {
        //处理收款按钮事件
        if (self.block) {
            
            self.block(_calculatePanel.text.floatValue);
            
        }
        return;
        
    }
    
    if ([btn.titleLabel.text isEqualToString:@"0"]) {
        //
        NSString *zeroStr=[historyStr substringFromIndex:0];
        
        if ([zeroStr isEqual:@"0"]) {
            
            return;
        }
        
        
    }
    
    
    //处理清除按钮事件
    if ([btn.titleLabel.text isEqualToString:@"←"]) {
        
        if (historyStr.length>0) {
            
            //清除原来的数字，重新输入
            NSRange deleteRange = { [historyStr length] - 1, 1 };
            [historyStr deleteCharactersInRange:deleteRange];
            
            _historyLabel.text=historyStr;
            
            NSString *result=[self calculatePattern:[self scanPattern:historyStr]];
            
            _calculatePanel.text=[NSString stringWithFormat:@"%.2f",[result floatValue]];
            moneyLabel.text=[NSString stringWithFormat:@"应收金额: ￥%.2f",[result floatValue]];
            
            if (historyStr.length==0) {
                _historyLabel.text =@"";
            }
            
        }else
        {
            //在为0的时候继续按清除键
            
            _historyLabel.text =@"";
            _calculatePanel.text=@"0.00";
            moneyLabel.text=kNorMoneyLabelStr;
            
        }
        
        return;
    }
    
    
    
    if ([btn.titleLabel.text isEqualToString:@"."]&&[historyStr containsString:@"."]) {
        //不能出现俩个.
        return;
    }
    
    
    NSMutableString *totalMon=historyStr.mutableCopy;
    [totalMon appendString:btn.titleLabel.text];
    if (totalMon.floatValue>300000) {
        
        NSLog(@"最高金额不能超过30w");
        return;
    }
    
    //    NSString *moneyStr=[NSString stringWithFormat:@"%.2f",sender.titleLabel.text.floatValue];
    
    [historyStr appendString:sender.titleLabel.text];
    _historyLabel.text=[historyStr copy];
    
    NSString *result=[self calculatePattern:[self scanPattern:historyStr]];
    
    
    _calculatePanel.text=[NSString stringWithFormat:@"%.2f",[result floatValue]];
    moneyLabel.text=[NSString stringWithFormat:@"应收金额: ￥%.2f",[result floatValue]];
    
    
}


-(NSArray *)scanPattern:(NSString *)pattern {
    NSUInteger header = 0;
    NSMutableString *middleData = [NSMutableString stringWithFormat:@""];
    NSMutableArray *middleArray = [NSMutableArray array];
    
    for (; header < pattern.length; header++) {
        unichar letter = [pattern characterAtIndex:header];
//        NSLog(@"%d", letter);
        if ((letter >= 48 && letter <= 57) || letter == 46) {
            char ch = (char)letter;
            [middleData appendFormat:@"%c", ch];
        }else {
            if ([middleData length] <= 0) {
                _error = YES;
                break;
            }
            [middleArray addObject:[middleData copy]];
            char ch = (char)letter;
            NSString *character = [NSString stringWithFormat:@"%c", ch];
            
            BOOL isHighLevel = (ch == '/' || ch == '*' || ch == '%');
            
            if([_operators count] == 0) {
                [_operators addObject:character];
            } else if(isHighLevel && ([[_operators lastObject] isEqualToString:@"+"] || [[_operators lastObject] isEqualToString:@"-"])) {
                [_operators addObject:character];
            }else {
                [middleData appendString:[_operators lastObject]];
                [middleArray addObject:[_operators lastObject]];
                [_operators removeLastObject];
                [_operators addObject:character];
            }
            NSRange range = NSMakeRange(0, [middleData length]);
            [middleData deleteCharactersInRange:range];
        }
    }
    [middleArray addObject:[middleData copy]];
    
    while ([_operators count]) {
        [middleArray addObject:[_operators lastObject]];
        [_operators removeLastObject];
    }
    return [middleArray copy];
}

-(void)setLabelColor
{
    NSMutableAttributedString *str= [[NSMutableAttributedString alloc]initWithString:moneyLabel.text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,5)];
    
}


- (NSString *)calculatePattern:(NSArray *)pattern {
    
    //    Stack<Double> intStack = new Stack<Double>();
    NSMutableArray *intStack = [NSMutableArray array];
    double result=0;
    
    for (int i = 0; i < [pattern count]; i++) {
        NSString *letter = pattern[i];
//        NSLog(@"%@", letter);
        NSString *string = [letter stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
        
        if (string.length == 0 || [string containsString:@"."]) {
            NSNumber *number = [NSNumber numberWithDouble:[letter doubleValue]];
            [intStack addObject:number];
        } else {
            NSNumber *topNum = [intStack lastObject];
            [intStack removeLastObject];
            
            NSNumber *secondNum = [intStack lastObject];
            [intStack removeLastObject];
            
            double top = [topNum doubleValue];
            double second = [secondNum doubleValue];
            
            switch([pattern[i] characterAtIndex:0])
            {
                case '*':
                    result = top * second;
                    break;
                case '/':
                    result = second / top;
                    break;
                case '+':
                    result = top + second;
                    break;
                case '-':
                    result = second - top;
                    break;
            }
            [intStack addObject:[NSNumber numberWithDouble:result]];
        }
    }
    NSNumber *finalResult = [intStack lastObject];
    [intStack removeLastObject];
    
    return [NSString stringWithFormat:@"%@", finalResult];
}

-(void)configUI
{
    NSArray *titleArray = @[@"7",@"8",@"9",@"←",@"4",@"5",@"6",@"+",@"1",@"2",@"3",@" ",@"00",@"0",@".",@"收款"];

    
    
    float buttonHeight = 65; //获取每个button的高度
    float buttonWidth = self.PP_width/4; //获取每个Button的宽度
    
    float btnConHeight=4*buttonHeight;
    
    
    UIView *topV=[UIView new];
    topV.backgroundColor=[UIColor grayColor];
    topV.frame=CGRectMake(0, 0, self.PP_width,self.PP_height-btnConHeight);
    [self addSubview:topV];
    
    _calculatePanel = [[UILabel alloc]initWithFrame:CGRectMake(0,100, self.PP_width,30)];
    _calculatePanel.PP_centerY=(self.PP_height-btnConHeight-64-20);
    _calculatePanel.backgroundColor = [UIColor clearColor];
    _calculatePanel.text = @"0.00";
    [_calculatePanel setTextColor:[UIColor blackColor]];
    _calculatePanel.textAlignment = NSTextAlignmentRight;
    _calculatePanel.font = [UIFont systemFontOfSize:30];
    _calculatePanel.numberOfLines=0;
    [topV addSubview:_calculatePanel];
    

    _historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,50, self.PP_width-30,100)];
//    _historyLabel.textInsets=UIEdgeInsetsMake(0, 10, 0, 10);
    _historyLabel.backgroundColor=[UIColor clearColor];
    _historyLabel.text = @"";
    _historyLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _historyLabel.numberOfLines=0;
    [_historyLabel setTextColor:[UIColor blackColor]];
    _historyLabel.textAlignment = NSTextAlignmentRight;
    _historyLabel.font = [UIFont systemFontOfSize:20];
    [topV addSubview:_historyLabel];

  
    moneyLabel=[UILabel new];
    moneyLabel.text=kNorMoneyLabelStr;
    moneyLabel.font=[UIFont systemFontOfSize:15];
    moneyLabel.textColor=[UIColor blackColor];
    moneyLabel.frame=CGRectMake(0, topV.PP_bottom-20, self.PP_width, 20);
    moneyLabel.textAlignment=NSTextAlignmentRight;
    moneyLabel.backgroundColor=[UIColor whiteColor];

    moneyLabel.text=kNorMoneyLabelStr;
//    [moneyLabel colorTextWithColor:Door_Global_title range:NSMakeRange(0, 2)];

    [topV addSubview:moneyLabel];
    
    _container = [[UIView alloc]initWithFrame:CGRectMake(0,topV.PP_bottom,self.PP_width ,btnConHeight)];
    [self addSubview:_container];
    
    float containerWidth = CGRectGetWidth(_container.frame);
    float containerHeight = CGRectGetHeight(_container.frame);
    
    
  

    for (int i=0; i<4; i++) {
        
        for (int j=0; j<4; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(j*(containerWidth/4), i*(containerHeight/4), buttonWidth, buttonHeight);
            [button addTarget:self action:@selector(calculate:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *title = titleArray[n++];
            
            
            button.tag = [title intValue];
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:title forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:25];
            
            if (j == 3) {
                
                if (i==2) {
                    button.frame=CGRectZero;
                }
                if (i==3) {
                    
                    button.frame = CGRectMake(j*(containerWidth/4), 2*(containerHeight/4), buttonWidth, buttonHeight*2);
                    button.backgroundColor = [UIColor blackColor];
                    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:25];
                }
                
                
            }
            [_container addSubview:button];
        }
        
    }
    
    //添加横线
    for (int i=0; i<5; i++) {
        
        float lineW=i==3?containerWidth-buttonWidth:containerWidth;
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, i*buttonHeight, lineW, lineWidth)];
        lable.backgroundColor = WPRGBColor(229, 229, 229);
        [_container addSubview:lable];
        
        
    }
    //添加竖线
    for (int i=0; i<4; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(i*buttonWidth, 0, lineWidth, containerHeight);
        label.backgroundColor = WPRGBColor(229, 229, 229);
        [_container addSubview:label];
    }
}




@end
