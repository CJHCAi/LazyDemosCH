//
//  HKHistoryTagView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_AllTags.h"
@protocol HKHistoryTagViewDelegate <NSObject>

@optional
-(void)historyTagViewBlock:(HK_AllTagsHis*)tagHis;
@end
@interface HKHistoryTagView : UIView

@property (nonatomic, strong) NSArray *hisTags;

@property (nonatomic,weak) id<HKHistoryTagViewDelegate> delegate;
@end

@interface HKHistoryTagInnerCell : UICollectionViewCell

@property (nonatomic, strong) HK_AllTagsHis *histroyTag;

@end
