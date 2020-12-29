//
//  URLServices.h
//  WallPaper
//
//  Created by Never on 2017/2/13.
//  Copyright © 2017年 Never. All rights reserved.
//

#ifndef URLServices_h
#define URLServices_h
//服务器地址
#define WallHavenURL @"https://alpha.wallhaven.cc/"
//@"https://w.wallhaven.cc/full/6k/wallhaven-6kwpol.png"
//最新
#define WallLatesURL WallHavenURL@"latest?page=%d"
//搜索
#define WallPaperSearchURL WallHavenURL@"search?q=%@&categories=101&purity=110&sorting=random&order=desc"
//缩略图
#define ThumbURL @"https://th.wallhaven.cc/small/kw/%@.jpg"

#endif /* URLServices_h */
