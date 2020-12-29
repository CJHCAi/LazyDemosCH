//
//  MHAsiNetworkUrl.h
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#ifndef MHProject_MHAsiNetworkUrl_h
#define MHProject_MHAsiNetworkUrl_h


#pragma mark - **********  Pixabay API  **********
// key
#define API_Key @"4137237-fe1ef507106a47d4f5128886a"
// 图片地址
#define KImageURL [NSString stringWithFormat:@"https://pixabay.com/api/?key=%@&image_type=photo",API_Key]
// 搜索图片
#define KSeachURL(Keyword) [NSString stringWithFormat:@"%@&q=%@"KImageURL,Keyword]

/**
 *  API HOST
 */
#define API_HOST @"https://pixabay.com/api/"

// 接口路径全拼
#define PATH(_path) [NSString stringWithFormat:_path, API_HOST]

#endif
