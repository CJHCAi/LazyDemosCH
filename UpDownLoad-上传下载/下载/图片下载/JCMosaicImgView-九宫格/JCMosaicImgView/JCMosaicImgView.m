//
//  JCMosaicImgView.m
//  JCMosaicImgViewDemo
//
//  Created by jimple on 14-1-9.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "JCMosaicImgView.h"
#import "GlobalDefine.h"
#import "RemoteImgListOperator.h"

#define SIZE_ThumbWBImgSize                     Size(80, 60)
#define SIZE_SquareWBImgSize                    Size(100, 100)
#define FLOAT_SquareWBImgSeperator              5.0f

@interface JCMosaicImgView ()

@property (nonatomic, readonly) NSMutableArray *m_arrImgURLs;
@property (nonatomic, readonly) NSMutableArray *m_arrImgView;
@property (nonatomic, readonly) RemoteImgListOperator *m_objImgListOper;

@end

@implementation JCMosaicImgView
@synthesize m_arrImgURLs = _arrImgURLs;
@synthesize m_arrImgView = _arrImgView;
@synthesize m_objImgListOper = _objImgListOper;

// 根据图片数量获取视图大小
+ (CGFloat)imgHeightByImg:(NSArray *)arrImg
{
    // 仅针对九宫格图片
    CGFloat fImgHeight = 0.0f;
    if (arrImg && arrImg.count > 0)
    {
        if (arrImg.count == 1)
        {
            fImgHeight = SIZE_ThumbWBImgSize.height;
        }
        else if (arrImg.count <= 3)
        {
            fImgHeight = SIZE_SquareWBImgSize.height + FLOAT_SquareWBImgSeperator;
        }
        else if (arrImg.count <= 6)
        {
            fImgHeight = (SIZE_SquareWBImgSize.height + FLOAT_SquareWBImgSeperator) * 2;
        }
        else
        {
            fImgHeight = (SIZE_SquareWBImgSize.height + FLOAT_SquareWBImgSeperator) * 3;
        }
    }else{}
    return fImgHeight;
}

+ (CGFloat)imgWidthByImg:(NSArray *)arrImg
{
    CGFloat fWidth = 0.0f;
    
    if (arrImg && (arrImg.count > 0))
    {
        if (arrImg.count == 1)
        {
            fWidth = SIZE_ThumbWBImgSize.width;
        }
        else
        {
            // 仅针对九宫格图片
            fWidth = (arrImg.count >= 3) ? (SIZE_SquareWBImgSize.width+FLOAT_SquareWBImgSeperator)*3 : ((SIZE_SquareWBImgSize.width+FLOAT_SquareWBImgSeperator) * ((arrImg.count%3)+1));
        }
    }
    
    return fWidth;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initWidget];
        
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 在TableViewCell里，重用时清空内容
- (void)prepareForReuse
{
    if (_arrImgView)
    {
        for (UIImageView *imgView in _arrImgView)
        {
            if (imgView)
            {
                [imgView removeFromSuperview];
            }else{}
        }
    }else{}
    _arrImgView = nil;
    _arrImgURLs = nil;
}

- (void)initWidget
{
    _arrImgURLs = nil;
    _arrImgView = nil;
}

- (NSArray *)allImgViews
{
    return _arrImgView;
}

- (NSArray *)allImgURLs
{
    return _arrImgURLs;
}

// 输入图片URL
- (void)showWithImgURLs:(NSArray *)arrImgURLs
{
    _arrImgView = nil;
    _arrImgURLs = nil;
    
    if (arrImgURLs)
    {
        _arrImgURLs = [[NSMutableArray alloc] initWithArray:arrImgURLs];
        _arrImgView = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _arrImgURLs.count; i++)
        {
            UIImageView *imgView = [self createImgViewAtIndex:i];
            [self addSubview:imgView];
            [_arrImgView addObject:imgView];
        }
        
        for (int iView = 0; iView < _arrImgView.count; iView++)
        {
            UIImageView *imgView = _arrImgView[iView];
            NSString *strURL = _arrImgURLs[iView];
            
            if (strURL && imgView)
            {
                __block NSString *strImgURLBlock  = [strURL copy];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        if (strImgURLBlock && (strImgURLBlock.length > 0))
                        {
                            __block NSData *dataItemImgBlock;
                            
                            // 可先从本地缓存中获取图片
                            // ...
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSInteger index = [self indexOfURL:strImgURLBlock];
                                if ((index != NSNotFound) && _arrImgView && _arrImgView[index])
                                {
                                    UIImageView *imgView = _arrImgView[index];
                                    if (dataItemImgBlock)
                                    {// 本地缓存了图片则直接使用本地缓存
                                        [self setImgData:dataItemImgBlock toView:imgView];
                                    }
                                    else
                                    {// 从网络下载
                                        [self getRemoteImgByURL:strImgURLBlock];
                                    }
                                }else{}
                            });
                        }else{}
                    });
                });
            }else{APP_ASSERT_STOP}
        }
    }else{APP_ASSERT_STOP}
}

