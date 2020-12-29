//
//  CBSegmentView.m
//  CBSegment
//
//  Created by 陈彬 on 2017/9/9.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import "CBSegmentView.h"
#import "UIButton+LXMImagePosition.h"
@interface CBSegmentView ()<UIScrollViewDelegate>
/**
 *  configuration.
 */
{
    CGFloat _HeaderH;
    UIColor *_titleColor;
    UIColor *_titleSelectedColor;
    CBSegmentStyle _SegmentStyle;
    CGFloat _titleFont;
}
/**
 *  The bottom red slider.
 */
@property (nonatomic, weak) UIView *slider;

@property (nonatomic, strong) NSMutableArray *titleWidthArray;

@property (nonatomic, weak) UIButton *selectedBtn;

@end

#define CBColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define CBScreenH [UIScreen mainScreen].bounds.size.height
#define CBScreenW [UIScreen mainScreen].bounds.size.width
@implementation CBSegmentView

#pragma mark - delayLoading
- (NSMutableArray *)titleWidthArray {
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray new];
    }
    return _titleWidthArray;
}

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
//        self.layer.borderColor = CBColorA(204, 204, 204, 1).CGColor;
//        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor whiteColor];
        
        _HeaderH = frame.size.height;
        _SegmentStyle = CBSegmentStyleSlider;
        _titleColor = [UIColor darkTextColor];
        _titleSelectedColor = keyColor;
        _titleSelectedColor =[UIColor colorFromHexString:@"333333"];
        _titleFont = 15;
    }
    return self;
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    [self setTitleArray:titleArray withStyle:0];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray withStyle:(CBSegmentStyle)style {
    [self setTitleArray:titleArray titleFont:0 titleColor:nil titleSelectedColor:nil withStyle:style];
}

- (BOOL)isBeyondBoundsWithTitleArray:(NSArray<NSString *> *)titleArray {
    CGFloat subLength = 0;
    for (NSInteger i = 0; i<titleArray.count; i++) {
        //        cache title width
        CGFloat titleWidth = [self widthOfTitle:titleArray[i] titleFont:_titleFont];
        CGFloat btnW = titleWidth+20;
        subLength += btnW;
    }
    return subLength > kScreenWidth;
}


