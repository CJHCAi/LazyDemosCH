//
//  VideoEditViewController.m
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/3/19.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import "VideoEditViewController.h"
#import "Masonry.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SVProgressHUD.h"
#import <CoreImage/CoreImage.h>
#import "Mp4VideoWriter.h"
#import <Accelerate/Accelerate.h>
#import "GPUImage.h"
#import "BlurImage.h"
#import "UIImage+Rotate.h"
#import "NHPlayerView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "VideoEditButton.h"
#import "VideoEditSlider.h"
#import "Mp4VideoWriter.h"

//获取导航栏+状态栏的高度
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height


#define weakSelf(type)  __weak typeof(type) weak##type = type;


@interface VideoEditViewController ()<PlayaerDelegete>{
    CGSize playVideoSize;
    BOOL isViewisLoad;
    
    NSTimer *writerTimer;
    
    NSArray *buttonArr;
    VideoEditButton *selectedButton;
    GPUImageMovieWriter *movieWriter;
    GPUImageMovie *movieFile;
    
    NSMutableDictionary *filterValueDic;
    
    UIImage *tempImage;
    

}


@property (strong,nonatomic)UIBarButtonItem *rightItem;
@property (strong,nonatomic)NHPlayerView *editPlayerView;
@property (strong,nonatomic)UIView *actionView;
@property (strong,nonatomic)UIView *editActionView;
@property (strong,nonatomic)VideoEditSlider *playerProgressSlider;

@property (strong,nonatomic)VideoEditButton *lightButton;
@property (strong,nonatomic)VideoEditButton *contrastButton;
@property (strong,nonatomic)VideoEditButton *saturationbutton;
@property (strong,nonatomic)VideoEditButton *colorTemperatureButton;
@property (strong,nonatomic)VideoEditButton *sharpnessButton;
@property (strong,nonatomic)VideoEditButton *drakButton;

@property (strong,nonatomic)UILabel *editValueLabel;

@property (strong,nonatomic)AVPlayerItemVideoOutput *videoOutPut;

@property (strong,nonatomic)GPUImageFilterGroup *filterGroup;

@property (strong,nonatomic)NSString *fileSavePath;

@property (strong,nonatomic)NSTimer *wtriterTimer;

@property (assign,nonatomic)BOOL isWriterVideo;

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"画面调色"];
    isViewisLoad = YES;

    AVURLAsset * asset = [AVURLAsset assetWithURL:_playUrl];
    NSArray *array = asset.tracks;
    CGSize size = CGSizeZero;
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            size = track.naturalSize;
        }
    }
    playVideoSize = CGSizeMake(size.width, size.height);
    
    [self setupUI];
        
    [self.editPlayerView setPlayerURLStr:_playUrl.absoluteString isEdit:YES];
    _videoOutPut = [[AVPlayerItemVideoOutput alloc] init];
    [self.editPlayerView.playerItem addOutput:_videoOutPut];
    selectedButton = _lightButton;
    
    
    
    
    [self.editPlayerView setDelegate:self];
    
    [_editPlayerView.gpuImageView setBackgroundColorRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0f];
    
    
    NSNumber *brightNumber = [NSNumber numberWithFloat:0.0f];
    NSNumber *contrastNumber = [NSNumber numberWithFloat:1.0f];
    NSNumber *saturationNumber = [NSNumber numberWithFloat:1.0f];
    NSNumber *colorTemperaNumber = [NSNumber numberWithFloat:0.0f];
    NSNumber *sharpnessNumber = [NSNumber numberWithFloat:0.0f];
    NSArray *vignetteNumberArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0f],[NSNumber numberWithFloat:1.0f],nil];
    
    float vignetteR = 255.0f/255.0f;
    float vignetteG = 255.0f/255.0f;
    float vignetteB = 255.0f/255.0f;

    NSDictionary *RGBDic = [NSDictionary dictionaryWithObject:@[[NSNumber numberWithFloat:vignetteR],
                                                                [NSNumber numberWithFloat:vignetteG],
                                                                [NSNumber numberWithFloat:vignetteB]] forKey:@[@"R",@"G",@"B"]];
    NSDictionary *vignetteValueDic = [NSDictionary dictionaryWithObjects:@[vignetteNumberArray,RGBDic] forKeys:@[@"VignetteValue",@"VignetteColor"]];
    

    
    filterValueDic = [NSMutableDictionary dictionaryWithObjects:@[brightNumber,contrastNumber,saturationNumber,colorTemperaNumber,sharpnessNumber,vignetteValueDic] forKeys:@[@"Brightness",@"Contrast",@"Saturation",@"ColorTemperature",@"Sharpness",@"Vignette"]];
    
    
    _filterGroup = [[GPUImageFilterGroup alloc]init];
    
    
    [self FilterGroupGetVlue:_filterGroup];
    
    
    [_editPlayerView.gpuImageMovie addTarget:_filterGroup];
    [_filterGroup addTarget:_editPlayerView.gpuImageView];
    
    
    _editPlayerView.videoRotation = [self degressFromVideoFileWithURL:asset];
    
    NSLog(@"Video W = %f Video H = %f videoRotation = %ld",playVideoSize.width,playVideoSize.height,(long)_editPlayerView.videoRotation);
    
    //监听挂起时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_editPlayerView playerPause];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //只调用一次此方法。防止其他操作再次调用。
    if (isViewisLoad == YES) {
        isViewisLoad = NO;
        [_editPlayerView playerPlay];
        //[_editPlayerView.gpuImageMovie cancelProcessing];
        [_editPlayerView.gpuImageMovie startProcessing];
        
        [_editPlayerView createVideoView];
    }
}



