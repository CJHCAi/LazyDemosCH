//
//  HK_LeSeeAddProductClassifyMenu.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_LeSeeAddProductClassifyMenu.h"
#import "HKBaseViewModel.h"
#import "HKInitializationRespone.h"
#import "HKShopDataInitRespone.h"
@interface HK_LeSeeAddProductClassifyMenu()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation HK_LeSeeAddProductClassifyMenu
{
    UIView *_holder;
    UIButton *_headerHolderButton;
    UILabel *_lbTitle;
    UIView *_sepLine;
    
    id _selectedFatherNodeModel;
    
    NSMutableArray *_tableViews;
    NSMutableArray *_dataSections;//section and row
    
    NSMutableArray *_selectItems;
    
    UIScrollView *_scrollView;
    UIView *_scrollContentView;
    
    DataSourceType _dataSourceType;
}

- (id)initWithFrame:(CGRect)frame dataSourceType:(DataSourceType)type{
    if (self = [super initWithFrame:frame]) {
        
        _tableViews = [NSMutableArray array];
        _dataSections = [NSMutableArray array];
        _selectItems = [NSMutableArray array];
        _dataSourceType = type;
        
        [self loadSectionData];
        [self setupDefaultSelectedData];
        
       
        self.backgroundColor = UICOLOR_RGB_Alpha(0x000000, 0.7);
    }
    return self;
}

- (void)loadSectionData
{
    if (_dataSections.count>0) {
        //取出最后一个元素，作为下一个子数据的父数据
       __block NSArray *children = nil;
        
        switch (_dataSourceType) {
            case DataSourceType_Data_RecruitCategorys: {
                _lbTitle.text = @"选择商品类目";
                for (RecruitcategorysModel *m in _dataSections.lastObject) {
                    [self getChildrenByFather:m back:^(NSArray *array) {
                        children =  array;
                    }];
                }
            }
                break;
            case DataSourceType_Data_RecruitIndustrys: {
                for (RecruitindustrysModel *m in _dataSections.lastObject) {
                    [self getChildrenByFather:m back:^(NSArray *array) {
                        children =  array;
                    }];
                }
            }
                break;
            case DataSourceType_Data_AllCategorys: {
                for (AllcategorysModel *m in _dataSections.lastObject) {
                    [self getChildrenByFather:m back:^(NSArray *array) {
                        children =  array;
                    }];
                }
            }
                break;
            case DataSourceType_ShopData_AllMediaShopCategorys:
            {
                _lbTitle.text = @"选择商品类目";
                
                NSArray *lastSectionRows = _dataSections.lastObject;
                AllmediashopcategorysInit *m = lastSectionRows.firstObject;
                [self getChildrenByFather:m back:^(NSArray *array) {
                    children =  array;
                }];
            }
                break;
            case DataSourceType_ShopData_MediaAreas:
            {
                for (MediaareasInits *m in _dataSections.lastObject) {
                    [self getChildrenByFather:m back:^(NSArray *array) {
                        children =  array;
                    }];
                }
            }
                break;
            case DataSourceType_ShopData_SystemShopCategorys: {
                for (SystemshopcategorysInit *m in _dataSections.lastObject) {
                    [self getChildrenByFather:m back:^(NSArray *array) {
                        children =  array;
                    }];
                }
            }
                break;
            default:
                break;
        }
        
        if (children.count>0) {
            [_dataSections addObject:children];
            
            //继续递归寻找子数据
            [self loadSectionData];
        }
        else{
            [self setupUI];
            //已经到最后 不做操作
        }
        
    }else{
     
        [self getChildrenByFather:nil back:^(NSArray *array) {
            NSArray *roots = array;
       
        if (roots.count>0) {
            [self->_dataSections addObject:roots];
            
            //递归寻找子数据
            [self loadSectionData];
        }
        else{
            [self setupUI];
        }
             }];
    }
    
}

- (void)setupDefaultSelectedData
{
    for (NSArray *sectionRows in _dataSections) {
        [_selectItems addObjectsFromArray:sectionRows];
    }
}
/**
 获得子节点的所有元素

 @param fatherModel 父节点模型
 @back 子节点数组
 */
