//
//  HKPublishSearchViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKSearchTipsTableViewCell.h"
typedef enum{
    SearchType_Goods = 0,
    SearchType_SeleMeadia = 1
}SearchType;
@interface HKPublishSearchViewController : HKBaseViewController<UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource>
@property (nonatomic, strong)NSMutableArray *locArray;
@property (nonatomic, strong)NSMutableArray *hotArray;
@property (strong, nonatomic) UICollectionView *collection;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,assign) SearchType type;
-(void)loadData;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isExit;
-(void)textFieldChange:(UITextField*)textField;
@property (nonatomic, copy)NSString *textF;
@end
