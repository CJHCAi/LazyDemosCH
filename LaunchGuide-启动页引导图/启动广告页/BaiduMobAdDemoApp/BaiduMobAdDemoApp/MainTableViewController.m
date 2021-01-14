//
//  MainTableViewController.m
//  APIExampleApp
//
//  Created by lishan04 on 15-5-14.
//
//

#import "MainTableViewController.h"
#import "BaiduMobAdFirstViewController.h"
#import "BaiduMobAdNormalInterstitialViewController.h"
#import "BaiduMobAdPrerollViewController.h"
#import "NativeTableViewController.h"
#import "NativeLoopViewController.h"
#import "InterstitialExampleViewController.h"
#import "CpuViewController.h"
#import "BaiduMobAdChuileiController.h"
#import "BaiduMobAdDubaoController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"横幅广告";
            break;
        case 1:
            cell.textLabel.text = @"视频贴片";
            break;
        case 2:
            cell.textLabel.text = @"插屏广告";
            break;
        case 3:
            cell.textLabel.text = @"信息流普通";
            break;
        case 4:
            cell.textLabel.text = @"信息流橱窗模板";
            break;
        case 5:
            cell.textLabel.text = @"信息流轮播模板";
            break;
        case 6:
            cell.textLabel.text = @"信息流视频";
            break;
        case 7:
            cell.textLabel.text = @"信息流焦点图(使用示例)";
            break;
        case 8:
            cell.textLabel.text = @"插屏章节切换(使用示例)";
            break;
        case 9:
            cell.textLabel.text = @"内容联盟";
            break;
        case 10:
            cell.textLabel.text = @"垂类";
            break;
        case 11:
            cell.textLabel.text = @"度宝";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *detailViewController = nil;
    switch (indexPath.row) {
        case 0:
            detailViewController = [[[BaiduMobAdFirstViewController alloc]init]autorelease];
            break;
        case 1:
            detailViewController = [[[BaiduMobAdPrerollViewController alloc]init]autorelease];
            break;
        case 2:
            detailViewController = [[[BaiduMobAdNormalInterstitialViewController alloc]init]autorelease];
            break;
        case 3:
            detailViewController = [[[NativeTableViewController alloc]init]autorelease];
            ((NativeTableViewController *)detailViewController).toBeChangedApid=ADID_NORMAL;
            ((NativeTableViewController *)detailViewController).toBeChangedPublisherId=@"ccb60059";
            break;
        case 4:
            detailViewController = [[[NativeTableViewController alloc]init]autorelease];
            ((NativeTableViewController *)detailViewController).toBeChangedApid=ADID_WINDOW;
            ((NativeTableViewController *)detailViewController).toBeChangedPublisherId=@"ccb60059";            break;
        case 5:
            detailViewController = [[[NativeTableViewController alloc]init]autorelease];
            ((NativeTableViewController *)detailViewController).toBeChangedApid=ADID_ROLL;
            ((NativeTableViewController *)detailViewController).toBeChangedPublisherId=@"ccb60059";            break;
        case 6:
            detailViewController = [[[NativeTableViewController alloc]init]autorelease];
            ((NativeTableViewController *)detailViewController).toBeChangedApid=ADID_VIDEO;
            ((NativeTableViewController *)detailViewController).toBeChangedPublisherId=@"ccb60059";            break;
        case 7:
            detailViewController = [[[NativeLoopViewController alloc]init]autorelease];
            break;
        case 8:
            detailViewController = [[[InterstitialExampleViewController alloc]init]autorelease];
            break;
        case 9:
            detailViewController = [[[CpuViewController alloc]init]autorelease];
            break;
        case 10:
            detailViewController = [[[BaiduMobAdChuileiController alloc]init]autorelease];
            ((BaiduMobAdChuileiController *)detailViewController).toBeChangedApid=@"2789987";
            ((BaiduMobAdChuileiController *)detailViewController).toBeChangedPublisherId=@"ccb60059";
            break;
        case 11:
            detailViewController = [[[BaiduMobAdDubaoController alloc]init]autorelease];
            break;
        default:
            break;
    }

    if (detailViewController) {
        [self.navigationController pushViewController:detailViewController animated:NO];
    }
}

@end
