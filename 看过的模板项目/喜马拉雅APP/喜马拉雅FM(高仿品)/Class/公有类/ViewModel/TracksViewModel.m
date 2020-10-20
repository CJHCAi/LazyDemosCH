//
//  TracksViewModel.m
//  喜马拉雅FM(高仿品)
//
//  Created by apple-jd33 on 15/11/26.
//  Copyright © 2015年 HansRove. All rights reserved.
//

#import "TracksViewModel.h"
#import "MoreCotentNetManager.h"
#import "DestinationModel.h"

@interface TracksViewModel ()
@property (nonatomic,strong) DestinationModel *model;
@end

@implementation TracksViewModel

- (instancetype)initWithAlbumId:(NSInteger)albumId title:(NSString *)title isAsc:(BOOL)asc {
    if (self = [super init]) {
        _albumId = albumId;
        _title = title;
        _asc = asc;
    }
    return self;
}

- (void)getDataCompletionHandle:(void (^)(NSError *))completed {
    self.dataTask = [MoreCotentNetManager getTracksForAlbumId:_albumId mainTitle:_title idAsc:_asc completionHandle:^(DestinationModel* responseObject, NSError *error) {
        self.model = responseObject;
        completed(error);
    }];
}

#pragma mark - 返回专辑歌曲单

- (NSInteger)rowNumber {
    return self.model.tracks.list.count;
}
/** 通过行数, 返回标题 */
- (NSString *)titleForRow:(NSInteger)row {
    return self.model.tracks.list[row].title;
    // nickname
}
/** 通过行数, 返回创作人(来源) */
- (NSString *)nickNameForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"by %@",self.model.tracks.list[row].nickname];
}
/** 通过行数, 返回更新时间 */
- (NSString *)updateTimeForRow:(NSInteger)row {
    // 获取当前时时间戳
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳
     NSTimeInterval createTime = self.model.tracks.list[row].createdAt/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}
/** 通过行数, 返回播放次数 */
- (NSString *)playsCountForRow:(NSInteger)row {
    //如果超过万，要显示*.*万
    NSInteger count = self.model.tracks.list[row].playtimes;
    if (count < 10000) {
        return @(self.model.tracks.list[row].playtimes).stringValue;
    }else{
        return [NSString stringWithFormat:@"%.1f万", (CGFloat)count/10000];
    }
}
/** 通过行数, 返回播放时长 */
- (NSString *)playTimeForRow:(NSInteger)row {
    NSTimeInterval duration = self.model.tracks.list[row].duration;
    // 分
    NSInteger minutes = duration/60;
    // 秒
    NSInteger seconds = (NSInteger)duration%60;
    return [NSString stringWithFormat:@"%02ld:%02ld",minutes,seconds];
}
/** 通过行数, 返回评论数 */
- (NSString *)commentCountForRow:(NSInteger)row {
    return @(self.model.tracks.list[row].comments).stringValue;
}
/** 通过行数, 返回收藏喜欢数 */
- (NSString *)favorCountForRow:(NSInteger)row {
    //如果超过万，要显示*.*万
    NSInteger count = self.model.tracks.list[row].likes;
    if (count < 10000) {
        return @(self.model.tracks.list[row].likes).stringValue;
    }else{
        return [NSString stringWithFormat:@"%.1f万", (CGFloat)count/10000];
    } 
}
/** 通过行数, 返回播放地址 */
- (NSURL *)playURLForRow:(NSInteger)row {
    NSString *path = self.model.tracks.list[row].playUrl64;
    return [NSURL URLWithString:path];
}
/** 通过行数, 返回集数图片地址 */
- (NSURL *)coverURLForRow:(NSInteger)row {
    NSString *path = self.model.tracks.list[row].coverSmall;
    return [NSURL URLWithString:path];
}


#pragma mark - 返回专辑标题系列属性
- (NSString *)albumTitle {
    return self.model.album.title;
}
- (NSString *)albumPlays {
    //如果超过万，要显示*.*万
    NSInteger count = self.model.album.playTimes;
    if (count < 10000) {
        return @(self.model.album.playTimes).stringValue;
    }else{
        return [NSString stringWithFormat:@"%.1f万", (CGFloat)count/10000];
    }
}
- (NSString *)albumNickName {
    return self.model.album.nickname;
}
- (NSString *)albumDesc {
    return self.model.album.intro;
}

- (NSURL *)albumCoverURL {
    NSString *path = self.model.album.coverSmall;
    return [NSURL URLWithString:path];
}
- (NSURL *)albumIconURL {
    NSString *path = self.model.album.avatarPath;
    return [NSURL URLWithString:path];
}
- (NSArray *)tagsName {
    return [self.model.album.tags componentsSeparatedByString:@","];
}


@end
