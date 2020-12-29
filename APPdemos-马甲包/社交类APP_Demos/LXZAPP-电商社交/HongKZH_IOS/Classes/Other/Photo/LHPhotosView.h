//
//  LHPhotosView.h
//  LHand
//
//  Created by 小华 on 15/5/15.
//  Copyright (c) 2015年 chenstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHPhotosView;

@protocol LHPhotosViewDelegate <NSObject>

@optional

- (void)tapPhotoWithArray:(NSArray *)pic_urls index:(int)index sourceImageView:(UIView *)source;

@end

@interface LHPhotosView : UIView

@property (nonatomic, strong) NSArray *pic_urls;

@property(nonatomic,assign)CGFloat minPhotoW;

@property(nonatomic,weak) id  <LHPhotosViewDelegate>delegate;

+ (CGSize)sizeWithPhotosCount:(int)photosCount andTag:(int)tag;
@property (nonatomic,assign) BOOL isLargen;
+(instancetype)lhPhotoViewWithCount:(BOOL)isLargen;

//+ (CGSize)sizeWithDiscW:(CGFloat )width PhotosCount:(int)photosCount;


@end
