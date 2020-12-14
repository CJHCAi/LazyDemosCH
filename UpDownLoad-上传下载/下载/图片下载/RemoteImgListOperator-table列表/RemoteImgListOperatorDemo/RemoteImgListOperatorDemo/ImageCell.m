//
//  ImageCell.m
//  RemoteImgListOperatorDemo
//
//  Created by jimple on 14-1-7.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "ImageCell.h"
#import "RemoteImgListOperator.h"

@interface ImageCell ()

@property (nonatomic, strong) IBOutlet UIImageView *m_imgView;
@property (nonatomic, strong) IBOutlet UILabel *m_labelMsg;

@property (nonatomic, readonly) RemoteImgListOperator *m_objRemoteImgListOper;
@property (nonatomic, readonly, copy) NSString *m_strURL;

@end

@implementation ImageCell
@synthesize m_objRemoteImgListOper = _objRemoteImgListOper;
@synthesize m_strURL = _strURL;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    self.m_imgView.image = nil;
    self.m_labelMsg.text = @"";
    
    [super prepareForReuse];
}

- (void)setRemoteImgOper:(RemoteImgListOperator *)objOper
{
    if (_objRemoteImgListOper != objOper)
    {
        if (_objRemoteImgListOper)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_objRemoteImgListOper.m_strSuccNotificationName object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:_objRemoteImgListOper.m_strFailedNotificationName object:nil];
        }else{}
        
        _objRemoteImgListOper = objOper;
        
        if (_objRemoteImgListOper)
        {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(remoteImgSucc:)
                                                         name:_objRemoteImgListOper.m_strSuccNotificationName
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(remoteImgFailed:)
                                                         name:_objRemoteImgListOper.m_strFailedNotificationName
                                                       object:nil];
        }else{}
    }else{}
}

- (void)showImgByURL:(NSString *)strURL
{
    _strURL = strURL ? strURL : @"";
    self.m_labelMsg.text = [NSString stringWithFormat:@"开始下载... %@", _strURL];
    
    __block NSString *blockStrURL = [strURL copy];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (blockStrURL.length > 1)
            {
                // 从网络下载
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (_objRemoteImgListOper)
                    {
                        [_objRemoteImgListOper getRemoteImgByURL:blockStrURL withProgress:nil];
                    }else{}
                });
            }else{}
        });
    });
}

#pragma mark - RemoteImgListOper notification
// 响应下载完成的通知，并显示图片。
- (void)remoteImgSucc:(NSNotification *)noti
{
    if (noti && noti.userInfo && noti.userInfo.allKeys && (noti.userInfo.allKeys.count > 0))
    {
        NSString *strURL;
        NSData *dataImg;
        
        strURL = [noti.userInfo.allKeys objectAtIndex:0];
        dataImg = [noti.userInfo objectForKey:strURL];
        if (_strURL && [_strURL isEqualToString:strURL])
        {
            self.m_labelMsg.text = [NSString stringWithFormat:@"下载成功 %@", _strURL];
            self.m_imgView.image = [UIImage imageWithData:dataImg];
        }else{}
        
    }else{}
}

- (void)remoteImgFailed:(NSNotification *)noti
{
    if (noti && noti.userInfo && noti.userInfo.allKeys && (noti.userInfo.allKeys.count > 0))
    {
        NSString *strURL;
        strURL = [noti.userInfo.allKeys objectAtIndex:0];
        if (_strURL && [_strURL isEqualToString:strURL])
        {
            self.m_labelMsg.text = [NSString stringWithFormat:@"下载失败 %@", _strURL];
        }else{}
        
    }else{}
}



@end
