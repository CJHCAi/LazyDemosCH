//
//  LevelViewController.m
//  SportForum
//
//  Created by liyuan on 3/31/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "LevelViewController.h"
#import "UIViewController+SportFormu.h"

@interface LevelItem : NSObject

@property(nonatomic, copy) NSString* itemImg;
@property(nonatomic, copy) NSString* itemTitle;

@property(nonatomic, assign) NSUInteger itemValue;

@end

@implementation LevelItem

@end

@interface LevelViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation LevelViewController
{
    NSMutableArray* m_accountItems;
    UITableView *m_tableLevel;
}

-(void)loadLevelItems
{
    [m_accountItems removeAllObjects];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    LevelItem *levelItem = [[LevelItem alloc]init];
    levelItem.itemTitle = @"体魄";
    levelItem.itemImg = @"me-level-runner";
    levelItem.itemValue = userInfo.proper_info.physique_value;
    [m_accountItems addObject:levelItem];
    
    levelItem = [[LevelItem alloc]init];
    levelItem.itemTitle = @"文学";
    levelItem.itemImg = @"me-level-pen";
    levelItem.itemValue = userInfo.proper_info.literature_value;
    [m_accountItems addObject:levelItem];
    
    levelItem = [[LevelItem alloc]init];
    levelItem.itemTitle = @"魔法";
    levelItem.itemImg = @"me-level-magic";
    levelItem.itemValue = userInfo.proper_info.magic_value;
    [m_accountItems addObject:levelItem];
    
    levelItem = [[LevelItem alloc]init];
    levelItem.itemTitle = @"金币";
    levelItem.itemImg = @"me-level-beibitcoin";
    levelItem.itemValue = userInfo.proper_info.coin_value / 100000000;
    [m_accountItems addObject:levelItem];
    
    levelItem = [[LevelItem alloc]init];
    levelItem.itemTitle = @"级别";
    levelItem.itemImg = @"me-level-grade";
    levelItem.itemValue = userInfo.proper_info.rankLevel;
    [m_accountItems addObject:levelItem];
    
    levelItem = [[LevelItem alloc]init];
    levelItem.itemTitle = @"总分";
    levelItem.itemImg = @"me-level-total-score";
    levelItem.itemValue = userInfo.proper_info.rankscore;
    [m_accountItems addObject:levelItem];
    
    levelItem = [[LevelItem alloc]init];
    levelItem.itemTitle = @"精灵";
    levelItem.itemImg = @"me-level-sprite";
    levelItem.itemValue = userInfo.proper_info.rankLevel;
    [m_accountItems addObject:levelItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    
    [self generateCommonViewInParent:self.view Title:@"等级" IsNeedBackBtn:YES];
    
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
    [self loadLevelItems];
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableLevel = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableLevel.delegate = self;
    m_tableLevel.dataSource = self;
    [viewBody addSubview:m_tableLevel];
    
    [m_tableLevel reloadData];
    m_tableLevel.backgroundColor = [UIColor clearColor];
    m_tableLevel.separatorColor = [UIColor clearColor];
    
    if ([m_tableLevel respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableLevel setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人等级 - LevelViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"个人等级 - LevelViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人等级 - LevelViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"LevelViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    [self loadLevelItems];
    [m_tableLevel reloadData];
}

#pragma mark - Table Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_accountItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"LevelIdentifier";
    LevelItem *levelItem = m_accountItems[[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.tag = 9;
        [cell.contentView addSubview:imgView];
        
        UILabel *lbTitle = [[UILabel alloc]init];
        lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor darkGrayColor];
        lbTitle.tag = 10;
        [cell.contentView addSubview:lbTitle];
        
        UILabel *lbValue = [[UILabel alloc]init];
        lbValue.font = [UIFont boldSystemFontOfSize:14.0];
        lbValue.textAlignment = NSTextAlignmentRight;
        lbValue.backgroundColor = [UIColor clearColor];
        lbValue.textColor = [UIColor darkGrayColor];
        lbValue.tag = 11;
        [cell.contentView addSubview:lbValue];
        
        UILabel *lbSep = [[UILabel alloc]init];
        lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        lbSep.tag = 12;
        [cell.contentView addSubview:lbSep];
        
        UIView *viewEspecial0 = [[UIView alloc]init];
        viewEspecial0.backgroundColor = [UIColor clearColor];
        viewEspecial0.tag = 13;
        [cell.contentView addSubview:viewEspecial0];
        
        UIView *viewEspecial1 = [[UIView alloc]init];
        viewEspecial1.backgroundColor = [UIColor clearColor];
        viewEspecial1.tag = 14;
        [cell.contentView addSubview:viewEspecial1];
    }
    
    UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:9];
    UILabel *lbTitle = (UILabel*)[cell.contentView viewWithTag:10];
    UILabel *lbValue = (UILabel*)[cell.contentView viewWithTag:11];
    UILabel *lbSep = (UILabel*)[cell.contentView viewWithTag:12];
    UIView *viewEspecial0 = [cell.contentView viewWithTag:13];
    UIView *viewEspecial1 = [cell.contentView viewWithTag:14];

    if ([levelItem.itemTitle isEqualToString:@"级别"])
    {
        viewEspecial0.hidden = NO;
        viewEspecial1.hidden = YES;
        lbValue.hidden = YES;
        
        cell.frame = CGRectMake(0, 0, 310, 52);
        
        [imgView setImage:[UIImage imageNamed:levelItem.itemImg]];
        imgView.frame = CGRectMake(10, 6, 40, 40);
        
        lbTitle.text = levelItem.itemTitle;
        lbTitle.frame = CGRectMake(60, 10, 150, 32);
        
        lbSep.frame = CGRectMake(60, CGRectGetMaxY(cell.frame) - 1, 250, 1);
        
        for (UIView *view in [viewEspecial0 subviews]) {
            [view removeFromSuperview];
        }
        
        UIImage *imgLev = [UIImage imageNamed:@"level-bg"];
        UIImageView *imgLevelBk = [[UIImageView alloc]init];
        imgLevelBk.frame = CGRectMake(310 - imgLev.size.width - 10, CGRectGetMidY(cell.frame) - imgLev.size.height / 2, imgLev.size.width, imgLev.size.height);
        imgLevelBk.image = imgLev;
        [viewEspecial0 addSubview:imgLevelBk];
        
        UILabel *lbLevel = [[UILabel alloc]init];
        lbLevel.backgroundColor = [UIColor clearColor];
        lbLevel.text = [NSString stringWithFormat:@"LV.%lu", levelItem.itemValue];
        lbLevel.textColor = [UIColor whiteColor];
        lbLevel.font = [UIFont italicSystemFontOfSize:10];
        lbLevel.frame = CGRectMake(CGRectGetMinX(imgLevelBk.frame), CGRectGetMinY(imgLevelBk.frame), imgLev.size.width, imgLev.size.height);
        lbLevel.textAlignment = NSTextAlignmentCenter;
        [viewEspecial0 addSubview:lbLevel];
    }
    else if([levelItem.itemTitle isEqualToString:@"精灵"])
    {
        viewEspecial0.hidden = YES;
        viewEspecial1.hidden = NO;
        lbValue.hidden = YES;
        
        [imgView setImage:[UIImage imageNamed:levelItem.itemImg]];
        imgView.frame = CGRectMake(10, 6, 40, 40);
        
        lbTitle.text = levelItem.itemTitle;
        lbTitle.frame = CGRectMake(60, 10, 100, 32);
        
        for (UIView *view in [viewEspecial1 subviews]) {
            [view removeFromSuperview];
        }
        
        UIImageView * imgStar[12];
        NSString * strStarImage[3] = {@"level-horse", @"level-rabbit", @"level-snail"};
        for(int i = 0; i < 3; i++)
        {
            for(int j = 0; j < 4; j++)
            {
                imgStar[i * 4 + j] = [[UIImageView alloc] initWithFrame:CGRectMake(280 - j * 20, 16 + i * 22, 20, 20)];
                imgStar[i * 4 + j].image = [UIImage imageNamed:strStarImage[i]];
                [viewEspecial1 addSubview:imgStar[i * 4 + j]];
                imgStar[i * 4 + j].hidden = YES;
            }
        }
        
        NSUInteger nLevel = levelItem.itemValue;
        NSUInteger nHorseCount = nLevel / 25;
        NSUInteger nRabbitCount = (nLevel - nHorseCount * 25) / 5;
        NSUInteger nSnailCount = nLevel - nHorseCount * 25 - nRabbitCount * 5;
        NSUInteger nButtonStartPoint = imgStar[0].frame.origin.y;
        for(NSUInteger i = 0; i < 4; i++)
        {
            imgStar[i].hidden = (i >= nHorseCount);
            imgStar[4 + i].hidden = (i >= nRabbitCount);
            imgStar[8 + i].hidden = (i >= nSnailCount);
            
            CGRect rectStar = imgStar[i].frame;
            if(nHorseCount != 0)
            {
                rectStar.origin.y += 22;
            }
            
            imgStar[4 + i].frame = rectStar;
            if(nRabbitCount != 0)
            {
                rectStar.origin.y += 22;
            }
            
            imgStar[8 + i].frame = rectStar;
        }
        
        if(nHorseCount != 0)
        {
            nButtonStartPoint += 22;
        }
        
        if(nRabbitCount != 0)
        {
            nButtonStartPoint += 22;
        }
        
        if(nSnailCount != 0)
        {
            nButtonStartPoint += 22;
        }

        cell.frame = CGRectMake(0, 0, 310, MAX(nButtonStartPoint + 10, 52));
        lbSep.frame = CGRectMake(60, CGRectGetMaxY(cell.frame) - 1, 250, 1);
    }
    else
    {
        viewEspecial0.hidden = YES;
        viewEspecial1.hidden = YES;
        lbValue.hidden = NO;
        
        cell.frame = CGRectMake(0, 0, 310, 52);
        
        [imgView setImage:[UIImage imageNamed:levelItem.itemImg]];
        imgView.frame = CGRectMake(10, 6, 40, 40);
        
        lbTitle.text = levelItem.itemTitle;
        lbTitle.frame = CGRectMake(60, 10, 150, 32);
        
        lbValue.text = [NSString stringWithFormat:@"%lu", levelItem.itemValue];
        lbValue.frame = CGRectMake(310 - 80 - 10, 10, 80, 32);
        
        lbSep.frame = CGRectMake(60, CGRectGetMaxY(cell.frame) - 1, 250, 1);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
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
