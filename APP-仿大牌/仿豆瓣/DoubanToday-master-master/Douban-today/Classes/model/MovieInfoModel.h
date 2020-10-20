//
//  MovieInfoModel.h
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieInfoModel : NSObject
@property (nonatomic, copy) NSString *mobile_url;//移动端影评页
@property (nonatomic, copy) NSString *title;//电影名
@property (nonatomic, copy) NSString *original_title;//电影原名
@property (nonatomic, copy) NSString *summary;//简介
@property (nonatomic, copy) NSString *movieId;//id
@property (nonatomic, strong) UIImage *posters;//海报
@property (nonatomic, copy) NSString *average;//评分
@end
