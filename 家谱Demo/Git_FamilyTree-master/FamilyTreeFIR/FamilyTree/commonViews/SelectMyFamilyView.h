//
//  SelectMyFamilyView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectMyFamilyView;

@protocol SelectMyFamilyViewDelegate <NSObject>

@optional

-(void)SelectMyFamilyViewDelegate:(SelectMyFamilyView *)seleMyFam didSelectFamID:(NSString *)famId;

-(void)SelectMyFamilyViewDelegate:(SelectMyFamilyView *)seleMyFam didSelectFamTitle:(NSString *)title SelectFamID:(NSString *)famId;

@end

@interface SelectMyFamilyView : UIView

//@property (nonatomic,strong) UICollectionView *collectionView; /*集合*/
/**下拉table*/
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *dataSource; /*家谱数据*/

//@property (nonatomic,assign) BOOL didSelectedItem; /*选中状态*/

@property (nonatomic,weak) id<SelectMyFamilyViewDelegate> delegate; /*代理人*/
-(void)updateDataSourceAndUI;
@end