#pragma mark -- UI
-(void)setupUI{
        
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [rightButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:7.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [rightButton setTitle:@"导出" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(importEditMovie) forControlEvents:UIControlEventTouchUpInside];
    _rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:_rightItem];
    
    [self.view addSubview:self.editPlayerView];
    [self.editPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(getRectNavAndStatusHight);
        make.left.right.mas_offset(0);
        make.height.mas_offset((self.view.frame.size.height-getRectNavAndStatusHight)*15/24);
    }];
    

    
    [self.view addSubview:self.actionView];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editPlayerView.mas_bottom).offset(0);
        make.left.right.bottom.mas_offset(0);
    }];
    
    
    [self.actionView addSubview:self.editActionView];
    [self.editActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.actionView);
        make.top.mas_offset(((self.view.frame.size.height-getRectNavAndStatusHight) - (self.view.frame.size.height-getRectNavAndStatusHight)*15/24)/15);
        make.height.mas_offset(75 * self.view.frame.size.width/640);
        make.width.mas_offset(self.view.frame.size.width * 1.0);
    }];
    
    [self.lightButton setCanTouch:YES];
    [self.editActionView addSubview:self.lightButton];
    [self.editActionView addSubview:self.contrastButton];
    [self.editActionView addSubview:self.saturationbutton];
    [self.editActionView addSubview:self.colorTemperatureButton];
    [self.editActionView addSubview:self.sharpnessButton];
    [self.editActionView addSubview:self.drakButton];
    
    
    
    buttonArr = [NSArray arrayWithObjects:
                          self.lightButton,
                          self.contrastButton,
                          self.saturationbutton,
                          self.colorTemperatureButton,
                          self.sharpnessButton,
                          self.drakButton,
                          nil];
    [buttonArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.width.height.mas_offset(75 * self.view.frame.size.width/640);
    }];
    
    [buttonArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:75 * self.view.frame.size.width/640 leadSpacing:15 tailSpacing:15];

 
    [self.editValueLabel setText:@"亮度0"];
    [self.actionView addSubview:self.editValueLabel];
    [self.editValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.actionView);
        make.top.equalTo(self.editActionView.mas_bottom).offset(((self.view.frame.size.height-getRectNavAndStatusHight) - (self.view.frame.size.height-getRectNavAndStatusHight)*2/3)/14);
        make.width.mas_offset(self.view.frame.size.width * 0.7);
        make.height.mas_offset(40);
    }];
    
    
    [self.actionView addSubview:self.playerProgressSlider];
    [self.playerProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.actionView);
        make.top.equalTo(self.editValueLabel.mas_bottom).offset(((self.view.frame.size.height-getRectNavAndStatusHight) - (self.view.frame.size.height-getRectNavAndStatusHight)*2/3)/14);
        make.width.mas_offset(self.view.frame.size.width * 0.8);
        make.height.mas_offset(15);
    }];
    
    
    [_lightButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_contrastButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_saturationbutton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_colorTemperatureButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_sharpnessButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    [_drakButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    
    
}


-(void)selectedTheButton:(VideoEditButton *)touchButton{
    for (VideoEditButton *button in buttonArr) {
        if (button == touchButton) {
            [button setCanTouch:YES];
        }else{
            [button setCanTouch:NO];
        }
    }
}

#pragma mark -- ACTION
/**视频编辑按钮的点击*/
-(void)touchVideoEdtionButton:(id)sender{
    VideoEditButton *button = (VideoEditButton *)sender;
    selectedButton = button;
    if (button == _lightButton) {
        
 
        [_editValueLabel setText:[NSString stringWithFormat:@"亮度%.2f",_lightButton.value]];
        _playerProgressSlider.value = _lightButton.value;
        
        
    }else if (button == _contrastButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"对比度%.2f",_contrastButton.value]];
        _playerProgressSlider.value = _contrastButton.value;
    }else if (button == _saturationbutton){
        [_editValueLabel setText:[NSString stringWithFormat:@"饱和度%.2f",_saturationbutton.value]];
        _playerProgressSlider.value = _saturationbutton.value;
    }else if (button == _colorTemperatureButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"色温%.2f",_colorTemperatureButton.value]];
        _playerProgressSlider.value = _colorTemperatureButton.value;
    }else if (button == _sharpnessButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"锐度%.2f",_sharpnessButton.value]];
        _playerProgressSlider.value = _sharpnessButton.value;
    }else if(button == _drakButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"暗角%.2f",_drakButton.value]];
        _playerProgressSlider.value = _drakButton.value;
    }else{
        
        return;
    }
    
    
    [self selectedTheButton:button];
}

