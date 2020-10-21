//
//  CXSearchCollectionReusableView.h
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CXSearchCollectionReusableView;

@protocol UICollectionReusableViewButtonDelegate<NSObject>

- (void)deleteDatas:(CXSearchCollectionReusableView *_Nullable)view;

@end

NS_ASSUME_NONNULL_BEGIN

@interface CXSearchCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) id<UICollectionReusableViewButtonDelegate> delegate;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) BOOL hidenDeleteBtn;

@end

NS_ASSUME_NONNULL_END
