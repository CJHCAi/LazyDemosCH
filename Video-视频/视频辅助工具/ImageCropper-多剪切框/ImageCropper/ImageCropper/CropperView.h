//
//  CropperView.h
//  ImageCropper
//
//  Created by Zhuochenming on 16/1/8.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropperView : UIView

@property (nonatomic, strong) UIImage *image;

//初始化
- (instancetype)initWithFrame:(CGRect)frame
              image:(UIImage *)image
          rectArray:(NSArray *)rectArray;

//截图
- (NSArray *)cropedImageArray;
- (void)addCropRect:(CGRect)rect;
- (void)removeCropRectByIndex:(NSInteger)index;

@end