- (void)getChildrenByFather:(id)fatherModel back:(void(^)(NSArray *array))back
{
    NSMutableArray *chilrenArr = [NSMutableArray array];
    if (_dataSourceType == DataSourceType_Data_AllCategorys||_dataSourceType == DataSourceType_Data_RecruitCategorys||_dataSourceType == DataSourceType_Data_RecruitIndustrys) {
        [HKBaseViewModel initDataSuccess:^(BOOL isSave, HKInitializationRespone *respone) {
        
        switch (self->_dataSourceType) {
       
            case DataSourceType_Data_RecruitCategorys:
            {
                NSArray *children = respone.data.recruitCategorys;
                
                for (RecruitcategorysModel *c in children) {
                    if (fatherModel) {
                        RecruitcategorysModel *fm = (RecruitcategorysModel *)fatherModel;
                        
                        if ([fm.ID isEqualToString:c.parentId]) {
                            [chilrenArr addObject:c];
                        }
                    }
                    else{
                        if ([c.parentId isEqualToString:@"0"]) {
                            [chilrenArr addObject:c];
                        }
                    }
                }
            }
                break;
            case DataSourceType_Data_RecruitIndustrys:
            {
                NSArray *children = respone.data.recruitIndustrys;
                
                for (RecruitindustrysModel *c in children) {
                    if (fatherModel) {
                        RecruitindustrysModel *fm = (RecruitindustrysModel *)fatherModel;
                        
                        if ([fm.ID isEqualToString:c.parentId]) {
                            [chilrenArr addObject:c];
                        }
                    }
                    else{
                        if ([c.parentId isEqualToString:@"0"]) {
                            [chilrenArr addObject:c];
                        }
                    }
                }
            }
                break;
            case DataSourceType_Data_AllCategorys:
            {
                NSArray *children = respone.data.allCategorys;
                
                for (AllcategorysModel *c in children) {
                    if (fatherModel) {
                        AllcategorysModel *fm = (AllcategorysModel *)fatherModel;
                        if ([fm.categoryId isEqualToString:c.parentId]) {
                            [chilrenArr addObject:c];
                        }
                    }
                    else{
                        if ([c.parentId isEqualToString:@"0"]) {
                            [chilrenArr addObject:c];
                        }
                    }
                }
            }
                break;
            default:
                break;
    }
            back(chilrenArr);
        }];
    }else{
        
        [HKBaseViewModel getShopDataSuccess:^(BOOL isSave, HKShopDataInitRespone *respone) {
       
        switch (self->_dataSourceType) {
        case DataSourceType_ShopData_SystemShopCategorys:
        {
            NSArray *children = respone.data.systemShopCategorys;
            
            for (SystemshopcategorysInit *c in children) {
                if (fatherModel) {
                    SystemshopcategorysInit *fm = (SystemshopcategorysInit *)fatherModel;
                    
                    if ([fm.ID isEqualToString:c.parentId]) {
                        [chilrenArr addObject:c];
                    }
                }
                else{
                    if ([c.parentId isEqualToString:@"0"]) {
                        [chilrenArr addObject:c];
                    }
                }
            }
        }
            break;
        case DataSourceType_ShopData_MediaAreas:
        {
            
            NSArray *children = respone.data.mediaAreas;
            
            for (MediaareasInits *c in children) {
                if (fatherModel) {
                    MediaareasInits *fm = (MediaareasInits *)fatherModel;

                    if ([fm.ID isEqualToString:c.parentId]) {
                        [chilrenArr addObject:c];
                    }
                }
                else{
                    if ([c.parentId isEqualToString:@"0"]) {
                        [chilrenArr addObject:c];
                    }
                }
            }
        }
            break;
            case DataSourceType_ShopData_AllMediaShopCategorys:
            {
                
                NSArray *children = respone.data.allMediaShopCategorys;
                
                for (AllmediashopcategorysInit *c in children) {
                    //寻找子节点
                    if (fatherModel) {
                        AllmediashopcategorysInit *fm = (AllmediashopcategorysInit *)fatherModel;
                        
                        if ([fm.mediaCategoryId isEqualToString:c.parentId]) {
                            [chilrenArr addObject:c];
                        }
                    }
                    else{
                        //否则寻找根节点
                        if ([c.parentId isEqualToString:@"0"]) {
                            [chilrenArr addObject:c];
                        }
                    }
                }
            }
                break;
       
        
        
        default:
            break;
    }
         back(chilrenArr);
        }];
    }
}


/**
 寻找被点击的行在_dataSections中的索引，以此来重新加载数据

 @return 点击行在_dataSection中的索引值
 */
- (NSInteger)indexOfSelectedRow
{
    return 0;
}

