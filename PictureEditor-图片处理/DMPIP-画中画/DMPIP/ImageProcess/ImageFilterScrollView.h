//
//  ImageFilterScrollView.h
//  LuoChang
//
//  Created by Rick on 15/9/14.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageFilterItem.h"

@interface ImageFilterScrollView : UIScrollView <ImageFilterItemDelegate>

@property (nonatomic , weak) id<ImageFilterItemDelegate> imageFilterItemdelegate;

@property(nonatomic,copy) NSArray *filterNamesArray;
@property(nonatomic,strong) NSMutableArray *itemImageArray;

-(instancetype)initWithImage:(UIImage *)originalImage;

@end
