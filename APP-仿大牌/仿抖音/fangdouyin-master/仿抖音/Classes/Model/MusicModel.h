//
//  MusicModel.h
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "CardModel.h"
#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import "AuthorModel.h"
#import "MusModel.h"

@interface MusicModel : CardModel
@property(nonatomic,assign)long author_user_id;
@property(nonatomic,assign)int rate;
@property(nonatomic,strong)VideoModel *video;
@property(nonatomic,strong)AuthorModel *author;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,strong)MusModel *music;

+(NSArray<MusicModel*>*)models;
@end
