//
//  PickerCell.m
//  ManLanApp
//
//  Created by wuruijie on 2018/4/27.
//  Copyright © 2018年 蔓蓝科技. All rights reserved.
//

#import "HK_PickerCell.h"

@implementation Hk_PickerCell

-(instancetype)initWithFrame:(CGRect)frame {
    
    
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor =[UIColor greenColor];
        [self addSubview:self.iocnV];
        [self addSubview:self.closeBtn];

    }
    return self;
    
}

-(UIImageView *)iocnV {
    if (!_iocnV) {
        _iocnV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        _iocnV.contentMode =  UIViewContentModeScaleAspectFill;
        _iocnV.layer.masksToBounds = YES;
    }
    return _iocnV;
}

-(UIButton *)closeBtn {
    if (!_closeBtn) {
        UIImage *closeIm =[UIImage imageNamed:@"shanchu"];
        _closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.hidden = YES;
        _closeBtn.frame = CGRectMake(CGRectGetWidth(self.frame)-closeIm.size.width/2-10,10,closeIm.size.width,closeIm.size.height);
        [_closeBtn setImage:closeIm forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(deleteIM:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.enabled = NO;
    }
    return _closeBtn;
}
/** 删除图片*/
-(void)deleteIM:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadDataListView:)]) {
        [self.delegate reloadDataListView:sender];
    }
}

@end
