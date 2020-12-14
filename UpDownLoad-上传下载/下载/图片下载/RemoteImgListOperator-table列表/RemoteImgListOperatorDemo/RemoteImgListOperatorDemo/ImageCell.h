//
//  ImageCell.h
//  RemoteImgListOperatorDemo
//
//  Created by jimple on 14-1-7.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemoteImgListOperator;
@interface ImageCell : UITableViewCell


- (void)setRemoteImgOper:(RemoteImgListOperator *)objOper;
- (void)showImgByURL:(NSString *)strURL;

@end
