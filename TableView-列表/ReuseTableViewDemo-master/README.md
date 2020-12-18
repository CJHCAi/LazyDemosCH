# 多个button在tableViewCell上的处理及单个button在tableViewCell上的重用处理
最近项目上出现了这种需要在一个cell上多个button的处理问题以及自己在项目中遇到的重用的问题,这也是开发中比较常见的功能和出现的问题,遂在此记录.

## 实现步骤:
1.主界面的布局.

* 布局
* 按钮的点击事件

2.多个button在tableViewCell上的处理.

* 布局
* 计算高度
* 按钮的点击事件
* 传递选中按钮

3.单个button在tableViewCell上的重用处理

* 布局
* 添加选中标记
* 按钮的点击事件
* 传递选中按钮

## 整体效果图:
![整体效果图](https://github.com/LitBr/ReuseTableViewDemo/raw/master/多个button/整体效果图.gif)

## 功能实现:

### 1.主界面的布局.

![主界面](https://github.com/LitBr/ReuseTableViewDemo/raw/master/多个button/主界面.jpg)

#### (1)声明多个button处理的数组addressArray,单个button处理的数组taskArray
```
@property (nonatomic, copy)NSArray *addressArray;

@property (nonatomic, copy)NSArray *taskArray;
```

#### (2)section数目

```
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
```
重点是对cellForRowAtIndexPath方法进行布局

分成 section = 0和 section = 1来处理

#### (3)cell布局

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    switch (indexPath.section) {
        case 0:
            {
            	// 多个button布局
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                // 标题
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH/3, firstSectionHeight)];
                titleLabel.text = @"Buttons";
                titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
                titleLabel.textColor = [UIColor blackColor];
                [cell addSubview:titleLabel];
                // 内容
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH*2/3, firstSectionHeight)];
                contentLabel.font = [UIFont systemFontOfSize:15];
                contentLabel.textColor = RGB(170, 170, 170, 0.75);
                contentLabel.text = @"请选择多个button";
                [cell addSubview:contentLabel];
                // 选中人最多显示三排,多余的人通过上下拉动显示
                UIScrollView *scrollView = [[UIScrollView alloc] init];
                [cell addSubview:scrollView];
                // 选中人的集合
                NSArray *array = self.addressArray;
                NSInteger lines = 0;
                if (array.count%3 != 0) {
                    lines = array.count/3 + 1;
                } else {
                    lines = array.count/3;
                }
                if (lines < 3) {
                    scrollView.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth, 33*lines);
                } else {
                    scrollView.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth, 33*3);
                }
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - contentToLeftWidth, 33*lines);
                scrollView.bounces = NO;
                // 选中人的集合
                for (NSInteger i = 0; i < array.count; i++) {
                    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake((scrollView.width/3)*(i%3), 33*(i/3), scrollView.width/3, 33)];
                    subView.backgroundColor = [UIColor whiteColor];
                    [scrollView addSubview:subView];
                    // 图标
                    UIImageView *iconView = [[UIImageView alloc] init];
                    iconView.image = [UIImage imageNamed:@"icon_people"];
                    [iconView sizeToFit];
                    iconView.frame = CGRectMake(5, (33 - iconView.height)/2, iconView.width, iconView.height);
                    [subView addSubview:iconView];
                    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconView.right + 11, 0, subView.width - iconView.right - 11, subView.height)];
                    contentLabel.font = [UIFont systemFontOfSize:13];
                    contentLabel.text = array[i][@"PERSONNAME"];
                    contentLabel.textColor = RGB(134, 134, 134, 1);
                    [subView addSubview:contentLabel];
                }
                // 选入按钮
                UIButton *addressButton = [[UIButton alloc] init];
                if (scrollView.height == 0) {
                    addressButton.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth - contentToLeftWidth, firstSectionHeight);
                } else {
                    addressButton.frame = CGRectMake(contentToLeftWidth, 0, SCREEN_WIDTH - contentToLeftWidth - contentToLeftWidth, scrollView.height);
                }
                [addressButton addTarget:self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:addressButton];
                return cell;
            }
            break;
        case 1:
        {
			// 单个button的重用
            TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:taskIdentifier];
            if (cell == nil) {
                cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:taskIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.task = self.taskArray[indexPath.row];
            cell.imageButton.userInteractionEnabled = NO;
            return cell;
        }
            break;
        default:
            {
                return nil;
            }
            break;
    }
}

```
对两个点击事件的处理

#### (4)需要通过选中人的数量计算row高度
```
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            if (!self.addressArray) {
                return firstSectionHeight;
            } else {
                NSInteger lines = 0;
                if (self.addressArray.count%3 != 0) {
                    lines = self.addressArray.count/3 + 1;
                } else {
                    lines = self.addressArray.count/3;
                }
                if (lines < 3) {
                    return lines*3*firstSectionHeight/4;
                } else {
                    return 3*3*firstSectionHeight/4;
                }
            }
        }
            break;
        case 1:
        {
            return 65;
        }
            break;
        default:
            return 0;
            break;
    }
}
```

#### (5)选择多个button点击处理
```
- (void)addressClick:(UIButton *)sender {
    
    AddressViewController *addressViewController = [AddressViewController new];
    addressViewController.title = @"选择多个button";
    addressViewController.addressBlock = ^(NSArray *userArray) {
        self.addressArray = userArray;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addressViewController animated:YES];
}
```

#### (6)选择单个button点击处理
```
// 因为之后要添加headerView的收起功能,所以直接添加的是手势
- (void)taskClick:(UITapGestureRecognizer *)sender{
    
    TaskViewController *taskViewController = [TaskViewController new];
    taskViewController.title = @"选择单个button处理";
    taskViewController.taskBlock = ^(NSArray *taskArray) {
        self.taskArray = taskArray;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:taskViewController animated:YES];
}
```

### 2.多个button在tableViewCell上的处理

![AddressViewController控制器](https://github.com/LitBr/ReuseTableViewDemo/raw/master/多个button/AddressViewController.jpg)

这里tableView可以用Grouped类型也可以用Plain类型
#### (1)对cell进行布局
for循环创建button并设置好点击后颜色的变化
#### (2)计算高度
在赋值承载多个button的cell模型Address中来计算并返回高度

```
#import "Address.h"

