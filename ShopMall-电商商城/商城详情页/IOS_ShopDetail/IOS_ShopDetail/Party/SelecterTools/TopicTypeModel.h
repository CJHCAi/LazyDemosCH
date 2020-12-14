//
//  TopicTypeModel.h
//  xtd_app_ios_financePeopleios
//
//  Created by 苟应航 on 2017/11/24.
//  Copyright © 2017年 Xtd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicTypeModel : NSObject
// 栏目名称
@property (nonatomic, copy) NSString *topicName;

// 栏目ID
@property int topicType;

// 子页面标题
@property (nonatomic, copy) NSArray *subTitle;

// 辅助发布
@property (nonatomic, copy) NSArray *publishIndexs;

// 子页面View
@property (nonatomic, copy) NSArray *viewType;

// ViewCellTitle1
@property (nonatomic, copy) NSArray *ViewCellTitle1;
// ViewCellTitle2
@property (nonatomic, copy) NSArray *ViewCellTitle2;

// 列表Cell的布局
@property (nonatomic, copy) NSArray *cellType;

// ListView的类别 0--List 1--瀑布 2--WEB
@property (nonatomic, copy) NSArray *listViewType;


// 下拉选项投标题
@property (nonatomic, copy) NSArray *titlelabe;
@end

