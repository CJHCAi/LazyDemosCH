#import <Foundation/Foundation.h>

/** 排序规则 */
#ifndef DDYCollation
#define DDYCollation [UILocalizedIndexedCollation currentCollation]
#endif

@interface NSArray (DDYExtension)

/**
 模型数组索引排序
 @param selector 模型排序依据属性
 @return 排序后的数组
 */
- (NSMutableArray *)ddy_SortWithCollectionStringSelector:(SEL)selector;

/**
 模型数组索引标题
 @param model 模型类名
 @param selector 依据属性
 @param show 是否显示serach图标
 @return 索引标题数组
 */
- (NSMutableArray *)ddy_SortWithModel:(NSString *)model selector:(SEL)selector showSearch:(BOOL)show;

@end
