//
//  MoreContentViewModel.h
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/19.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "BaseViewModel.h"

@interface MoreContentViewModel : BaseViewModel

/**  VM初始化,通过获取外界数据,进行网络加载 */
- (instancetype)initWithCategoryId:(NSInteger)categoryId contentType:(NSString *)type;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,assign) NSInteger categoryId;


/**  获取标题数组 */
- (NSArray *)tagsArrayForSection:(NSInteger)section;
/**  获取分组数 */
@property (nonatomic,assign) NSInteger sectionNumber;
/**  通过分组数, 获取行数 */
- (NSInteger)rowForSection:(NSInteger)section;
/**  通过分组数, 获取是否有更多 */
- (BOOL)hasMoreForSection:(NSInteger)section;
/**  通过分组数, 获取主标题 */
- (NSString *)mainTitleForSection:(NSInteger)section;

/**  通过分组数和行数(IndexPath), 获取图标 */
- (NSURL *)coverURLForIndexPath:(NSIndexPath *)indexPath;
/**  通过分组数和行数(IndexPath), 获取标题 */
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;
/**  通过分组数和行数(IndexPath), 获取副标题 */
- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath;
/**  通过分组数和行数(IndexPath), 获取播放数 */
- (NSString *)playsForIndexPath:(NSIndexPath *)indexPath;
/**  通过分组数和行数(IndexPath), 获取集数 */
- (NSString *)tracksForIndexPath:(NSIndexPath *)indexPath;
/**  通过分组数和行数(IndexPath), 获取类别ID */
- (NSInteger)albumIdForIndexPath:(NSIndexPath *)indexPath;


#pragma mark - 头视图相关
// 有多找张滚动图
@property (nonatomic,assign) NSInteger focusImgNumber;
/**  通过下标获取图片地址 */
- (NSURL *)focusImgURLForIndex:(NSInteger)index;


@end
