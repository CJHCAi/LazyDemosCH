//
//  ImageFilterBtn.h
//  GifDemo
//
//  Created by Rick on 15/5/29.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageFilterItem;
@protocol ImageFilterItemDelegate <NSObject>

-(void)imageFilterItemClick:(ImageFilterItem *)itemView filterDict:(NSDictionary *)filterDict;

@end

@interface ImageFilterItem : UIView
@property(nonatomic,assign) BOOL selected;
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSDictionary *filterDict;
@property(nonatomic,strong) UIImage *iconImage;
@property(nonatomic,strong) UIView *backgroundView;

@property (nonatomic , weak) id<ImageFilterItemDelegate> delegate;

- (void)setIconImage:(UIImage *)iconImage;
@end
