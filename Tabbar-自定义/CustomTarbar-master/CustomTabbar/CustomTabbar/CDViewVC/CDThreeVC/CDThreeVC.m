//
//  CDThreeVC.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDThreeVC.h"

@interface CDThreeVC ()
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation CDThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self operationQueueMaxConcurrentOperationCount];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //当self.operationQueue.suspended 为YES时执行任务，为NO时暂停任务
    //每个任务都有执行状态，暂停的时候正在执行的任务执行完，才会暂停
    //self.operationQueue.suspended = !self.operationQueue.suspended;
    
    //取消所有的任务，正在执行的任务执行完，才会执行这个动作，和暂停类似。该方法不可逆，取消后不能恢复执行
    [self.queue  cancelAllOperations];
}
- (void)operationQueueMaxConcurrentOperationCount
{
    //1:创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    /*
     默认是并发队列，如果最大并发数>1，并发
     如果最大并发数==1，串行
     系统默认的并发数是-1，所有任务全部并发执行
     */
    queue.maxConcurrentOperationCount = 3;
    //2:封装操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"1------%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"2------%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"3------%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"4------%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"5------%@",[NSThread currentThread]);
    }];
    NSBlockOperation *op6 = [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1.0];
        NSLog(@"6------%@",[NSThread currentThread]);
    }];
    
    //3:把操作添加到队列
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    [queue addOperation:op6];
    self.queue = queue;
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
