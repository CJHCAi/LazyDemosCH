//
//  CYCropView.m
//  CYImageCrop
//
//  Created by Cyrus on 16/6/9.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import "CYCropView.h"
#import "CYCropCornerView.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, CYCropDragType) {
    CYCropDragTypeNone,
    CYCropDragTypeLeftTop,
    CYCropDragTypeLeftBottom,
    CYCropDragTypeRightTop,
    CYCropDragTypeRightBottom,
    CYCropDragTypeLeft,
    CYCropDragTypeTop,
    CYCropDragTypeRight,
    CYCropDragTypeBottom,
    CYCropDragTypeCenter,
};

@interface CYCropView ()

/** 三分线 */
@property (nonatomic, strong)UIView *verticalLeftLine;
@property (nonatomic, strong)UIView *verticalRightLine;
@property (nonatomic, strong)UIView *horizontalTopLine;
@property (nonatomic, strong)UIView *horizontalBottomLine;
/** 辅助布局的中心视图 */
@property (nonatomic, strong)UIView *centerView;

/** 半透明层 */
@property (nonatomic, strong)UIView *leftMask;
@property (nonatomic, strong)UIView *topMask;
@property (nonatomic, strong)UIView *rightMask;
@property (nonatomic, strong)UIView *bottomMask;

/** 4个角落的视图 */
@property (nonatomic, strong)CYCropCornerView *leftTopCorner;
@property (nonatomic, strong)CYCropCornerView *rightTopCorner;
@property (nonatomic, strong)CYCropCornerView *leftBottomCorner;
@property (nonatomic, strong)CYCropCornerView *rightBottomCorner;

/** 实际显示裁剪部分的视图 */
@property (nonatomic, strong)UIView *containerView;

@end

@implementation CYCropView {
    CGFloat _leftOffset;
    CGFloat _topOffset;
    CGFloat _rightOffset;
    CGFloat _bottomOffset;
    CGPoint _centerOffset;
    
    MASConstraint *_leftConstraint;
    MASConstraint *_topConstraint;
    MASConstraint *_rightConstraint;
    MASConstraint *_bottomConstraint;
    
    MASConstraint *_heightAndWidthConstraint;
    
    NSInteger _leftPriority;
    NSInteger _topPriority;
    NSInteger _rightPriority;
    NSInteger _bottomPriority;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    
    _borderWidth = 2.0;
    _maskColor = [UIColor colorWithWhite:0 alpha:0.5];
    _minLenghOfSide = 100;
    
    // 默认缩放类型
    _scaleType = CYCropScaleTypeCustom;

    [self p_addAllViews];
    [self p_configAllViews];
    [self p_addAllConstraints];
    [self p_configGesture];
    
    _leftPriority = 250;
    _topPriority = 250;
    _rightPriority = 250;
    _bottomPriority = 250;
    
    return self;
}

#pragma mark - 初始化设置

/** 初始化并添加视图 */
- (void)p_addAllViews {
    _containerView = [UIView new];
    
    _verticalLeftLine = [UIView new];
    _verticalRightLine = [UIView new];
    _horizontalTopLine = [UIView new];
    _horizontalBottomLine = [UIView new];
    
    _centerView = [UIView new];
    
    _leftMask = [UIView new];
    _rightMask = [UIView new];
    _topMask = [UIView new];
    _bottomMask = [UIView new];
    
    _leftTopCorner = [[CYCropCornerView alloc] initWithPosition:CYCropCornerPositionLeftTop];
    _rightTopCorner = [[CYCropCornerView alloc] initWithPosition:CYCropCornerPositionRightTop];
    _leftBottomCorner = [[CYCropCornerView alloc] initWithPosition:CYCropCornerPositionLeftBottom];
    _rightBottomCorner = [[CYCropCornerView alloc] initWithPosition:CYCropCornerPositionRightBottom];
    
    [self addSubview:_containerView];
    [self addSubview:_leftMask];
    [self addSubview:_rightMask];
    [self addSubview:_topMask];
    [self addSubview:_bottomMask];
    
    [_containerView addSubview:_verticalLeftLine];
    [_containerView addSubview:_verticalRightLine];
    [_containerView addSubview:_horizontalTopLine];
    [_containerView addSubview:_horizontalBottomLine];
    
    [_containerView addSubview:_centerView];
    
    [_containerView addSubview:_leftTopCorner];
    [_containerView addSubview:_rightTopCorner];
    [_containerView addSubview:_leftBottomCorner];
    [_containerView addSubview:_rightBottomCorner];
}

