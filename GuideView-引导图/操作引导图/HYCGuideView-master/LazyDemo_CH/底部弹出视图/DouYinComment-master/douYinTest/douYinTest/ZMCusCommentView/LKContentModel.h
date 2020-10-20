//
//  LKContentModel.h
//  douYinTest
//
//  Created by Kai Liu on 2019/3/5.
//  Copyright © 2019 Kai Liu. All rights reserved.
//  评论模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKContentModel : NSObject

/** <#注释#> */
@property (nonatomic, copy) NSString *username;
/** <#注释#> */
@property (nonatomic, copy) NSString *content;
/** <#注释#> */
@property (nonatomic, strong) NSArray *replay;
/** 是否是 点击展开更多 */
@property (nonatomic, assign) BOOL isMoreCell;
/** ID */
@property (nonatomic, copy, readonly) NSString *identifier;
/** 记录当前显示了多少子回复 */
@property (nonatomic, assign) NSInteger nowReplayCount;
/** 当前显共有多少子回复 */
@property (nonatomic, assign) NSInteger maxReplayCount;

-(id)initWithDict:(NSDictionary*)dict;
+(id)modelWithDict:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
