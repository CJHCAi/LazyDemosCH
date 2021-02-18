//
//  PersonalCenterMyPhotoAlbumsView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/11.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemallInfoModel.h"
@class PersonalCenterMyPhotoAlbumsView;

@protocol  PersonalCenterMyPhotoAlbumsViewDelegate<NSObject>

-(void)clickMoreBtnTo;

@end

@interface PersonalCenterMyPhotoAlbumsView : UIView
/** 代理人*/
@property (nonatomic, weak) id<PersonalCenterMyPhotoAlbumsViewDelegate> delegate;

-(void)reloadData:(NSArray<MemallInfoGrxcModel *> *)grxcArr;
@end
