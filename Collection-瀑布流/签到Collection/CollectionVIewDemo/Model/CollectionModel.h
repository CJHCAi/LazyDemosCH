//
//  CollectionModel.h
//  CollectionVIewDemo
//
//  Created by 栗子 on 2017/12/13.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject
//是否选中
@property (nonatomic, assign) BOOL isSelected;
//是否完成
@property (nonatomic, assign) BOOL isComplete;
//第几天
@property (nonatomic, copy) NSString *text;
//图片
@property (nonatomic,strong)UIImage *image;


@end
