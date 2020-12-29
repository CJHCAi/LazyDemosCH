//
//  YCCollectionViewCell.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/6/21.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YCCollectionViewCell;
@protocol YCCollectionViewCellDelegate <NSObject>
- (void)beginDeleteState;
- (void)deletePic:(YCBaseModel *)pic
      atIndexpath:(NSIndexPath *)indexPath;
@end
@interface YCCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton    *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<YCCollectionViewCellDelegate>delegate;

- (void)setModel:(YCBaseModel *)model;
- (void)setUpLongGes;
- (void)setUpModel:(YCBaseModel *)model;

@end
