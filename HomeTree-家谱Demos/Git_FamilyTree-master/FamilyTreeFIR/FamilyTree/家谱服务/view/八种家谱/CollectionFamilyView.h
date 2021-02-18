//
//  CollectionFamilyView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CollectionFamilyView;

@protocol CollectionFamilyDelegate <NSObject>

-(void)CollevtionFamily:(CollectionFamilyView *)collecView didSelectedItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface CollectionFamilyView : UIView

@property (nonatomic,weak) id<CollectionFamilyDelegate> delegate; /*代理人*/


@end
