//
//  ZQBottomToolbarView.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/29.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <UIKit/UIKit.h>




@class PHAsset;
@class ZQPhotoModel;


@interface ZQBottomToolbarView : UIView
@property (nonatomic, strong) UIButton *btnPreview;
@property (nonatomic, strong) UIButton *btnFinish;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UILabel *lblNumber;
@property (nonatomic, strong) UIImageView *ivCircle;
@property (nonatomic, strong) UIView *vLine;

@property (nonatomic, assign) NSInteger selectedNum;

@property (nonatomic, assign) BOOL bSingleSelection;


- (void)selectionChange:(NSArray<ZQPhotoModel*> *)assets;
@end
