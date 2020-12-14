//
//  DLDownloadUrlModel.h
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DLDownloadUrlModel : JSONModel

@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *name;

@end