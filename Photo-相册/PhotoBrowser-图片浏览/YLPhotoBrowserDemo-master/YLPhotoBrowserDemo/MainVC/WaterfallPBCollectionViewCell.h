//
//  WaterfallPBCollectionViewCell.h
//  YLPhotoBrowserDemo
//
//  Created by 杨磊 on 2018/3/22.
//  Copyright © 2018年 csda_Chinadance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterfallPBCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainPicView;
@property (nonatomic,  copy) NSString *pic;
@end
