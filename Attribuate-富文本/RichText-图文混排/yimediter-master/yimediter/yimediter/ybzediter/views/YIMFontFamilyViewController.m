//
//  YIMFontFamilyViewController.m
//  yimediter
//
//  Created by ybz on 2017/11/25.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMFontFamilyViewController.h"
#import "YIMEditerFontFamilyManager.h"
#import "NSBundle+YIMBundle.h"

@interface YIMFontFamilyTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation YIMFontFamilyTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *label = [[UILabel alloc]init];
        label.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:label];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[label]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.contentView,label)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-16-[label]-16-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self.contentView,label)]];
        self.titleLabel = label;
    }
    return self;
}
@end


@interface YIMFontFamilyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)YIMEditerFontFamilyManager *ffmanager;
@end

@implementation YIMFontFamilyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.ffmanager = [YIMEditerFontFamilyManager defualtManager];
    
    UITableView *tableView = [[UITableView alloc]init];
    [tableView registerClass:[YIMFontFamilyTableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.frame = self.view.bounds;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.ffmanager allRegistFontName].count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YIMFontFamilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleLabel.text = [[NSBundle YIMBundle]localizedStringForKey:@"你好，世界" value:@"你好，世界" table:nil];
    cell.titleLabel.font = [self.ffmanager fontWithName:[self.ffmanager allRegistFontName][indexPath.row] size:20];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(self.completeSelect)
        self.completeSelect([self.ffmanager allRegistFontName][indexPath.row]);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
