//
//  MoreContentViewModel.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/19.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "MoreContentViewModel.h"
#import "MoreCotentNetManager.h"
#import "ContentsModel.h"

@interface MoreContentViewModel ()
@property (nonatomic,strong) ContentsModel *model;
@end

@implementation MoreContentViewModel

#pragma mark - 初始化
- (instancetype)initWithCategoryId:(NSInteger)categoryId contentType:(NSString *)type {
    if (self = [super init]) {
        _categoryId = categoryId;
        _type = type;
    }
    return self;
}

#pragma mark - 方法
- (void)getDataCompletionHandle:(void (^)(NSError *))completed {
    self.dataTask = [MoreCotentNetManager getContentsForForCategoryId:_categoryId contentType:_type completionHandle:^(ContentsModel* responseObject, NSError *error) {
        self.model = responseObject;
        completed(error);
    }];
    
}

/**  获取标题数组 */
- (NSArray *)tagsArrayForSection:(NSInteger)section {
    NSMutableArray *titleArr = [NSMutableArray array];
    NSArray *arr = self.model.tags.list;
    // 头一次先加"推荐"
    [titleArr addObject:@"推荐"];
    for (ContentTags_List *model in arr) {
        [titleArr addObject:model.tname];
    }
    return [titleArr copy];
}

- (NSInteger)sectionNumber {
    return self.model.categoryContents.list.count;
}
/**  通过分组数, 获取行数 */
- (NSInteger)rowForSection:(NSInteger)section {
    return self.model.categoryContents.list[section].list.count;
}
/**  通过分组数, 获取是否有更多 */
- (BOOL)hasMoreForSection:(NSInteger)section {
    return self.model.categoryContents.list[section].hasMore;
}

/**  通过分组数, 获取主标题 */
- (NSString *)mainTitleForSection:(NSInteger)section {
    return self.model.categoryContents.list[section].title;
}

/**  通过分组数和行数(IndexPath), 获取图标 */
- (NSURL *)coverURLForIndexPath:(NSIndexPath *)indexPath {
    NSString *path = nil;
    if (indexPath.section == 0) {
        path =  self.model.categoryContents.list[indexPath.section].list[indexPath.row].coverPath;
    } else {
        path = self.model.categoryContents.list[indexPath.section].list[indexPath.row].coverMiddle;
    }
    return [NSURL URLWithString:path];
}
/**  通过分组数和行数(IndexPath), 获取标题 */
- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath {
    return self.model.categoryContents.list[indexPath.section].list[indexPath.row].title;
}
/**  通过分组数和行数(IndexPath), 获取副标题 */
- (NSString *)subTitleForIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.model.categoryContents.list[indexPath.section].list[indexPath.row].subtitle;
    } else {
        return self.model.categoryContents.list[indexPath.section].list[indexPath.row].intro;
    }
}
/**  通过分组数和行数(IndexPath), 获取播放数 */
- (NSString *)playsForIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.model.categoryContents.list[indexPath.section].list[indexPath.row].playsCounts;
    if (count>10000) {
        return [NSString stringWithFormat:@"%.1lf万",count/10000.0];
    } else {
        return [NSString stringWithFormat:@"%ld",count];
    }
}
/**  通过分组数和行数(IndexPath), 获取集数 */
- (NSString *)tracksForIndexPath:(NSIndexPath *)indexPath {
    NSInteger tracks = self.model.categoryContents.list[indexPath.section].list[indexPath.row].tracksCounts;
    return [NSString stringWithFormat:@"%ld集",tracks];
}
/**  通过分组数和行数(IndexPath), 获取类别ID */
- (NSInteger)albumIdForIndexPath:(NSIndexPath *)indexPath {
    return self.model.categoryContents.list[indexPath.section].list[indexPath.row].albumId;
}

#pragma mark - 表头滚动视图相关
- (NSInteger)focusImgNumber {
    return self.model.focusImages.list.count;
}
/**  通过下标获取图片地址 */
- (NSURL *)focusImgURLForIndex:(NSInteger)index {
    NSString *path = self.model.focusImages.list[index].pic;
    return [NSURL URLWithString:path];
}

@end
