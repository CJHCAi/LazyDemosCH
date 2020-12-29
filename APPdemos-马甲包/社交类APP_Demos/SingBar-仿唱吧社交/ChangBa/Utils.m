//
//  Utils.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "Utils.h"
#import <AFNetworking.h>
#import "RecommendBannersModel.h"
#import "SongsModel.h"
#import "BoardsModel.h"
#import "ContentsModel.h"

#import "HomeBaseClass.h"
#import "PerformBaseClass.h"
#import "PerformanceBaseClass.h"

#import <AVFoundation/AVFoundation.h>

@implementation Utils
//唱歌界面的轮播图
+(void)requestRecommendBannersWithCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URL_SingDianGeTaiPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *resultDic = dic[@"result"];
        NSArray *recommendBannersArr = resultDic[@"recommendBanners"];
        NSArray *recommendBanners = [RecommendBannersModel arrayOfModelsFromDictionaries:recommendBannersArr error:nil];
        callback(recommendBanners);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];
}
//推荐歌曲列表
+(void)requestSongsWithCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URL_SingDianGeTaiPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *resultDic = dic[@"result"];
        NSDictionary *channelshowDic = resultDic[@"channelshow"];
        NSArray *songsArr = channelshowDic[@"songs"];
        NSArray *songs = [SongsModel arrayOfModelsFromDictionaries:songsArr error:nil];
        callback(songs);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];

}
//唱歌界面表头title
+(void)requestTitlesWithCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URL_SingDianGeTaiPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *resultDic = dic[@"result"];
        NSDictionary *channelshowDic = resultDic[@"channelshow"];
        NSDictionary *channelsDic = resultDic[@"channels"];
        NSDictionary *songboardDic = resultDic[@"songboard"];
        NSMutableArray *titles = [NSMutableArray array];
        [titles addObject:channelshowDic[@"title"]];
        [titles addObject:songboardDic[@"title"]];
        [titles addObject:channelsDic[@"title"]];
        callback(titles);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];

}
+(void)requestboardsWithCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URL_SingDianGeTaiPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *resultDic = dic[@"result"];
        NSDictionary *songboardDic = resultDic[@"songboard"];
        NSArray *boardsArr = songboardDic[@"boards"];
        
        NSArray *boards = [BoardsModel arrayOfModelsFromDictionaries:boardsArr error:nil];
        callback(boards);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];

}
+(void)requestContentsWithCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URL_SingDianGeTaiPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSDictionary *resultDic = dic[@"result"];
        NSDictionary *contentsDic = resultDic[@"channels"];
        NSArray *contentsArr = contentsDic[@"contents"];
        
        NSArray *contents = [ContentsModel arrayOfModelsFromDictionaries:contentsArr error:nil];
        callback(contents);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];

}
//第一次用MJExtention想全部解析，有个数组失败了  原来是URL路径错了！！！！！！！！！！！！！
+(void)requestHomesWithUrlPath:(NSString *)urlPath andCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        HomeBaseClass *homeBaseClass = [HomeBaseClass mj_objectWithKeyValues:dic];
        callback(homeBaseClass);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];
}
//精彩表演的数据请求
+(void)requestPerformsWithCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URL_JingCaiBiaoYanPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        PerformBaseClass *performBaseClass = [PerformBaseClass mj_objectWithKeyValues:dic];
        callback(performBaseClass);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];
}
//精彩表演排行榜的数据请求
+(void)requestPerformancesWithCallback:(MyCallback)callback{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager new];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URL_PerfoermancePath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        
        PerformanceBaseClass *performanceBaseClass = [PerformanceBaseClass mj_objectWithKeyValues:dic];
        callback(performanceBaseClass);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        callback(nil);
    }];

}
//获取音乐播放路径
+(NSDictionary *)getMusicInfoByPath:(NSString *)path{
    
    NSMutableDictionary *retDic = [NSMutableDictionary dictionary];
    
    NSURL *u = [NSURL fileURLWithPath:path];
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:u options:nil];
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            if(metadataItem.commonKey)
                [retDic setObject:metadataItem.value forKey:metadataItem.commonKey];
            
        }
    }
    
    return retDic;
}
//获取音乐歌词
+(NSDictionary *)parseLrcWithPath:(NSString *)path{
    //得到完整的歌词字符串
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //得到每一行
    NSArray *lines = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableDictionary *lrcDic = [NSMutableDictionary dictionary];
    //遍历每一行
    for (NSString *line in lines) {
        //分割出时间和歌词
        NSArray *timeAndText = [line componentsSeparatedByString:@"]"];
        //取出歌词内容
        NSString *text = [timeAndText lastObject];
        //取出时间字符串
        NSString *timeString = [[timeAndText firstObject] substringFromIndex:1];
        //分割出分和秒
        NSArray *timeArr = [timeString componentsSeparatedByString:@":"];
        //得到秒数
        float time = [timeArr[0] intValue]*60+[timeArr[1] floatValue];
        
        //把歌词和时间的对应关系存到字典中
        [lrcDic setObject:text forKey:@(time)];
        
    }
    //把得到的歌词相关字典返回
    return lrcDic;
    
    
}
+(NSString *)parseTimeWithTimeStap:(float)timestap{
    
    timestap/=1000;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timestap];
    
    //获取当前时间对象
    NSDate *nowDate = [NSDate date];
    
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime-timestap;
    if (time<60) {
        return @"刚刚";
    }else if (time<3600){
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if (time<3600*24){
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
}
+(void)faceMappingWithText:(YYTextView *)tv{
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    NSMutableDictionary *mapperDic = [NSMutableDictionary dictionary];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"default" ofType:@"plist"];
    NSArray *faceArr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *faceDic in faceArr) {
        NSString *imageName = faceDic[@"png"];
        NSString *text = faceDic[@"chs"];
        [mapperDic setObject:[UIImage imageNamed:imageName] forKey:text];
    }
    parser.emoticonMapper = mapperDic;
    tv.textParser = parser;
}
//+(void)playVoiceWithPath:(NSString *)path{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //得到amr音频数据
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
//        //把amr 解码 到wav格式
//        data = DecodeAMRToWAVE(data);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            player = [[AVAudioPlayer alloc]initWithData:data error:nil];
//            [player play];
//        });
//        
//    });
//}

@end
