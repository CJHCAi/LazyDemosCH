//
//  CMNode.h
//  明医智
//
//  Created by LiuLi on 2019/1/15.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMNode : NSObject

@property (nonatomic,copy) NSString *name;

/** 返回当前节点是否已经展开，默认为NO  */
@property (nonatomic, readwrite, assign) BOOL expand;
/** 返回当前节点深度,默认为0，根节点为-1  */
@property (nonatomic, readonly, assign) NSInteger depth;
/** 返回当前节点的爷节点  */
@property (nonatomic, readonly, weak) CMNode *parentNode;
/** 存储当前节点的子节点集合(一级 二级 ，三级放在另一个位置用于右侧展示)  */
@property (nonatomic,strong) NSMutableArray *subNodes;
/** 三级数组（新增 此处场景限制死 只用于三级collectionview去使用）  */
@property (nonatomic,strong) NSMutableArray *threeNodes;

/** 是否已被选中  */
@property (nonatomic,assign) BOOL isChoosed;

- (instancetype)initWithParent:(CMNode *)parent expand:(BOOL) expand;

+ (instancetype)initWithParent:(CMNode *)parent expand:(BOOL) expand;

- (void)toggle;

@end

NS_ASSUME_NONNULL_END