- (void)setupUI
{
    //_holder
    _holder = [HKComponentFactory viewWithFrame:CGRectZero supperView:self];
    _holder.backgroundColor = [UIColor whiteColor];
    
    //holder button
    _headerHolderButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                       frame:CGRectZero
                                                       taget:self
                                                      action:@selector(tapClose)
                                                  supperView:self];
    
    //title
    _lbTitle = [HKComponentFactory labelWithFrame:CGRectZero
                                        textColor:UICOLOR_HEX(0x333333)
                                    textAlignment:NSTextAlignmentCenter
                                             font:FontMaker(PingFangSCMedium, 15)
                                             text:nil
                                       supperView:_holder];
    
    //sepline
    _sepLine = [HKComponentFactory viewWithFrame:CGRectZero supperView:_holder];
    _sepLine.backgroundColor = UICOLOR_HEX(0xe2e2e2);
    
    //_scrollView
    _scrollView = [HKComponentFactory scrollViewWithFrame:CGRectZero
                                              contentSize:CGSizeZero
                                                 delegate:self
                                               supperView:_holder];
    _scrollView.bounces = NO;
    
    
    //_scrollContentView
    _scrollContentView = [HKComponentFactory viewWithFrame:CGRectZero supperView:_scrollView];
  
    //table views
    for (int i=0; i<_dataSections.count; i++) {
        UITableView *tbv = [HKComponentFactory tableViewWithFrame:CGRectZero
                                                            style:UITableViewStylePlain
                                                         delegate:self
                                                       dataSource:self
                                                       supperView:_scrollContentView];
        if (i==0) {
            tbv.backgroundColor = UICOLOR_HEX(0xf1f1f1);
        }
        
        [_tableViews addObject:tbv];
    }
}

- (void)layoutSubviews
{
    //500
    [_holder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(250);
        make.left.right.bottom.equalTo(self);
    }];
    
    //_headerHolderButton
    [_headerHolderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self->_holder.mas_top);
    }];
    

    //title
    [_lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_holder).offset(20);
        make.left.right.equalTo(self->_holder);
        make.height.mas_equalTo(15);
    }];
    
    //sep line
    [_sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_lbTitle.mas_bottom).offset(20);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    //scroll view
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->_sepLine.mas_bottom);
        make.left.equalTo(self->_holder);
        make.bottom.equalTo(self->_holder);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
    [_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self->_scrollView);
        if (iPhoneX) {
            make.height.mas_equalTo(self->_scrollView).offset(-20);
        } else {
            make.height.mas_equalTo(self->_scrollView);
        }
        
    }];
    
    for (int i=0;i<_tableViews.count;i++) {
        UITableView *tbv = _tableViews[i];
        [tbv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_scrollContentView);
            make.height.equalTo(self->_scrollContentView);
            make.width.mas_equalTo(kScreenWidth/2.f);

            if (i==0) {
                make.left.equalTo(self->_scrollContentView);
            }
            else{
                UITableView *preTbv = self->_tableViews[i-1];
                make.left.equalTo(preTbv.mas_right);

                if (i == self->_tableViews.count - 1) {
                    //最后一个
                    [self->_scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(tbv.mas_right);
                    }];
                }

            }
        }];
    }
}

