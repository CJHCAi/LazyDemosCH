//
//  TJPhotoCollectionCell.h
//  TJGifMaker
//
//  Created by TanJian on 17/6/16.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJPhotoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);
@property (nonatomic, copy) void (^unSelectedBlock)(NSInteger index);
@property (nonatomic, assign) NSInteger index;

@end
