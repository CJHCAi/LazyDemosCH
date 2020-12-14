//
//  ARBookCollectionViewCell.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/27.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARBookCollectionViewCell;

@protocol ARBookCollectionViewCellDelegate <NSObject>

-(void)deleteCellAtIndexpath:(NSIndexPath *)indexPath;
-(void)showAllDeleteBtn;
-(void)hideAllDeleteBtn;
@end


@interface ARBookCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *bookNameView;

@property (nonatomic,weak) id<ARBookCollectionViewCellDelegate>delegate;

@property (nonatomic,strong) UIButton *deleteBtn;

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
