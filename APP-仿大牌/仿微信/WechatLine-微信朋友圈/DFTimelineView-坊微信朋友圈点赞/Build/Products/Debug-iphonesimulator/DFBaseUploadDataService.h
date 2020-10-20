//
//  DFBaseUploadDataService.h
//  coder
//
//  Created by Allen Zhong on 15/5/22.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseDataService.h"

@interface DFBaseUploadDataService : DFBaseDataService

-(void) upload:(NSData *) data success:(RequestSuccess) success;

-(NSString *) getFileType;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com