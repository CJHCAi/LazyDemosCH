//
//  ZHBStandardViewCollectionViewCell.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/28.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBStandardViewCollectionViewCell.h"
#import "ZHBProductAttrsInfoModel.h"


@interface ZHBStandardViewCollectionViewCell ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *selectShapeLayer;
@property (nonatomic, strong) CAShapeLayer *unSelectShapeLayer;
@property (nonatomic, strong) CAShapeLayer *specShapeLayer;
@property (nonatomic, strong) CAShapeLayer *stockShapeLayer;
@end

@implementation ZHBStandardViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.standardLabel.frame = self.bounds;
        [self.contentView addSubview:self.standardLabel];
    }
    return self;
}

- (void)setBottonsValue:(ZHBBottonsValueModel *)bottonsValue
{
    _bottonsValue = bottonsValue;
    
    self.standardLabel.text = bottonsValue.name;
    self.standardLabel.frame = self.bounds;
    
    //已选
    if (bottonsValue.isSelected) {
        self.standardLabel.textColor = ColorWithHex(0xBE824E);
        self.standardLabel.backgroundColor = [UIColor clearColor];
        [self setupShapeLayer:self.selectShapeLayer];
    }else{
        if (bottonsValue.isSpec) {
            if (bottonsValue.isNoStock){
                self.standardLabel.textColor = ColorWithHex(0xE2E2E4);
                self.standardLabel.backgroundColor = [UIColor clearColor];
                [self setupShapeLayer:self.stockShapeLayer];
//                [self setupShapeLayer:self.specShapeLayer];
            } else {
                self.standardLabel.textColor = ColorWithHex(0x555555);
                self.standardLabel.backgroundColor = [UIColor clearColor];
                [self setupShapeLayer:self.unSelectShapeLayer];
            }
        }else{
            
            if (bottonsValue.isNoStock){
                self.standardLabel.textColor = ColorWithHex(0xE2E2E4);
                self.standardLabel.backgroundColor = [UIColor clearColor];
                [self setupShapeLayer:self.stockShapeLayer];
//                [self setupShapeLayer:self.specShapeLayer];
            } else {
                self.standardLabel.textColor = ColorWithHex(0x555555);
                self.standardLabel.backgroundColor = [UIColor clearColor];
                [self setupShapeLayer:self.specShapeLayer];
            }
        }
    }
}

- (void)setupShapeLayer:(CAShapeLayer *)shapeLayer
{
    CAShapeLayer *resultLayer = nil;
    for (CALayer *layer in [self.standardLabel.layer.sublayers copy]) {
        if (shapeLayer != layer) {
            [layer removeFromSuperlayer];
        } else {
            resultLayer = (CAShapeLayer *)layer;
        }
    }
    if (!resultLayer) {
        [self.standardLabel.layer addSublayer:shapeLayer];
    }
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.standardLabel.bounds cornerRadius:4.0].CGPath;
    shapeLayer.frame = self.standardLabel.bounds;
}


- (UILabel *)standardLabel
{
    if (!_standardLabel) {
        _standardLabel = [[UILabel alloc] init];
        _standardLabel.backgroundColor = [UIColor clearColor];
        _standardLabel.font = [UIFont systemFontOfSize:14];
        _standardLabel.textAlignment = NSTextAlignmentCenter;
        _standardLabel.textColor = ColorWithHex(0x555555);
        _standardLabel.layer.cornerRadius = 4.f;
        _standardLabel.layer.masksToBounds = YES;
    }
    return _standardLabel;
}

- (CAShapeLayer *)selectShapeLayer
{
    if (!_selectShapeLayer) {
        _selectShapeLayer = [CAShapeLayer layer];
        _selectShapeLayer.strokeColor = ColorWithHex(0xBE824E).CGColor;
        _selectShapeLayer.fillColor = nil;
        _selectShapeLayer.lineWidth = 1.5f;
        _selectShapeLayer.lineCap = kCALineCapRound;
    }
    return _selectShapeLayer;
}

- (CAShapeLayer *)unSelectShapeLayer
{
    if (!_unSelectShapeLayer) {
        _unSelectShapeLayer = [CAShapeLayer layer];
        _unSelectShapeLayer.strokeColor = ColorWithHex(0x555555).CGColor;
        _unSelectShapeLayer.fillColor = nil;
        _unSelectShapeLayer.lineWidth = 1.5f;
        _unSelectShapeLayer.lineCap = kCALineCapRound;
    }
    return _unSelectShapeLayer;
}

- (CAShapeLayer *)specShapeLayer
{
    if (!_specShapeLayer) {
        _specShapeLayer = [CAShapeLayer layer];
        _specShapeLayer.strokeColor = ColorWithHex(0xE2E2E4).CGColor;
        _specShapeLayer.fillColor = nil;
        _specShapeLayer.lineWidth = 1.5f;
        _specShapeLayer.lineCap = kCALineCapRound;
        _specShapeLayer.lineDashPattern = @[@3 , @3];
    }
    return _specShapeLayer;
}

- (CAShapeLayer *)stockShapeLayer
{
    if (!_stockShapeLayer) {
        _stockShapeLayer = [CAShapeLayer layer];
        _stockShapeLayer.strokeColor = ColorWithHex(0xE2E2E4).CGColor;
        _stockShapeLayer.fillColor = nil;
        _stockShapeLayer.lineWidth = 1.5f;
        _stockShapeLayer.lineCap = kCALineCapRound;
    }
    return _stockShapeLayer;
}

@end
