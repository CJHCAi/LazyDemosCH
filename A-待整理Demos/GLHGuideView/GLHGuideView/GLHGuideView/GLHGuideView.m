//
//  GLHGuideView.m
//  GLHGuideView
//
//  Created by ligui on 2017/5/26.
//  Copyright © 2017年 ligui. All rights reserved.
//

#import "GLHGuideView.h"
#define GLHRGBA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
typedef enum{
    Left  = 1,
    Right = 1 << 1,
    Upper = 1 << 2,
    Down  = 1 << 3
}GLHGuideLocation;
@interface GLHGuideView()
@property (nonatomic, copy) NSArray<NSDictionary<NSString *,NSValue *> *> *guidesArr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) GLHGuideLocation location;
@property (nonatomic, strong) UILabel *labMessage;
@property (nonatomic, strong) NSArray *styleArr;
@property (nonatomic, strong) NSArray *arrowTypeArr;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end
@implementation GLHGuideView
- (GLHGuideView *)initWithFrame:(CGRect)frame
                        guides:(NSArray<NSDictionary<NSString *,NSValue *> *> *)guides styles:(NSArray *)styleArr arrowType:(NSArray *)arrowTypeArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = GLHRGBA(32, 32, 32, 0.8);
        _guidesArr = guides;
        _styleArr = styleArr;
        _arrowTypeArr = arrowTypeArr;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
        [self addGestureRecognizer:tap];
        // 引导描述
        self.labMessage = [[UILabel alloc] init];
        self.labMessage.textColor = [UIColor whiteColor];
        self.labMessage.font = [UIFont systemFontOfSize:16];
        self.labMessage.textAlignment = NSTextAlignmentCenter;
        self.labMessage.numberOfLines = 0;
        [self addSubview:self.labMessage];
        
        _arrowImageView = [[UIImageView alloc] init];
        [self addSubview:_arrowImageView];
    }
    return self;
}
- (void)showGuide {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.currentIndex = 0;
    [self guideWithIndex:self.currentIndex];
}

- (void)guideWithIndex:(NSInteger)index {
    if (self.guidesArr.count == 0) {
        return;
    }
    NSDictionary *dic = self.guidesArr[index];
    NSString *descStr = [[dic allKeys] firstObject];
    CGRect rect = [dic[descStr] CGRectValue];
    
    // 添加描述
//    if (self.messageStyle == WQStyle0) {
//        [self addMessage0:[[dic allKeys] firstObject]
//                 nearRect:rect];
//    }else {
//        [self addMessage1:[[dic allKeys] firstObject]
//                 nearRect:rect];
//    }
    [self configImageAndLabelLocation:descStr nearRect:rect arrowType:_arrowTypeArr[index]];
    
    UIBezierPath *shapePath;
    CGFloat lineWidth = 0.0;
    
    if ([self.styleArr[index] isEqualToString:@"0"]) {
        // 圆形
        shapePath = [UIBezierPath bezierPathWithOvalInRect:rect];
    }else if ([self.styleArr[index] isEqualToString:@"1"]) {
        // 方形
        shapePath = [UIBezierPath bezierPathWithRect:rect];
    }
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:self.bounds];
    [bezier appendPath:[shapePath bezierPathByReversingPath]];
    layer.path = bezier.CGPath;
    layer.lineWidth = lineWidth;
    layer.lineDashPattern = @[@5,@5];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    self.layer.mask = layer;
}
- (void)configImageAndLabelLocation:(NSString *)labelText nearRect:(CGRect)rect arrowType:(NSString *)arrowType
{
    NSString *arrowNameStr = @"";
    CGRect arrowFrame = _arrowImageView.frame;
    arrowFrame.size = CGSizeMake(100, 80);
    
    CGRect labelFrame = _labMessage.frame;
    
    CGFloat labelHeight = [labelText boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height+5;
    switch ([arrowType integerValue]) {
        case 1:
            arrowNameStr = @"leftUp";
            arrowFrame.origin.x = rect.origin.x;
            arrowFrame.origin.y = rect.origin.y+rect.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y+arrowFrame.size.height, 100, labelHeight);
            break;
        case 2:
            arrowNameStr = @"rightUp";
            arrowFrame.origin.x = rect.origin.x+rect.size.width-arrowFrame.size.width;
            arrowFrame.origin.y = rect.origin.y+rect.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y+arrowFrame.size.height, 100, labelHeight);
            break;
        case 3:
            arrowNameStr = @"leftDown";
            arrowFrame.origin.x = rect.origin.x;
            arrowFrame.origin.y = rect.origin.y-arrowFrame.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y-arrowFrame.size.height, 100,labelHeight);
            break;
        case 4:
            arrowNameStr = @"rightDown";
            arrowFrame.origin.x = rect.origin.x+rect.size.width-arrowFrame.size.width;
            arrowFrame.origin.y = rect.origin.y-arrowFrame.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y-arrowFrame.size.height, 100, labelHeight);
            break;
        case 99:
            labelFrame = self.frame;
            arrowFrame = CGRectZero;
            break;
        case 98:
            arrowFrame = self.frame;
//            [_arrowImageView sd_setImageWithURL:[NSURL URLWithString:labelText]];
            break;
        default:
            break;
    }
    _arrowImageView.image = [UIImage imageNamed:arrowNameStr];
    _labMessage.text = labelText;
    _arrowImageView.frame = arrowFrame;
    _labMessage.frame = labelFrame;
}
///**
// *  新手指引
// */
//
//- (void)newUserGuide
//{
//    
//    // 这里创建指引在这个视图在window上
//    CGRect frame = [UIScreen mainScreen].bounds;
//    UIView * bgView = [[UIView alloc]initWithFrame:frame];
//    bgView.backgroundColor = GLHRGBA(32, 32, 32, 0.8);
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
//    [bgView addGestureRecognizer:tap];
//    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
//    
//    //create path 重点来了（**这里需要添加第一个路径）
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
//    // 这里添加第二个路径 （这个是圆）
//    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width - 30, 42) radius:30 startAngle:0 endAngle:2*M_PI clockwise:NO]];
//    // 这里添加第二个路径 （这个是矩形）
//    //[path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(frame.size.width/2.0-1, 234, frame.size.width/2.0+1, 55) cornerRadius:5] bezierPathByReversingPath]];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = path.CGPath;
//    //shapeLayer.strokeColor = [UIColor blueColor].CGColor;
//    [bgView.layer setMask:shapeLayer];
//    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width -300,72,270, 137)];
//    imageView.image = [UIImage imageNamed:@"CouponBoard_guid"];
//    [bgView addSubview:imageView];
//    
//}


/**
 *   新手指引确定
 */
- (void)sureTapClick:(UITapGestureRecognizer *)tap
{
    self.currentIndex ++;
    if (self.currentIndex < self.guidesArr.count) {
        [self guideWithIndex:self.currentIndex];
        return;
    }
    
    [self removeFromSuperview];
//    if ([self.delegate respondsToSelector:@selector(hideGuide)]) {
//        [self.delegate hideGuide];
//    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
