//
//  ImageViewCell.h
//  MITO
//
//  Created by keenteam on 2017/12/16.
//  Copyright © 2017年 keenteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeoperModel.h"

@interface ImageViewCell : UICollectionViewCell


@property (nonatomic , strong)UIImageView * imgView;
@property (nonatomic , strong)PeoperModel *model;

@end
