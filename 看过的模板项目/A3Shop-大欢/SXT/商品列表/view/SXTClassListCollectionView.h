//
//  SXTClassListCollectionView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectGoodsId)(NSString *);

@interface SXTClassListCollectionView : UICollectionView

@property (strong, nonatomic)   NSArray *classListArray;              /** 存储数据的数组 */
@property (copy, nonatomic)     selectGoodsId selectCoods;

@end
