//
//  HKSpecificationsCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSpecificationsCollectionViewCell.h"
#import "UIImage+YY.h"
#import "UIView+BorderLine.h"
@interface HKSpecificationsCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *w;

@end

@implementation HKSpecificationsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btn.layer.cornerRadius = 15;
    self.btn.layer.masksToBounds = YES;
    [self.btn borderForColor:[UIColor colorWithRed:255.0/255.0 green:247.0/255.0 blue:237.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
    // Initialization code
}
-(void)setColorsM:(CommodityDetailsesColors *)colorsM{
    _colorsM = colorsM;
    [self.btn setTitle:colorsM.name forState:0];
     [self.btn setTitle:colorsM.name forState:UIControlStateSelected];
    self.w.constant = colorsM.w;
}
-(void)setSpecs:(CommodityDetailsesSpecs *)specs{
    _specs = specs;
    [self.btn setTitle:specs.name forState:0];
    [self.btn setTitle:specs.name forState:UIControlStateSelected];
    self.w.constant = specs.w;
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
         [self.btn setTitleColor:[UIColor colorFromHexString:@"EF593C"] forState:0];
        [self.btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];

    }else{
        [self.btn setTitleColor:[UIColor colorFromHexString:@"666666"] forState:0];  [self.btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexString:@"FFF0ED"]] forState:0];
        
    }
    
}
@end
