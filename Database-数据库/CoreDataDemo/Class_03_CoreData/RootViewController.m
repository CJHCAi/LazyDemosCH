//
//  RootViewController.m
//  Class_03_CoreData
//
//  Created by wanghao on 16/3/10.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"//导入目的为，得到临时数据库（为了应用可以和数据文件交互）（context）
#import "Student+CoreDataProperties.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)UITableView *myTabelView;
@property (nonatomic,retain)NSMutableArray *allDataArray;//表视图用的数组
@property (nonatomic,retain)NSArray *dataArray;

@property (nonatomic,retain) NSString *name;//alertVC中输入的年龄和姓名
@property (nonatomic,retain) NSString *age;


@end


@implementation RootViewController

-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc]init];
    }
    return _dataArray;
}

-(NSMutableArray *)allDataArray
{
    if (!_allDataArray) {
        _allDataArray = [[NSMutableArray alloc]init];
    }
    return _allDataArray;
}

//为了得到临时数据库context
//得到Appdelegate对象
-(AppDelegate*)appDelegate
{
    //整个应用程序的代理
    return [UIApplication sharedApplication].delegate;
}

//得到context对象
-(NSManagedObjectContext*)context
{
    return [[self appDelegate]managedObjectContext];
}



//数据存储
- (void)addDataToCoreData
{
    //通过实体描述对象，获得实体(相当于得到我们要操作的数据库表)
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:[self context]];
    //写入数据

        //插入操作
        Student *student = [[Student alloc]initWithEntity:entity insertIntoManagedObjectContext:[self context]];
        student.name = self.name;
        student.age = [self.age intValue];
        student.gender = @"m";

    //将context中存储的数据同步到真实的文件中
    [[self appDelegate]saveContext];//这个是在AppDelegate中写好的
    //    BOOL isSave = [[self context]save:nil];//这个save返回bool
    //    if (isSave) {
    //        NSLog(@"ok");
    //    }
    //    else
    //    {
    //        NSLog(@"fs");
    //    }

    
    //刷新显示
    [self fetchData:nil];
}


//由观察者得到text的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
}

//查询操作
-(NSArray*)fetch
{
    //构造出需要查询的实体
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:[self context]];
    //初始化查询工具
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    //为查询工具设置所需要查询的实体
    [req setEntity:entity];
    //设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age < 100"];
    [req setPredicate:predicate];
    
    //排序方法
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
    [req setSortDescriptors:@[sort]];
    
    //执行查询（相当于执行查询语句）
    NSArray *allDataArray = [[self context]executeFetchRequest:req error:nil];
    if (allDataArray&&allDataArray.count) {
        return allDataArray;
    }
    else
    {
        NSLog(@"no result");
        return nil;
    }
}

//删除数据
-(void)deleteData
{
    //从当前数据取出要删除的对象
    if (!_allDataArray.count) {
        NSLog(@"点锤子，没看见没有了");
        return;
    }
    Student *delStu = [self.allDataArray lastObject];
    //删除context里的
    [[self context]deleteObject:delStu];
    
    //同步
    [[self appDelegate]saveContext];
    
    //刷新tableView
    [self fetchData:nil];
}


//更新数据
-(void)updateData
{
    //得到要查询的表
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:[self context]];
    //建立查询的工具类
    NSFetchRequest *req = [[NSFetchRequest alloc]init];
    [req setEntity:entity];
    
    
    //这块自己改咯
    //谓词
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@",@"若风"];
    [req setPredicate:predicate];
    
    //结果
    NSArray *array = [[self context]executeFetchRequest:req error:nil];
    //遍历结果集更改对象属性
    for (Student *stu in array) {
        stu.name = @"倾城";

    }
    //更新操作需要同步
    [[self appDelegate]saveContext];
}


//添加按钮
-(void)addData:(UIBarButtonItem*)sender
{
    //弹出一个alert用来输入内容
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"添加数据" message:@"姓名，年龄" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 读取文本框的值显示出来
        UITextField *nameTF = alertVC.textFields.firstObject;
        self.name = nameTF.text;
        UITextField *ageTF = alertVC.textFields[1];
        self.age = ageTF.text;
        
        //调用方法添加到数据库
        [self addDataToCoreData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //移除观察者
        [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    [alertVC addAction:okAction];
    [alertVC addAction:cancelAction];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"姓名";
        textField.backgroundColor = [UIColor colorWithRed:109/255.0 green:211/255.0 blue:206/255.0 alpha:1];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textAlignment = NSTextAlignmentCenter;
        
        
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"年龄";
        textField.backgroundColor = [UIColor colorWithRed:109/255.0 green:211/255.0 blue:206/255.0 alpha:1];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textAlignment = NSTextAlignmentCenter;
        
        
    }];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    
}

//查询按钮
-(void)fetchData:(UIBarButtonItem*)sender
{
    
    
    self.dataArray = [self fetch];
    self.allDataArray = [NSMutableArray arrayWithArray:[self fetch]];

    //刷新UI
    [_myTabelView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"CoreData";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData:)];
    UIBarButtonItem *serBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(fetchData:)];
    // Do any additional setup after loading the view.
    UIBarButtonItem *delBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteData)];
    
    UIBarButtonItem *upDateBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateData)];
    
    self.navigationItem.rightBarButtonItems = @[serBarBtn,delBarBtn,upDateBarBtn];
    
    //添加tableView
    _myTabelView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:_myTabelView];
    
    //设置代理
    _myTabelView.delegate = self;
    _myTabelView.dataSource = self;
    
    //注册cell
    [_myTabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
}

#pragma mark -- cell

//rows
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _allDataArray.count;
}



//cell in
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_myTabelView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    
    Student *stu = _allDataArray[indexPath.row];
//    NSLog(@"stu%@",stu);
//    NSLog(@"%@",_allDataArray);
    
    cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@,年龄:%d",[stu name],stu.age];
    
    cell.imageView.image = [UIImage imageNamed:@"bufu.jpg"];
    
    
    return cell;
}


@end