-(void)setTitleArray:(NSArray<NSString *> *)titleArray
           titleFont:(CGFloat)font
          titleColor:(UIColor *)titleColor
  titleSelectedColor:(UIColor *)selectedColor
           withStyle:(CBSegmentStyle)style andHasHongbao:(BOOL)hasH {

    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    
    //    set style
    if (style != 0) {
        _SegmentStyle = style;
    }
    if (font != 0) {
        _titleFont = font;
    }
    if (titleColor) {
        _titleColor = titleColor;
    }
    if (selectedColor) {
        _titleSelectedColor = selectedColor;
    }
    
    if (style == CBSegmentStyleSlider) {
        UIView *slider = [[UIView alloc]init];
        slider.frame = CGRectMake(0, _HeaderH-2, 0, 2);
        slider.backgroundColor = keyColor;
        [self addSubview:slider];
        self.slider = slider;
    }
    
    [self.titleWidthArray removeAllObjects];
    
    BOOL isBeyondScreen = [self isBeyondBoundsWithTitleArray:titleArray];
    
    CGFloat totalWidth ;
    CGFloat btnSpace;
    if (hasH) {
        btnSpace = 5;
        totalWidth =10;
        self.scrollEnabled = NO;
    }else {
         btnSpace  = 15;
        totalWidth =15;
    }
    if (!isBeyondScreen) {
        totalWidth = 0;
        btnSpace = 0;
    }
    for (NSInteger i = 0; i<titleArray.count; i++) {
        //        cache title width
        CGFloat titleWidth = [self widthOfTitle:titleArray[i] titleFont:_titleFont];
        [self.titleWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
        //        creat button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        CGFloat btnW = titleWidth+10;
        if (!isBeyondScreen) {
           // btnW = kScreenWidth/titleArray.count;
            btnW =titleWidth+10;
        }
        btn.frame =  CGRectMake(totalWidth, 0.5, btnW, _HeaderH-0.5-2);
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:_titleFont]];
        [btn addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        totalWidth = totalWidth+btnW+btnSpace;
        
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            if (_SegmentStyle == CBSegmentStyleSlider) {
                self.slider.cb_Width = titleWidth;
                self.slider.cb_CenterX = btn.cb_CenterX;
                if (hasH) {
                    [btn setImage:[UIImage imageNamed:@"lk_hb"] forState:UIControlStateNormal];
                    [btn setImagePosition:1 spacing:4];
                }
            }else if (_SegmentStyle == CBSegmentStyleZoom) {
                self.selectedBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }
        }
    }
    totalWidth = totalWidth+btnSpace;
    self.contentSize = CGSizeMake(totalWidth, 0);
    if (!isBeyondScreen) {
        self.contentSize = CGSizeMake(kScreenWidth, 0);
    }
}
- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor
            withStyle:(CBSegmentStyle)style {
    
    for (UIView *v in [self subviews]) {
        [v removeFromSuperview];
    }
    
//    set style
    if (style != 0) {
        _SegmentStyle = style;
    }
    if (font != 0) {
        _titleFont = font;
    }
    if (titleColor) {
        _titleColor = titleColor;
    }
    if (selectedColor) {
        _titleSelectedColor = selectedColor;
    }
    
    if (style == CBSegmentStyleSlider) {
        UIView *slider = [[UIView alloc]init];
        slider.frame = CGRectMake(0, _HeaderH-2, 0, 2);
        slider.backgroundColor = _titleSelectedColor;
        [self addSubview:slider];
        self.slider = slider;
    }
    
    [self.titleWidthArray removeAllObjects];
    
    BOOL isBeyondScreen = [self isBeyondBoundsWithTitleArray:titleArray];
    
    CGFloat totalWidth = 15;
    CGFloat btnSpace = 15;
    if (!isBeyondScreen) {
        totalWidth = 0;
        btnSpace = 0;
    }
    for (NSInteger i = 0; i<titleArray.count; i++) {
//        cache title width
        CGFloat titleWidth = [self widthOfTitle:titleArray[i] titleFont:_titleFont];
        [self.titleWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
//        creat button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        [self addSubview:btn];
        CGFloat btnW = titleWidth+20;
        if (!isBeyondScreen) {
            btnW = kScreenWidth/titleArray.count;
        }
         btn.frame =  CGRectMake(totalWidth, 0.5, btnW, _HeaderH-0.5-2);
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectedColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:_titleFont]];
        [btn addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        totalWidth = totalWidth+btnW+btnSpace;

        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            if (_SegmentStyle == CBSegmentStyleSlider) {
                self.slider.cb_Width = titleWidth;
                self.slider.cb_CenterX = btn.cb_CenterX;
            }else if (_SegmentStyle == CBSegmentStyleZoom) {
                self.selectedBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            }
        }
    }
    totalWidth = totalWidth+btnSpace;
    self.contentSize = CGSizeMake(totalWidth, 0);
    if (!isBeyondScreen) {
        self.contentSize = CGSizeMake(kScreenWidth, 0);
    }
}

//  button click
- (void)titleButtonSelected:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    if (_SegmentStyle == CBSegmentStyleSlider) {
        NSNumber* sliderWidth = self.titleWidthArray[btn.tag];
        [UIView animateWithDuration:0.2 animations:^{
            self.slider.cb_Width = sliderWidth.floatValue;
            self.slider.cb_CenterX = btn.cb_CenterX;
        }];
    }else if (_SegmentStyle == CBSegmentStyleZoom) {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedBtn.transform = CGAffineTransformIdentity;
            btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            
        }];
    }
    self.selectedBtn = btn;
    CGFloat offsetX = btn.cb_CenterX - self.frame.size.width*0.5;
    if (offsetX<0) {
        offsetX = 0;
    }
    if (offsetX>self.contentSize.width-self.frame.size.width) {
        offsetX = self.contentSize.width-self.frame.size.width;
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    if (self.titleChooseReturn) {
        self.titleChooseReturn(btn.tag);
    }
}
//  cache title width
- (CGFloat)widthOfTitle:(NSString *)title titleFont:(CGFloat)titleFont {
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, _HeaderH-2)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName]
                                            context:nil].size;
    return titleSize.width;
}

@end

@implementation UIView (CBViewFrame)

- (void)setCb_Width:(CGFloat)cb_Width {
    CGRect frame = self.frame;
    frame.size.width = cb_Width;
    self.frame = frame;
}

- (CGFloat)cb_Width {
    return self.frame.size.width;
}

- (void)setCb_Height:(CGFloat)cb_Height {
    CGRect frame = self.frame;
    frame.size.height = cb_Height;
    self.frame = frame;
}

- (CGFloat)cb_Height {
    return self.frame.size.height;
}

- (void)setCb_CenterX:(CGFloat)cb_CenterX {
    CGPoint center = self.center;
    center.x = cb_CenterX;
    self.center = center;
}

- (CGFloat)cb_CenterX {
    return self.center.x;
}

- (void)setCb_CenterY:(CGFloat)cb_CenterY {
    CGPoint center = self.center;
    center.y = cb_CenterY;
    self.center = center;
}

- (CGFloat)cb_CenterY {
    return self.center.y;
}
@end