/** 配置视图的一些属性 */
- (void)p_configAllViews {
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.layer.borderWidth = _borderWidth;
    _containerView.layer.borderColor = [UIColor whiteColor].CGColor;
    // 阴影
    _containerView.layer.shadowRadius = 1.0;
    _containerView.layer.shadowColor = [UIColor grayColor].CGColor;
    _containerView.layer.shadowOpacity = 0.2;
    _containerView.layer.shadowOffset = CGSizeMake(0, 0);
    
    for (UIView *maskView in @[_leftMask, _rightMask, _topMask, _bottomMask]) {
        maskView.backgroundColor = _maskColor;
    }
    
    for (UIView *lineView in @[_verticalLeftLine, _verticalRightLine, _horizontalTopLine, _horizontalBottomLine]) {
        lineView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    }
}

/** 添加约束 */
- (void)p_addAllConstraints {
    // 裁剪部分的视图
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 上下左右不能超过自身的范围
        make.left.top.greaterThanOrEqualTo(self);
        make.right.bottom.lessThanOrEqualTo(self);
        // 最小宽高
        make.height.width.mas_greaterThanOrEqualTo(_minLenghOfSide);
    }];
    
    // 半透明层
    [_topMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(_containerView.mas_top);
    }];
    [_bottomMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(_containerView.mas_bottom);
    }];
    [_leftMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.bottom.equalTo(_containerView);
        make.right.equalTo(_containerView.mas_left);
    }];
    [_rightMask mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.bottom.equalTo(_containerView);
        make.left.equalTo(_containerView.mas_right);
    }];
    
    // 辅助布局视图
    [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_containerView);
        make.width.equalTo(_containerView).multipliedBy(1.0/3.0);
        make.height.equalTo(_containerView).multipliedBy(1.0/3.0);
    }];
    // 三分线
    CGFloat lineWidth = 1.0;
    [_verticalLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_containerView);
        make.width.mas_equalTo(lineWidth);
        make.left.equalTo(_centerView).offset(-lineWidth/2.0);
    }];
    [_verticalRightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(_containerView);
        make.width.mas_equalTo(lineWidth);
        make.right.equalTo(_centerView).offset(lineWidth/2.0);
    }];
    [_horizontalTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.height.mas_equalTo(lineWidth);
        make.top.equalTo(_centerView).offset(-lineWidth/2.0);
    }];
    [_horizontalBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.height.mas_equalTo(lineWidth);
        make.bottom.equalTo(_centerView).offset(lineWidth/2.0);
    }];
    
    // 四个角落视图
    [_leftTopCorner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_containerView);
        make.width.height.mas_equalTo(_leftTopCorner.bounds.size.width);
    }];
    [_rightTopCorner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(_containerView);
        make.width.height.mas_equalTo(_rightTopCorner.bounds.size.width);
    }];
    [_leftBottomCorner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(_containerView);
        make.width.height.mas_equalTo(_leftBottomCorner.bounds.size.width);
    }];
    [_rightBottomCorner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_containerView);
        make.width.height.mas_equalTo(_rightBottomCorner.bounds.size.width);
    }];

}

#pragma mark - 手势

/** 配置拖动手势 */
- (void)p_configGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_panCropView:)];
    [_containerView addGestureRecognizer:pan];
}

- (void)p_panCropView:(UIPanGestureRecognizer *)sender {
    static CYCropDragType dragType;
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            dragType = [self p_dragTypeWithLocation:[sender locationInView:sender.view]];
            // 如果是按照比例进行缩放的时候，每次缩放后的偏移量与实际的并不相同，所以在开始前更新一下偏移
            _leftOffset = _containerView.frame.origin.x;
            _topOffset = _containerView.frame.origin.y;
            _rightOffset = (_containerView.frame.size.width + _containerView.frame.origin.x) - self.frame.size.width;
            _bottomOffset = (_containerView.frame.size.height + _containerView.frame.origin.y) - self.frame.size.height;
            break;
        case UIGestureRecognizerStateChanged:
            [self p_dragCropViewWithType:dragType gesture:sender];
            break;
        case UIGestureRecognizerStateEnded:
            // 完成后的回调
            if(_completionHandler) {
                _completionHandler();
            }
            break;
        default:
            break;
    }
    
}

