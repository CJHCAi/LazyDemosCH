//
//  Mp4VideoWriter.h
//  Inew_Cam
//
//  Created by hjm on 17/2/7.
//  Copyright © 2017年 GaoZhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol Mp4VideoWriterDelegate <NSObject>
@optional

-(void)SaveMp4Succuce:(NSError *)error;

-(void)SaveMp4Faild:(NSError *)error;



@end

@interface Mp4VideoWriter : NSObject

@property (nonatomic, weak) id <Mp4VideoWriterDelegate> delegate;



@property (strong,nonatomic)NSString *YasuoMp4Path;

@property (assign,nonatomic)float fps;

@property (assign,nonatomic)float duration;

@property (assign,nonatomic)NSInteger frameNum;

@property (assign,nonatomic)NSInteger transForm;

@property (assign,nonatomic)BOOL isStart;

@property (assign,nonatomic)BOOL pauseWriter;

-(instancetype) initVideoAudioWriterSize:(CGSize)writerVideoSize;



- (void)writeVideoWithCGImage: (CVPixelBufferRef)frameImage Time:(CMTime)time;

-(void)WritevideoBegain;

-(void)WriteVideoEnd;

- (void)writeAudioBytesWithDataBuffer: (CMSampleBufferRef)sampleBuffer;

- (void)yaSuoShiPinWithfilepathCompletionHandler:(void (^)(void))handler;

@end
