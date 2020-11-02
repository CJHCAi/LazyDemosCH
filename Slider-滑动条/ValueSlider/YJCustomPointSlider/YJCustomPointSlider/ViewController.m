//
//  ViewController.m
//  YJCustomPointSlider
//
//  Created by 于英杰 on 2019/5/15.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YJUiView.h"

#import "YJSliderPointView.h"
#import "YJSliderPointViewTwo.h"

@interface ViewController ()

@property(nonatomic,strong)UILabel*lableTip;
@property(nonatomic,strong)UILabel*lableTiptwo;
@property(nonatomic,strong)UILabel*lableTipthree;

@property(nonatomic,strong)YJSliderPointView*sliderView;
@property(nonatomic,strong)YJSliderPointViewTwo*sliderViewTwo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.lableTip];
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.lableTiptwo];
    [self.view addSubview:self.sliderViewTwo];
  


}


-(UILabel*)lableTip{
    if (_lableTip==nil) {
        _lableTip = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, KScreenWidth, 20)];
        _lableTip.backgroundColor = [UIColor clearColor];
        _lableTip.text=@"试例1包含小数";
    }
    return _lableTip;
}
/*
 试例1
 */
-(YJSliderPointView*)sliderView{
    
    if (_sliderView==nil) {
        _sliderView = [[YJSliderPointView alloc]initWithFrame:CGRectMake(20, _lableTip.bottom+10, KScreenWidth-40, 44)];
        _sliderView.backgroundColor = [UIColor clearColor];
    }
    return _sliderView;
    
}

-(UILabel*)lableTiptwo{
    if (_lableTiptwo==nil) {
        _lableTiptwo = [[UILabel alloc]initWithFrame:CGRectMake(10, _sliderView.bottom+30, KScreenWidth, 20)];
        _lableTiptwo.backgroundColor = [UIColor clearColor];
        _lableTiptwo.text=@"试例2取整";
    }
    return _lableTiptwo;
}
/*
 试例2
 */
-(YJSliderPointViewTwo*)sliderViewTwo{
    if (_sliderViewTwo==nil) {
        _sliderViewTwo = [[YJSliderPointViewTwo alloc]initWithFrame:CGRectMake(20, _lableTiptwo.bottom+10, KScreenWidth-40, 44)];
        _sliderViewTwo.backgroundColor = [UIColor clearColor];
    }
    return _sliderViewTwo;
}

-(UILabel*)lableTipthree{
    
    if (_lableTipthree==nil) {
        _lableTipthree = [[UILabel alloc]initWithFrame:CGRectMake(10, _sliderViewTwo.bottom+30, KScreenWidth, 20)];
        _lableTipthree.backgroundColor = [UIColor clearColor];
        _lableTipthree.text=@"试例3";
    }
    return _lableTipthree;

}



@end
