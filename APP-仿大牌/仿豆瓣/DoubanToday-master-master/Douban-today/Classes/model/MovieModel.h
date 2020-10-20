//
//  MovieModel.h
//  Douban-today
//
//  Created by dzw on 2018/10/26.
//  Copyright © 2018 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

@property (nonatomic, copy) NSString *title;//电影名
@property (nonatomic, copy) NSString *original_title;//电影原名
@property (nonatomic, copy) NSString *movieID;//电影ID
@property (nonatomic, strong) UIImage *postersPath;//海报图片
@property (nonatomic, copy) NSString *average;//评分

@end
