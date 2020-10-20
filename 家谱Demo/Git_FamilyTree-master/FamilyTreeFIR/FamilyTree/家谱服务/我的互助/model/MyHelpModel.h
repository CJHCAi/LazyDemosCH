//
//  MyHelpModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/2.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHelpModel : NSObject
/** 封面 */
@property (nonatomic, copy) NSString *ZqCover;
/** 类型 */
@property (nonatomic, copy) NSString *ZqType;
/** 宗亲互助ID */
@property (nonatomic, assign) NSInteger ZqId;
/** 意向人数 */
@property (nonatomic, assign) NSInteger ZqIntencnt;
/** 关注人数 */
@property (nonatomic, assign) NSInteger ZqFollowcnt;
/** 剩余天数 */
@property (nonatomic, assign) NSInteger Syts;
/** 标题 */
@property (nonatomic, copy) NSString *ZqTitle;
/** 状态 */
@property (nonatomic, copy) NSString *ZqState;

@end
