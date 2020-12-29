//
//  AVC_ShortVideo_Config.h
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/30.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  短视频模块的配置类

#ifndef AVC_ShortVideo_Config_h
#define AVC_ShortVideo_Config_h

// Demo模块入口
#define DebugModule 0b111101
#define SDK_VERSION 1


#define SDK_VERSION_BASE 1      //基础版本
#define SDK_VERSION_STANDARD 2  //标准版本
#define SDK_VERSION_CUSTOM 3    //自定义版本


#ifdef __OBJC__
#if SDK_VERSION != SDK_VERSION_BASE
#import "AliyunIConfig.h"
#import "AliyunImage.h"
#endif
#endif

#endif /* AVC_ShortVideo_Config_h */
