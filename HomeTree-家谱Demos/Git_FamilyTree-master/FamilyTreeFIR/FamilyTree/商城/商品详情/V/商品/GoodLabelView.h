//
//  GoodLabelView.h
//  ListV
//
//  Created by imac on 16/7/28.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodLabelView : UIView
/**
 *  详情
 */
@property (strong,nonatomic) UILabel *detaiLb;
/**滚动图*/
@property (nonatomic,strong) ScrollerView *scroView;

- (void)refreshFrame;
@end
