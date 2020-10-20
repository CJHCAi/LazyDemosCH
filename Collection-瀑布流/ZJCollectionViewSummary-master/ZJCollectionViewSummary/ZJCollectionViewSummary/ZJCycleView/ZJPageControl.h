//
//  ZJPageControl.h
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/12.
//  Copyright © 2018年 James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJPageControl : UIPageControl

@property (nonatomic,strong)UIImage *currentImage; //选中图片
@property (nonatomic,strong)UIImage *pageImage;    //默认图片
@property (nonatomic,assign)CGSize pointSize;       //图标大小

@end
