//
//  CLRotationView.m
//  菁优网首页动画
//
//  Created by JackChen on 2016/12/13.
//  Copyright © 2016年 chenlin. All rights reserved.
//

#import "CLRotationView.h"
#import "CLCustomRotationGestureRecognizer.h"
@interface CLRotationView ()
// 按钮数组
@property (nonatomic , strong) NSMutableArray *btnArray;

@property (nonatomic , assign) CGFloat rotationAngleInRadians; // 旋转的弧度

// 按钮的名字
@property (nonatomic , strong) NSMutableArray *nameArray ;

@end
@implementation CLRotationView

static CLRotationView *shareInstance;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2 ;
        self.Width = self.frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        // 按钮和按钮标题数组
        _btnArray = [NSMutableArray new];
        _nameArray = [NSMutableArray new];
        
        [self addGestureRecognizer:[[CLCustomRotationGestureRecognizer alloc]initWithTarget:self action:@selector(changeMove:)]];
    }
    return self;
}




- (void)BtnType:(CL_RoundviewType)type BtnWidth:(CGFloat)BtnWidth  adjustsFontSizesTowidth:(BOOL)sizeWith  masksToBounds:(BOOL)mask conrenrRadius:(CGFloat)radius image:(NSMutableArray *)image TitileArray:(NSMutableArray *)titileArray titileColor:(UIColor *)titleColor {
    CGFloat corner = -M_PI * 2.0 / titileArray.count;
    // 半径为 （转盘半径➖按钮半径）的一半
    CGFloat r = (self.Width  - BtnWidth) / 2 ;
    CGFloat x = self.Width  / 2 ;
    CGFloat y = self.Width  / 2 ;
    _nameArray = titileArray;
    
    for (int i = 0 ; i < titileArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, BtnWidth, BtnWidth);
        btn.layer.masksToBounds = mask;
        btn.layer.cornerRadius = radius;
        CGFloat  num = (i + 0.5) * 1.0;
        btn.center = CGPointMake(x + r * cos(corner * num), y + r *sin(corner * num));
        btn.backgroundColor = self.BtnBackgroudColor;
        self.BtnWidth = BtnWidth;
        
        // 自定义按钮的样式
        if (type == CL_RoundviewTypeCustom) {
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",image[i]]];
            imageview.contentMode = UIViewContentModeScaleAspectFit ;
            imageview.userInteractionEnabled = NO;
            // 设置的按钮的图片的大小
            imageview.frame = CGRectMake(20, 10, 50, 50);
            [btn addSubview:imageview];
            
            UILabel *label = [[UILabel alloc]init ];
            label.frame = CGRectMake(  imageview.center.x - (BtnWidth - 20)*0.5, CGRectGetMaxY(imageview.frame), BtnWidth - 20 , 20);
            
            label.text = titileArray[i];
            // 设置字体颜色为白色
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            
            label.font = [UIFont systemFontOfSize:11];
            // label根据字体自适应label大小，居中对齐
            label.adjustsFontSizeToFitWidth = YES;
            label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
            
            label.tag = i;
            [btn addSubview:label];
            
        }else {
            [btn setTitle:titileArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [_btnArray addObject:btn];
        
    }
}

#pragma mark - 点击按钮时跳转控制器
- (void)btn: (UIButton *)btn {

    NSInteger num1 = btn.tag;
    NSString *name = _nameArray[num1];
    self.back(num1,name);
    
}

#pragma mark -通过旋转手势转动转盘
- (void)changeMove:(CLCustomRotationGestureRecognizer *)retation {

    
    switch (retation.state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            self.rotationAngleInRadians += retation.rotation;
            [UIView animateWithDuration:.25 animations:^{
                
                self.transform = CGAffineTransformMakeRotation(self.rotationAngleInRadians+retation.rotation);
                for (UIButton *btn in _btnArray) {
                    btn.transform = CGAffineTransformMakeRotation(-(self.rotationAngleInRadians+retation.rotation));
                }
            }];
            
            break;
        }
            
//        case UIGestureRecognizerStateFailed:
//        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            int num = self.rotationAngleInRadians/(M_PI/3);
            int last = ((int)(self.rotationAngleInRadians*(180/M_PI)))%(60);
            
            
                    if (abs(last)>=30) {
                        
                        [UIView animateWithDuration:.25 animations:^{
                            
                            self.transform = CGAffineTransformMakeRotation(M_PI/3*(last>0?(num+1):(num-1)));
                            //                        tempAngle = M_PI/3*(last>0?(num+1):(num-1));
                            for (UIButton *btn in _btnArray) {
                                btn.transform = CGAffineTransformMakeRotation(-(M_PI/3*(last>0?(num+1):(num-1))));
                            }
                        }];
                        //偏转角度保存。
                        self.rotationAngleInRadians = M_PI/3*(last>0?(num+1):(num-1));
                        NSLog(@"偏转角度 = %lf ", self.rotationAngleInRadians*(180/M_PI));
                        
            }
                    else{
                        
                        [UIView animateWithDuration:.25 animations:^{
                            
                            self.transform = CGAffineTransformMakeRotation(M_PI/3*num);
                            for (UIButton *btn in _btnArray) {
                                btn.transform = CGAffineTransformMakeRotation(-(M_PI/3*num));
                            }
                }];
                //偏转角度保存。
                    self.rotationAngleInRadians = M_PI/3*num;

            }
    
            break;
        }
        default:
            break;
    }
    
   
}


@end
