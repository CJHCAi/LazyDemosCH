//
//  SXTClassCollectionView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^collectionSelectionCell)(NSDictionary *);

@interface SXTClassCollectionView : UICollectionView

@property (copy, nonatomic)     collectionSelectionCell selectCellBlock;    /**选择哪一个cell*/

@property (strong, nonatomic)   NSArray *classicClassArray;              /** 经典 */
@property (strong, nonatomic)   NSArray *recommendClassArray;              /** 推荐 */
@property (strong, nonatomic)   NSArray *effectArray;              /** 功效 */

@end
