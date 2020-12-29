//
//  YXWWallPaperViewController.h
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWBaseViewController.h"

@interface YXWWallPaperViewController : YXWBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    UIImageView *imageView;
    NSString* filePath;
}
    
@property (nonatomic, strong) NSString *customName;
@property (nonatomic, strong) NSURL *imageUrl;


@end
