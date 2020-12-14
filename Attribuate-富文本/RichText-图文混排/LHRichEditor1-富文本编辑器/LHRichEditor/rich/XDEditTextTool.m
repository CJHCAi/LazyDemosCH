//
//  XDEditTextTool.m
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/18.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "XDEditTextTool.h"
#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

# define kBarBtnW  kAppFrameWidth/6.0
static NSInteger const kAttributesBtnTag = 100;
@interface XDEditTextTool()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_dataArr;
    NSInteger _num;
}

@property (nonatomic ,strong) UIView *attributesView;
@property (nonatomic ,strong) UIView *colorView;
@end

@implementation XDEditTextTool
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setUI];
        [self attributesUIconfig];
        [self colorViewUIconfig];
    }
    return self;
}

- (void)initData{
  
    _dataArr = @[UIColorFromRGB(0x333333),UIColorFromRGB(0x6a6a6a),UIColorFromRGB(0xC6C6C6),UIColorFromRGB(0x49BAF2),UIColorFromRGB(0x00CCBB),UIColorFromRGB(0xB19693),UIColorFromRGB(0xB28FCE),UIColorFromRGB(0x8695B2),UIColorFromRGB(0xFF9B9B),UIColorFromRGB(0xFF66A6),UIColorFromRGB(0xFFAA00),UIColorFromRGB(0xD93448)];
    _num = -1;
}

- (void)setUI{
       [self createBarBtn];
}

- (void) createBarBtn {
    
    
    NSArray *images = @[@"图", @"字", @"色",@"撤", @"复", @"键盘"];
    for (NSInteger i = 0; i < images.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.tag = i +1;
        btn.frame = CGRectMake(kBarBtnW * i, 0, kBarBtnW, (43));
        btn.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
        btn.selected = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:images[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void)colorViewUIconfig{
    CGFloat btnWH = 40;
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWH * _dataArr.count/2 +15, 95)];
    [self addSubview:_colorView];
    _colorView.backgroundColor = [UIColor blackColor];
    _colorView.layer.borderColor = [UIColor blackColor].CGColor;
    _colorView.layer.cornerRadius = 8;
    _colorView.hidden = YES;
    _colorView.center = CGPointMake(kBarBtnW*8/2.0, -20);
    CGFloat sub = (kBarBtnW*7/2.0 + btnWH*_dataArr.count/2.0)-(kAppFrameWidth -10);
    sub =1;
    if (sub > 0) {
        _colorView.center = CGPointMake(kBarBtnW*5/2.0, -(40));
        [self createAngelwithSuperView:_colorView
                            angelPoint:CGPointMake(_colorView.frame.size.width/2.0 , 105)];
        
    }else{
        [self createAngelwithSuperView:_colorView
                            angelPoint:CGPointMake(_colorView.frame.size.width/2.0, 90)];
    }
    
    for (NSInteger i = 0; i < _dataArr.count; i ++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_colorView addSubview:btn];
                btn.backgroundColor = _dataArr[i];
                btn.tag = 200 + i;
                NSInteger row = i / 6;
                NSInteger col = i %6;
                btn.frame = CGRectMake(15 + btnWH * col, 15 +btnWH *row, 25, 25);
                btn.selected = NO;
                [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
                [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickColer:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [self clickColer:btn];
        }
        
    }

}