- (void)addGPUImageFilter:(GPUImageOutput<GPUImageInput> *)filter withGroupFilter:(GPUImageFilterGroup *)groupFilter
{
    [groupFilter addFilter:filter];
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;
    
    NSInteger count = groupFilter.filterCount;
    
    if (count == 1)
    {
        groupFilter.initialFilters = @[newTerminalFilter];
        groupFilter.terminalFilter = newTerminalFilter;
        
    } else{
        GPUImageOutput<GPUImageInput> *terminalFilter    = groupFilter.terminalFilter;
        NSArray *initialFilters                          = groupFilter.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];
        
        groupFilter.initialFilters = @[initialFilters[0]];
        groupFilter.terminalFilter = newTerminalFilter;
    }
}


-(void)playStatusEnd{
    if(_filterGroup){
        tempImage = [self getFirstTimeImage];
        if (tempImage) {
            [_editPlayerView.videoView setImage:[_filterGroup imageByFilteringImage:tempImage]];
        }
    }

    [_editPlayerView.videoView setHidden:NO];
    
    
}

-(void)playStatusChangeisPlay:(BOOL)isPlay{
    if(_filterGroup){
        tempImage = [self getCurrentImage];
        if (tempImage) {
            [_editPlayerView.videoView setImage:[_filterGroup imageByFilteringImage:tempImage]];
        }
    }
    
    
    if (isPlay) {
        [_editPlayerView.videoView setHidden:YES];
    }else{

        [_editPlayerView.videoView setHidden:NO];
    }
    
}

-(void)FilterGroupGetVlue:(GPUImageFilterGroup *)filterGroup{
    
    GPUImageBrightnessFilter *brightFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightFilter setBrightness:[filterValueDic[@"Brightness"] floatValue]];
    [self addGPUImageFilter:brightFilter withGroupFilter:filterGroup];
    
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc]init];
    [contrastFilter setContrast:[filterValueDic[@"Contrast"] floatValue]];
    [self addGPUImageFilter:contrastFilter withGroupFilter:filterGroup];
    
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc]init];
    [saturationFilter setSaturation:[filterValueDic[@"Saturation"] floatValue]];
    [self addGPUImageFilter:saturationFilter withGroupFilter:filterGroup];
    
    
    GPUImageWhiteBalanceFilter *colorTemperatureFilter = [[GPUImageWhiteBalanceFilter alloc]init];
    colorTemperatureFilter.temperature = 5000.0f;
    colorTemperatureFilter.tint = [filterValueDic[@"ColorTemperature"] floatValue];
    [self addGPUImageFilter:colorTemperatureFilter withGroupFilter:filterGroup];
    
    GPUImageSharpenFilter *sharpnessFilter = [[GPUImageSharpenFilter alloc]init];
    [sharpnessFilter setSharpness:[filterValueDic[@"Sharpness"] floatValue]];
    [self addGPUImageFilter:sharpnessFilter withGroupFilter:filterGroup];
    
    GPUImageVignetteFilter *vignetteFilter = [[GPUImageVignetteFilter alloc]init];
    NSDictionary *vignetteFilterDic = filterValueDic[@"Vignette"];
    NSArray *darkValueArray = vignetteFilterDic[@"VignetteValue"];
    [vignetteFilter setVignetteStart:[darkValueArray[0] floatValue]];
    [vignetteFilter setVignetteEnd:[darkValueArray[1] floatValue]];
    NSDictionary *vignetteFilterColorDic = vignetteFilterDic[@"VignetteColor"];
    float R = [vignetteFilterColorDic[@"R"] floatValue];
    float G = [vignetteFilterColorDic[@"G"] floatValue];
    float B = [vignetteFilterColorDic[@"B"] floatValue];

    GPUVector3 gpuColor = {R,G,B};
    [vignetteFilter setVignetteColor:gpuColor];
    [self addGPUImageFilter:vignetteFilter withGroupFilter:filterGroup];
    
}