/** 根据位置计算出拖动的类型 */
- (CYCropDragType)p_dragTypeWithLocation:(CGPoint)location {
    CGFloat x = location.x;
    CGFloat y = location.y;
    CGFloat width = _containerView.bounds.size.width;
    CGFloat height = _containerView.bounds.size.height;
    // 移动过快时会导致 location 超出 containerView 的范围，这种情况下，把点纠正到视图内
    x = x < 0 ? 0 : x;
    x = x > width ? width : x;
    y = y < 0 ? 0 : y;
    y = y > height ? height : y;
    
    // 边缘手势作用的范围
    CGFloat range = 40.0;
    if (x >= 0 && x <= range && y >= 0 && y <= range) {
        // 左上角
        _leftPriority = 250;
        _topPriority = 250;
        _rightPriority = 251;
        _bottomPriority = 251;
        return CYCropDragTypeLeftTop;
    } else if (x >= width-range && x <= width && y >= 0 && y <= range) {
        // 右上角
        _leftPriority = 251;
        _topPriority = 250;
        _rightPriority = 250;
        _bottomPriority = 251;
        return CYCropDragTypeRightTop;
    } else if (x >= 0 && x <= range && y >= height-range && y <= height) {
        // 左下角
        _leftPriority = 250;
        _topPriority = 251;
        _rightPriority = 251;
        _bottomPriority = 250;
        return CYCropDragTypeLeftBottom;
    } else if (x >= width-range && x <= width && y >= height-range && y <= height) {
        // 右下角
        _leftPriority = 251;
        _topPriority = 251;
        _rightPriority = 250;
        _bottomPriority = 250;
        return CYCropDragTypeRightBottom;
    } else if (x >= 0 && x <= range && y >= range && y <= height-range) {
        // 左边
        _leftPriority = 250;
        _topPriority = 250;
        _rightPriority = 251;
        _bottomPriority = 250;
        return CYCropDragTypeLeft;
    } else if (x >= width-range && x <= width && y >= range && y <= height-range) {
        // 右边
        _leftPriority = 251;
        _topPriority = 250;
        _rightPriority = 250;
        _bottomPriority = 250;
        return CYCropDragTypeRight;
    } else if (x >= range && x <= width-range && y >= 0 && y <= range) {
        // 上边
        _leftPriority = 250;
        _topPriority = 250;
        _rightPriority = 250;
        _bottomPriority = 251;
        return CYCropDragTypeTop;
    } else if (x >= range && x <= width-range && y >= height-range && y <= height) {
        // 下边
        _leftPriority = 250;
        _topPriority = 251;
        _rightPriority = 250;
        _bottomPriority = 250;
        return CYCropDragTypeBottom;
    } else {
        // 内部
        _leftPriority = 250;
        _topPriority = 250;
        _rightPriority = 250;
        _bottomPriority = 250;
        return CYCropDragTypeCenter;
    }
}

/** 具体拖动的实现 */
- (void)p_dragCropViewWithType:(CYCropDragType)dragType gesture:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:sender.view];
    if (_scaleType != CYCropScaleTypeCustom && (dragType == CYCropDragTypeLeft || dragType == CYCropDragTypeTop || dragType == CYCropDragTypeRight || dragType == CYCropDragTypeBottom)) {
        dragType = CYCropDragTypeCenter;
    }
    switch (dragType) {
        case CYCropDragTypeLeftTop:
            _leftOffset += translation.x;
            _topOffset += translation.y;
            break;
        case CYCropDragTypeLeftBottom:
            _leftOffset += translation.x;
            _bottomOffset += translation.y;
            break;
        case CYCropDragTypeRightTop:
            _rightOffset += translation.x;
            _topOffset += translation.y;
            break;
        case CYCropDragTypeRightBottom:
            _rightOffset += translation.x;
            _bottomOffset += translation.y;
            break;
        case CYCropDragTypeLeft:
            _leftOffset += translation.x;
            if (_leftOffset < 0) {
                _leftOffset = 0;
            }
            break;
        case CYCropDragTypeTop:
            _topOffset += translation.y;
            break;
        case CYCropDragTypeRight:
            _rightOffset += translation.x;
            break;
        case CYCropDragTypeBottom:
            _bottomOffset += translation.y;
            break;
        case CYCropDragTypeCenter:
            _leftOffset += translation.x;
            _topOffset += translation.y;
            _rightOffset += translation.x;
            _bottomOffset += translation.y;
            if (_leftOffset <= 0) {
                CGFloat delta = -_leftOffset;
                _leftOffset += delta;
                _rightOffset += delta;
            }
            if (_rightOffset >= 0) {
                CGFloat delta = _rightOffset;
                _leftOffset -= delta;
                _rightOffset -= delta;
            }
            if (_topOffset <= 0) {
                CGFloat delta = -_topOffset;
                _topOffset += delta;
                _bottomOffset += delta;
            }
            if (_bottomOffset >= 0) {
                CGFloat delta = _bottomOffset;
                _topOffset -= delta;
                _bottomOffset -= delta;
            }
            break;
        case CYCropDragTypeNone:
            
            break;
    }
    [self setNeedsUpdateConstraints];
    [sender setTranslation:CGPointZero inView:sender.view];
}

