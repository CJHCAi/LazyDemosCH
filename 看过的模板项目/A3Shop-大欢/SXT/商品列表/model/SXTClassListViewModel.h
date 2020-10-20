//
//  SXTClassListViewModel.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXTClassListViewModel : NSObject
/**商品简述*/
@property (copy, nonatomic) NSString *Abbreviation;

/**商品标题*/
@property (copy, nonatomic) NSString *Title;

/**老价格*/
@property (copy, nonatomic) NSString *DomesticPrice;

/**当前价格*/
@property (copy, nonatomic) NSString *Price;

/**商品ID*/
@property (copy, nonatomic) NSString *GoodsId;

/**国旗地址*/
@property (copy, nonatomic) NSString *CountryImg;

/**商品图片地址*/
@property (copy, nonatomic) NSString *ImgView;

@end
