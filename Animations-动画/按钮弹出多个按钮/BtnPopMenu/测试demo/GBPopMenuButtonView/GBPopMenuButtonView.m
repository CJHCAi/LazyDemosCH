//
//  MuneBar.m
//  WKMuneController
//
//  Created by macairwkcao on 16/1/26.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import "GBPopMenuButtonView.h"
#import "GBPopMenuButtonItem.h"

#define GBRotationAngle M_PI / 20

#define GBScreenWidth [UIScreen mainScreen].bounds.size.width
#define GBScreenHeight [UIScreen mainScreen].bounds.size.height
@interface GBPopMenuButtonView()

@property (nonatomic,weak)UIButton *mainButton;

@property(nonatomic,strong)NSArray *items;

@end

@implementation GBPopMenuButtonView

-(instancetype)initWithItems:(NSArray *)itemsImages size:(CGSize)size type:(GBmenuButtonType)type isMove:(BOOL)isMove{
    self = [super init];
    if (self) {
        self.itemsImages = itemsImages;
        self.isShow = NO;
        self.type = type;
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.layer.cornerRadius = size.width / 2.0;
        self.backgroundColor = [UIColor clearColor];
        [self addSubviews];
        
        //判断是否添加添加移动手势
        if (isMove) {
            UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
            [self addGestureRecognizer:pan];
        }else{
            
            return self;
        }
    }
    return self;
}


#pragma mark - 移动方法
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //根据在view上Pan的位置，
    CGPoint locationPoint = [pan locationInView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat padding = CGRectGetWidth(self.frame)/2;
    // 超出屏幕可视范围的直接return
    if (locationPoint.x < padding || locationPoint.y < padding || locationPoint.x > GBScreenWidth-padding || locationPoint.y > GBScreenHeight-padding) return;
    
    self.center = locationPoint;
}

-(void)setImage:(UIImage *)image{
    [self.mainButton setImage:image forState:UIControlStateNormal];
}

-(void)setHighlightedImage:(UIImage *)highlightedImage{
    [self.mainButton setImage:highlightedImage forState:UIControlStateHighlighted];
}

-(void)setTitle:(NSString *)title color:(UIColor *)color{
    [self.mainButton setTitle:title forState:UIControlStateNormal];
    [self.mainButton setTitleColor:color forState:UIControlStateNormal];
}
#pragma mark - 重写hitTest:withEvent:方法，检查是否点击item
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    if (self.isShow) {
        for (GBPopMenuButtonItem *item in self.items) {
            CGPoint buttonPoint = [item convertPoint:point fromView:self];
            if ([item pointInside:buttonPoint withEvent:event]) {
                return item;
            }
            
        }
    }
    return result;
}
-(void)setType:(GBmenuButtonType)type{
    _type = type;
}
#pragma mark -- 添加子视图
-(void)addSubviews{
    UIButton *mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainButton addTarget:self action:@selector(showItems) forControlEvents:UIControlEventTouchUpInside];
    [mainButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [mainButton setBackgroundColor:[UIColor lightGrayColor]];
    [mainButton setTitle:@"Mune" forState:UIControlStateNormal];
    self.mainButton = mainButton;
    self.mainButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    mainButton.layer.cornerRadius = self.frame.size.width / 2.0;
    mainButton.layer.masksToBounds = YES;
    
#pragma mark -- 菜单选项

    [self items];
    
    [self addSubview:_mainButton];
    
}
#pragma mark -- 懒加载菜单选项
-(NSArray *)items{
    if (_items == nil) {
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.itemsImages.count];
        for (int i = 0; i < self.itemsImages.count; i++) {
            UIImage *image = [UIImage imageNamed:self.itemsImages[i]];
            GBPopMenuButtonItem *item = [GBPopMenuButtonItem muneItemWithSize:CGSizeMake(self.frame.size.width, self.frame.size.height) image:image heightImage:nil target:self action:@selector(tapItem:)];
            item.tag = 100 + i;
            item.center = self.mainButton.center;
            [self addSubview:item];
            [items addObject:item];
        }
        [self addSubview:_mainButton];
        _items = items;
    }
    return _items;
}
#pragma mark -- 展开item，以MuneBarTypeRound方式展开(@param offsetAngle  根据展开的方向不同，设置不同的偏移角度)
-(void)itemShowRoundTypeWithOffsetAngle:(CGFloat)offsetAngle{
    CGFloat count = self.items.count;
    for (GBPopMenuButtonItem *item in self.items) {
        CGFloat angle = [self caculateRoundAngleWithOffsetAngle:offsetAngle index:count];
        [item itemShowWithType:GBButtonItemShowTypeRound angle:angle];
        count -- ;
    }
}
-(void)itemShowLineWithOffsetPoint:(CGPoint)point incremenr:(CGSize)increment{
    CGFloat count = self.items.count;

    for (GBPopMenuButtonItem *item in self.items) {
        CGPoint targetPoint = [self caculateLinePointWithOffsetPoint:point increment:increment index:count];
        [item itemShowWithTargetPoint:targetPoint type:GBButtonItemShowTypeLine];
        count -- ;
    }
}
#pragma mark -- 展开角度计算，以MuneBarTypeRound方式展开(@param offsetAngle  根据展开的方向不同，设置不同的偏移角度,@return return angle 每个item偏移的角度)
-(CGFloat)caculateRoundAngleWithOffsetAngle:(CGFloat)offsetAngle index:(CGFloat)index{
    CGFloat angle = M_PI / (self.items.count);
    angle = angle * index - angle / 2.0 + offsetAngle;
    return angle;
}

