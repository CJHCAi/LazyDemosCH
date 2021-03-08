//
//  FiltrateCVCell.h
//  JingBanYun
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiltrateCVCell : UICollectionViewCell
@property(nonatomic,strong)NSDictionary *dic;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end
