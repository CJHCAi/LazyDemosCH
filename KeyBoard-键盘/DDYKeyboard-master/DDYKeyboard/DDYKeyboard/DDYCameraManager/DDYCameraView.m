#import "DDYCameraView.h"
#import "Masonry.h"

static inline UIImage *cameraImg(NSString *imageName) {return [UIImage imageNamed:[NSString stringWithFormat:@"DDYCamera.bundle/%@", imageName]];}

@interface DDYCameraView ()
/** 返回按钮 */
@property (nonatomic, strong) UIButton *backButton;
/** 改变色调按钮 */
@property (nonatomic, strong) UIButton *toneButton;
/** 闪光灯/补光灯按钮 */
@property (nonatomic, strong) UIButton *lightButton;
/** 切换前后摄像头按钮 */
@property (nonatomic, strong) UIButton *toggleButton;
/** 拍照录制按钮 */
@property (nonatomic, strong) UIButton *takeButton;
/** 进度layer */
@property (nonatomic, strong) CAShapeLayer *progressLayer;
/** 背景layer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t recordTimer;
/** 是否录制 */
@property (nonatomic, assign) BOOL isRecording;
/** 聚焦框 */
@property (nonatomic, strong) UIImageView *focusCursor;
/** 录制时长 */
@property (nonatomic, strong) UILabel *durationLabel;

@end

@implementation DDYCameraView

- (UIButton *)btnImg:(NSString *)img imgS:(NSString *)imgS sel:(SEL)sel {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (img) [button setImage:cameraImg(img) forState:UIControlStateNormal];
    if (imgS) [button setImage:cameraImg(imgS) forState:UIControlStateSelected];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self btnImg:@"back" imgS:nil sel:@selector(handleBack:)];
    }
    return _backButton;
}

- (UIButton *)toneButton {
    if (!_toneButton) {
        _toneButton = [self btnImg:@"toneN" imgS:@"toneS" sel:@selector(handleTone:)];
        _toneButton.hidden = YES;
    }
    return _toneButton;
}

- (UIButton *)lightButton {
    if (!_lightButton) {
        _lightButton = [self btnImg:@"lightN" imgS:@"lightS" sel:@selector(handleLight:)];
    }
    return _lightButton;
}

- (UIButton *)toggleButton {
    if (!_toggleButton) {
        _toggleButton = [self btnImg:@"toggle" imgS:nil sel:@selector(handleToggle:)];
    }
    return _toggleButton;
}

- (UIButton *)takeButton {
    if (!_takeButton) {
        _takeButton = [self btnImg:nil imgS:nil sel:@selector(handleTake:)];
        [_takeButton addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)]];
    }
    return _takeButton;
}

- (UIImageView *)focusCursor {
    if (!_focusCursor) {
        _focusCursor = [[UIImageView alloc] initWithImage:cameraImg(@"focus")];
        _focusCursor.alpha = 0;
        [self addSubview:_focusCursor];
    }
    return _focusCursor;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        _durationLabel.font = [UIFont systemFontOfSize:14];
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.hidden = YES;
        [self addSubview:_durationLabel];
    }
    return _durationLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.toneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.lightButton.mas_left).offset(-15);
            make.top.mas_equalTo(self.backButton);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.toggleButton.mas_left).offset(-15);
            make.top.mas_equalTo(self.backButton);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.toggleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-15);
            make.top.mas_equalTo(self.backButton);
            make.width.height.mas_equalTo(30);
        }];
        
        [self.takeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-20);
            make.width.height.mas_equalTo(60);
        }];
        
        [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.takeButton.mas_top).offset(-20);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(15);
        }];
        
        [self.focusCursor mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(60);
        }];
        
        [self addGenstureRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addShapeLayer];
}

#pragma mark 添加手势
- (void)addGenstureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:singleTap];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)addShapeLayer {
    CGRect rect = self.takeButton.bounds;
    CGFloat radius = rect.size.width/2.;
    CGPoint center = CGPointMake(radius, radius);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:2*M_PI-M_PI_2 clockwise:YES];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = rect;
    self.shapeLayer.lineWidth = 4.0f;
    self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.path = circlePath.CGPath;
    [self.takeButton.layer addSublayer:self.shapeLayer];
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.frame = rect;
    self.progressLayer.lineWidth = 4.0f;
    self.progressLayer.strokeColor = [UIColor blueColor].CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.lineCap = kCALineCapSquare;
    self.progressLayer.path = circlePath.CGPath;
    self.progressLayer.strokeEnd = 0./10.;
    [self.takeButton.layer addSublayer:_progressLayer];
}