static const CGFloat buttonHeight = 25;

@implementation Address

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (CGFloat)cellHeight {
    
    NSInteger c = self.USERS.count/4;
    NSInteger l = self.USERS.count%4;
    CGFloat userButtonsViewHeight = 0;
    if (l != 0) {
        userButtonsViewHeight = (c + 1)*(buttonHeight + 10);
    } else {
        userButtonsViewHeight = c*(buttonHeight + 10);
    }
    //  contentHeight = Item离cell顶部高度 + Item高度 + Item离button顶部高度 + buttonView的高度 + buttonView离cell底部高度;
    
    CGFloat contentHeight = 13 + 13 + 8 + userButtonsViewHeight + 18;
    return contentHeight;
}
```
在控制器AddressViewController返回高度

```
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Address *address = self.addressModels[indexPath.row];
    return address.cellHeight;
}

```
#### (3)按钮的点击事件
```
- (void)userButtonClick:(UIButton *)button {
    
    NSInteger tag = button.tag - 100;
    NSDictionary *userDic = self.userArray[tag];
    BOOL selectSate = [self.selectStateArray[tag] integerValue];
    button.selected = selectSate;
    if (button.selected) {
        button.backgroundColor = RGB(240, 240, 240, 1);// 未选中灰色
        button.selected = NO;
        [self.selectStateArray replaceObjectAtIndex:tag withObject:@"0"];
        [self.addressDelegate deleteUserDicFromUsers:userDic];
    } else {
        button.backgroundColor = RGB(56, 173, 255, 1);// 选中蓝色
        button.selected = YES;
        [self.selectStateArray replaceObjectAtIndex:tag withObject:@"1"];
        [self.addressDelegate addUserDicToUsers:userDic];
    }
}
```
点击事件里面记录了点击button的状态并用self.selectStateArray保存起来,这里button修改选中背景颜色可以直接修改或者通过对button添加观察者实现,这里通过代理传递选中的人物到主界面显示

```
// 改变按钮高亮背景颜色
- (void)addObserver:(UIButton *)button {
    [button addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    UIButton *button = (UIButton *)object;
    if ([keyPath isEqualToString:@"highlighted"]) {
        if (button.highlighted) {
            [button setBackgroundColor:RGB(56, 173, 255, 1)];
            return;
        }
        [button setBackgroundColor:RGB(240, 240, 240, 1)];
    }
}
```

#### (4)传递选中按钮
在AddressViewController控制器中执行代理方法

```
// 添加用户
- (void)addUserDicToUsers:(NSDictionary *)userDic {
    [self.selectedUserArray addObject:userDic];
}

// 删除用户
- (void)deleteUserDicFromUsers:(NSDictionary *)userDic {
    [self.selectedUserArray removeObject:userDic];
}

// 确定按钮
- (void)confirmButtonClick:(UIButton *)sender {
    
    self.addressBlock(self.selectedUserArray);
    [self.navigationController popViewControllerAnimated:YES];
}
```
#### (5)效果图
![多个button处理效果图](https://github.com/LitBr/ReuseTableViewDemo/raw/master/多个button/多个button处理效果图.gif)

### 3.单个button在tableViewCell上的重用处理

![TaskViewController控制器](https://github.com/LitBr/ReuseTableViewDemo/raw/master/多个button/TaskViewController.jpg)

#### (1)对cell进行布局
进行基本的布局即可
#### (2)添加选中标记

给在承载单个button的cell模型Task中添加isSelected属性

解决重用造成的按钮选中状态丢失的问题

```
@property (nonatomic, assign)BOOL isSelected;
```

#### (3)按钮的点击事件
```
- (void)imageButtonClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.relateDelegate addTaskToRecord:_task];
    } else {
        [self.relateDelegate deleteTaskToRecord:_task];
    }
}
```

#### (4)传递选中按钮
在TaskViewController控制器中执行代理方法

```
// 添加选择的任务
- (void)addTaskToRecord:(Task *)task {
    
    task.isSelected = YES;
    [self.taskModels replaceObjectAtIndex:task.indexPathRow withObject:task];
    [self.tableView reloadData];
    [self.selectedTaskArray addObject:task];
}

// 删除选择的任务
- (void)deleteTaskToRecord:(Task *)task {
    
    task.isSelected = NO;
    [self.tableView reloadData];
    [self.selectedTaskArray removeObject:task];
}

// 确定按钮
- (void)confirmButtonClick:(UIButton *)sender {
    
    self.taskBlock(self.selectedTaskArray);
    [self.navigationController popViewControllerAnimated:YES];
}
```
#### (5)效果图
![单个button处理效果图](https://github.com/LitBr/ReuseTableViewDemo/raw/master/多个button/单个button处理效果图.gif)

附上[Demo](https://github.com/LitBr/ReuseTableViewDemo)地址

有什么问题可以留言,共同学习~
