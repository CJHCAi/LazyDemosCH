//
//  GoodsDetailsViewController.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WGoodsDetailModel.h"
@interface GoodsDetailsViewController : BaseViewController

- (instancetype)initWithTitle:(NSString *)title
                        image:(UIImage *)image
             detailGoodsModel:(WGoodsDetailModel *)goodModel;

@end