- (void)attributesUIconfig {
    
    CGFloat btnWH = 40;
    NSArray *items = @[@"粗", @"斜", @"下", @"H1", @"H2", @"H3"];
    _attributesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWH * items.count, btnWH)];
    [self addSubview:_attributesView];
    _attributesView.backgroundColor = [UIColor blackColor];
    _attributesView.layer.cornerRadius = 8;
    _attributesView.hidden = YES;
    _attributesView.center = CGPointMake(kBarBtnW*7/2.0, -20);
    
    CGFloat sub = (kBarBtnW*7/2.0 + btnWH*items.count/2.0)-(kAppFrameWidth -10);
    sub =1;
    if (sub > 0) {
        _attributesView.center = CGPointMake(kBarBtnW*3/2.0 + 30, -20);
        [self createAngelwithSuperView:_attributesView
                            angelPoint:CGPointMake(_attributesView.frame.size.width/2.0 -30, 50)];
        
    }else{
        [self createAngelwithSuperView:_attributesView
                            angelPoint:CGPointMake(_attributesView.frame.size.width/2.0, 50)];
    }
    
    for (NSInteger i = 0; i < items.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attributesView addSubview:btn];
        
        btn.backgroundColor = [UIColor blackColor];
        btn.tag = kAttributesBtnTag + i;
        btn.frame = CGRectMake(btnWH * i, 0, btnWH, btnWH);
        btn.selected = NO;
        btn.layer.cornerRadius = 8;
        btn.clipsToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
            [btn setTitle:items[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected ];
        
       
         [btn addTarget:self action:@selector(attributesChoose:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 3) {
            btn.selected = YES;
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
    }
}

- (void)clickColer:(UIButton *)btn{
    
    UIButton *btn1 = (UIButton *)[self viewWithTag:_num];
    if (_num != 0){
        btn1.selected = NO;
    }
    _num = btn.tag;
    btn.selected = YES;

    if (_changeTextColerBlock) {
        _changeTextColerBlock(_dataArr[btn.tag - 200]);
    }
    
}



- (void)attributesChoose:(UIButton *)sender {
    
    NSInteger index = sender.tag - kAttributesBtnTag;
    
    switch (index) {
        case 0:
        {
            [self changToBoldAction:sender];// 加粗
        }
            break;
        case 1:
        {
            [self changToObliqueAction:sender];// 斜体
        }
            break;

        case 2:
        {
            [self changToUnderLineAction:sender];// 下划线
        }
            break;
        case 3:
        {
            [self chooseFontAction:sender];// 大
        }
            break;
        case 4:
        {
            [self chooseFontAction:sender];// 中
        }
            break;
        case 5:
        {
            [self chooseFontAction:sender];// 小
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark Block
- (void)chooseFontAction:(UIButton *)sender{
    
    for (NSInteger i = 3; i <=5; i ++) {
        UIButton *btn = (UIButton *)[self viewWithTag:kAttributesBtnTag + i];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.selected = NO;
    }
    
    sender.selected = YES;
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    NSInteger index = sender.tag - kAttributesBtnTag;
    CGFloat font = (15);
    
    switch (index) {
        case 3:
        {
            font = (15);
        }
            break;
        case 4:
        {
            font = (13);
        }
            break;
        case 5:
        {
            font = (11);
        }
            break;
            
        default:
            break;
    }
    
    if (_textFontBlock) {
        _textFontBlock(font);
    }
    
}

- (void)changToUnderLineAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        UIImage *image = [self changeImage:sender.imageView.image withColor:[UIColor orangeColor]];
        [sender setImage:image forState:UIControlStateNormal];
    }else{
        UIImage *image = [self changeImage:sender.imageView.image withColor:[UIColor whiteColor]];
        [sender setImage:image forState:UIControlStateNormal];
    }
    
    if (_changeToUnderLineBlock) {
        _changeToUnderLineBlock(sender.selected);
    }
    
}

- (void)changToObliqueAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        UIImage *image = [self changeImage:sender.imageView.image withColor:[UIColor orangeColor]];
        [sender setImage:image forState:UIControlStateNormal];
    }else{
        UIImage *image = [self changeImage:sender.imageView.image withColor:[UIColor whiteColor]];
        [sender setImage:image forState:UIControlStateNormal];
    }
    
    if (_changeToObliqueBlock) {
        _changeToObliqueBlock(sender.selected);
    }
}
- (void)changToBoldAction:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        UIImage *image = [self changeImage:sender.imageView.image withColor:[UIColor orangeColor]];
        [sender setImage:image forState:UIControlStateNormal];
    }else{
        UIImage *image = [self changeImage:sender.imageView.image withColor:[UIColor whiteColor]];
        [sender setImage:image forState:UIControlStateNormal];
    }
    
    if (_changeToBoldBlock) {
        _changeToBoldBlock(sender.selected);
    }
}

