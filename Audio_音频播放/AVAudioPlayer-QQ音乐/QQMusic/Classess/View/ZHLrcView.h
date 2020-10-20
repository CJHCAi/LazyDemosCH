//
//  ZHLrcView.h
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHLrcLabel;

@interface ZHLrcView : UIScrollView
/** 歌词的名称 */
@property (nonatomic, copy) NSString *lrcname;

/** 当前歌曲播放的时间 */
@property (nonatomic, assign) NSTimeInterval currentTime;

/** 外面的Label */
@property (nonatomic, weak) ZHLrcLabel *lrcLabel;

@end
