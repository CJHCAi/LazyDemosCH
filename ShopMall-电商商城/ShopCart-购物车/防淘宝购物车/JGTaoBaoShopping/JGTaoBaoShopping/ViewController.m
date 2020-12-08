//
//  ViewController.m
//  JGTaoBaoShopping
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "ViewController.h"
#import "CompileCell.h"
#import "EditCompileCell.h"
#import "SectionView.h"
#import "BottomView.h"
#import "Helper.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height



@interface ViewController () <UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,ShoppingSelectedDelegate,SelectedSectionDelegate,BottomViewDelegate>
{
    BOOL allowMultipleSwipe;
    
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong)UITableView *CartTableView;
@property (nonatomic, strong)BottomView *AccountView;

@end

@implementation ViewController

static NSString *identifierID1 = @"cell1";
static NSString *identifierID2 = @"cell2";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self CartData];
    
    _CartTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStyleGrouped];
    _CartTableView.delegate = self;
    _CartTableView.dataSource = self;
    _CartTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_CartTableView];
    
    [self AccountsView];
    
}

-( NSMutableArray *)CartData
{
    if (_dataSource == nil) {
        
        _dataSource = [[NSMutableArray alloc]init];
        
        NSArray *data =      @[@[@{@"GoodsIcon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487571326962&di=8f502445613592dc9dd19dde4032c6ec&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fm6%2FM0A%2F98%2F05%2FwKhQoVVat96Ee_nyAAAAANCKIXo389.jpg",@"GoodsName":@"秋冬季毛呢显瘦直筒西装裤韩版高腰哈伦裤女小脚裤休闲裤宽松裤子",@"GoodsDesc":@"颜色:米白色;尺寸:170/85A[M 120斤内]",@"GoodsPrice":@"15",@"GoodsOldPrice":@"￥235",@"GoodsNumber":@"3",@"SelectedType":@"check_box_nor",@"Type":@"0",@"CheckAll":@"0",@"Edit":@"0",@"EditBtn":@"0"},@{@"GoodsIcon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487571328758&di=0f9dafd5ef73a3eff0a125ae310174ac&imgtype=0&src=http%3A%2F%2Fpic36.nipic.com%2F20131205%2F12477111_155227608129_2.jpg",@"GoodsName":@"秋冬加绒卫裤2016韩版松紧腰系带金丝绒哈伦裤男女情侣休闲裤保暖",@"GoodsDesc":@"颜色:米白色;尺寸:170/85A[M 120斤内]",@"GoodsPrice":@"7",@"GoodsOldPrice":@"￥353",@"GoodsNumber":@"2",@"SelectedType":@"check_box_nor",@"Type":@"0",@"Edit":@"0"}],
                               @[@{@"GoodsIcon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487571383364&di=3aea37c3e86ada28783624a5475d27cf&imgtype=0&src=http%3A%2F%2Fimg.shushi100.com%2F2017%2F02%2F15%2F1487169103-2682884336966288.jpg",@"GoodsName":@"简易牛津布大号双人无纺布艺衣柜收纳加固加厚钢架衣橱衣柜挂衣柜",@"GoodsDesc":@"颜色:米白色;尺寸:170/85A[M 120斤内]",@"GoodsPrice":@"5",@"GoodsOldPrice":@"￥3533",@"GoodsNumber":@"4",@"SelectedType":@"check_box_nor",@"Type":@"0",@"CheckAll":@"0",@"Edit":@"0",@"EditBtn":@"0"}],
                               @[@{@"GoodsIcon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487571404170&di=93c67271812592cb3483b4e88d633e2c&imgtype=0&src=http%3A%2F%2Fpic16.nipic.com%2F20110911%2F3059559_103205656510_2.png",@"GoodsName":@"运动裤女长裤春秋卫裤纯棉宽松学生三道杠哈伦裤小脚运动裤男收口",@"GoodsDesc":@"颜色:米白色;尺寸:170/85A[M 120斤内]",@"GoodsPrice":@"15",@"GoodsOldPrice":@"￥125",@"GoodsNumber":@"2",@"SelectedType":@"check_box_nor",@"Type":@"0",@"CheckAll":@"0",@"Edit":@"0",@"EditBtn":@"0"},@{@"GoodsIcon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487571451068&di=33fa6647e96d7213edb8773522775191&imgtype=0&src=http%3A%2F%2Fd10.yihaodianimg.com%2FN10%2FM04%2FD7%2FD6%2FChEi3FYbPAqALUz-AAIG6KjEa9c87800_320x320.jpg",@"GoodsName":@"春季李易峰鹿晗纯棉同款条纹长袖T恤打底衫男女卫衣学生情侣衣服",@"GoodsDesc":@"颜色:米白色;尺寸:170/85A[M 120斤内]",@"GoodsPrice":@"13",@"GoodsOldPrice":@"￥3225",@"GoodsNumber":@"1",@"SelectedType":@"check_box_nor",@"Type":@"0",@"Edit":@"0"},@{@"GoodsIcon":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1487571466593&di=2814d8170a2e17baf9b4de1bd9b9a930&imgtype=jpg&src=http%3A%2F%2Fimg1.imgtn.bdimg.com%2Fit%2Fu%3D25193392%2C2952556956%26fm%3D214%26gp%3D0.jpg",@"GoodsName":@"gd权志龙同款卫衣长袖男女bigbang演唱会欧美潮牌衣服嘻哈街舞潮",@"GoodsDesc":@"颜色:米白色;尺寸:170/85A[M 120斤内]",@"GoodsPrice":@"25",@"GoodsOldPrice":@"￥3523",@"GoodsNumber":@"2",@"SelectedType":@"check_box_nor",@"Type":@"0",@"Edit":@"0"}]];
        
        [_dataSource addObjectsFromArray:data];
        
    }
    return _dataSource;
}

/**
 *  底部结账栏
 */
-(void)AccountsView
{
    self.AccountView = [[BottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - 44, SCREEN_WIDTH, 44)];
    self.AccountView.backgroundColor = [UIColor whiteColor];
    self.AccountView.AllSelected = YES;
    self.AccountView.delegate = self;
    [self.view addSubview:self.AccountView];
    
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#warning notice ---  我只把信息放在了第一个row中  这里不想改  但是原理一样
    NSArray *arr = _dataSource[section];
    NSDictionary *dict = arr[0];
    
    //自定义一个View
    SectionView *SectionHeadView = [[SectionView alloc]initWithFrame:tableView.tableHeaderView.bounds];
    SectionHeadView.delegate = self;
    SectionHeadView.backgroundColor = [UIColor whiteColor];
    SectionHeadView.Section = section;
    [SectionHeadView InfuseData:dict[@"CheckAll"]];
    
    return SectionHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
//cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//有多少section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
//每个section有多少row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *ListArr = _dataSource[section];
    return ListArr.count;
}
//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *ListArr = _dataSource[indexPath.section];
    NSDictionary *dict = ListArr[indexPath.row];
    
    if ([dict[@"Edit"] isEqualToString:@"0"]) {
        CompileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierID1];
        
        //    if (!cell) {
        cell = [[CompileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierID1];
        //    }
        
        cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"删除" backgroundColor:[UIColor redColor]],[MGSwipeButton buttonWithTitle:@"更多" backgroundColor:[UIColor grayColor]]];
        
        [cell withData:dict];
        
        cell.delegate = self;
        cell.SelectedDelegate = self;
        
        cell.allowsMultipleSwipe = allowMultipleSwipe;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        EditCompileCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierID2];
        //    if (!cell) {
        cell = [[EditCompileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierID2];
        //    }
        [cell withData:dict];
        cell.SelectedDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
/**
 *  侧滑后的动作  删除   +   更多
 */
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    NSIndexPath *indexPath = [_CartTableView indexPathForCell:cell];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[indexPath.section]];
    
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    //删除
    if (index == 0) {
        
        [Helper ShowAlertWithTitle:@"是否删除该商品" prompt:@"" cancel:@"取消" defaultLb:@"确定" ViewController:self alertOkClick:^{
            
            [arr removeObjectAtIndex:indexPath.row];
            if (arr.count > 0) {
                [_dataSource replaceObjectAtIndex:indexPath.section withObject:arr];
                
                [self postCenter];
                
                
                
                //                [_CartTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[indexPath.section]];
                NSInteger index = 0; //判读section下的row是否全部勾选
                for (NSInteger i = 0; i < arr.count; i++) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[i]];
                    if ([dict[@"Type"] isEqualToString:@"1"]) {
                        index ++;
                    }
                }
                
                //如果全部row的状态都为选中状态   则改变section的按钮状态
                if (index == arr.count) {
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
                    [dict setValue:@"1" forKey:@"CheckAll"];
                    [arr replaceObjectAtIndex:0 withObject:dict];
                }
                
                [_dataSource replaceObjectAtIndex:indexPath.section withObject:arr];
                
                //                //一个section刷新
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                [_CartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [_dataSource removeObjectAtIndex:indexPath.section];
                
                [self postCenter];
                
                //                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
                //                [_CartTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                [_CartTableView reloadData];
            }
            
            
            
        } alertNoClick:^{
            
        }];
        
    }
    
    return YES;
}
/**
 *  选中商品
 */
