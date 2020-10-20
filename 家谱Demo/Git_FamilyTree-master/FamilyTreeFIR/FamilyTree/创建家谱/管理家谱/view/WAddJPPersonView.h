//
//  WAddJPPersonView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WAddJPPersonView;

@protocol WAddJPPersonViewDelegate <NSObject>

-(void)WAddJPPersonViewDelegate:(WAddJPPersonView *)addView didSelectedBtn:(UIButton *)sender;

@end

@interface WAddJPPersonView : UIView

@property (nonatomic,weak) id<WAddJPPersonViewDelegate> delegate; /*代理人*/

- (instancetype)initWithFrame:(CGRect)frame forPersonArr:(NSArray *)perArr;

@end
