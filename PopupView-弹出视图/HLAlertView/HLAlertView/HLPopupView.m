//
//  HLPopupView.m
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/1.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HLPopupView.h"
#import "HLAlertView.h"



@interface HLPopupView()
@property (nonatomic ,strong) UIStackView *actionStackView;
@property(nonatomic ,strong) NSMutableArray *itemArray;
@property(nonatomic ,assign) CGFloat fixHeight;
@property(nonatomic ,assign) CGFloat basicWidth;
@property(nonatomic ,assign) CGFloat height;


@end
@implementation HLPopupView
- (id)init {
    self = [super init];
    if (self) {
        self.basicWidth = 270;
        self.frame = CGRectMake(0, 0, self.basicWidth, self.height);
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self initParams];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.fixHeight = 0;
}

- (void)initParams {
    self.itemArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
}


- (void)setItemArray:(NSMutableArray *)itemArray {
    _itemArray = itemArray;
}

- (void)addItemToArrayWithObject:(id)object {
    if ([object isMemberOfClass:[HLLabel class]]) {
        HLLabel *item = object;
        [_itemArray addObject:item];
    }
    if ([object isMemberOfClass:[HMLabel class]]) {
        HMLabel *item = object;
        [_itemArray addObject:item];
    }
    if ([object isMemberOfClass:[HLAction class]]) {
        HLAction *item = object;
        
        [_itemArray addObject:item];
        [self.actionStackView addArrangedSubview:item];
        [self addTopLineByView:item];
    }
    if ([object isMemberOfClass:[HLImageView class]]) {
        HLImageView *item = object;
        [_itemArray addObject:item];
    }
    if ([object isMemberOfClass:[HLButton class]]) {
        HLButton *item = object;
        [_itemArray addObject:item];
    }
    if ([object isMemberOfClass:[HLTextField class]]) {
        HLTextField *item = object;
        [_itemArray addObject:item];
    }
    
    self.height = 0;
     __block BOOL isHaveAction = NO;
    [_itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isMemberOfClass:[HLLabel class]]) {
            HLLabel *item = obj;
            Constraint *model = [item valueForKey:@"constraint"];
            if (model.autoRelation == YES) {
                self.height = self.height + model.height + model.top + model.bottom;
            }
        }
        else if ([obj isMemberOfClass:[HMLabel class]]) {
            HMLabel *item = obj;
            Constraint *model = [item valueForKey:@"constraint"];
            UITextView *textView = [item valueForKey:@"textView"];
            if (model.height == 0) {
                model.height = [HLPopupView getHightWithText:item.title andWidth:self.basicWidth withFontOfSize:textView.font.pointSize];
            }
            if (model.autoRelation == YES) {
                self.height = self.height + model.height + model.top + model.bottom;
            }
        }
        else if ([obj isMemberOfClass:[HLAction class]]) {
            isHaveAction = YES;
        }else if ([obj isMemberOfClass:[HLTextField class]]) {
            HLTextField *item = obj;
            self.height = self.height + item.model.height + item.model.topBorder;
        }else if ([obj isMemberOfClass:[HLButton class]]) {
            HLButton *item = obj;
            Constraint *model = [item valueForKey:@"constraint"];
            if (model.autoRelation == YES) {
                self.height = self.height + model.height + model.top + model.bottom;
            }
        }
        else if ([obj isMemberOfClass:[HLImageView class]]) {
            HLImageView *item = obj;
            Constraint *model = [item valueForKey:@"constraint"];
            if (model.autoRelation == YES) {
                self.height = self.height + model.height + model.top + model.bottom;
            }
        }
        if (obj == [_itemArray lastObject]) {
            if (isHaveAction == YES) {
                NSInteger actionAccount = _actionStackView.arrangedSubviews.count;
                if (actionAccount <= 2) {
                    _height = _height + 50;
                }else {
                    _height = _height + 50 * actionAccount;
                }
            }
        }
    }];
    
    //如果用户设置了一个高度，但是控件排列的高度大于用户设置的高度，将自适应控件排列的高度以防止UI重叠
    if (_height >= self.fixHeight) {
        self.fixHeight = _height;
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, _height)];
    }
    NSLog(@"height : %f",_height);
}

- (void)fixSize:(CGSize)size {
    self.fixHeight = size.height;
    self.basicWidth = size.width;
    if (_height >= self.fixHeight) {
        self.fixHeight = _height;
        [self setFrame:CGRectMake(0, 0, size.width, _height)];
    }else {
        _height = self.fixHeight;
        [self setFrame:CGRectMake(0, 0, size.width, _height)];
    }
}