-(CGPoint)caculateLinePointWithOffsetPoint:(CGPoint)offsetPoint increment:(CGSize)increment index:(NSInteger)index{
    CGFloat x = offsetPoint.x;
    CGFloat y = offsetPoint.y;
    x += increment.width * index;
    y += increment.height * index;
    CGPoint point = CGPointMake(x, y);
    return point;
}
#pragma mark - 成员方法(显示菜单)
-(void)showItems{
    if (!self.isShow) {
        CGFloat count = self.items.count;
        self.isShow = YES;
        if ([self.delegate respondsToSelector:@selector(menuButtonHide)]) {
            [self.delegate menuButtonShow];
        }
        switch (self.type) {
            case GBMenuButtonTypeRadRight:
                for (GBPopMenuButtonItem *item in self.items) {
                    [item itemShowWithType:GBButtonItemShowTypeRadRight angle:GBRotationAngle * count];
                    count --;
                }
                break;
            case GBMenuButtonTypeRadLeft:
                for (GBPopMenuButtonItem *item in self.items) {
                    [item itemShowWithType:GBButtonItemShowTypeRadLeft angle:GBRotationAngle * count];
                    count --;
                }
                break;
            case GBMenuButtonTypeLineTop:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(0, -self.frame.size.height - 10)];
            }
                break;
            case GBMenuButtonTypeLineBottom:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(0, self.frame.size.height + 10)];

            }
                break;
            case GBMenuButtonTypeLineLeft:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(- self.frame.size.height - 10, 0)];
            }
                break;
            case GBMenuButtonTypeLineRight:{
                [self itemShowLineWithOffsetPoint:CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) incremenr:CGSizeMake(self.frame.size.height + 10, 0)];
            }
                break;
            case GBMenuButtonTypeRoundTop:{
                [self itemShowRoundTypeWithOffsetAngle:0];
            }
                break;
                
            case GBMenuButtonTypeRoundBottom:{
                [self itemShowRoundTypeWithOffsetAngle:- M_PI];
            }
                break;
            case GBMenuButtonTypeRoundLeft:{
                [self itemShowRoundTypeWithOffsetAngle:M_PI / 2.0];

            }
                break;
            case GBMenuButtonTypeRoundRight:{
                [self itemShowRoundTypeWithOffsetAngle: - M_PI / 2.0];

            }
                break;
            default:
                break;
        }
    }else{
        [self hideItems];
    }
}
#pragma mark - 成员方法(隐藏菜单)

-(void)hideItems{
    for (GBPopMenuButtonItem *item in self.items) {
        [item itemHide];
    }
    if ([self.delegate respondsToSelector:@selector(menuButtonHide)]) {
        [self.delegate menuButtonShow];
    }
    self.isShow = NO;
}
#pragma 点击item响应事件

-(void)tapItem:(GBPopMenuButtonItem *)item{
    if ([self.delegate respondsToSelector:@selector(menuButtonSelectedAtIdex:)]) {
        [self.delegate menuButtonSelectedAtIdex:item.tag - 100];
    }
    
    if (self.menuButtonSelectedAtIdex) {
        self.menuButtonSelectedAtIdex(item.tag - 100);
    }

}

@end
