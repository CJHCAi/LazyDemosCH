//
//  ImageEditViewController.h
//  housefinder
//
//  Created by zhengying on 7/24/13.
//  Copyright (c) 2013 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFImageEditorViewController.h"

typedef void (^UserDoneCallBack)(UIImage* doneImage, NSString* doneImageID, BOOL isOK);

@interface ImageEditViewController : HFImageEditorViewController

-(HFImageEditorDoneCallback)commonDoneCallbackWithUserDoneCallBack:(UserDoneCallBack)usercallback;

@end
