//
//  WZAssetBrowseToolView.h
//  WZPhotoPicker
//
//  Created by wizet on 2017/6/9.
//  Copyright © 2017年 wizet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZProtocolAssetBrowseTool <NSObject>

- (void)selectedOrigionAction;//选择原尺寸图片的代理事件
- (void)completeAction;//发送代理事件

@end

@interface WZAssetBrowseToolView : UIView

@property (nonatomic, weak) id<WZProtocolAssetBrowseTool> delegate;
@property (nonatomic, strong) void (^fetchClearInfo)(NSString *info);
@property (nonatomic, strong) void (^restrictNumber)(NSUInteger restrictNumber);
@property (nonatomic, strong) UIButton *selectedButtonClear;
@property (nonatomic, strong) UILabel *clearInfoLabel;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UILabel *countLabel;

+ (instancetype)customAssetBrowseToolWithDelegate:(id<WZProtocolAssetBrowseTool>)delegate;

@end
