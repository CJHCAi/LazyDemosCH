//
//  EquipmentInfoViewController.m
//  SportForum
//
//  Created by liyuan on 4/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "EquipmentInfoViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"
#import "EquipmentChooseViewController.h"

@interface EquipmentItem : NSObject

@property(nonatomic, copy) NSString* itemImg;
@property(nonatomic, copy) NSString* itemTitle;

@property(nonatomic, copy) NSString* equipName;
@property(nonatomic, copy) NSString* equipModel;
@property(nonatomic, copy) NSString* equipImg;

@end

@implementation EquipmentItem

@end

@interface EquipmentInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@end

@implementation EquipmentInfoViewController
{
    NSMutableArray* m_accountItems;
    UITableView *m_tableEquipment;
    
    EquipmentItem *_curEquipmentItem;
    UIAlertView* _alertView;
}

-(void)loadEquipmentItems
{
    [m_accountItems removeAllObjects];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    EquipmentItem *equipmentItem = [[EquipmentItem alloc]init];
    
    equipmentItem.itemTitle = @"跑鞋";
    equipmentItem.itemImg = @"me-equipment-shoes";

    if (userInfo.user_equipInfo.run_shoe.data.count > 0) {
        NSString *strShoes = userInfo.user_equipInfo.run_shoe.data.lastObject;
        
        NSArray *list=[strShoes componentsSeparatedByString:@"###"];
        
        if ([list count] == 1) {
            equipmentItem.equipName = list[0];
            equipmentItem.equipImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
        else
        {
            equipmentItem.equipName = list[0];
            equipmentItem.equipModel = list[1];
            equipmentItem.equipImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
    }
    
    [m_accountItems addObject:equipmentItem];
    
    equipmentItem = [[EquipmentItem alloc]init];
    
    equipmentItem.itemTitle = @"可穿戴设备";
    equipmentItem.itemImg = @"me-equipment-device";
    
    if (userInfo.user_equipInfo.ele_product.data.count > 0) {
        NSString *strShoes = userInfo.user_equipInfo.ele_product.data.lastObject;
        
        NSArray *list=[strShoes componentsSeparatedByString:@"###"];
        
        if ([list count] == 1) {
            equipmentItem.equipName = list[0];
            equipmentItem.equipImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
        else
        {
            equipmentItem.equipName = list[0];
            equipmentItem.equipModel = list[1];
            equipmentItem.equipImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
    }
    
    [m_accountItems addObject:equipmentItem];
    
    equipmentItem = [[EquipmentItem alloc]init];
    
    equipmentItem.itemTitle = @"轨迹记录App";
    equipmentItem.itemImg = @"me-equipment-app";
    
    if (userInfo.user_equipInfo.step_tool.data.count > 0) {
        NSString *strShoes = userInfo.user_equipInfo.step_tool.data.lastObject;
        
        NSArray *list=[strShoes componentsSeparatedByString:@"###"];
        
        if ([list count] == 1) {
            equipmentItem.equipName = list[0];
            equipmentItem.equipImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
        else
        {
            equipmentItem.equipName = list[0];
            equipmentItem.equipModel = list[1];
            equipmentItem.equipImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
    }
    
    [m_accountItems addObject:equipmentItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    
    [self generateCommonViewInParent:self.view Title:@"装备" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    m_accountItems = [[NSMutableArray alloc]init];
    [self loadEquipmentItems];
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableEquipment = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableEquipment.delegate = self;
    m_tableEquipment.dataSource = self;
    [viewBody addSubview:m_tableEquipment];
    
    [m_tableEquipment reloadData];
    m_tableEquipment.backgroundColor = [UIColor clearColor];
    m_tableEquipment.separatorColor = [UIColor clearColor];
    
    if ([m_tableEquipment respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableEquipment setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"装备 - EquipmentInfoViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"装备 - EquipmentInfoViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"装备 - EquipmentInfoViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"EquipmentInfoViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    [self loadEquipmentItems];
    [m_tableEquipment reloadData];
}

-(void)deleteEquipment
{
    NSUInteger nIndex = [m_accountItems indexOfObject:_curEquipmentItem];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    EquipmentInfo *equipmentInfo = userInfo.user_equipInfo;
    
    if (nIndex == 0) {
        [equipmentInfo.run_shoe.data removeAllObjects];
    }
    else if(nIndex == 1) {
        [equipmentInfo.ele_product.data removeAllObjects];
    }
    else if(nIndex == 2) {
        [equipmentInfo.step_tool.data removeAllObjects];
    }
    
    id _processId = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance]userUpdateEquipment:equipmentInfo FinishedBlock:^(int errorCode, ExpEffect* expEffect) {
        [AlertManager dissmiss:_processId];
        
        [self loadEquipmentItems];
        [m_tableEquipment reloadData];
        
        if (errorCode == 0) {
            [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
             {
                 if (errorCode == 0)
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                 }
             }];
        }
        else
        {
            [JDStatusBarNotification showWithStatus:@"删除失败" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
        }
    }];
}

#pragma mark - Table Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_accountItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"EquipmentInfoIdentifier";
    EquipmentItem *equipmentItem = m_accountItems[[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.tag = 109;
        [cell.contentView addSubview:imgView];
        
        UILabel *lbTitle = [[UILabel alloc]init];
        lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor darkGrayColor];
        lbTitle.tag = 110;
        [cell.contentView addSubview:lbTitle];
        
        UILabel *lbSep = [[UILabel alloc]init];
        lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        lbSep.tag = 111;
        [cell.contentView addSubview:lbSep];
        
        UIImageView *arrImgView = [[UIImageView alloc]init];
        [arrImgView setImage:[UIImage imageNamed:@"arrow-1"]];
        arrImgView.tag = 112;
        [cell.contentView addSubview:arrImgView];
        
        UILabel *lbEqName = [[UILabel alloc]init];
        lbEqName.font = [UIFont boldSystemFontOfSize:13.0];
        lbEqName.textAlignment = NSTextAlignmentLeft;
        lbEqName.backgroundColor = [UIColor clearColor];
        lbEqName.textColor = [UIColor darkGrayColor];
        lbEqName.tag = 113;
        [cell.contentView addSubview:lbEqName];
        
        UIImageView *imgViewEq = [[UIImageView alloc]init];
        imgViewEq.tag = 114;
        [cell.contentView addSubview:imgViewEq];
        
        UILabel *lbEqModel = [[UILabel alloc]init];
        lbEqModel.font = [UIFont boldSystemFontOfSize:12.0];
        lbEqModel.textAlignment = NSTextAlignmentLeft;
        lbEqModel.backgroundColor = [UIColor clearColor];
        lbEqModel.textColor = [UIColor lightGrayColor];
        lbEqModel.tag = 115;
        [cell.contentView addSubview:lbEqModel];
        
        CSButton *btnDelete = [CSButton buttonWithType:UIButtonTypeCustom];
        btnDelete.backgroundColor = [UIColor clearColor];
        [btnDelete setImage:[UIImage imageNamed:@"blog-delete"] forState:UIControlStateNormal];
        btnDelete.tag = 116;
        [cell.contentView addSubview:btnDelete];
    }
    
    UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:109];
    UILabel *lbTitle = (UILabel*)[cell.contentView viewWithTag:110];
    UILabel *lbSep = (UILabel*)[cell.contentView viewWithTag:111];
    UIImageView *arrImgView = (UIImageView*)[cell.contentView viewWithTag:112];
    UILabel *lbEqName = (UILabel*)[cell.contentView viewWithTag:113];
    UIImageView *imgViewEq = (UIImageView*)[cell.contentView viewWithTag:114];
    UILabel *lbEqModel = (UILabel*)[cell.contentView viewWithTag:115];
    CSButton *btnDelete = (CSButton*)[cell.contentView viewWithTag:116];

    [imgView setImage:[UIImage imageNamed:equipmentItem.itemImg]];
    imgView.frame = CGRectMake(10, 6, 40, 40);
    
    lbTitle.text = equipmentItem.itemTitle;
    lbTitle.frame = CGRectMake(60, 10, 150, 32);
    
    arrImgView.frame = CGRectMake(310 - 18, 20, 8, 16);
    
    if (equipmentItem.equipName.length > 0) {
        lbEqName.hidden = NO;
        lbEqModel.hidden = NO;
        btnDelete.hidden = NO;
        
        lbEqName.text = equipmentItem.equipName;

        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbEqName.text boundingRectWithSize:CGSizeMake(FLT_MAX, 30)
                                                           options:options
                                                        attributes:@{NSFontAttributeName:lbEqName.font} context:nil].size;
        lbEqName.frame = CGRectMake(60, 50, MIN(lbSize.width, 280 - 60), 30);
        
        NSString *path = [[NSBundle mainBundle] pathForResource:equipmentItem.equipImg ofType:@"webp"];
        
        if(path == NULL)
        {
            imgViewEq.hidden = YES;
        }
        else
        {
            UIImage *image = [UIImage imageNamedWithWebP:equipmentItem.equipImg];
            imgViewEq.hidden = NO;
            [imgViewEq setImage:image];
            imgViewEq.frame = CGRectMake(CGRectGetMaxX(lbEqName.frame) + 5, 50, 66, 27);
        }

        if (equipmentItem.equipModel.length > 0) {
            lbEqModel.text = [NSString stringWithFormat:@"%@(型号)", equipmentItem.equipModel];
            CGSize lbSize1 = [lbEqModel.text boundingRectWithSize:CGSizeMake(280 - 70, FLT_MAX)
                                                          options:options
                                                       attributes:@{NSFontAttributeName:lbEqModel.font} context:nil].size;
            lbEqModel.frame = CGRectMake(60, CGRectGetMaxY(lbEqName.frame) + 5, 280 - 70, lbSize1.height);
        }
        
        cell.frame = CGRectMake(0, 0, 310, (lbEqModel.text.length > 0 ? CGRectGetMaxY(lbEqModel.frame) + 10 : 95));
        btnDelete.frame = CGRectMake(280, CGRectGetHeight(cell.frame) - 32, 30, 25);
        
        __weak __typeof(self) weakSelf = self;
        
        btnDelete.actionBlock = ^(void)
        {
            __typeof(self) strongSelf = weakSelf;
            strongSelf->_curEquipmentItem = equipmentItem;
            strongSelf->_alertView = [[UIAlertView alloc] initWithTitle:@"删除装备" message:@"要删除该装备吗？" delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            strongSelf->_alertView.tag = 10;
            [strongSelf->_alertView show];
        };
    }
    else
    {
        lbEqName.hidden = YES;
        imgViewEq.hidden = YES;
        lbEqModel.hidden = YES;
        btnDelete.hidden = YES;
        
        cell.frame = CGRectMake(0, 0, 310, 52);
    }
    
    lbSep.frame = CGRectMake(60, CGRectGetMaxY(cell.frame) - 1, 250, 1);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EquipmentChooseViewController *equipmentChooseViewController = [[EquipmentChooseViewController alloc]init];
    
    if ([indexPath row] == 0) {
        equipmentChooseViewController.nEquipType = EQUIP_TYPE_SHOES;
    }
    else if([indexPath row] == 1)
    {
        equipmentChooseViewController.nEquipType = EQUIP_TYPE_DEVICE;
    }
    else
    {
        equipmentChooseViewController.nEquipType = EQUIP_TYPE_APP;
    }
    
    [self.navigationController pushViewController:equipmentChooseViewController animated:YES];
}

#pragma mark - AlertView Logic

-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            [self deleteEquipment];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
