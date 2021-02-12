//
//  WDCircleAnimationView.m
//  CircleAnimationUserInteractionDemo
//
//  Created by Amale on 16/2/29.
//  Copyright © 2016年 Amale. All rights reserved.
//

#import "WDCircleAnimationView.h"

#import "CircleAnimationBottomView.h"
#import "UIView+Extensions.h"

@interface WDCircleAnimationView ()

@property(strong,nonatomic) CircleAnimationBottomView * bottomView ;

@property (nonatomic, strong) CAShapeLayer *bottomLayer; // 进度条底色

@end

@implementation WDCircleAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

-(void)initSubView{

    //添加底部圆形图
    [self addSubview:self.bottomView];
    
    
    [self.bottomView setDidTouchBlock:^(NSInteger temp) {
       
        _temperInter  = temp;
        
    }];
    
    
    UIView * backview = [[UIView alloc] initWithFrame:CGRectMake(40, 40, self.width-80, self.width-80)];
    
    backview.layer.masksToBounds = YES ;
    
    backview.layer.cornerRadius = (self.width-80)/2 ;
    
    [self addSubview:backview];
   
}

-(void)setText:(NSString *)text{

    _text = text;
    
    self.bottomView.text = text ;
    
}

-(void)setTemperInter:(NSInteger)temperInter{

    _temperInter = temperInter ;
    
    
    self.bottomView.temperInter = (float)temperInter;

}

-(void)setFunctionImage:(FunctionType)functionImage{

    _functionImage = functionImage;
    
    NSString * imgName = @"icon_m_auto";
    
    switch (functionImage) {
        case FunctionTypeAuto:
            
            imgName = @"icon_m_auto";
            
            break;
            
        case FunctionTypeChuShi:
            
            imgName = @"icon_m_chushi";
            
            break;
        case FunctionTypeSnow:
            
            imgName = @"icon_m_snow";
            
            break;
        case FunctionTypeSun:
            
            imgName = @"icon_m_sun";
            
            break;
        case FunctionTypeWind:
            
            imgName = @"icon_m_wind";
            
            break;
            
        default:
            
            imgName = @"icon_m_auto";
            
            break;
    }
    
    
    self.bottomView.typeImgName = imgName ;

}


-(CircleAnimationBottomView *)bottomView{

    if (!_bottomView) {
        
        _bottomView = [[CircleAnimationBottomView alloc] initWithFrame:self.bounds];
        
        
        //_bottomView.typeImage = FunctionTypeWind ;
        
    }

    
    return _bottomView;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
