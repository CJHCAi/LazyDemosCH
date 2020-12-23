//
//  ViewController.m
//  Motion
//
//  Created by 黎仕仪 on 16/9/21.
//  Copyright © 2016年 黎仕仪. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()<UITableViewDataSource,UIAccelerometerDelegate>
{
    NSMutableArray *arr;
    NSMutableArray *arr1;
    NSMutableArray *arr2;
    CMMotionManager *motionManager;
    UITableView *myTableView;
    
    NSString *accStr;
    
    UITextField *textField1;
    UITextField *textField2;
    UITextField *textField3;
    UITextField *textField4;
    
    NSMutableArray *strArr1;
    NSMutableArray *strArr2;
    NSMutableArray *strArr3;
    
    
    
}
@property (nonatomic,assign) float resNumber1;
@property (nonatomic,assign) float resNumber2;
@property (nonatomic,assign) int stepCount;
@property (nonatomic,assign) int stepCount2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    strArr1 = [[NSMutableArray alloc]init];
    strArr2 = [[NSMutableArray alloc]init];
    strArr3 = [[NSMutableArray alloc]init];
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(100, 200, 100, 100);
    [Btn setTitle:@"开始" forState:UIControlStateNormal];
    Btn.backgroundColor = [UIColor grayColor];
    [Btn addTarget:self action:@selector(Btn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, 320, 60) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    
    
    motionManager = [[CMMotionManager alloc]init];
    
    textField1 = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, 100, 30)];
    textField2 = [[UITextField alloc]initWithFrame:CGRectMake(180, 20, 100, 30)];
    textField1.backgroundColor = [UIColor grayColor];
    textField2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textField1];
    [self.view addSubview:textField2];
    
    
    textField3 = [[UITextField alloc]initWithFrame:CGRectMake(20, 60, 100, 30)];
    textField4 = [[UITextField alloc]initWithFrame:CGRectMake(180, 60, 100, 30)];
    textField3.backgroundColor = [UIColor grayColor];
    textField4.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textField3];
    [self.view addSubview:textField4];
    

    UIButton *Btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn1.frame = CGRectMake(100, 400, 100, 100);
    [Btn1 setTitle:@"打印" forState:UIControlStateNormal];
    Btn1.backgroundColor = [UIColor grayColor];
    [Btn1 addTarget:self action:@selector(BtnWW) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn1];
    
}

-(void)BtnWW{
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(dosomething) userInfo:nil repeats:NO];

}

-(void)dosomething{
    NSLog(@"%@",strArr1);
    NSLog(@"%@",strArr2);
    NSLog(@"%@",strArr3);

}



-(void)dododo{
    //    NSLog(@"%@",arr);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [myTableView reloadData];
        
    });
    
}


