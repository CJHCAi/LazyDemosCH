//
//  ZJPhotoBrowser.h
//  ZJPhotoBrowserDemo
//
//  Created by 陈志健 on 2017/4/10.
//  Copyright © 2017年 chenzhijian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJPhoto.h"
#import "ZJActionSheet.h"

@class ZJPhotoBrowser;

@protocol ZJPhotoBrowerDelegate <NSObject>

@required
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(ZJPhotoBrowser *)photoBrowser;

//返回需要显示的图片对应的Photo实例
- (ZJPhoto *)photoBrowser:(ZJPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
@optional
//返回长按的事件,默认有保存图片
- (NSArray<ZJAction*> *)longPressActionsInPhotoBrowser:(ZJPhotoBrowser *)photoBrowser image:(UIImage *)image;

@end

@interface ZJPhotoBrowser : UIViewController

@property (nonatomic, weak) id<ZJPhotoBrowerDelegate>delegate;

- (void)showWithSelectedIndex:(NSUInteger)index;


@end
