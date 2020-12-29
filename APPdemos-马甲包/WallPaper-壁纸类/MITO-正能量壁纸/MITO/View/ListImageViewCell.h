//
//  ListImageViewCell.h
//  MITO
//
//  Created by keenteam on 2017/12/17.
//  Copyright © 2017年 keenteam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "List_audioModel.h"
@interface ListImageViewCell : UICollectionViewCell
@property (nonatomic , strong)UIImageView * imgView;
@property (nonatomic , strong)List_audioModel *model;
@end
