//
//  TypeView.h
//  ListV
//
//  Created by imac on 16/8/5.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

@protocol TypeViewDelegate <NSObject>

- (void)selectTypeCellGoodsId:(NSString *)goodId;

@end

@interface TypeView : UIView

- (void)setTypeView:(NSArray<GoodsDatalist*> *)typeArr;

@property (weak,nonatomic) id<TypeViewDelegate>delegate;

@end
