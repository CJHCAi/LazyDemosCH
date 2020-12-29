//
//  GameViewController.m
//  SportForum
//
//  Created by liyuan on 12/23/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "GameViewController.h"
#import "UIViewController+SportFormu.h"
#import "WebGameViewController.h"
#import "AlertManager.h"
#import "PokerViewControllerEx.h"
#import "AccountPreViewController.h"
#import "AppDelegate.h"

#define GAME_CONTENT_VIEW 9
#define GAME_TITLE_LABEL_TAG 10
#define GAME_DESC_IMAGE_TAG 11
#define GAME_ARROW_IMAGE_TAG 12

@implementation GameItem

@end

@interface GameViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation GameViewController
{
    NSArray * _arrTableStruct;
    NSMutableArray* m_gameItems;
    UITableView *m_tableGame;
}

-(void)generateGameItems
{
    m_gameItems = [[NSMutableArray alloc]init];
    
    GameItem *gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"熊出没";
    gameItem.gameImg = @"game-bear";
    gameItem.eGameType = e_game_xiongchumo;
    [m_gameItems addObject:gameItem];
    
    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"爱之跳跳";
    gameItem.gameImg = @"game-qixi";
    gameItem.eGameType = e_game_qixi;
    [m_gameItems addObject:gameItem];
    
    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"蜘蛛侠";
    gameItem.gameImg = @"game-lineLife";
    gameItem.eGameType = e_game_spiderman;
    [m_gameItems addObject:gameItem];
    
    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"古墓历险";
    gameItem.gameImg = @"game-escape";
    gameItem.eGameType = e_game_mishi;
    [m_gameItems addObject:gameItem];
    
    gameItem = [[GameItem alloc]init];
    gameItem.gameTitle = @"幸运转盘";
    gameItem.gameImg = @"game-rotate";
    gameItem.eGameType = e_game_znm;
    [m_gameItems addObject:gameItem];
    
    _arrTableStruct = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:(int)m_gameItems.count],
                       [NSNumber numberWithInt:1],
                       nil];
}

