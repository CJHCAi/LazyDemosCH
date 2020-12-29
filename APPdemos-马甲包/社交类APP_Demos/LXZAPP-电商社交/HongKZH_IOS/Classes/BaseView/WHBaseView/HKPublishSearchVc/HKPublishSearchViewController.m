//
//  HKPublishSearchViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPublishSearchViewController.h"
#import "HKSearchHeadCollectionViewCell.h"
#import "HKPublishSearchCollectionViewCell.h"
#import "HKSearchModels.h"
#import "HKNavSearchView.h"
#import "HK_BaseRequest.h"
#import "HKBaseResponeModel.h"
@interface HKPublishSearchViewController ()<HKNavSearchViewDelegate,HKSearchHeadCollectionViewCellDelegate>
@property (nonatomic, strong)HKNavSearchView *navView;
@property (nonatomic, copy)NSString *urlStr;
@end

@implementation HKPublishSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self loadData];
    [self setUI];
    [self.navView.textField addTarget:self action:@selector(textFieldEndChange:) forControlEvents:UIControlEventEditingChanged];
    [self.navView.textFieldClck addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setUI{
    [self.view addSubview:self.navView];
    [self.view addSubview:self.collection];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(self.navView.mas_bottom);
    }];
}
-(void)closeSearch{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)toEmptySearchHistory{
    [HK_BaseRequest buildPostRequest:self.urlStr body:@{@"loginUid":HKUSERLOGINID} success:^(id  _Nullable responseObject) {
        HKBaseResponeModel *model = [HKBaseResponeModel mj_objectWithKeyValues:responseObject];
        if (model.responeSuc) {
            [self.locArray removeAllObjects];
            [self.collection reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"清空失败"];
        }
    } failure:^(NSError * _Nullable error) {
        
    }];
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.hidden = YES;
    }
    return _tableView;
}
-(UICollectionView *)collection{
    if (!_collection) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        [_collection registerNib:[UINib nibWithNibName:@"HKPublishSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKPublishSearchCollectionViewCell"];
        [_collection registerNib:[UINib nibWithNibName:@"HKSearchHeadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSearchHeadCollectionViewCell"];
    }
    return _collection;
}

-(void)textFieldChange:(UITextField *)textField{}
-(void)textFieldEndChange:(UITextField*)textField{
    [self textFieldChange:textField];
}
-(void)loadData{
    
}


#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKSearchTipsTableViewCell*cell = [HKSearchTipsTableViewCell baseCellWithTableView:tableView];
    [cell setEndTitle:self.navView.textField.text name:[self.dataArray[indexPath.row] title]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     if(section == 1){
        return self.locArray.count;
        
    }else if(section == 3){
       return self.hotArray.count;
    }else{
        return 1;
    }
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        HKPublishSearchCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKPublishSearchCollectionViewCell" forIndexPath:indexPath];
        cell.model = self.locArray[indexPath.item];
        return cell;
    }else if (indexPath.section == 3){
        HKPublishSearchCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKPublishSearchCollectionViewCell" forIndexPath:indexPath];
        cell.model = self.hotArray[indexPath.item];
        return cell;
    }else{
        HKSearchHeadCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSearchHeadCollectionViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.type = (int)indexPath.section;
        return cell;
    }
    return nil;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0||indexPath.section == 2) {
        return CGSizeMake(kScreenWidth, 55);
    }
    if (indexPath.section == 1) {
        HKSearchModels*model = self.locArray[indexPath.item];
        return CGSizeMake(model.w, 20);
    }else{
        HKSearchModels*model = self.hotArray[indexPath.item];
        return CGSizeMake(model.w, 20);
    }
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}
- (void)searchClick:(id)sender {
    self.isExit = !self.isExit;
    if (self.isExit) {
        self.navView.textFieldClck.hidden = YES;
        [self.navView.textField becomeFirstResponder];
        self.tableView.hidden = NO;
    }else{
        self.navView.textFieldClck.hidden = NO;
        [self.navView.textField resignFirstResponder];
        [self.view endEditing:YES];
        self.tableView.hidden = YES;
    }
}
-(HKNavSearchView *)navView{
    if (!_navView) {
        _navView = [[HKNavSearchView alloc]init];
        _navView.delegate = self;
    }
    return _navView;
}
-(void)setType:(SearchType)type{
    _type = type;
    if (type == SearchType_SeleMeadia) {
        self.urlStr = get_mediaAdvEmptySearchHistory;
    }else{
        self.urlStr = get_shopEmptySearchHistory;
    }
}
@end