- (void)startRecord {
    self.isRecording = YES;
    
    if (self.recordBlock) self.recordBlock(self.isRecording);
    if (self.lightBlock) self.lightBlock(self.isRecording, self.lightButton.selected);
    
    self.durationLabel.hidden = !self.isRecording;
    self.shapeLayer.transform = CATransform3DMakeScale(1.35, 1.35, 1);
    self.progressLayer.transform = CATransform3DMakeScale(1.35, 1.35, 1);
    __block NSInteger recordSeconds = 0.;
    self.recordTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.recordTimer, dispatch_walltime(NULL, 0), 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.recordTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (recordSeconds == 100) {
                [self stopRecord];
            } else {
                recordSeconds ++;
                self.durationLabel.text = [NSString stringWithFormat:@"%lds", recordSeconds/10];
                self.progressLayer.strokeEnd = recordSeconds/100.f;
            } 
        });
    });
    dispatch_source_set_cancel_handler(self.recordTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recordTimer = nil;
            recordSeconds = 0.;
        });
    });
    dispatch_resume(self.recordTimer);
}

- (void)stopRecord {
    if (self.isRecording) {
        dispatch_source_cancel(self.recordTimer);
        self.shapeLayer.transform = CATransform3DIdentity;
        self.progressLayer.transform = CATransform3DIdentity;
        self.isRecording = NO;
        if (self.recordBlock) self.recordBlock(self.isRecording);
        if (self.lightBlock) self.lightBlock(self.isRecording, self.lightButton.selected);
    }
}

#pragma mark - 事件处理
#pragma mark 返回
- (void)handleBack:(UIButton *)sender {
    if (self.backBlock) self.backBlock();
}

#pragma mark 曝光模式
- (void)handleTone:(UIButton *)sender {
    if (self.toneBlock) self.toneBlock((sender.selected = !sender.selected));
}
#pragma mark 切换摄像头
- (void)handleToggle:(UIButton *)sender {
    if (self.toggleBlock) self.toggleBlock();
}

#pragma mark 切换闪光灯模式
- (void)handleLight:(UIButton *)sender {
    if (self.lightBlock) self.lightBlock(self.isRecording, (sender.selected = !sender.selected));
}

#pragma mark 拍照
- (void)handleTake:(UIButton *)sender {
    if (self.takeBlock) self.takeBlock();
}

#pragma mark 长按录制与结束
- (void)handleLongPress:(UILongPressGestureRecognizer *)longP {
    if (longP.state == UIGestureRecognizerStateBegan) {
        [self startRecord];
    } else if (longP.state == UIGestureRecognizerStateEnded) {
        [self stopRecord];
    }
}

#pragma mark 单击聚焦
- (void)SingleTap:(UITapGestureRecognizer*)recognizer {
    CGPoint point= [recognizer locationInView:self];
    if (self.focusBlock) self.focusBlock(point);
    
    self.focusCursor.center = point;
    self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha = 1.;

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(identityAnimation) object:nil];
    [self performSelector:@selector(identityAnimation) withObject:nil afterDelay:0.5];
}

- (void)identityAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursor.transform = CGAffineTransformIdentity;
        self.focusCursor.alpha = 0.4;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha = 0;
    }];
}

#pragma mark 双击切换摄像头
- (void)DoubleTap:(UITapGestureRecognizer*)recognizer {
    if (self.toggleBlock) self.toggleBlock();
}

#pragma mark 是否显示调整曝光度的按钮
- (void)setIsShowToneButton:(BOOL)isShowToneButton {
    _isShowToneButton = isShowToneButton;
    self.toneButton.hidden = !_isShowToneButton;
}

#pragma mark 录制完重置view
- (void)ddy_ResetRecordView {
    self.isRecording = NO;
    self.shapeLayer.transform = CATransform3DIdentity;
    self.progressLayer.transform = CATransform3DIdentity;
    self.durationLabel.hidden = YES;
    self.progressLayer.strokeEnd = 0./100.f;
}

@end
