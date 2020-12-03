//
//  testView.m
//  Test
//
//  Created by zhuyuelong on 2017/4/25.
//  Copyright © 2017年 zhuyuelong. All rights reserved.
//

#import "CLTextVerCodeView.h"

@implementation CLTextVerCodeView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        float red = arc4random() % 100 / 100.0;
        
        float green = arc4random() % 100 / 100.0;
        
        float blue = arc4random() % 100 / 100.0;
        
        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
        
        self.backgroundColor = color;
        
        [self createUI];
        
    }
    
    return self;

}

- (void)createUI{

    self.textArr = [NSMutableArray array];
    
    self.textArray = [NSMutableArray array];
    
    self.tapArr = [NSMutableArray array];
    
    self.textString = nil;
    
    // 默认随机生成5个不同汉字
    for (int i = 0; i < self.textTotal; i ++) {
        
        NSString *text = [self Written];
        
        BOOL is = YES;
        
        for (NSString *str in self.textArr) {
            
            if ([str isEqualToString:text]) {
                
                i = i - 1;
                
                is = NO;
                
                break;
                
            }
            
        }
        
        if (is) {
            
            [self.textArr addObject:text];
            
            [self.textArray addObject:text];
            
        }
        
    }
    
    self.textPoint = [NSMutableArray array];
    
    for (int i = 0; i < self.textArr.count; i ++) {
        
        int wh = [self getRandomNumber:20 to:self.frame.size.height  - 20];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake([self getRandomNumber:self.frame.size.width/self.textArr.count * i to:(self.frame.size.width/self.textArr.count - 5) * (i + 1)], [self getRandomNumber:5 to:self.frame.size.height - wh], wh, wh)];
        
        int font = [self getRandomNumber:17 to:wh - 3];
        
        label.font =  [UIFont fontWithName:[self fonStyle] size:font];
        
        label.adjustsFontSizeToFitWidth = YES;
        
        label.text = self.textArr[i];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        int pi = [self getRandomNumber:-180 to:180];
        
        label.transform = CGAffineTransformMakeRotation(M_PI/pi);
        
        [self addSubview:label];
        
        NSDictionary *dic = @{@"x":[NSString stringWithFormat:@"%.f",label.frame.origin.x],@"y":[NSString stringWithFormat:@"%.f",label.frame.origin.y]};
        
        [self.textPoint addObject:dic];
        
    }
    
    self.resultArray = [self randomArray];
    
    self.pointArr = [self resultPointArr];
    
    for (NSString *str in self.resultArray) {
        
        if (self.textString) {
            
            self.textString = [NSString stringWithFormat:@"%@ '%@'",self.textString,str];
            
        }else{
        
            self.textString = [NSString stringWithFormat:@"'%@'",str];;
            
        }
        
    }

}

// 范围生成随机数
- (int)getRandomNumber:(int)from to:(int)to{
    
    if (from < to) {
        
        return (int)(from + (arc4random() % (to - from + 1)));
        
    }else{
    
        return (int)(to + (arc4random() % (from - to + 1)));
    
    }
}

// 生成随机文字
- (NSString *)Written{

    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
    
    NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
    
    NSInteger number = (randomH<<8)+randomL;
    
    NSData *data = [NSData dataWithBytes:&number length:2];
    
    NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
    
    return string;

}

// 默认随机取3个汉字
- (NSArray *)randomArray
{
    //随机数产生结果
    NSMutableArray *resultArray=[[NSMutableArray alloc] initWithCapacity:0];
    //随机3个汉字
    for (int i = 0; i < self.textNum; i ++) {
        
        int t = arc4random()%self.textArr.count;
        
        resultArray[i] = self.textArr[t];
        
        self.textArr[t] = [self.textArr lastObject]; //为更好的乱序，故交换下位置
        
        [self.textArr removeLastObject];
        
    }
    
    return resultArray;
    
}

// 随机一个字体样式
- (NSString *)fonStyle{

    NSMutableArray *fontArr = [NSMutableArray arrayWithObjects:@"American Typewriter",@"AppleGothic",@"Arial",@"Arial Rounded MT Bold",@"Arial Unicode MS",@"Courier",@"Courier New",@"DB LCD Temp",@"Georgia",@"Helvetica",@"Helvetica Neue",@"Hiragino Kaku Gothic **** W3",@"Hiragino Kaku Gothic **** W6",@"Marker Felt",@"STHeiti J",@"STHeiti K",@"STHeiti SC",@"STHeiti TC",@"Times New Roman",@"Trebuchet MS",@"Verdana",@"Zapfino", nil];
    
    int t = arc4random()%fontArr.count;
    
    NSString *font = fontArr[t];
    
    return font;

}

