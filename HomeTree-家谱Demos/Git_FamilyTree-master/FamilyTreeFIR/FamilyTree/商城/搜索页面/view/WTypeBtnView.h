//
//  WTypeBtnView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTypeBtnView;
@protocol WTypeBtnViewDelegate <NSObject>

-(void)typeBtnView:(WTypeBtnView *)btnView didSelectedTitle:(NSString *)title;

@end
@interface WTypeBtnView : UIView
@property (nonatomic,weak) id<WTypeBtnViewDelegate> delegate; /*代理人*/

@end