-(void)Btn{
    
    _stepCount = 0;
    _stepCount2 = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dododo) userInfo:nil repeats:YES];
    
    /* 设置采样的频率，单位是秒 */
    NSTimeInterval updateInterval = 0.02; // 每秒采样50次
    
    //    创建2个数组,存平方和后开根号的数值
    NSMutableArray *dataArr1 = [[NSMutableArray alloc]init];
    NSMutableArray *dataArr2 = [[NSMutableArray alloc]init];
    
    //    创建2个数组,存15个以上数据求和后的平均数
    NSMutableArray *averageArr1 = [[NSMutableArray alloc]init];
    NSMutableArray *averageArr2 = [[NSMutableArray alloc]init];
    
    //    timeTag,处理是不是同一秒数据
    __block int timeTag = 0;
    __block int lastIndex1;
    __block int lastIndex2;
    
    //    __block int stepCount = 0; // 步数
    //在block中，只能使用weakSelf。
    /* 判断是否加速度传感器可用，如果可用则继续 */
    if ([motionManager isAccelerometerAvailable] == YES) {
        /* 给采样频率赋值，单位是秒 */
        [motionManager setAccelerometerUpdateInterval:updateInterval];
        
        /* 加速度传感器开始采样，每次采样结果在block中处理 */
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
          
             NSString *str1 = [NSString stringWithFormat:@"x:%.4f,y:%.4f,z:%.4f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z];
             [strArr1 addObject:str1];
             
             
             float sqrtValue1 = sqrt(accelerometerData.acceleration.x*accelerometerData.acceleration.x+accelerometerData.acceleration.y*accelerometerData.acceleration.y+accelerometerData.acceleration.z*accelerometerData.acceleration.z);
             [dataArr1 addObject:[NSNumber numberWithFloat:sqrtValue1]];
             
             
             NSString *str2 = [NSString stringWithFormat:@"%.4f",sqrtValue1];
             [strArr2 addObject:str2];
             
             float sqrtValue2 = sqrt(accelerometerData.acceleration.x*accelerometerData.acceleration.x+accelerometerData.acceleration.y*accelerometerData.acceleration.y);
             [dataArr2 addObject:[NSNumber numberWithFloat:sqrtValue2]];
             
             //             存了15个数后
             if (dataArr1.count==15) {
                 float sum1 = 0;
                 float sum2 = 0;
                 for (int i=0; i<dataArr1.count; i++) {
                     float value1 = [dataArr1[i] floatValue];
                     float value2 = [dataArr2[i] floatValue];
                     sum1 += value1;
                     sum2 += value2;
                 }
                 float averageValue1 = sum1/15;
                 float averageValue2 = sum2/15;
                 [averageArr1 addObject:[NSNumber numberWithFloat:averageValue1]];
                 [averageArr2 addObject:[NSNumber numberWithFloat:averageValue2]];
                 
                 NSString *str3 = [NSString stringWithFormat:@"%.4f",averageValue1];
                 [strArr3 addObject:str3];
                 //                 去掉最后的一个数据
                 [dataArr1 removeObjectAtIndex:0];
                 [dataArr2 removeObjectAtIndex:0];
                 
             }
             
             // 添加变量i的目的是使得步数在1秒内重新计算
             static int i = 0;
             if (i==50) {
                 i=0;
                 if (averageArr1.count!=0) {
                     
                     //                 将1秒中获取的所有平均值的数据排序，从小到大
                     NSArray *sequenceArr1 = [averageArr1 sortedArrayUsingSelector:@selector(compare:)];
                     NSArray *sequenceArr2 = [averageArr2 sortedArrayUsingSelector:@selector(compare:)];
                     
                     //                 取得从小到大排列后，70%那里的数值
                     int index = sequenceArr1.count * 0.7;
                     float value1 = [sequenceArr1[index] floatValue];
                     float value2 = [sequenceArr2[index] floatValue];
                     
                     //                 求原始数据的平均值，排不排序都一样
                     float sum1 = 0;
                     float sum2 = 0;
                     for (int i=0; i<averageArr1.count; i++) {
                         float value1 = [averageArr1[i] floatValue];
                         float value2 = [averageArr2[i] floatValue];
                         sum1 += value1;
                         sum2 += value2;
                     }
                     float averageValue1 = sum1/averageArr1.count;
                     float averageValue2 = sum2/averageArr2.count;
                     
                     //                 计算门限值
                     if (textField1.text.length==0 ) {
                         _resNumber1 = value1/averageValue1;
                         NSLog(@"xyz的%.3f",_resNumber1);
                         //                 灵敏的xyz
                         if (_resNumber1>1.2) {
                             _resNumber1 = 1.2;
                         }else if (_resNumber1<1.05){
                             _resNumber1 = 1.05;
                         }
                         
                     }else{
                         if (_resNumber1>[textField1.text floatValue]) {
                             _resNumber1 = [textField1.text floatValue];
                         }else if (_resNumber1<[textField2.text floatValue]){
                             _resNumber1 = [textField2.text floatValue];
                         }
                         
                     }
                     
                     if (textField3.text.length==0) {
                         _resNumber2 = value2/averageValue2;
                         NSLog(@"只用xy的%.3f",_resNumber2);
//                                          平稳的xy
                         if (_resNumber2>1.3) {
                             _resNumber2 = 1.3;
                         }else if (_resNumber2<1.15){
                             _resNumber2 = 1.15;
                         }
                         
                     }else{
                         if (_resNumber2>[textField3.text floatValue]) {
                             _resNumber2 = [textField3.text floatValue];
                         }else if (_resNumber1<[textField4.text floatValue]){
                             _resNumber2 = [textField4.text floatValue];
                         }
                         
                     }
                     
                     
                     //                 原始数据中每个元素的值与averageValue*_resNumber得值相比,大就存1,小存0
                     NSMutableArray *zeroAndOneArr1 = [[NSMutableArray alloc]init];
                     NSMutableArray *zeroAndOneArr2 = [[NSMutableArray alloc]init];
                     for (int i=0; i<averageArr1.count; i++) {
                         float value1 = [averageArr1[i] floatValue];
                         if (value1>averageValue1*_resNumber1) {
                             [zeroAndOneArr1 addObject:[NSNumber numberWithInt:1]];
                         }else{
                             [zeroAndOneArr1 addObject:[NSNumber numberWithInt:0]];
                         }
                         
                         float value2 = [averageArr2[i] floatValue];
                         if (value2>averageValue2*_resNumber2) {
                             [zeroAndOneArr2 addObject:[NSNumber numberWithInt:1]];
                         }else{
                             [zeroAndOneArr2 addObject:[NSNumber numberWithInt:0]];
                         }
                         
                     }
                     
                     //                 将数组中数据，后一个减去前一个，再存入另一个数组中去
                     NSMutableArray *otherArr1 = [[NSMutableArray alloc]init];
                     NSMutableArray *otherArr2 = [[NSMutableArray alloc]init];
                     for (int i=1; i<zeroAndOneArr1.count; i++) {
                         int before1 = [zeroAndOneArr1[i-1] intValue];
                         int after1 = [zeroAndOneArr1[i] intValue];
                         int result1 = after1-before1;
                         [otherArr1 addObject:[NSNumber numberWithInt:result1]];
                         
                         int before2 = [zeroAndOneArr2[i-1] intValue];
                         int after2 = [zeroAndOneArr2[i] intValue];
                         int result2 = after2-before2;
                         [otherArr2 addObject:[NSNumber numberWithInt:result2]];
                         
                     }
                     
                     //                 取出数组otherArr中，出现1的下标
                     //                 如果是第一次定位
                     if (timeTag==0) {
                         lastIndex1 = -20;  //开始第一次设小一点
                         lastIndex2 = -20;
                         for (int i=0; i<otherArr1.count; i++) {
                             int value1 = [otherArr1[i] intValue];
                             if (value1==1) {
                                 //                             后一次减前一次下标大于15，则加一步
                                 if (i-lastIndex1>15) {
                                     _stepCount++;
                                     lastIndex1 = i;
                                 }
                             }
                             
                             int value2 = [otherArr2[i] intValue];
                             if (value2==1) {
                                 //                             后一次减前一次下标大于15，则加一步
                                 if (i-lastIndex2>15) {
                                     _stepCount2++;
                                     lastIndex2 = i;
                                 }
                             }
                             
                         }
                         
                     }else if (timeTag!=0){
                         
                         for (int i=0; i<otherArr1.count; i++) {
                             int value1 = [otherArr1[i] intValue];
                             if (value1==1) {
                                 //                             后一次减前一次下标大于15，则加一步
                                 if (50+i-lastIndex1>15) {
                                     _stepCount++;
                                     lastIndex1 = 50+i;
                                 }
                             }
                             
                             int value2 = [otherArr2[i] intValue];
                             if (value2==1) {
                                 //                             后一次减前一次下标大于15，则加一步
                                 if (50+i-lastIndex2>15) {
                                     _stepCount2++;
                                     lastIndex2 = 50+i;
                                 }
                             }
                             
                         }
                         
                         
                     }
                     if (lastIndex1>=50) {
                         lastIndex1 -= 50;
                     }
                     
                     if (lastIndex2>=50) {
                         lastIndex2 -= 50;
                     }
                     
                     
                     
                     timeTag=1;
                     [averageArr1 removeAllObjects];
                     [averageArr2 removeAllObjects];
                     
                 }
                 
                
             }
             
             
             i++;
         }];
        
        
    }

    
    
    
    
}

//----
#pragma mark - tableview dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
 
    cell.textLabel.text = [NSString stringWithFormat:@"xyz:%d步---xy:%d步",_stepCount,_stepCount2];
    
    
    
    return cell;
    
}


@end
