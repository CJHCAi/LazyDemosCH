//
//  AliyunVideoUIConfig.h
//  AliyunVideoSDK
//
//  Created by TripleL on 17/5/4.
//  Copyright (C) 2010-2017 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AliyunVideoRecordType) {
    AliyunVideoRecordTypeCombination = 0,  /* 混合模式（短按自动录制，再次短按停止录制+长按录制，松开停止录制）*/
    AliyunVideoRecordTypeClick,            /* 短按模式（短按自动录制，再次短按停止录制）*/
    AliyunVideoRecordTypeHold              /* 长按模式（长按录制，松开停止录制）*/
};

@interface AliyunVideoUIConfig : NSObject

/* 背景颜色 */
@property (nonatomic, strong) UIColor *backgroundColor;
/* 录制进度条 已录制颜色 */
@property (nonatomic, strong) UIColor *timelineTintColor;
/* 录制进度条 背景颜色 */
@property (nonatomic, strong) UIColor *timelineBackgroundCollor;
/* 录制进度条 视频删除部分选中颜色 */
@property (nonatomic, strong) UIColor *timelineDeleteColor;
/* 录制时间提示框 字体颜色 */
@property (nonatomic, strong) UIColor *durationLabelTextColor;
/* 裁剪页裁剪条下边框颜色 */
@property (nonatomic, strong) UIColor *cutBottomLineColor;
/* 裁剪页裁剪条上边框颜色 */
@property (nonatomic, strong) UIColor *cutTopLineColor;


/* 隐藏已录制时间提示框 */
@property (nonatomic, assign) BOOL hiddenDurationLabel;
/* 隐藏美颜按钮 */
@property (nonatomic, assign) BOOL hiddenBeautyButton;
/* 隐藏录制按钮 */
@property (nonatomic, assign) BOOL hiddenCameraButton;
/* 隐藏闪光灯按钮 */
@property (nonatomic, assign) BOOL hiddenFlashButton;
/* 隐藏相册导入按钮 */
@property (nonatomic, assign) BOOL hiddenImportButton;
/* 隐藏删除视频片段按钮 */
@property (nonatomic, assign) BOOL hiddenDeleteButton;
/* 隐藏录制完成按钮 */
@property (nonatomic, assign) BOOL hiddenFinishButton;
/* 是否录制单段视频 */
@property (nonatomic, assign) BOOL recordOnePart;
/* 相册界面是否显示跳转相机按钮 */
@property (nonatomic, assign) BOOL showCameraButton;


/* 录制模式 */
@property (nonatomic, assign) AliyunVideoRecordType recordType;
/* 滤镜名称数组 注：请对应到滤镜bundle的各个滤镜文件名 */
@property (nonatomic, strong) NSArray<NSString *> *filterArray;


/* 录制切换为无滤镜选项时提示文字 */
@property (nonatomic, strong) NSString *noneFilterText;
/* 图片资源存放的BundleName */
@property (nonatomic, strong) NSString *imageBundleName;
/* 滤镜资源存放的BundleName */
@property (nonatomic, strong) NSString *filterBundleName;

@end
