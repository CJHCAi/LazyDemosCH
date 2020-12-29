//
//  TGFriendTrendVC.m
//  baisibudejie
//
//  Created by targetcloud on 2017/3/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import "TGFriendTrendVC.h"
#import "CardView.h"
#import "CardItem2.h"
#import "CardViewConstants.h"
#import "LBPhotoBrowserManager.h"
#import "LJSeeViewController.h"

@interface TGFriendTrendVC ()<CardViewDelegate, CardViewDataSource,UIAlertViewDelegate>
{
    BOOL __oneTypeItem;
    CardViewItemScrollMode __cardViewMode;
}

@property (strong, nonatomic) NSMutableArray<NSString *> * model2;
@property (weak, nonatomic) IBOutlet CardView * cardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * cardViewHeightConstraint;
@end

static NSString * ITEM_XIB_2  = @"CardItem2";
static NSString * ITEM_RUID_2 = @"Item_RUID2";

@implementation TGFriendTrendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self initData];
    self.cardView.delegate   = self;
    self.cardView.dataSource = self;
    self.cardView.maxItems   = 3;
    self.cardView.scaleRatio = 0.05;
    self.cardViewHeightConstraint.constant = CARD_ITEM_H + 100;
    
    [self.view layoutIfNeeded];
    
    [self.cardView registerXibFile:ITEM_XIB_2 forItemReuseIdentifier:ITEM_RUID_2];
    [self.cardView reloadData];
}

- (void)initData
{
    
    self.model2 = [NSMutableArray array];
    for (int i=1; i<=27; i++) {
        
        [self.model2 addObject:[NSString stringWithFormat:@"class01_%.2d",i]];
        
    }
    
}

#pragma mark - CYKJCardViewDelegate/DataSource

- (NSInteger)numberOfItemsInCardView:(CardView *)cardView
{
    return   [self.model2 count];
    
}

- (CardViewItem *)cardView:(CardView *)cardView itemAtIndex:(NSInteger)index
{
    
    CardItem2 * item2 = (CardItem2 *)[cardView dequeueReusableCellWithIdentifier:ITEM_RUID_2];
    
    item2.imageView.image = [UIImage imageNamed:self.model2[index]];
    
    return item2;
    
}

- (CGRect)cardView:(CardView *)cardView rectForItemAtIndex:(NSInteger)index
{
    return CGRectMake(0, 0, CARD_ITEM_W, CARD_ITEM_H);
}

- (void)cardView:(CardView *)cardView didSelectItemAtIndex:(NSInteger)index
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存图片至相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
          [self collectPictrue:[UIImage imageNamed:[NSString stringWithFormat:@"class01_%.2d",(int)index+1]]];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
        
    }];
    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        LJSeeViewController *seeVC = [[LJSeeViewController alloc] init];
        seeVC.image = [UIImage imageNamed:[NSString stringWithFormat:@"class01_%.2d",(int)index+1]];
        [self presentViewController:seeVC animated:YES completion:nil];
        
    }];
    
    [alertController addAction:okAction];
    [alertController addAction:errorAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)collectPictrue:(UIImage *)imageView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已保存到相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(imageView, nil, nil, nil);
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
//根据被点击的按钮做出反应，0对应destructiveButton，之后的button依次排序


- (void)setupNavBar{
    //self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    self.navigationItem.title = @"图卡";
    
}

- (void)friendsRecomment{
    TGFunc
   
}

- (IBAction)loginRegister:(id)sender {
   
}

@end
