//
//  SecondSingTableViewCell.h
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondSingTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *boards;


@end