-(NSUInteger)degressFromVideoFileWithURL:(AVAsset *)asset{
    NSUInteger degress = 0;
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    
    return degress;
}


-(UIImage *)getCurrentImage
{
    CMTime itemTime = _editPlayerView.player.currentItem.currentTime;
    CVPixelBufferRef pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    if (pixelBuffer) {
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext
                                 createCGImage:ciImage
                                 fromRect:CGRectMake(0, 0,
                                                     CVPixelBufferGetWidth(pixelBuffer),
                                                     CVPixelBufferGetHeight(pixelBuffer))];
        //当前帧的画面
        UIImage *currentImage = [UIImage imageWithCGImage:videoImage];
        CGImageRelease(videoImage);
        if (pixelBuffer) {
            CVPixelBufferRelease(pixelBuffer);
        }
        return currentImage;
    }else{
        return nil;
    }
}

-(UIImage *)getFirstTimeImage
{
    CVPixelBufferRef pixelBuffer = [_videoOutPut copyPixelBufferForItemTime:CMTimeMake(0, 1) itemTimeForDisplay:nil];
    if (pixelBuffer) {
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        CIContext *temporaryContext = [CIContext contextWithOptions:nil];
        CGImageRef videoImage = [temporaryContext
                                 createCGImage:ciImage
                                 fromRect:CGRectMake(0, 0,
                                                     CVPixelBufferGetWidth(pixelBuffer),
                                                     CVPixelBufferGetHeight(pixelBuffer))];
        //当前帧的画面
        UIImage *currentImage = [UIImage imageWithCGImage:videoImage];
        CGImageRelease(videoImage);
        if (pixelBuffer) {
            CVPixelBufferRelease(pixelBuffer);
        }
        return currentImage;
    }else{
        return nil;
    }
}