- (UIImage *)changeImage:(UIImage *)image withColor:(UIColor *)color {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
    
}

#pragma mark 响应超出self范围的event事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    NSLog(@"%f",point.x);
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            @autoreleasepool {
                CGPoint p = [subView convertPoint:point fromView:self];
                if (CGRectContainsPoint(subView.bounds, p) && subView.hidden == NO) {
                    for (UIView *sub in subView.subviews) {
                        @autoreleasepool {
                            
                            CGPoint q = [sub convertPoint:p fromView:subView];
                            
                            if (CGRectContainsPoint(sub.bounds, q)) {

                             //   NSLog(@"%@",sub.gestureRecognizers);
                                
                                
//                                if ([sub isKindOfClass:[UIScrollView class]]) {
//                                    for (UIView *colerSub in sub.subviews) {
//
//                                        @autoreleasepool {
//
//                                            CGPoint j = [colerSub convertPoint:q fromView:sub];
//
//                                            if (CGRectContainsPoint(colerSub.bounds, j)) {
//
//                                                view = colerSub;
//                                                break;
//
//                                            }
//                                        }
//
//                                    }
                                
                          //      }else{
                                    view = sub;
                                    break;
                           //     }
                                
                              
                                
                              
                                
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    return view;
}


#pragma mark -AngelLayer
- (void)createAngelwithSuperView:(UIView *)superView angelPoint:(CGPoint)point {
    
    CGPoint pointA = point;
    CGPoint pointB = CGPointMake(point.x-10, point.y - 10);
    CGPoint pointC = CGPointMake(point.x+10, point.y - 10);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor blackColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    
    // BC
    [path addLineToPoint:pointC];
    
    // CA
    [path addLineToPoint:pointA];
    
    layer.path = path.CGPath;
    
    [superView.layer addSublayer:layer];
    
}


- (void)barButtonAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            [self addImageAction];
        }
            break;
        case 2://字体样式不知
        {
            btn.selected = !btn.selected;
            _attributesView.hidden = !btn.selected;

            UIButton *btn2 = [self viewWithTag:3];
            if (btn2.selected == YES) {
                btn2.selected = !btn.selected;
                _colorView.hidden = !btn2.selected;
            }

        }
            break;
        case 3://字体样式不知
        {
            btn.selected = !btn.selected;
            _colorView.hidden = !btn.selected;
            UIButton *btn2 = [self viewWithTag:2];
            if (btn2.selected == YES) {
                btn2.selected = !btn.selected;
                _attributesView.hidden = !btn2.selected;
            }
        }
            break;
        case 4:
        {
            // 撤销
            [self undo];
          
        }
            break;
        case 5:
        {
            
            // 恢复
            [self restore];
            
  
        }
            break;
        case 6://打开取消键盘
        {
            btn.selected =!btn.selected;
            [self heidenKey:btn.selected];
        }
            break;
        default:
            break;
    }
    
    if (btn.tag != 2 && btn.tag != 3) {
        UIButton *btn1 = [self viewWithTag:2];
        btn1.selected = NO;
        _attributesView.hidden = YES;
        UIButton *btn2 = [self viewWithTag:3];
        btn2.selected = NO;
        _colorView.hidden = YES;
    }
    
    
    
}


- (void)addImageAction{
    
    if (_addImageBlock) {
        _addImageBlock();
    }
}

- (void)heidenKey:(BOOL)selected{
    if (_changekeyboardBlock) {
        _changekeyboardBlock(selected);
    }
}


- (void)undo{
    if (_undoBlock) {
        _undoBlock();
    }
}

- (void)restore{
    if (_restoreBlock) {
        _restoreBlock();
    }
}

- (void)setIsEdit:(BOOL)isEdit{
    _isEdit = isEdit;
    if (_isEdit) {
        UIButton *btn = [self viewWithTag:6];
        btn.selected = YES;
    }
}

- (void)hiddenView{
    UIButton *btn1 = [self viewWithTag:2];
    btn1.selected = NO;
    _attributesView.hidden = YES;
    UIButton *btn2 = [self viewWithTag:3];
    btn2.selected = NO;
    _colorView.hidden = YES;
}

@end
