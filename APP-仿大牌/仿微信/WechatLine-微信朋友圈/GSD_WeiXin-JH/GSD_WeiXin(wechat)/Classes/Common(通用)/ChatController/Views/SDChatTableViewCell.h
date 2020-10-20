//
//  SDChatTableViewCell.h
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/13.
//  Copyright © 2016年 GSD. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDChatModel.h"
#import "MLEmojiLabel.h"

@interface SDChatTableViewCell : UITableViewCell

@property (nonatomic, strong) SDChatModel *model;

@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);

@end
