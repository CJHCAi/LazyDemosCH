//
//  FiltrateReusableView.h
//  JingBanYun
//
//  Created by zhu on 2017/5/5.
//  Copyright © 2017年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^FiltrateReusableViewBlock)(BOOL state,NSInteger index);

@interface FiltrateReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property(nonatomic)NSInteger index;//索引值
@property(nonatomic,strong)NSDictionary *dic;//
@property(nonatomic,strong)FiltrateReusableViewBlock filtrateReusableViewBlock;
@end
