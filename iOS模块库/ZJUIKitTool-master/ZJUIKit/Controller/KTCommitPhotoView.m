//
//  KTCommitPhotoView.m
//  ZJUIKit
//
//  Created by keenteam on 2018/4/3.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "KTCommitPhotoView.h"
#import <KSPhotoBrowser/KSPhotoBrowser.h>
#import "YYWebImage.h"

@interface KTCommitPhotoView()<KSPhotoBrowserDelegate>

@end


@implementation KTCommitPhotoView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllView];
    }
    return self;
}

-(void)setUpAllView{
    for (int i =0; i<9; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.clipsToBounds = YES;
        imageV.userInteractionEnabled = YES;
        imageV.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgVClick:)];
        [imageV addGestureRecognizer:tap];
        [self addSubview:imageV];
    }
}

#pragma mark - 设置图片数据
-(void)setPic_urls:(NSArray *)pic_urls{
    _pic_urls = pic_urls;
    NSInteger count = self.subviews.count;
    for (int i = 0; i<count; i++) {
        UIImageView *imageV = self.subviews[i];
        if (i<pic_urls.count) {
            [imageV yy_setImageWithURL:[NSURL URLWithString:pic_urls[i]] options:YYWebImageOptionShowNetworkActivity];
            imageV.hidden = NO;
        }else{
            imageV.hidden = YES;
        }
    }
}
#pragma mark -  图片点击事件
-(void)imgVClick:(UITapGestureRecognizer *)sender{
    NSLog(@"点击了第%ld个图片",sender.view.tag + 1);
    
    NSMutableArray *items = @[].mutableCopy;
    NSInteger count = self.pic_urls.count;
    for (int i = 0; i < count; i++) {
        UIImageView *imgV = self.subviews[i];
        NSString *url = [_pic_urls[i] stringByReplacingOccurrencesOfString:@"bmiddle" withString:@"large"];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imgV imageUrl:[NSURL URLWithString:url]];
        [items addObject:item];
    }
    
    /**
     * 使用 KSPhotoBrowser 浏览图片
     * 使用cocoaPods 导入
     *
     * pod 'KSPhotoBrowser'
     *
     */
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:sender.view.tag];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    browser.bounces = NO;
    [browser showFromViewController:self.selfVc];
}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index{
    NSLog(@"----------===>%ld",index);
}

// 计算尺寸
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.frame.size.width - 20) / 3;
    CGFloat h = w;
    CGFloat margin  = 10;
    int col = 0 ;
    int rol = 0;
    
    NSInteger count = _pic_urls.count;
    
    int cols = count == 4?2:3;
    
    // 计算显示出来的imageView
    for (int i = 0; i < count; i++) {
        col = i % cols;
        rol = i / cols;
        UIImageView *imageV = self.subviews[i];
        x = col * (w + margin);
        y = rol * (h + margin);
        imageV.frame = CGRectMake(x, y, w, h);
    }
}

-(void)dealloc{
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
    
}
@end