-(void)SelectedConfirmCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [_CartTableView indexPathForCell:cell];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[indexPath.section]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[indexPath.row]];
    [dict setValue:@"check_box_sel" forKey:@"SelectedType"];
    [dict setValue:@"1" forKey:@"Type"];
    [arr replaceObjectAtIndex:indexPath.row withObject:dict];
    
    [_dataSource replaceObjectAtIndex:indexPath.section withObject:arr];
    
    [self didChangeValueForSectionAllRow:indexPath.section];
}
/**
 *  取消选中商品
 */
-(void)SelectedCancelCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [_CartTableView indexPathForCell:cell];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[indexPath.section]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[indexPath.row]];
    [dict setValue:@"check_box_nor" forKey:@"SelectedType"];
    [dict setValue:@"0" forKey:@"Type"];
    [arr replaceObjectAtIndex:indexPath.row withObject:dict];
    
    [_dataSource replaceObjectAtIndex:indexPath.section withObject:arr];
    
    //判断是否把section的全选按钮取消
    [self didChangeValueForSectionRow:indexPath.section];
}
/**
 *  选中了哪一section
 */
-(void)SelectedSection:(NSInteger)section
{
    //修改section的选中状态
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[section]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
    [dict setValue:@"1" forKey:@"CheckAll"];
    [arr replaceObjectAtIndex:0 withObject:dict];
    
    [_dataSource replaceObjectAtIndex:section withObject:arr];
    
    
    [self didChangeValueForSection:section SectionSelectedTyep:YES];
}
/**
 *  取消选中哪个section
 */
