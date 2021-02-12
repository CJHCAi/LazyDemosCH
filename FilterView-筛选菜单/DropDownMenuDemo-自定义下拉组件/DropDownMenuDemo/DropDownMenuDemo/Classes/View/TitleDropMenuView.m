//
//  TitleDropMenuView.m
//  TextColorRamp
//
//  Created by admin on 2017/6/22.
//  Copyright © 2017年 王晓丹. All rights reserved.
/*  __VA_ARGS__ 是一个可变参数的宏，很少人知道这个宏，这个可变参数的宏是新的C99规范中新增的，目前似乎只有gcc支持（VC6.0的编译器不支持）。宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,否则会编译出错, 你可以试试。
 */

#import "TitleDropMenuView.h"
#import "PopDropdownMenuView.h"

#define ButtonTag   100
#define ImageTag    200
#define imageWith   12
#define buttonWith  self.frame.size.width/self.titleArray.count //没有图标的按钮宽度
#define DEFAULT_VOID_COLOR [UIColor blackColor]
#define YB_SAFE_BLOCK(BlockName, ...) ({ !BlockName ? nil : BlockName(__VA_ARGS__); })

@implementation TitleDropMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
    }
    return self;
}
#pragma mark - Custom Accessors

#pragma mark - Click Actions
- (void)titleButtonClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    for(int i =0; i<self.titleArray.count; i++) {
        UIButton *otherBtn = (UIButton *)[self viewWithTag:ButtonTag + i];
        if(btn.tag != ButtonTag + i){
            otherBtn.selected = NO;
        }
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(titleButtonClick:buttonSelect:)]) {
        [self.delegate titleButtonClick:btn.tag - 100 buttonSelect:btn.selected];
    }
}
#pragma mark - Public
+ (instancetype)TitleDropMenuViewInitWithFrame:(CGRect)frame otherSetting:(void (^)(TitleDropMenuView *titleMenuView))otherSetting{
    
    TitleDropMenuView *titleMenuView = [[TitleDropMenuView alloc]initWithFrame:frame];
    
    YB_SAFE_BLOCK(otherSetting,titleMenuView);
    
    [titleMenuView configerSubViews];
    
    return titleMenuView;
}
- (void)configerSubViews {
    for(int i = 0; i < self.titleArray.count; i ++) {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titleButton setTitle:[NSString stringWithFormat:@"%@",self.titleArray[i]] forState:UIControlStateNormal];
        titleButton.selected = NO;
        titleButton.tag = ButtonTag + i;
        [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleButton setTitleColor:[self colorFromHexRGB:self.titleColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[self colorFromHexRGB:self.titleSelectColor] forState:UIControlStateSelected];
        [titleButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        NSString *imageName;
        if(i< self.imageArray.count) {
           imageName = self.imageArray[i];
        }
        
        if(imageName.length != 0 && imageName != nil) {
            [titleButton setImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
            [titleButton setImage:[UIImage imageNamed:_imageSelectArray[i]] forState:UIControlStateSelected];
            CGSize buttonTitleSize = [self getSizeByText:titleButton.titleLabel.text textFont:[UIFont systemFontOfSize:12] textWidth:buttonWith-1];
            titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(40+buttonTitleSize.width));
            titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(buttonTitleSize.width), 0, 0);
            NSLog(@"(65  35)buttonTitleSize.width---%f",buttonTitleSize.width);
        }
        
        
        titleButton.frame = CGRectMake(buttonWith*i, 0, buttonWith-1, 50);
        [self addSubview:titleButton];
        
        UILabel *linLB = [[UILabel alloc]initWithFrame:CGRectMake(buttonWith*i - 2, (50-12)/2, 2, 12)];
        linLB.backgroundColor = [self colorFromHexRGB:@"#F5F5F5"];
        [self addSubview:linLB];
    }
}

#pragma mark - Private

#pragma mark - NSObject
/* 通过RGB色值设置颜色
 * inColorString         @“#9e9e9e”
 */
- (UIColor *) colorFromHexRGB:(NSString *) inColorString
{
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return DEFAULT_VOID_COLOR;
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return DEFAULT_VOID_COLOR;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
/* 根据字体获取lable宽高
 * text :  lable的text
 * textFont ： lable的textFont
 * textWidth ： lable的textWidth
 */
- (CGSize)getSizeByText:(NSString *)text textFont:(UIFont *)textFont textWidth:(long)textWidth{
    UIFont *font = textFont;//跟label的字体大小一样
    CGSize size = CGSizeMake(textWidth, 29999);//跟label的宽设置一样
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

@end