- (NSArray *)resultPointArr{

    NSMutableArray *resultArr = [NSMutableArray array];
    
    for (NSString *str in self.resultArray) {
            
        for (int i = 0; i < self.textArray.count; i ++) {
            
            if ([self.textArray[i] isEqualToString:str]) {
                
                [resultArr addObject:self.textPoint[i]];
                
                break;
                
            }
            
        }
        
    }
    
    return resultArr;
    
}

// 视图点击事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (self.tapArr.count < self.textNum) {
        
        UITouch *touch = touches.anyObject;
        
        CGPoint touchLocation = [touch locationInView:self];
        
        self.view = [[UIView alloc] initWithFrame:CGRectMake(touchLocation.x - 5, touchLocation.y - 5, 10, 10)];
        
        [self addSubview:self.view];
        
        self.view.backgroundColor = self.viewColor;
        
        NSDictionary *dic = @{@"x":[NSString stringWithFormat:@"%.f",touchLocation.x],@"y":[NSString stringWithFormat:@"%.f",touchLocation.y]};
        
        [self.tapArr addObject:dic];
        
    }
    
    if (self.tapArr.count == self.textNum) {
        
        NSMutableArray *resultTapArr = [NSMutableArray array];
        
        for (int i = 0; i < self.tapArr.count; i ++) {
            
            NSDictionary *dicp = self.pointArr[i];
            
            NSDictionary *dict = self.tapArr[i];
            
            CGFloat x = [dicp[@"x"] floatValue];
            
            CGFloat y = [dicp[@"y"] floatValue];
            
            CGFloat tx = [dict[@"x"] floatValue];
            
            CGFloat ty = [dict[@"y"] floatValue];
            
            if (x <= tx && tx <= (x + 30) && y <= ty && ty <= (y + 30)) {
                
                [resultTapArr addObject:dict];
                
            }
            
        }
        
        if (resultTapArr.count == self.textNum) {
            
            if (self.successBlock) {
                
                self.successBlock(YES);
                
            }
            
        }else{
            
            if (self.successBlock) {
                
                self.successBlock(NO);
                
            }
        
        }
        
    }

}

- (void)change{

    NSArray *views = [self subviews];
    
    for (UIView *view in views) {
        
        [view removeFromSuperview];
        
    }
    
    [self createUI];
    
    [self setNeedsDisplay];

}

- (void)didmiss{

    [self removeFromSuperview];

}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    float red = arc4random() % 100 / 100.0;
    
    float green = arc4random() % 100 / 100.0;
    
    float blue = arc4random() % 100 / 100.0;
    
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
    
    self.backgroundColor = color;

    float pX, pY;

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    for(int i = 0; i < self.lineNum; i++){
        
        red = arc4random() % 100 / 100.0;
        
        green = arc4random() % 100 / 100.0;
        
        blue = arc4random() % 100 / 100.0;
        
        color = [UIColor colorWithRed:red green:green blue:blue alpha:0.2];
        
        CGContextSetStrokeColorWithColor(context, [color CGColor]);
        
        pX = arc4random() % (int)rect.size.width;
        
        pY = arc4random() % (int)rect.size.height;
        
        CGContextMoveToPoint(context, pX, pY);
        
        pX = arc4random() % (int)rect.size.width;
        
        pY = arc4random() % (int)rect.size.height;
        
        CGContextAddLineToPoint(context, pX, pY);
        
        CGContextStrokePath(context);
    }
}

- (NSInteger)lineNum{

    if (!_lineNum) {
        
        _lineNum = 20;
    
    }

    return _lineNum;
    
}

- (NSInteger)textNum{

    if (!_textNum) {
        
        _textNum = 3;
        
    }
    
    if (self.textTotal < _textNum) {
        
        _textNum = 3;
        
    }
    
    return _textNum;

}

- (NSInteger)textTotal{

    if (!_textTotal) {
        
        _textTotal = 5;
        
    }
    
    return _textTotal;

}

- (UIColor *)viewColor{

    if (!_viewColor) {
        
        _viewColor = [UIColor blueColor];
        
    }
    
    return _viewColor;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