-(BOOL)bShowFooterViewController {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:_taskInfo != nil ? @"魔法冒险任务" : @"魔法冒险" IsNeedBackBtn:YES];
    [self generateGameItems];
    
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
    
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableGame = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    m_tableGame.delegate = self;
    m_tableGame.dataSource = self;
    [viewBody addSubview:m_tableGame];
    
    [m_tableGame reloadData];
    m_tableGame.backgroundColor = [UIColor clearColor];
    m_tableGame.separatorColor = [UIColor clearColor];
    
    if ([m_tableGame respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableGame setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"游戏选择 - GameViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"游戏选择 - GameViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"游戏选择 - GameViewController"];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.mainNavigationController updateTabBarItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"GameViewController dealloc called!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_arrTableStruct objectAtIndex:section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrTableStruct count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"GameIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* viewContent = [[UIImageView alloc]init];
        viewContent.tag = GAME_CONTENT_VIEW;
        [cell.contentView addSubview:viewContent];
        
        UIImageView * imgDescImage = [[UIImageView alloc] init];
        imgDescImage.tag = GAME_DESC_IMAGE_TAG;
        [viewContent addSubview:imgDescImage];
        
        UILabel * lbGameTitle = [[UILabel alloc]init];
        lbGameTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbGameTitle.textAlignment = NSTextAlignmentLeft;
        lbGameTitle.backgroundColor = [UIColor clearColor];
        lbGameTitle.textColor = [UIColor blackColor];
        lbGameTitle.tag = GAME_TITLE_LABEL_TAG;
        [viewContent addSubview:lbGameTitle];
        
        UIImageView * imgArrow = [[UIImageView alloc] init];
        imgArrow.tag = GAME_ARROW_IMAGE_TAG;
        [viewContent addSubview:imgArrow];
    }
    
    GameItem *gameItem = nil;
    
    UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    BOOL bFirstSection = NO;
    
    if ([indexPath section] == 0) {
        gameItem = m_gameItems[[indexPath row]];
        bFirstSection = YES;
    }
    
    UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:GAME_CONTENT_VIEW];
    viewContent.frame = CGRectMake(5, 1, 300, bFirstSection ? 50 : 60);
    [viewContent setImage:imgBk];
    
    UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:GAME_DESC_IMAGE_TAG];
    UIImage *image = [UIImage imageNamed:gameItem != nil ? gameItem.gameImg : @"game-poker"];
    [imgDescImage setImage:image];
    imgDescImage.frame = CGRectMake(8, bFirstSection ? 3 : 8, 40, 40);
    
    UILabel * lbGameTitle = (UILabel*)[viewContent viewWithTag:GAME_TITLE_LABEL_TAG];
    lbGameTitle.text = gameItem != nil ? gameItem.gameTitle : @"德州扑克内测尝鲜版\n(该游戏处于测试阶段)";
    //CGSize lbLeftSize = [lbGameTitle.text sizeWithFont:lbGameTitle.font
    //                                   constrainedToSize:CGSizeMake(150, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize lbLeftSize = [lbGameTitle.text boundingRectWithSize:CGSizeMake(150, FLT_MAX)
                                         options:options
                                      attributes:@{NSFontAttributeName:lbGameTitle.font} context:nil].size;
    
    if (bFirstSection) {
        lbGameTitle.frame = CGRectMake(15 + image.size.width, 15, lbLeftSize.width, 20);
    }
    else
    {
        lbGameTitle.numberOfLines = 0;
        lbGameTitle.frame = CGRectMake(15 + image.size.width, 10, lbLeftSize.width, 40);
    }
    
    UIImageView * imgArrow = (UIImageView*)[cell.contentView viewWithTag:GAME_ARROW_IMAGE_TAG];
    image = [UIImage imageNamed:@"arrow-1"];
    [imgArrow setImage:image];
    imgArrow.frame = CGRectMake(viewContent.frame.size.width - 15 - image.size.width, bFirstSection ? 15 : 20, image.size.width, image.size.height);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath section] == 0 ? 52 : 62;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat fHeight = 5;
    
    if(section > 0)
    {
        fHeight = 10;
    }
    
    return fHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        NSString *strGameDir = @"";
        GameItem *gameItem = m_gameItems[[indexPath row]];
        
        if ([gameItem.gameTitle isEqualToString:@"熊出没"]) {
            strGameDir = @"xiongchumo";
        }
        else if([gameItem.gameTitle isEqualToString:@"爱之跳跳"])
        {
            strGameDir = @"qixi";
        }
        else if([gameItem.gameTitle isEqualToString:@"蜘蛛侠"])
        {
            strGameDir = @"spiderman";
        }
        else if([gameItem.gameTitle isEqualToString:@"古墓历险"])
        {
            strGameDir = @"mishi";
        }
        else if([gameItem.gameTitle isEqualToString:@"幸运转盘"])
        {
            strGameDir = @"znm";
        }
        
        WebGameViewController *webGameViewController = [[WebGameViewController alloc]init];
        webGameViewController.gameTitle = gameItem.gameTitle;
        webGameViewController.eGameType = gameItem.eGameType;
        webGameViewController.gameDir = strGameDir;
        webGameViewController.taskInfo = _taskInfo;
        [self.navigationController pushViewController:webGameViewController animated:YES];
    }
    else
    {
        NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
        NSString* strAccessToken = [dict objectForKey:@"AccessToken"];
        
        PokerViewControllerEx* pocker  = [[PokerViewControllerEx alloc]init];
        pocker.token = strAccessToken;
        
        __typeof__(pocker) __weak thisPocker = pocker;
        
         pocker.profileShowBlock = ^(NSString* userID) {
             AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
             accountPreViewController.strUserId = userID;
             accountPreViewController.bGame = YES;
             [thisPocker presentViewController:accountPreViewController animated:YES completion:nil];
         };

        [self.navigationController presentViewController:pocker animated:YES completion:nil];
    }
}

@end
