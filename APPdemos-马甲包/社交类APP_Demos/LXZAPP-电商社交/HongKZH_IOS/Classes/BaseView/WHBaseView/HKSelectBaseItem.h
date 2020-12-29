//
//  HKSelectBaseItem.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HKSelectBaseItemDelegate <NSObject>

@optional
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag;
@end
@interface HKSelectBaseItem : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,weak) id<HKSelectBaseItemDelegate> delegate;

@property (nonatomic,assign) int row;


@property (nonatomic,assign) BOOL isLeft;
@end
