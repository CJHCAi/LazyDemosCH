//
//  YXWSmileViewController.h
//  StarAlarm
//
//  Created by dllo on 16/4/6.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YXWAlarmModel.h"
@interface YXWSmileViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UIDocumentInteractionControllerDelegate> {
    
    UIView *previewView;
    AVCaptureVideoPreviewLayer *mPreviewLayer;
    AVCaptureVideoDataOutput *mVideoDataOutput;
    dispatch_queue_t mVideoDataOutputQueue;
    AVCaptureStillImageOutput *mStillImageOutput;
    CIDetector *mFaceDetector;
    UIImage *mTakenPhoto;

}
@property (strong, nonatomic) UIDocumentInteractionController *documentController;
@property (nonatomic, strong) YXWAlarmModel *alarmModel;

@end
