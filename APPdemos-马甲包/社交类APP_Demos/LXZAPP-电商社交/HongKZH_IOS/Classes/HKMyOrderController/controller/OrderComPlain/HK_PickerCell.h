//
//  PickerCell.h
//  ManLanApp
//
//  Created by wuruijie on 2018/4/27.
//  Copyright © 2018年 蔓蓝科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cellActionDelegate <NSObject>

-(void)reloadDataListView:(UIButton *)sender;

@end

@interface Hk_PickerCell : UICollectionViewCell

@property(nonatomic,strong)UIImageView * iocnV ;

@property(nonatomic,strong)UIButton * closeBtn;

@property(nonatomic,weak) id<cellActionDelegate>delegate;

@end