#pragma mark ----------------------------SliderChange-------------------------
-(void)filterSliderChange{
    if (_filterGroup.filterCount < 6) {
        return;
    }
    float value = self.playerProgressSlider.value;
    
    if (selectedButton == _lightButton) {
        
        GPUImageBrightnessFilter *brightFilter = (GPUImageBrightnessFilter *)[_filterGroup filterAtIndex:0];
        [_editValueLabel setText:[NSString stringWithFormat:@"亮度%.2f",value]];
        [brightFilter setBrightness:value];
        [filterValueDic setObject:[NSNumber numberWithFloat:value] forKey:@"Brightness"];
        _lightButton.value = value;
    }else if (selectedButton == _contrastButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"对比度%.2f",value]];
        GPUImageContrastFilter *contrastFilter = (GPUImageContrastFilter *)[_filterGroup filterAtIndex:1];
        [contrastFilter setContrast:value+1.0f];
        _contrastButton.value = value;
        [filterValueDic setObject:[NSNumber numberWithFloat:value+1.0f] forKey:@"Contrast"];
        
    }else if (selectedButton == _saturationbutton){
        [_editValueLabel setText:[NSString stringWithFormat:@"饱和度%.2f",value]];
        GPUImageSaturationFilter *saturationFilter = (GPUImageSaturationFilter *)[_filterGroup filterAtIndex:2];
        [saturationFilter setSaturation:value+1.0f];
        _saturationbutton.value = value;
        [filterValueDic setObject:[NSNumber numberWithFloat:value+1.0f] forKey:@"Saturation"];
    }else if (selectedButton == _colorTemperatureButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"色温%.2f",value]];
        GPUImageWhiteBalanceFilter *colorTemperatureFilter = (GPUImageWhiteBalanceFilter *)[_filterGroup filterAtIndex:3];
        colorTemperatureFilter.tint = value*500.0f;
        _colorTemperatureButton.value = value;
        [filterValueDic setObject:[NSNumber numberWithFloat:value*500.0f] forKey:@"ColorTemperature"];
    }else if (selectedButton == _sharpnessButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"锐度%.2f",value]];
        GPUImageSharpenFilter *sharpnessFilter = (GPUImageSharpenFilter *)[_filterGroup filterAtIndex:4];
        sharpnessFilter.sharpness = value*4;
        _sharpnessButton.value = value;
        [filterValueDic setObject:[NSNumber numberWithFloat:value*4] forKey:@"Sharpness"];
        
    }else if(selectedButton == _drakButton){
        [_editValueLabel setText:[NSString stringWithFormat:@"暗角%.2f",value]];
        GPUImageVignetteFilter *vignetteFilter = (GPUImageVignetteFilter *)[_filterGroup filterAtIndex:5];
        float StartValue = 0.8f;
        float EndValue = 0.8f;
        float R = 255.0f/255.0f;
        float G = 255.0f/255.0f;
        float B = 255.0f/255.0f;

  
        
        if (value > 0.0) {

            R = 255.0f/255.0f;
            G = 255.0f/255.0f;
            B = 255.0f/255.0f;
            
            GPUVector3 color = {R,G,B};
            
            [vignetteFilter setVignetteColor:color];
            
            StartValue = 0.8f - value*1.6f;
            
            [vignetteFilter setVignetteStart:StartValue];
            
            [vignetteFilter setVignetteEnd:EndValue];


        }else{
            R = 0.0f/255.0f;
            G = 0.0f/255.0f;
            B = 0.0f/255.0f;
            
            GPUVector3 color = {R,G,B};
            
            [vignetteFilter setVignetteColor:color];
            
            StartValue = 0.8f + value*1.6f;

            [vignetteFilter setVignetteStart:StartValue];
            
            [vignetteFilter setVignetteEnd:EndValue];
        }
        
        
        NSArray *vignetteFilterValueArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:StartValue],[NSNumber numberWithFloat:EndValue], nil];
        
        
        
        NSDictionary *RGBDic = [NSDictionary dictionaryWithObjects:@[[NSNumber numberWithFloat:R],
                                                                    [NSNumber numberWithFloat:G],
                                                                    [NSNumber numberWithFloat:B]] forKeys:@[@"R",@"G",@"B"]];
        
        
        NSDictionary *vignetteFilterDic = [NSDictionary dictionaryWithObjects:@[vignetteFilterValueArray,RGBDic] forKeys:@[@"VignetteValue",@"VignetteColor"]];
        
        
        [filterValueDic setObject:vignetteFilterDic forKey:@"Vignette"];
        
    }else{
        
        return;
    }
    if (_editPlayerView.player.rate == 0.0) {
        @autoreleasepool {
        if (tempImage) {
            UIImage *newImge = [_filterGroup imageByFilteringImage:tempImage];
            [_editPlayerView.videoView setImage:newImge];
        }
        }
    }
}




#pragma mark ----------------------------SliderEnd-------------------------
-(void)filterSliderEnd{

}




#pragma mark ----------------------------滑动手势返回处理-------------------------
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    [_editPlayerView stopPlayer];
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        NSLog(@"页面pop成功了");
    }
}


#pragma mark ----------------------------进入后台-------------------------
-(void)EnterBackgroundNotification{
    if(movieWriter){
        if (_wtriterTimer) {
            [_wtriterTimer invalidate];
        }
        [movieWriter setPaused:YES];
    }
    
    [_editPlayerView.gpuImageMovie endProcessing];
}



#pragma mark ----------------------------将要进入前台-------------------------
-(void)WillEnterForegroundNotification{
    if(movieWriter){
        if (_isWriterVideo) {
            [_wtriterTimer invalidate];
            _wtriterTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(writerVideoProgress) userInfo:nil repeats:YES];
        }
        [movieWriter setPaused:NO];
        
    }
    
    [_editPlayerView.gpuImageMovie startProcessing];
}






