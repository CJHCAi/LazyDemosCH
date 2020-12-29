//
//  ShakeViewController.m
//  通讯userInformationPage
//
//  Created by lanou on 15/11/30.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import "ShakeViewController.h"
#import "UIView+UIView_Frame.h"
#import "DetailListModel.h"
#import "DetailController.h"
#import "PrefixHeader.pch"
#import "UIImageView+WebCache.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ShakeViewController ()
@property (nonatomic, weak) UIImageView *bg;
@property (nonatomic, weak) UIImageView *up;
@property (nonatomic, weak) UIImageView *down;
@property(nonatomic, assign)NSInteger numb;
//@property(nonatomic, strong)DetailListModel *detailListModel;
@property(nonatomic, strong)NSMutableArray *modelArray;
@end

@implementation ShakeViewController
//懒加载(你用我的时候我再创建它)
- (NSMutableArray *)modelArray
{
    if(!_modelArray)
    {
        self.modelArray=[NSMutableArray array];
    }
    return _modelArray;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Shake shake"];
    
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage imageNamed:@"bg_shaking"];
    bg.frame = self.view.bounds;
    [self.view addSubview:bg];
    self.bg = bg;
    
    
    UIImageView *up = [[UIImageView alloc] init];
    up.image = [UIImage imageNamed:@"yaoyao_above"];
    up.frame = CGRectMake(0, self.view.height / 6.6, self.view.width, self.view.width / 1.65);
    [bg addSubview:up];
    self.up = up;
    
    
    UIImageView *down = [[UIImageView alloc] init];
    down.image = [UIImage imageNamed:@"yaoyao_under"];
    down.frame = CGRectMake(0, self.view.width / 1.65 + self.view.height / 6.6, self.view.width, self.view.width / 1.43);
    [bg addSubview:down];
    self.down = down;
}


-(BOOL)canBecomeFirstResponder
{
    return YES;
}


-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self becomeFirstResponder];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - 实现相应的响应者方法
/** 开始摇一摇 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motionBegan");
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    CGFloat offset = self.bg.height/2;
    CGFloat duration = 1;
    
    [UIView animateWithDuration:duration animations:^{
        self.up.y -= offset;
        self.down.y += offset;
    }];
    
    [self.modelArray removeAllObjects];
    
//    [LZAudioTool playMusic:@"dance.mp3"];
}

/** 摇一摇结束（需要在这里处理结束后的代码） */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    // 不是摇一摇运动事件
    if (motion != UIEventSubtypeMotionShake) return;
    
    NSLog(@"motionEnded");
    CGFloat offset = self.bg.height / 2;
    CGFloat duration = 1;
    [UIView animateWithDuration:duration animations:^{
        self.up.y += offset;
        self.down.y -= offset;

    }];
    
    //触发一个随机id
    self.numb=(int)(arc4random()%7999-1);
    
    NSString *url=[NSString stringWithFormat:@"http://apis.juhe.cn/cook/queryid?id=%ld&dtype=&key=e074fab9f025b7bc80731753b2fa9aa7",self.numb];
    NSLog(@"%ld",self.numb);
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSDictionary *result=[dic objectForKey:@"result"];
        
        NSArray *dataArray=[result objectForKey:@"data"];
        
        for(NSDictionary *dataDic in dataArray)
        {
            DetailListModel *detailModel=[[DetailListModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:dataDic];
        
            [self.modelArray addObject:detailModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self performSelector:@selector(tiaozhuan) withObject:nil afterDelay:0];

        });
        NSLog(@"%@", self.modelArray);
    }] resume];
    
   
}
- (void)tiaozhuan
{
    //跳转详情界面
    DetailController *detail=[[DetailController alloc]init];
    detail.model=self.modelArray[0];
    [self.navigationController pushViewController:detail animated:YES];
}
/** 摇一摇取消（被中断，比如突然来电） */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motionCancelled");
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"再来一次" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    CGFloat offset = self.bg.height / 2;
    CGFloat duration = 1;
    [UIView animateWithDuration:duration animations:^{
        self.up.y += offset;
        self.down.y -= offset;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
