//
//  ZJWCollectionView.h
//  navigationBarAnimation
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleScrollView.h"

@class ZJWCollectionView;
typedef void (^ZJWCollectionViewBlock)(ZJWCollectionView *view,NSInteger indepath);

@interface ZJWCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout ,TitleScrollViewDelegate>
@property(nonatomic,strong)UICollectionView *colleciont;
@property(nonatomic,assign)NSInteger itms;
@property(copy ,nonatomic)ZJWCollectionViewBlock itmsBlock;
@property(nonatomic,strong)TitleScrollView * titleScrollView;
@property(nonatomic,strong)NSArray *imageArrays;

-(void)createCollectionWithItms:(NSInteger)itms;

@end
