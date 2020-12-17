//
//  ZJContact.h
//  ZJIndexContacts
//
//  Created by ZeroJ on 16/10/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJContact : NSObject
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *icon;
// 搜索联系人的方法 (拼音/拼音首字母缩写/汉字)
+ (NSArray<ZJContact *> *)searchText:(NSString *)searchText inDataArray:(NSArray<ZJContact *> *)dataArray;
@end