-(void)writerVideoProgress{
    [SVProgressHUD showProgress:movieFile.progress status:@"正在导出视频..."];
    
}

#pragma mark ----------------------------合成视频点击事件-------------------------
/**
 使用GPUImage加载水印
 
 @param vedioPath 视频路径
 @param fileName 生成之后的视频名字
 */
-(void)saveVedioPath:(NSURL*)vedioPath WithFileName:(NSString*)fileName
{
    
   
    // 滤镜
    NSURL *sampleURL  = vedioPath;
    AVAsset *asset = [AVAsset assetWithURL:sampleURL];
    
    movieFile = [[GPUImageMovie alloc] initWithAsset:asset];
    movieFile.playAtActualSpeed = NO;
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.mp4",fileName]];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:playVideoSize];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(_editPlayerView.videoRotation / 180.0 * M_PI );
    movieWriter.transform = rotate;
    [SVProgressHUD showProgress:0.0 status:@"正在导出视频..."];
    
    GPUImageFilterGroup *group = [[GPUImageFilterGroup alloc]init];
    
    [self FilterGroupGetVlue:group];
    
   // [group addTarget:filter];
    [movieFile addTarget:group];

    
    movieWriter.shouldPassthroughAudio = YES;
    if ([[asset tracksWithMediaType:AVMediaTypeAudio] count] > 0){
        movieFile.audioEncodingTarget = movieWriter;
    } else {//no audio
        movieFile.audioEncodingTarget = nil;
    }
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];
    // 显示到界面
    [group addTarget:movieWriter];
    [movieWriter startRecording];
    [movieFile startProcessing];
    
    _isWriterVideo = YES;
    
    [_wtriterTimer invalidate];
    _wtriterTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(writerVideoProgress) userInfo:nil repeats:YES];

    
    
    __weak typeof(self) weakSelf = self;
    [movieWriter setFailureBlock:^(NSError *error) {
        [weakSelf.wtriterTimer invalidate];
        weakSelf.isWriterVideo = NO;
        __strong typeof(self) strongSelf = weakSelf;
        [group removeTarget:strongSelf->movieWriter];
        NSLog(@"error = %@",error);
    }];
    
    //保存相册
    [movieWriter setCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.wtriterTimer invalidate];
            __strong typeof(self) strongSelf = weakSelf;
            [group removeTarget:strongSelf->movieWriter];
            [strongSelf->movieWriter finishRecording];
            weakSelf.isWriterVideo = NO;
            __block PHObjectPlaceholder *placeholder;
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
            {
                NSError *error;
                [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
                    PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:movieURL];
                    placeholder = [createAssetRequest placeholderForCreatedAsset];
                } error:&error];
                if (error) {
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error] hideInterVal:1.0f];
                }
                else{
                    [SVProgressHUD showSuccessWithStatus:@"视频已经保存到相册" hidewithInterVal:1.0f];
                }
            }
        });
    }];
}


#pragma mark -----------------------------视频存放位置------------------------
-(NSString *)fileSavePath{
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/myVidio/test.mp4", pathDocuments];//视频存放位置
    NSString *createPath2 = [NSString stringWithFormat:@"%@/myVidio", pathDocuments];//视频存放文件夹
    //判断视频文件是否存在，存在删除
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:createPath];
    if (blHave) {
        BOOL blDele= [fileManager removeItemAtPath:createPath error:nil];
        if (!blDele) {
            [fileManager removeItemAtPath:createPath error:nil];
        }
    }
    //判断视频存放文件夹是否存在，不存在创建
    BOOL blHave1=[[NSFileManager defaultManager] fileExistsAtPath:createPath2];
    if (!blHave1) {
        [fileManager createDirectoryAtPath:createPath2 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    _fileSavePath = createPath;
    
    NSLog(@"视频输出地址 fileSavePath = %@",_fileSavePath);
    
    return _fileSavePath;
}





-(void)importEditMovie{
    
    [self.editPlayerView stopPlayer];
    [self saveVedioPath:_playUrl WithFileName:@"test.mp4"];
    
  //  [self readMovie:_playUrl];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_wtriterTimer invalidate];
    [_editPlayerView playerPause];
    [_filterGroup removeAllTargets];
    [_editPlayerView.gpuImageMovie removeAllTargets];
    [_editPlayerView.gpuImageMovie endProcessing];
    [_editPlayerView.gpuImageMovie cancelProcessing];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"player dealloc");
}