-(void)SelectedSectionCancel:(NSInteger)section
{
    //修改section的选中状态
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[section]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
    [dict setValue:@"0" forKey:@"CheckAll"];
    [arr replaceObjectAtIndex:0 withObject:dict];
    
    [_dataSource replaceObjectAtIndex:section withObject:arr];
    
    [self didChangeValueForSection:section SectionSelectedTyep:NO];
    
    
}
/******************************************
 
 1.根据状态修改section中所有row的选中状态
 
 2.
 
 *********************************************************/
-(void)didChangeValueForSection:(NSInteger)section SectionSelectedTyep:(BOOL)Check
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[section]];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[i]];
        if (Check) {
            [dict setValue:@"check_box_sel" forKey:@"SelectedType"];
            [dict setValue:@"1" forKey:@"Type"];
        }else{
            [dict setValue:@"check_box_nor" forKey:@"SelectedType"];
            [dict setValue:@"0" forKey:@"Type"];
        }
        
        [arr replaceObjectAtIndex:i withObject:dict];
    }
    [_dataSource replaceObjectAtIndex:section withObject:arr];
    
    
    //判断section按钮是选中还是取消  再判断结账栏的状态
    if (Check) {
        //根据头部section的选中状态  判断结账栏的状态
        BOOL sectionChose = YES;
        for (NSInteger i = 0; i < _dataSource.count; i++) {
            NSArray *arr = _dataSource[i];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
            if ([dict[@"CheckAll"] isEqualToString:@"1"]) {
                sectionChose = YES;
            }else{
                sectionChose = NO;
                
                break;
            }
        }
        
        if (sectionChose == YES) {
            [_AccountView init:@{@"SelectIcon":@"check_box_sel",@"SelectedType":@"YES"} GoodsData:_dataSource];
        }
        
    }else{
        [_AccountView init:@{@"SelectIcon":@"check_box_nor",@"SelectedType":@"NO"} GoodsData:_dataSource];
    }
    
    [self postCenter];
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [_CartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

/********************************************
 
 判断是否需要取消section的全选状态
 
 *******************************************************/

-(void)didChangeValueForSectionRow:(NSInteger)section
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[section]];
    for (NSInteger i = 0; i < arr.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
        if ([dict[@"CheckAll"] isEqualToString:@"1"]) {
            [dict setValue:@"0" forKey:@"CheckAll"];
            [arr replaceObjectAtIndex:0 withObject:dict];
            
            [_AccountView init:@{@"SelectIcon":@"check_box_nor",@"SelectedType":@"NO"} GoodsData:_dataSource];
        }
    }
    
    [_dataSource replaceObjectAtIndex:section withObject:arr];
    
    [self postCenter];
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [_CartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

/****************************************
 
 每次选中单个row时  判断是否section内的row全部选中 全部选中后改变section的状态按钮
 
 ***********************************************************/

-(void)didChangeValueForSectionAllRow:(NSInteger)section
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[section]];
    NSInteger index = 0; //判读section下的row是否全部勾选
    for (NSInteger i = 0; i < arr.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[i]];
        if ([dict[@"Type"] isEqualToString:@"1"]) {
            index ++;
        }
    }
    
    //如果全部row的状态都为选中状态   则改变section的按钮状态
    if (index == arr.count) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
        [dict setValue:@"1" forKey:@"CheckAll"];
        [arr replaceObjectAtIndex:0 withObject:dict];
    }
    
    [_dataSource replaceObjectAtIndex:section withObject:arr];
    
    //根据头部section的选中状态  判断结账栏的状态
    BOOL sectionChose = YES;
    for (NSInteger i = 0; i < _dataSource.count; i++) {
        NSArray *arr = _dataSource[i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[0]];
        if ([dict[@"CheckAll"] isEqualToString:@"1"]) {
            sectionChose = YES;
        }else{
            sectionChose = NO;
            
            break;
        }
    }
    
    if (sectionChose == YES) {
        [_AccountView init:@{@"SelectIcon":@"check_box_sel",@"SelectedType":@"YES"} GoodsData:_dataSource];
    }
    
    
    [self postCenter];
    
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [_CartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

/****************************************
 
 底部结账按钮
 
 ***********************************************************/

-(void)DidSelectedAllGoods
{
    for (NSInteger i = 0; i < _dataSource.count; i ++) {
        NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[i]];
        for (NSInteger j = 0; j < arr.count; j ++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[j]];
            if (j == 0) {
                [dict setValue:@"1" forKey:@"CheckAll"];
                [arr replaceObjectAtIndex:0 withObject:dict];
            }
            [dict setValue:@"check_box_sel" forKey:@"SelectedType"];
            [dict setValue:@"1" forKey:@"Type"];
            [arr replaceObjectAtIndex:j withObject:dict];
        }
        [_dataSource replaceObjectAtIndex:i withObject:arr];
    }
    [self postCenter];
    
    [_CartTableView reloadData];
}

