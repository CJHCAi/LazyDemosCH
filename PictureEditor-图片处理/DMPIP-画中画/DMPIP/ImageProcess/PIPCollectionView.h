//
//  PIPCollectionView.h
//  LuoChang
//
//  Created by Rick on 15/9/14.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PIPCollectionViewItemDelegate <NSObject>

-(void)pipItemClick:(NSIndexPath *)indexPath pipDict:(NSDictionary *)pipDict;

@end

@interface PIPCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,copy) NSArray *pipArray;
@property(nonatomic,copy) UIImage *originalImage;

@property(nonatomic,weak) id<PIPCollectionViewItemDelegate> pipDelegate;

@end
