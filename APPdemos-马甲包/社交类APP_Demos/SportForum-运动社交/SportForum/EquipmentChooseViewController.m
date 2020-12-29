//
//  EquipmentChooseViewController.m
//  SportForum
//
//  Created by liyuan on 4/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "EquipmentChooseViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"
#import "EquipmentEditViewController.h"

@interface EquipmentChooseViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation EquipmentChooseViewController
{
    NSArray* m_arrEquipItems;
    UITableView *m_tableEquip;
}

-(NSString*)generateTitle
{
    NSString *strTitle = @"跑鞋";
    
    switch (_nEquipType) {
        case EQUIP_TYPE_SHOES:
            strTitle = @"跑鞋";
            break;
        case EQUIP_TYPE_SHOES_OTHER:
            strTitle = @"其他跑鞋";
            break;
        case EQUIP_TYPE_DEVICE:
            strTitle = @"可穿戴设备";
            break;
        case EQUIP_TYPE_DEVICE_OTHER:
            strTitle = @"其他可穿戴设备";
            break;
        case EQUIP_TYPE_APP:
            strTitle = @"轨迹记录APP";
            break;
        default:
            break;
    }
    
    return strTitle;
}

-(void)loadEquipmentItems
{
    switch (_nEquipType) {
        case EQUIP_TYPE_SHOES:
            m_arrEquipItems = @[@"耐克", @"阿迪达斯", @"纽巴伦", @"亚瑟士", @"锐步", @"彪马", @"美津浓", @"李宁", @"安踏", @"匹克", @"Brooks"];
            break;
        case EQUIP_TYPE_SHOES_OTHER:
            m_arrEquipItems = @[@"乔丹", @"361度", @"鸿星尔克", @"Aetrex", @"ALTRA", @"Anatom", @"CBA", @"Columbia", @"D.GROWTH", @"Diadora", @"ecoo", @"Etonic", @"Hoka-one-one", @"Iceberg", @"Iecoq-sportif", @"Kappa", @"Kalenji", @"Karhu", @"KSWISS", @"La-Sporyiva", @"Merrell", @"Montrail", @"MVP-BOY", @"newton", @"Patagonia", @"Pearl-Izumi",  @"Salomon", @"Salomon2", @"Salomon3", @"Saucony", @"Scarpa", @"Scott", @"Skora", @"Speedo", @"Spira", @"Tecnica", @"Terra-Plana", @"Teva", @"The-North-Face", @"Topo-Athletic", @"Treksta", @"Under-Armour", @"Vibram", @"Vivobarefoot", @"Zoot", @"特步", @"三叶草", @"中大鳄鱼", @"乐途", @"乔丹格兰", @"伊蒂泰斯", @"先吉", @"八哥", @"公牛世家", @"力为", @"十只狼", @"卡尊", @"双星", @"喜得龙", @"喜攀登", @"回力", @"多威", @"安超", @"宜动", @"宾木", @"富贵鸟", @"左丹狼", @"德尔加多", @"德尔惠", @"意尔康", @"执行官", @"斐乐", @"斯凯奇", @"杰作", @"沃特", @"波尼", @"海斯尔", @"潮熙", @"火炬", @"玩觅", @"美克", @"艾弗森", @"艾的威", @"花花公子", @"苹果", @"茵奈儿", @"茵宝", @"贝踏", @"贵人鸟", @"赛琪", @"跨洋", @"踏旺", @"金帅威", @"金莱克", @"领舞者", @"飙山狼", @"骄傲男孩"];
            break;
        case EQUIP_TYPE_DEVICE:
            m_arrEquipItems = @[@"Apple-Watch", @"Nike+sportwatch", @"fitbit", @"TCL", @"三星", @"中兴", @"华为", @"咕咚-设备", @"小米", @"索尼", @"联想", @"荣耀"];
            break;
        case EQUIP_TYPE_DEVICE_OTHER:
            m_arrEquipItems = @[@"bodivis", @"bong2", @"COTEetCIEL", @"GYENNO-One", @"Hi-PEEL", @"hicling", @"ibody-追客", @"Misfit", @"oppo", @"SENBOWE", @"USAMS", @"Weloop-Now-Classic", @"一丁手环", @"三旭数码", @"乐心", @"佳明（GARMIN）", @"卓棒", @"品佳", @"唯动（vidonn）", @"喜越", @"埃微(iwown)", @"山水", @"幻响", @"智蝶科技(SMARTFLY)", @"朵酷", @"爱国者", @"爱迪思（Aidis）", @"玩咖（wan-ka）", @"环宇", @"美创", @"运动令", @"酷道"];
            break;
        case EQUIP_TYPE_APP:
            m_arrEquipItems = @[@"NikeRunning", @"乐动力", @"咕咚", @"Strava", @"Runtastic", @"悦跑圈", @"endomondo", @"Runkeeper", @"益动GPS", @"Cyberace-赛跑乐"];
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:[self generateTitle] IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    [self loadEquipmentItems];
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableEquip = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableEquip.delegate = self;
    m_tableEquip.dataSource = self;
    [viewBody addSubview:m_tableEquip];
    
    [m_tableEquip reloadData];
    m_tableEquip.backgroundColor = [UIColor clearColor];
    m_tableEquip.separatorColor = [UIColor clearColor];
    
    if ([m_tableEquip respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableEquip setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"EquipmentChooseViewController dealloc called!");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nRows = 1;
    
    if (section == 0) {
        nRows = [m_arrEquipItems count];
    }
    
    return nRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger nSession = 2;
    
//    if (_nEquipType == EQUIP_TYPE_APP) {
//        nSession = 1;
//    }
//    else
//    {
//        nSession = 2;
//    }
    
    return nSession;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        static NSString *CellTableIdentifier = @"EquipmentChooseIdentifier";
        NSString *strItem = m_arrEquipItems[[indexPath row]];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *lbTitle = [[UILabel alloc]init];
            lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
            lbTitle.textAlignment = NSTextAlignmentLeft;
            lbTitle.backgroundColor = [UIColor clearColor];
            lbTitle.textColor = [UIColor darkGrayColor];
            lbTitle.tag = 9;
            [cell.contentView addSubview:lbTitle];
            
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.tag = 10;
            [cell.contentView addSubview:imgView];
            
            UILabel *lbSep = [[UILabel alloc]init];
            lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
            lbSep.tag = 11;
            [cell.contentView addSubview:lbSep];
            
            UIImageView *arrImgView = [[UIImageView alloc]init];
            [arrImgView setImage:[UIImage imageNamed:@"arrow-1"]];
            arrImgView.tag = 12;
            [cell.contentView addSubview:arrImgView];
        }
        
        UILabel *lbTitle = (UILabel*)[cell.contentView viewWithTag:9];
        UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:10];
        UILabel *lbSep = (UILabel*)[cell.contentView viewWithTag:11];
        UIImageView *arrImgView = (UIImageView*)[cell.contentView viewWithTag:12];
        
        lbTitle.text = ([strItem isEqualToString:@"咕咚-设备"] ? @"咕咚" : strItem);
        lbTitle.frame = CGRectMake(15, 20, 145, 30);
        
        [imgView setImage:[UIImage imageNamedWithWebP:[NSString stringWithFormat:@"%@-big", strItem]]];
        imgView.frame = CGRectMake(160, 12, 110, 44);
        
        arrImgView.frame = CGRectMake(310 - 18, 27, 8, 16);
        cell.frame = CGRectMake(0, 0, 310, 70);
        lbSep.frame = CGRectMake(0, CGRectGetMaxY(cell.frame) - 1, 310, 1);
        
        return cell;
    }
    else
    {
        static NSString *CellTableIdentifier = @"EquipmentChooseOtherIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView *imgBg = [[UIImageView alloc]init];
            imgBg.tag = 13;
            [cell.contentView addSubview:imgBg];
            
            UILabel *lbTitle = [[UILabel alloc]init];
            lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
            lbTitle.textAlignment = NSTextAlignmentLeft;
            lbTitle.backgroundColor = [UIColor clearColor];
            lbTitle.textColor = [UIColor darkGrayColor];
            lbTitle.tag = 20;
            [cell.contentView addSubview:lbTitle];
            
            UIImageView *arrImgView = [[UIImageView alloc]init];
            [arrImgView setImage:[UIImage imageNamed:@"arrow-1"]];
            arrImgView.tag = 15;
            [cell.contentView addSubview:arrImgView];
        }
        
        UIImageView *imgBg = (UIImageView*)[cell.contentView viewWithTag:13];
        UILabel *lbTitle = (UILabel*)[cell.contentView viewWithTag:20];
        UIImageView *arrImgView = (UIImageView*)[cell.contentView viewWithTag:15];
        
        UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
        imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
        imgBg.frame = CGRectMake(5, 0, 300, 70);
        [imgBg setImage:imgBk];
        
        if (_nEquipType == EQUIP_TYPE_SHOES || _nEquipType == EQUIP_TYPE_DEVICE) {
            lbTitle.text = @"其他品牌";
        }
        else
        {
            lbTitle.text = @"自定义品牌";
        }
        
        lbTitle.frame = CGRectMake(15, 20, 150, 30);
        
        arrImgView.frame = CGRectMake(310 - 18, 27, 8, 16);
        cell.frame = CGRectMake(0, 0, 310, 70);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    else
    {
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    if (section == 0) {
        view.frame = CGRectMake(0, 0, CGRectGetWidth(m_tableEquip.frame), 40);
        view.backgroundColor = [UIColor colorWithRed:205.0 / 255.0 green:205.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
        
        UILabel * lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 150, 20)];
        lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.text = @"选择品牌";
        lbTitle.textColor = [UIColor whiteColor];
        [view addSubview:lbTitle];
    }
    else
    {
        view.frame = CGRectMake(0, 0, CGRectGetWidth(m_tableEquip.frame), 25);
        view.backgroundColor = [UIColor clearColor];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        if (_nEquipType == EQUIP_TYPE_APP) {
            UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
            EquipmentInfo *equipmentInfo = userInfo.user_equipInfo;
            [equipmentInfo.step_tool.data removeAllObjects];
            [equipmentInfo.step_tool.data addObject:m_arrEquipItems[[indexPath row]]];
            
            id _processId = [AlertManager showCommonProgress];
            
            [[SportForumAPI sharedInstance]userUpdateEquipment:equipmentInfo FinishedBlock:^(int errorCode, ExpEffect* expEffect) {
                [AlertManager dissmiss:_processId];
                
                if (errorCode == 0) {
                    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                     {
                         if (errorCode == 0)
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     }];
                }
                else
                {
                    [JDStatusBarNotification showWithStatus:@"设置装备失败" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                }
            }];
        }
        else
        {
            EquipmentEditViewController *equipmentEditViewController = [[EquipmentEditViewController alloc]init];
            equipmentEditViewController.strTitle = @"填写型号";
            equipmentEditViewController.strEquipName = m_arrEquipItems[[indexPath row]];

            if (_nEquipType == EQUIP_TYPE_SHOES || _nEquipType == EQUIP_TYPE_SHOES_OTHER) {
                equipmentEditViewController.nEquipType = EQUIP_TYPE_EDIT_SHOES;
            }
            else if (_nEquipType == EQUIP_TYPE_DEVICE || _nEquipType == EQUIP_TYPE_DEVICE_OTHER)
            {
                equipmentEditViewController.nEquipType = EQUIP_TYPE_EDIT_DEVICE;
            }
            
            [self.navigationController pushViewController:equipmentEditViewController animated:YES];
        }
    }
    else
    {
        if (_nEquipType == EQUIP_TYPE_SHOES) {
            EquipmentChooseViewController *equipmentChooseViewController = [[EquipmentChooseViewController alloc]init];
            equipmentChooseViewController.nEquipType = EQUIP_TYPE_SHOES_OTHER;
            [self.navigationController pushViewController:equipmentChooseViewController animated:YES];
        }
        else if(_nEquipType == EQUIP_TYPE_DEVICE)
        {
            EquipmentChooseViewController *equipmentChooseViewController = [[EquipmentChooseViewController alloc]init];
            equipmentChooseViewController.nEquipType = EQUIP_TYPE_DEVICE_OTHER;
            [self.navigationController pushViewController:equipmentChooseViewController animated:YES];
        }
        else
        {
            EquipmentEditViewController *equipmentEditViewController = [[EquipmentEditViewController alloc]init];
            equipmentEditViewController.strTitle = @"自定义品牌";

            if (_nEquipType == EQUIP_TYPE_SHOES_OTHER) {
                equipmentEditViewController.nEquipType = EQUIP_TYPE_EDIT_SHOES;
            }
            else if (_nEquipType == EQUIP_TYPE_DEVICE_OTHER)
            {
                equipmentEditViewController.nEquipType = EQUIP_TYPE_EDIT_DEVICE;
            }
            else
            {
                equipmentEditViewController.nEquipType = EQUIP_TYPE_EDIT_APP;
            }
            
            [self.navigationController pushViewController:equipmentEditViewController animated:YES];
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
