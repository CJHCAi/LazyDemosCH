//
//  HKNewPersonCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKNewPerSonTool.h"

@protocol HKNewPersonCellDelegate <NSObject>

@optional
-(void)labelTagBlock:(HKNewPersonList*)list tag:(NSInteger)tag;
@end
@interface HKNewPersonCell : UITableViewCell

@property (nonatomic, strong)HKNewPersonList * list;

-(void)setListModel:(HKNewPersonList *)list andTags:(NSInteger)tag;
@property (nonatomic,weak) id<HKNewPersonCellDelegate> delegate;
@end
