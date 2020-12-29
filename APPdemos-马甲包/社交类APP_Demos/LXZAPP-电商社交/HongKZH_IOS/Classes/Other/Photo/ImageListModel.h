//
//  ImageListModel.h
//  LHand
//
//  Created by 小华 on 15/6/5.
//  Copyright (c) 2015年 chenstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageListModel : NSObject

@property(nonatomic,copy)NSString *filemd5;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *sequence;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *fileName;
@property(nonatomic,copy)NSString *filetype;
@property(nonatomic,copy)NSString *valid;
@property(nonatomic,copy)NSString *fileUrl ;
@property(nonatomic,copy)NSString *md5operdate;
@property(nonatomic,copy)NSString *uploaddate;



@end