#pragma mark - 更新约束

- (void)updateConstraints {
    
    // 因为拖动不同位置时约束的优先级要改变，所以需要删除原先的约束后重新添加
    [_leftConstraint uninstall];
    [_topConstraint uninstall];
    [_rightConstraint uninstall];
    [_bottomConstraint uninstall];
    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        _leftConstraint =  make.left.equalTo(self).offset(_leftOffset).priority(_leftPriority);
        _topConstraint = make.top.equalTo(self).offset(_topOffset).priority(_topPriority);
        _rightConstraint = make.right.equalTo(self).offset(_rightOffset).priority(_rightPriority);
        _bottomConstraint = make.bottom.equalTo(self).offset(_bottomOffset).priority(_bottomPriority);
    }];
    
    [super updateConstraints];
}

#pragma mark - 重写 setter & getter
- (void)setScaleType:(CYCropScaleType)scaleType {
    if (_scaleType == scaleType) {
        return;
    }
    _scaleType = scaleType;
    CGFloat mutiplyValue;
    [_heightAndWidthConstraint uninstall];
    switch (scaleType) {
        case CYCropScaleTypeCustom:
            // 如果是自定义模式，直接取消了长宽比的约束后即可返回
            return;
        case CYCropScaleTypeOriginal:
            mutiplyValue = self.frame.size.height/self.frame.size.width;
            break;
        case CYCropScaleType1To1:
            mutiplyValue = 1.0;
            break;
        case CYCropScaleType3To2:
            mutiplyValue = 3.0/2.0;
            break;
        case CYCropScaleType2To3:
            mutiplyValue = 2.0/3.0;
            break;
        case CYCropScaleType4To3:
            mutiplyValue = 4.0/3.0;
            break;
        case CYCropScaleType3To4:
            mutiplyValue = 3.0/4.0;
            break;
        case CYCropScaleType16To9:
            mutiplyValue = 16.0/9.0;
            break;
        case CYCropScaleType9To16:
            mutiplyValue = 9.0/16.0;
            break;
    }
    // 更新约束
    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
       _heightAndWidthConstraint = make.width.equalTo(_containerView.mas_height).priority(252).multipliedBy(mutiplyValue);
    }];
    // 把各个方向的偏移设为0，这样变化的时候比较合理
    _leftOffset = 0;
    _topOffset = 0;
    _rightOffset = 0;
    _bottomOffset = 0;
    [self setNeedsUpdateConstraints];
}

- (void)setScaleType:(CYCropScaleType)scaleType animated:(BOOL)animated {
    [self setScaleType:scaleType];
    if (animated) {
        [UIView animateWithDuration:0.15 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (CGRect)cropFrame {
    return _containerView.frame;
}

- (CGRect)cropFrameRatio {
    CGFloat x = _containerView.frame.origin.x / self.frame.size.width;
    CGFloat y = _containerView.frame.origin.y / self.frame.size.height;
    CGFloat width = _containerView.frame.size.width / self.frame.size.width;
    CGFloat height = _containerView.frame.size.height / self.frame.size.height;
    return CGRectMake(x, y, width, height);
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    _containerView.layer.borderWidth = borderWidth;
}
- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    for (UIView *maskView in @[_leftMask, _rightMask, _topMask, _bottomMask]) {
        maskView.backgroundColor = maskColor;
    }
}

- (void)setMinLenghOfSide:(CGFloat)minLenghOfSide {
    _minLenghOfSide = minLenghOfSide;
    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_greaterThanOrEqualTo(minLenghOfSide);
    }];
    [self setNeedsUpdateConstraints];
}
@end