+ (void)showInView:(UIView *)view withDataSourceType:(DataSourceType)type
         animation:(BOOL)animation
  selectedCallback:(void (^)(NSArray *items))block
{
    if (view) {
        HK_LeSeeAddProductClassifyMenu *menu = [[HK_LeSeeAddProductClassifyMenu alloc] initWithFrame:CGRectZero dataSourceType:type];
        [view addSubview:menu];
        [menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        
        menu.selectedBlock = block;
        
        [view bringSubviewToFront:menu];
        
        if (animation) {
           
            menu.backgroundColor = UICOLOR_RGB_Alpha(0x000000, 0);
            
            [UIView animateWithDuration:0.2 animations:^{
                menu.backgroundColor = UICOLOR_RGB_Alpha(0x000000, 0.8);
            }];
        }
    }
}

- (void)tapClose
{
    [self removeFromSuperview];
}

#pragma mark - tableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //寻找当前tableView 在数组中的位置
    NSUInteger index = [_tableViews indexOfObject:tableView];
    
    //根据索引 使用对应的数据
    NSArray *rows = _dataSections[index];
    
    return rows.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //寻找当前tableView 在数组中的位置
    NSUInteger index = [_tableViews indexOfObject:tableView];
    
    //最后一个cell
    UITableViewCell *cell = [HKComponentFactory cellInTableView:tableView
                                                     identifier:[NSString stringWithFormat:@"cell-%lu",(unsigned long)index]
                                                       cellType:UITableViewCellStyleDefault];
    //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = FontMaker(PingFangSCRegular, 15);
    
    cell.detailTextLabel.font = FontMaker(PingFangSCRegular, 14);
    cell.detailTextLabel.textColor = UICOLOR_HEX(0x333333);
    
    
    //根据索引 使用对应的数据
    NSArray *rows = _dataSections[index];
    
    switch (_dataSourceType) {
        case DataSourceType_Data_RecruitCategorys: {
            RecruitcategorysModel *m = rows[indexPath.row];
            cell.textLabel.text = m.name;
        }
            break;
        case DataSourceType_Data_RecruitIndustrys: {
            RecruitindustrysModel *m = rows[indexPath.row];
            cell.textLabel.text = m.name;
        }
            break;
        case DataSourceType_Data_AllCategorys: {
            AllcategorysModel *m = rows[indexPath.row];
            cell.textLabel.text = m.name;
        }
            break;
        case DataSourceType_ShopData_AllMediaShopCategorys:
        {
            AllmediashopcategorysInit *m = rows[indexPath.row];
            cell.textLabel.text = m.name;
            
            AllmediashopcategorysInit *_selectModel = (AllmediashopcategorysInit*)_selectedFatherNodeModel;
            if ([_selectModel.mediaCategoryId isEqualToString:m.mediaCategoryId]) {
                cell.textLabel.textColor = UICOLOR_HEX(0x4090f7);
            }else{
                cell.textLabel.textColor = UICOLOR_HEX(0x333333);
            }
        }
            break;
        case DataSourceType_ShopData_MediaAreas:
        {
            MediaareasInits *m = rows[indexPath.row];
            cell.textLabel.text = m.name;
        }
            break;
        case DataSourceType_ShopData_SystemShopCategorys: {
            SystemshopcategorysInit *m = rows[indexPath.row];
            cell.textLabel.text = m.name;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //寻找当前tableView 在数组中的位置
    NSUInteger index = [_tableViews indexOfObject:tableView];
    
    //根据索引 使用对应的数据
    NSArray *rows = _dataSections[index];
    
    //取出对象
    switch (_dataSourceType) {
        case DataSourceType_ShopData_AllMediaShopCategorys:
        {
            AllmediashopcategorysInit *m = rows[indexPath.row];
            if ([m.parentId isEqualToString:@"0"]) {
                [_selectItems removeAllObjects];
            }else{
                //子节点
                //删除当前节点后面的所有数据
                [_selectItems removeObjectsInRange:NSMakeRange(index, _selectItems.count-index)];
                
                //做动画
                [self showChildren];
            }
            [_selectItems addObject:m];
        }
            break;
        case DataSourceType_ShopData_MediaAreas:
        {
            MediaareasInits *m = rows[indexPath.row];
            if ([m.parentId isEqualToString:@"0"]) {
                [_selectItems removeAllObjects];
            }else{
                //子节点
                //删除当前节点后面的所有数据
                [_selectItems removeObjectsInRange:NSMakeRange(index, _selectItems.count-index)];
                
                //做动画
                [self showChildren];
            }
            [_selectItems addObject:m];
        }
            break;
        case DataSourceType_ShopData_SystemShopCategorys:
        {
            SystemshopcategorysInit *m = rows[indexPath.row];
            if ([m.parentId isEqualToString:@"0"]) {
                [_selectItems removeAllObjects];
            }else{
                //子节点
                //删除当前节点后面的所有数据
                [_selectItems removeObjectsInRange:NSMakeRange(index, _selectItems.count-index)];
                
                //做动画
                [self showChildren];
            }
            [_selectItems addObject:m];
        }
            break;
        case DataSourceType_Data_AllCategorys:
        {
            AllcategorysModel *m = rows[indexPath.row];
            if ([m.parentId isEqualToString:@"0"]) {
                [_selectItems removeAllObjects];
            }else{
                //子节点
                //删除当前节点后面的所有数据
                [_selectItems removeObjectsInRange:NSMakeRange(index, _selectItems.count-index)];
                
                //做动画
                [self showChildren];
            }
            [_selectItems addObject:m];
        }
            break;
        case DataSourceType_Data_RecruitCategorys:
        {
            RecruitcategorysModel *m = rows[indexPath.row];
            if ([m.parentId isEqualToString:@"0"]) {
                [_selectItems removeAllObjects];
            }else{
                //子节点
                //删除当前节点后面的所有数据
                [_selectItems removeObjectsInRange:NSMakeRange(index, _selectItems.count-index)];
                
                //做动画
                [self showChildren];
            }
            [_selectItems addObject:m];
        }
            break;
        case DataSourceType_Data_RecruitIndustrys:
        {
            RecruitindustrysModel *m = rows[indexPath.row];
            if ([m.parentId isEqualToString:@"0"]) {
                [_selectItems removeAllObjects];
            }else{
                //子节点
                //删除当前节点后面的所有数据
                [_selectItems removeObjectsInRange:NSMakeRange(index, _selectItems.count-index)];
                
                //做动画
                [self showChildren];
            }
            [_selectItems addObject:m];
        }
            break;
            
        default:
            break;
    }
    
    //如果选的是最后一个tableview 返回数据 直接退出界面
    if (index == _tableViews.count -1) {
        [self tapClose];
        
        if (self.selectedBlock) {
            self.selectedBlock(_selectItems);
        }
    }
    else{
        for (UITableView *tbv in _tableViews) {
            [tbv reloadData];
        }
    }
}

#pragma mark - 动画

- (void)showChildren
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [_scrollView setContentOffset:CGPointMake(kScreenWidth/2.f, 0.0f) animated:YES];
    [UIView commitAnimations];

}
@end
