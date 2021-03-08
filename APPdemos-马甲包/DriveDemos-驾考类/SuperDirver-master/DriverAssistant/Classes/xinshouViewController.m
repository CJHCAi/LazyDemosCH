//
//  xinshouViewController.m
//  SuperDriver
//
//  Created by 王俊钢 on 2017/2/22.
//  Copyright © 2017年 C. All rights reserved.
//

#import "xinshouViewController.h"
#import "Cell.h"
#import "Model.h"
static NSString *cellID = @"cellID";
@interface xinshouViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray<Model*> *_modelList;
}
@property (nonatomic,strong) UITableView *cartableView;


@end

@implementation xinshouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新手上路";
    [self loadData];
    [self.view addSubview:self.cartableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getters

-(UITableView *)cartableView
{
    if(!_cartableView)
    {
        _cartableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
        _cartableView.dataSource = self;
        _cartableView.delegate = self;
        [_cartableView registerClass:[Cell class] forCellReuseIdentifier:cellID];
    }
    return _cartableView;
}

// MARK: - 加载数据

- (void)loadData {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"TextInfo" withExtension:@"json"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSArray<NSDictionary*> *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSMutableArray<Model *> *arrM = [NSMutableArray arrayWithCapacity:array.count];
        
        [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Model *model = [[Model alloc] initWithDict:obj];
            [arrM addObject:model];
        }];
        _modelList = arrM.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cartableView reloadData];
        });
    });
}

// MARK: - tableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    Model *model = _modelList[indexPath.row];
    cell.model = model;
    [cell setShowMoreBlock:^(UITableViewCell *currentCell) {
        NSIndexPath *reloadIndexPath = [self.cartableView indexPathForCell:currentCell];
        [self.cartableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    return cell;
}

// MARK: - 返回cell高度的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *model = _modelList[indexPath.row];
    if (model.isShowMoreText){
        return [Cell moreHeight:model];
    } else{
        return [Cell defaultHeight:model];
    }
}



@end
