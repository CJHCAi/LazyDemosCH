//
//  HK_LeSeeAddProductDetailDescVC.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//
//  添加商品--商品图文描述
#import "HK_BaseView.h"

@interface HK_LeSeeAddProductDescVC : HKBaseViewController<UIWebViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong)NSString *inHtmlString;

@property (nonatomic,copy) void (^saveCallback)(NSString *htmlString);
@end