- (CGFloat)getCurrentHeight {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationPortraitUpsideDown) {
        return _height;
    }else {
        if (_height > self.frame.size.width) {
            return self.frame.size.width + 30;
        }else {
            return _height;
        }
    }
}
//更新约束
- (void)updateConstraints {
    [super updateConstraints];
    CGFloat bTopBorder = 0.0f;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    CGFloat offset = 0;
    if (self.actionStackView == nil || self.actionStackView.arrangedSubviews.count == 0) {
        offset = 0;
    }else if (self.actionStackView.arrangedSubviews.count <=2){
        offset = -1 * 50;
    }
    else if (self.actionStackView.arrangedSubviews.count >2){
        offset = self.actionStackView.arrangedSubviews.count * -50;
    }
    NSLayoutConstraint *bottomBorder = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:offset];
    
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width];
    [self addConstraints:@[top,centerX,bottomBorder]];
    [self addConstraints:@[width]];
    
    for (NSInteger i = 0; i < _itemArray.count; i ++) {
        if ([_itemArray[i] isMemberOfClass:[HLLabel class]]) {
            HLLabel *item = _itemArray[i];
            Constraint *model = [item valueForKey:@"constraint"];
            UILabel *label = [item valueForKey:@"label"];
            [self addSubview:label];
            bTopBorder = bTopBorder + model.top;
            
            NSLayoutConstraint *topBorder = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:model.autoRelation == NO?model.top:bTopBorder];
            if (model.autoRelation == YES) {
                bTopBorder = bTopBorder + model.height;
            }

            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:model.left];
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:model.right];
            
            NSLayoutConstraint *cWidth = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width - model.left + model.right];
            NSLayoutConstraint *cHeight = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:model.height];
            [self addConstraints:@[topBorder,left,right]];
            NSLog(@"Debug + hac.popview topBorder = %f",topBorder.constant);
            [label addConstraints:@[cWidth,cHeight]];
        }else if ([_itemArray[i] isMemberOfClass:[HMLabel class]]) {
            HMLabel *item = _itemArray[i];
            Constraint *model = [item valueForKey:@"constraint"];
            UITextView *textView = [item valueForKey:@"textView"];
            [self addSubview:textView];
            bTopBorder = bTopBorder + model.top;
            NSLayoutConstraint *topBorder = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:model.autoRelation == NO?model.top:bTopBorder];
             if (model.autoRelation == YES) {
                 bTopBorder = bTopBorder + model.height;
             }
            
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:model.left];
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:model.right];
            
            NSLayoutConstraint *cWidth = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width - model.left + model.right];
            NSLayoutConstraint *cHeight = [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:model.height];
            [self addConstraints:@[topBorder,left,right]];
            NSLog(@"Debug + hac.popview topBorder = %f",topBorder.constant);
            [textView addConstraints:@[cWidth,cHeight]];
            
        } else if ([_itemArray[i] isMemberOfClass:[HLTextField class]]){
            HLTextField*item = _itemArray[i];
            [self addSubview:item];
            bTopBorder = bTopBorder + item.model.topBorder;
            NSLayoutConstraint *topBorder = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:bTopBorder];
            bTopBorder = bTopBorder + item.model.height;
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:item.model.leftBorder];
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:item.model.rightBorder];

            NSLayoutConstraint *cWidth = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width - item.model.leftBorder + item.model.rightBorder];
            NSLayoutConstraint *cHeight = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:item.model.height];
            [self addConstraints:@[topBorder,left,right]];
            
            NSLog(@"Debug + hac.popview topBorder = %f",topBorder.constant);
            [_itemArray[i] addConstraints:@[cWidth,cHeight]];
        }
        else if ([_itemArray[i] isMemberOfClass:[HLImageView class]]){
            HLImageView*item = _itemArray[i];
            UIImageView *imageView = [item valueForKey:@"imageView"];
            Constraint *model = [item valueForKey:@"constraint"];
            [self addSubview:imageView];
            bTopBorder = bTopBorder + model.top;
            NSLayoutConstraint *topBorder = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:model.autoRelation == NO?model.top:bTopBorder];
            if (model.autoRelation == YES) {
                bTopBorder = bTopBorder + model.height;
            }

            
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:model.left];
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:model.right];

            NSLayoutConstraint *cWidth = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width - model.left + model.right];
            NSLayoutConstraint *cHeight = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:model.height];
            [self addConstraints:@[topBorder,left,right]];
            NSLog(@"Debug + hac.popview topBorder = %f",topBorder.constant);
            [imageView addConstraints:@[cWidth,cHeight]];
        }
        else if ([_itemArray[i] isMemberOfClass:[HLButton class]]){
            HLButton *item = _itemArray[i];
            Constraint *model = [item valueForKey:@"constraint"];
            UIButton *button = [item valueForKey:@"button"];
            [self addSubview:button];
            
            bTopBorder = bTopBorder + model.top;
            NSLayoutConstraint *topBorder = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:model.autoRelation == NO?model.top:bTopBorder];
            if (model.autoRelation == YES) {
                bTopBorder = bTopBorder + model.height;
            }

            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:model.left];
            NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:model.right];

            NSLayoutConstraint *cWidth = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width - model.left + model.right];
            NSLayoutConstraint *cHeight = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:model.height];
            [self addConstraints:@[topBorder,left,right]];
            NSLog(@"Debug + hac.popview topBorder = %f",topBorder.constant);
            [button addConstraints:@[cWidth,cHeight]];
        }
    }
    
    if (_actionStackView !=nil && _actionStackView.arrangedSubviews.count > 0) {
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.actionStackView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        if (self.actionStackView.arrangedSubviews.count <= 2) {
            NSLayoutConstraint *bottomBorder = [NSLayoutConstraint constraintWithItem:self.actionStackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            [self addConstraints:@[bottomBorder,centerX]];
            
            if (self.actionStackView.arrangedSubviews.count == 2) {
                [self addMiddleLineByView:_actionStackView];
            }
            NSLayoutConstraint *cWidth = [NSLayoutConstraint constraintWithItem:self.actionStackView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width];
            NSLayoutConstraint *cHeight = [NSLayoutConstraint constraintWithItem:self.actionStackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
            [self.actionStackView addConstraints:@[cWidth,cHeight]];
        }else {
            _actionStackView.axis = UILayoutConstraintAxisVertical;
            NSLayoutConstraint *bottomBorder = [NSLayoutConstraint constraintWithItem:self.actionStackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
            [self addConstraints:@[bottomBorder,centerX]];
            
            NSLayoutConstraint *cWidth = [NSLayoutConstraint constraintWithItem:self.actionStackView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:self.frame.size.width];
            NSLayoutConstraint *cHeight = [NSLayoutConstraint constraintWithItem:self.actionStackView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50 * self.actionStackView.arrangedSubviews.count];
            [self.actionStackView addConstraints:@[cWidth,cHeight]];
        }
    }
  
}


- (void)actionClicked:(UIButton *)sender {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"HLPopupView Touch Began...");
}

//获取文字高度
+ (CGFloat)getHightWithText:(NSString *)text andWidth:(CGFloat)textWidth withFontOfSize:(CGFloat)size {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size.height;
}

//添加线
- (void)addTopLineByView:(UIView*)view {
    UIColor *color = [UIColor colorWithWhite:0.7 alpha:0.7];
    [color set]; //设置线条颜色
    
    UIBezierPath *verticalPath = [UIBezierPath bezierPath];
    [verticalPath moveToPoint:CGPointMake(0, 0)];
    [verticalPath addLineToPoint:CGPointMake(view.frame.size.width + 1, 0)];
    
    verticalPath.lineWidth = 0.3;
    verticalPath.lineCapStyle = kCGLineCapRound; //线条拐角
    verticalPath.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [verticalPath stroke];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.lineWidth = 0.3;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = verticalPath.CGPath;
    [view.layer addSublayer:shapeLayer];
}

- (void)addMiddleLineByView:(UIView*)view {
    UIColor *color = [UIColor colorWithWhite:0.7 alpha:0.7];
    [color set]; //设置线条颜色
    UIBezierPath *verticalPath = [UIBezierPath bezierPath];
    [verticalPath moveToPoint:CGPointMake(self.frame.size.width/2, 1)];
    [verticalPath addLineToPoint:CGPointMake(self.frame.size.width/2, view.frame.size.height)];
    verticalPath.lineWidth = 0.3;
    verticalPath.lineCapStyle = kCGLineCapRound; //线条拐角
    verticalPath.lineJoinStyle = kCGLineJoinRound; //终点处理
    
    [verticalPath stroke];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.lineWidth = 0.3;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = verticalPath.CGPath;
    [view.layer addSublayer:shapeLayer];
}


- (UIStackView *)actionStackView {
    if (_actionStackView == nil) {
        _actionStackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        [_actionStackView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _actionStackView.axis = UILayoutConstraintAxisHorizontal;
        _actionStackView.distribution = UIStackViewDistributionFillEqually;
        _actionStackView.spacing = 0;
        [self addSubview:self.actionStackView];
    }
    return _actionStackView;
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationLandscapeLeft) {
        NSLog(@"");
        if (_height > self.frame.size.width) {
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width - 20)];
        }
    } else if(orientation == UIDeviceOrientationPortrait){
        NSLog(@"");
    }
}
@end
