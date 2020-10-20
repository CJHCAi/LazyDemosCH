//
//  LCSuspendCustomBaseViewController.h
//  LuochuanAD
//
//  Created by care on 17/5/8.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, SuspendType){
    BUTTON    =0,//按钮
    IMAGEVIEW =1,//图片
    GIF       =2,//gif图
    MUSIC     =3,//音乐界面
    VIDEO     =4,//视频界面
    SCROLLVIEW =5,//滚动多图
    OTHERVIEW =6//自定义view
};
@interface LCSuspendCustomBaseViewController : UIViewController
@property (nonatomic, assign) SuspendType suspendType;

@end
