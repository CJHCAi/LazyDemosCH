//
//  WFilterView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WFilterView;
@protocol WfilterViewDelegate <NSObject>

-(void)WfilterView:(WFilterView *)filterView completeFilterDictionary:(NSDictionary *)filterDic;

@end
@interface WFilterView : UIView
@property (nonatomic,weak) id<WfilterViewDelegate> delegate; /*代理人*/

@end
