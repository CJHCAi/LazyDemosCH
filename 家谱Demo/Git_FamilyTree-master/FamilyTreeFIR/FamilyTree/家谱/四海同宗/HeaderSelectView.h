//
//  HeaderSelectView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/31.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderSelectView;

@protocol HeaderSelectViewDelegate <NSObject>

-(void)HeaderSelecteView:(HeaderSelectView *)headSeView didSelectedBtn:(UIButton *)sender;

@end
@interface HeaderSelectView : UIView

@property (nonatomic,weak) id<HeaderSelectViewDelegate> delegate; /*代理人*/

@end
