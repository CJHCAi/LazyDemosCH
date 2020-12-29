//
//  CategoryCell.h
//  WallPaper
//
//  Created by Never on 2017/2/10.
//  Copyright © 2017年 Never. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCategory;

@class PixabayModel;

@class HXTagsView;

@protocol HXCellTagsViewDelegate <NSObject>

@optional
- (void)cellTagsViewButtonAction:(HXTagsView *)tagsView button:(UIButton *)sender;

@end

@interface CategoryCell : UITableViewCell

@property (nonatomic,assign) id<HXCellTagsViewDelegate> delegate;

- (void)setImageModel:(PixabayModel *)imageModel;



@end
