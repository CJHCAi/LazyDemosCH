
# TMSwipeCell

微信样式，支持文字和图片样式按钮，支持删除再确认效果, 兼容代码和xib创建, 屏幕翻转.

#### 效果图
![image](https://github.com/cocomanbar/TMSwipeCell/blob/master/TMSwipeCell/gif/one.gif)

## pods

```
pod 'TMSwipeCell'
```

## How to use

1.继承该类

```
@interface TMSwipeCell111 : TMSwipeCell
@end
```

2.在`tableView:cellForRowAtIndexPath:`方法中设置代理:

```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMSwipeCell111 *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TMSwipeCell111.class)];
    if (!cell) {
        cell = [[TMSwipeCell111 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(TMSwipeCell111.class)];
        cell.delegate = self;
    }
    return cell;
}
```

3.实现`TMSwipeCellDelegate`协议三个方法，返回侧滑按钮事件数组、返回需要事件的cell、以及代理处理事件(当然block也ok)。



4.更多细节请看demo