#pragma mark -- LAZY
-(VideoEditButton *)lightButton{
    if (!_lightButton) {
        _lightButton = [[VideoEditButton alloc]initWithButtonImage:[UIImage imageNamed:@"tiaose_liangdu"] ButtonTitle:@"亮度"];
        [_lightButton addTarget:self action:@selector(touchVideoEdtionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _lightButton;
}

-(VideoEditButton *)contrastButton{
    if (!_contrastButton) {
        _contrastButton = [[VideoEditButton alloc]initWithButtonImage:[UIImage imageNamed:@"tiaose_duibidu"] ButtonTitle:@"对比度"];
        [_contrastButton addTarget:self action:@selector(touchVideoEdtionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contrastButton;
}


-(VideoEditButton *)saturationbutton{
    if (!_saturationbutton) {
        _saturationbutton = [[VideoEditButton alloc]initWithButtonImage:[UIImage imageNamed:@"tiaose_baohedu"] ButtonTitle:@"饱和度"];
        [_saturationbutton addTarget:self action:@selector(touchVideoEdtionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saturationbutton;
}

-(VideoEditButton *)colorTemperatureButton{
    if (!_colorTemperatureButton) {
        _colorTemperatureButton = [[VideoEditButton alloc]initWithButtonImage:[UIImage imageNamed:@"tiaose_sewen"] ButtonTitle:@"色温"];
        [_colorTemperatureButton addTarget:self action:@selector(touchVideoEdtionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colorTemperatureButton;
}

-(VideoEditButton *)sharpnessButton{
    if (!_sharpnessButton) {
        _sharpnessButton = [[VideoEditButton alloc]initWithButtonImage:[UIImage imageNamed:@"tiaose_ruidu"] ButtonTitle:@"锐度"];
        [_sharpnessButton addTarget:self action:@selector(touchVideoEdtionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharpnessButton;
}


-(VideoEditButton *)drakButton{
    if (!_drakButton) {
        _drakButton = [[VideoEditButton alloc]initWithButtonImage:[UIImage imageNamed:@"tiaose_anjiao"] ButtonTitle:@"暗角"];
        [_drakButton addTarget:self action:@selector(touchVideoEdtionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _drakButton;
}

-(UILabel *)editValueLabel{
    if (!_editValueLabel) {
        _editValueLabel = [[UILabel alloc]init];
        [_editValueLabel setFont:[UIFont systemFontOfSize:18]];
        [_editValueLabel setTextColor:[UIColor whiteColor]];
        [_editValueLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _editValueLabel;
}



-(VideoEditSlider *)playerProgressSlider{
    if (!_playerProgressSlider) {
        // 进度条
        _playerProgressSlider = [[VideoEditSlider alloc] init];
        [_playerProgressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [_playerProgressSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];
        // 最初的颜色
        _playerProgressSlider.maximumTrackTintColor = [UIColor colorWithRed:73.0f/255.0f green:73.0f/255.0f blue:73.0f/255.0f alpha:1.0];
        // 划过之后的颜色
        _playerProgressSlider.minimumTrackTintColor = [UIColor whiteColor];
        [_playerProgressSlider setMaximumValue:0.5f];
        [_playerProgressSlider setMinimumValue:-0.5f];
        [_playerProgressSlider setValue:0.0f];
        // 添加响应事件
        [_playerProgressSlider addTarget:self action:@selector(filterSliderChange) forControlEvents:UIControlEventValueChanged];
        [_playerProgressSlider addTarget:self action:@selector(filterSliderEnd) forControlEvents:UIControlEventTouchUpInside];
        [_playerProgressSlider setVideoEditEnum:VideoEditLight];
    }
    return _playerProgressSlider;
}


-(NHPlayerView *)editPlayerView{
    if (!_editPlayerView) {
        _editPlayerView = [[NHPlayerView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height-getRectNavAndStatusHight)*15/24)];
        _editPlayerView.backgroundColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:1.0];
    }
    return _editPlayerView;
}



-(UIView *)actionView{
    if (!_actionView) {
        _actionView = [[UIView alloc]init];
        [_actionView setBackgroundColor:[UIColor colorWithRed:28.0f/255.0f green:28.0f/255.0f blue:28.0f/255.0f alpha:1.0]];
    }
    return _actionView;
}

-(UIView *)editActionView{
    if (!_editActionView) {
        _editActionView = [[UIView alloc]init];
    }
    return _editActionView;
}

@end