-(void)NoDidSelectedAllGoods
{
    for (NSInteger i = 0; i < _dataSource.count; i ++) {
        NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[i]];
        for (NSInteger j = 0; j < arr.count; j ++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[j]];
            if (j == 0) {
                [dict setValue:@"0" forKey:@"CheckAll"];
                [arr replaceObjectAtIndex:0 withObject:dict];
            }
            [dict setValue:@"check_box_nor" forKey:@"SelectedType"];
            [dict setValue:@"0" forKey:@"Type"];
            [arr replaceObjectAtIndex:j withObject:dict];
        }
        [_dataSource replaceObjectAtIndex:i withObject:arr];
    }
    
    [self postCenter];
    
    [_CartTableView reloadData];
}

/**
 *  刷新结账栏金额
 */
-(void)postCenter
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"BottomRefresh" object:nil userInfo:@{@"Data":_dataSource}];
}

/**
 *  编辑商品
 */
-(void)SelectedEdit:(NSInteger)section
{
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[section]];
    if ([arr[0][@"EditBtn"] isEqualToString:@"0"]) {
        for (NSInteger i = 0; i < arr.count; i ++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[i]];
            
            [dict setValue:@"1" forKey:@"Edit"];
            [dict setValue:@"1" forKey:@"EditBtn"];
            
            [arr replaceObjectAtIndex:i withObject:dict];
        }
        
    }else{
        for (NSInteger i = 0; i < arr.count; i ++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[i]];
            
            [dict setValue:@"0" forKey:@"Edit"];
            [dict setValue:@"0" forKey:@"EditBtn"];
            
            [arr replaceObjectAtIndex:i withObject:dict];
        }
    }
    
    [_dataSource replaceObjectAtIndex:section withObject:arr];
    
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [_CartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
    NSLog(@"%ld",section);
}

/**
 *  修改商品数量
 */
-(void)ChangeGoodsNumberCell:(UITableViewCell *)cell Number:(NSInteger)num
{
    NSIndexPath *indexPath = [_CartTableView indexPathForCell:cell];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[indexPath.section]];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:arr[indexPath.row]];
    [dict setValue:[NSString stringWithFormat:@"%ld",num] forKey:@"GoodsNumber"];
    [arr replaceObjectAtIndex:indexPath.row withObject:dict];
    
    [_dataSource replaceObjectAtIndex:indexPath.section withObject:arr];
    
    [self postCenter];
    
    //一个cell刷新
    NSIndexPath *indexPaths=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    [_CartTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPaths,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}
/**
 *  删除该商品
 */
-(void)DeleteTheGoodsCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [_CartTableView indexPathForCell:cell];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:_dataSource[indexPath.section]];
    
    [Helper ShowAlertWithTitle:@"是否删除该商品" prompt:@"" cancel:@"取消" defaultLb:@"确定" ViewController:self alertOkClick:^{
        
        [arr removeObjectAtIndex:indexPath.row];
        
        if (arr.count > 0) {
            
            [_dataSource replaceObjectAtIndex:indexPath.section withObject:arr];
            
            [self postCenter];
            
            //                //一个section刷新
            //                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            //                [_CartTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [_CartTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            [_dataSource removeObjectAtIndex:indexPath.section];
            
            [self postCenter];
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [_CartTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            //                [_CartTableView reloadData];
        }
        
        
        
    } alertNoClick:^{
        
    }];
    
}



@end