- (UIImageView *)createImgViewAtIndex:(NSInteger)i
{
    UIImageView *imgView;
    
    CGRect rcImg = Rect(0.0f, 0.0f, SIZE_SquareWBImgSize.width, SIZE_SquareWBImgSize.height);
    rcImg.origin.x = (SIZE_SquareWBImgSize.width + FLOAT_SquareWBImgSeperator) * (i%3);
    rcImg.origin.y = (SIZE_SquareWBImgSize.height + FLOAT_SquareWBImgSeperator) * (i/3);
    
    imgView = [[UIImageView alloc] initWithFrame:rcImg];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imgView.layer.borderWidth = 0.5f;
    imgView.backgroundColor = RGB(230.0f, 230.0f, 230.0f);
    
    return imgView;
}

- (NSInteger)indexOfURL:(NSString *)strURL
{
    NSInteger iRet = NSNotFound;
    if (strURL && _arrImgURLs)
    {
        iRet = [_arrImgURLs indexOfObject:strURL];
    }else{}
    return iRet;
}

- (NSInteger)indexOfImgView:(UIImageView *)imgView
{
    NSInteger iRet = NSNotFound;
    if (imgView && _arrImgView)
    {
        iRet = [_arrImgView indexOfObject:imgView];
    }
    return iRet;
}

- (void)setImgData:(NSData *)dataImg toView:(UIImageView *)imgView
{
    UIImage *img;
    if (dataImg && imgView)
    {
        img = [UIImage imageWithData:dataImg];
        if (img)
        {
            CGFloat fRatio = img.size.width/img.size.height;
            imgView.contentMode = (fRatio < 0.5f) ? UIViewContentModeScaleAspectFit : UIViewContentModeScaleAspectFill;
            imgView.image = img;
        }else{}
    }else{}
}

#pragma mark - image list operator
// 使用 JCRemoteImgListOperator 进行图片下载
- (void)setImgListOper:(RemoteImgListOperator *)objOper;
{
    if (_objImgListOper != objOper)
    {
        if (_objImgListOper)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_objImgListOper.m_strSuccNotificationName object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_objImgListOper.m_strFailedNotificationName object:nil];
        }else{}
        
        _objImgListOper = objOper;
        
        if (_objImgListOper)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(remoteImgSucc:)
                                                         name:_objImgListOper.m_strSuccNotificationName
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(remoteImgFailed:)
                                                         name:_objImgListOper.m_strFailedNotificationName
                                                       object:nil];
        }else{}
    }else{}
}

#pragma mark - RemoteImgOperStack notification
- (void)remoteImgSucc:(NSNotification *)noti
{
    if (noti && noti.userInfo && noti.userInfo.allKeys && (noti.userInfo.allKeys.count > 0))
    {
        NSString *strURL;
        NSData *dataImg;
        
        strURL = [noti.userInfo.allKeys objectAtIndex:0];
        dataImg = [noti.userInfo objectForKey:strURL];
        if (strURL && dataImg && _arrImgView && _arrImgURLs)
        {
            NSInteger index = [self indexOfURL:strURL];
            if ((index != NSNotFound) && _arrImgView[index])
            {
                UIImageView *imgView = _arrImgView[index];
                [self setImgData:dataImg toView:imgView];
            }
            else{}
        }
        
    }else{APP_ASSERT_STOP}
}

- (void)remoteImgFailed:(NSNotification *)noti
{
    // 下载失败
    // ...
}

#pragma mark - Remote request
- (void)getRemoteImgByURL:(NSString *)strURL
{
    [self getRemoteImgByURL:strURL withProgress:nil];
}

- (void)getRemoteImgByURL:(NSString *)strURL withProgress:(id)progress
{
    if (_objImgListOper)
    {
        [_objImgListOper getRemoteImgByURL:strURL withProgress:progress];
    }else{APP_ASSERT_STOP}
}






@end
