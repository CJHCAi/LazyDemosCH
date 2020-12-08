//
//  YTBookCollectionViewCell.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/11.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YTBookCollectionViewCell;
@protocol YTBookCollectionViewCellDelegate <NSObject>

-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath;
-(void)showAllDeleteBtn;
-(void)hideAllDeleteBtn;
@end


@interface YTBookCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *bookNameView;

@property (nonatomic,weak) id<YTBookCollectionViewCellDelegate>delegate;

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
