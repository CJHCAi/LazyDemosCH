//
//  SDPhotoGroup.m
//  SDPhotoBrowser
//
//  Created by aier on 15-2-4.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"
#import "UIButton+WebCache.h"
#import "SDPhotoBrowser.h"

#define SDPhotoGroupImageMargin 15

@interface SDPhotoGroup () <SDPhotoBrowserDelegate>

@end

@implementation SDPhotoGroup 

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
        [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
            
        }];
    }
    return self;
}


- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(SDPhotoItem *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        btn.alpha =0;
        [btn sd_setImageWithURL:[NSURL URLWithString:obj.thumbnail_pic] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [image  fadeIn:btn  withDuration: 0.2 andWait : 0.2];
            }
            
        }];
        
        
        btn.tag = idx;
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    long imageCount = self.photoItemArray.count;
//    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
//    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
//    int totalRowCount = ceil(imageCount / perRowImageCountF); // ((imageCount + perRowImageCount - 1) / perRowImageCount)
//    CGFloat w = 80;
//    CGFloat h = 80;
//    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.frame = CGRectMake(0, 0, kScreenWidth, 450);
    }];
    self.frame = CGRectMake(0, 0, kScreenWidth, 450);
}

- (void)buttonClick:(UIButton *)button
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self; // 原图的父控件
    browser.imageCount = self.photoItemArray.count; // 图片总数
    browser.currentImageIndex = button.tag;
    browser.delegate = self;
    [browser show];
    
}

#pragma mark - photobrowser代理方法

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}

@end
