//
//  SDEditImageControllerItemsView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/13.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SDEditPhotoDefine = 0,
    SDEditPhotoMain = 1<<0,
    
} SDEditPhotoShowType;

#define maineditfunctionphotoheight MAXSize(146)

@interface SDEditImageControllerItemsView : UIView

@property (nonatomic, strong) NSArray * editList;

@property (nonatomic, assign) SDEditPhotoShowType editPtotoShowType;

@end
