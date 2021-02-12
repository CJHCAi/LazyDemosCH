# ClassifyMenuDemo
# 多级分类菜单 多集列表展开合并 仿口碑分类效果
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg) 
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
![](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg)
![](https://img.shields.io/vscode-marketplace/d/repo.svg)
![](https://img.shields.io/cocoapods/l/packageName.svg)

# ClassifyMenuDemo 简单使用 无入侵 对原项目无污染

`分类菜单` `筛选菜单` `口碑分类筛选菜单` `电商通用筛选菜单` `多级列表`

---

![分类菜单演示.gif](https://upload-images.jianshu.io/upload_images/668798-716adaec035f6575.gif?imageMogr2/auto-orient/strip)

---

#### 使用方法:
````
- (void)clickTitleBtn:(UIButton *)sender {
    if (self.isShowMenu == NO) {
        WEAKSELF
        self.rootNode = [self doConfigNodes]; // 整理数据
        self.menu = [[ClassifyMenu alloc] initWithFrame:CGRectZero rootNode:self.rootNode chooseResult:^(CMNode *node) {
            weakSelf.isShowMenu = NO;
            NSString *result = @"";
            if (node.depth == 0) {
                // 一级终结
                result = [NSString stringWithFormat:@"%@", node.name];
            }else if (node.depth == 1) {
                // 二级终结
                result = [NSString stringWithFormat:@"%@-%@", node.parentNode.name, node.name];
            }else if (node.depth == 2) {
                // 三级终结
                result = [NSString stringWithFormat:@"%@-%@-%@", node.parentNode.parentNode.name, node.parentNode.name, node.name];
            }
            NSLog(@"选择的结果：%@", result);
            self.resultLabel.text = result;
        } closeMenuAction:^{
            weakSelf.isShowMenu = NO;
        }];
        [self.menu show];
        self.isShowMenu = YES;
    }else {
        self.isShowMenu = NO;
        if (self.menu) {
            [self.menu close];
        }
    }
}

````

# 数据整理成CMNode类集合 按照层次整理 加入只做多级列表的话 只用左侧的列表，可以做无数级，也是按照如下所示的方法整理数据格式就行了
````
#pragma mark - 数据格式源整理
- (CMNode *)doConfigNodes {
    NSDictionary *item1 = @{@"name":@"一级分类1", @"arr":@[@{@"name":@"二级分类1", @"arr":@[@{@"name":@"三级分类11"}, @{@"name":@"三级分类22"}, @{@"name":@"三级分类33"}, @{@"name":@"三级分类44"}, @{@"name":@"三级分类55"}]},
                                                       @{@"name":@"二级分类2", @"arr":@[@{@"name":@"游泳馆1"}, @{@"name":@"游泳馆2"}, @{@"name":@"游泳馆3"}, @{@"name":@"游泳馆4"}, @{@"name":@"游泳馆5"}]},
                                                       @{@"name":@"二级分类3", @"arr":@[@{@"name":@"舞蹈1"}, @{@"name":@"舞蹈2"}, @{@"name":@"舞蹈3"}, @{@"name":@"舞蹈4"}, @{@"name":@"舞蹈5"}]},
                                                       @{@"name":@"亲子", @"arr":@[@{@"name":@"少儿才艺"}, @{@"name":@"少儿打架"}, @{@"name":@"科普"}]},
                                                       @{@"name":@"二级分类5", @"arr":@[@{@"name":@"hello1"}, @{@"name":@"hello Kitty"}, @{@"name":@"蓝胖子"}, @{@"name":@"小黑"}, @{@"name":@"大大pan"}]}]};
    NSDictionary *item2 = @{@"name":@"热门精选", @"arr":@[@{@"name":@"为你推荐", @"arr":@[@{@"name":@"快餐小吃1"}, @{@"name":@"快餐小吃2"}]}, @{@"name":@"超市", @"arr":@[@{@"name":@"超市1"}, @{@"name":@"超市2"}, @{@"name":@"超市3"}, @{@"name":@"超市4"}, @{@"name":@"超市5"}]}]};
    NSDictionary *item3 = @{@"name":@"休闲娱乐", @"arr":@[@{@"name":@"彩妆造型1", @"arr":@[@{@"name":@"美发1"}, @{@"name":@"美发2"}, @{@"name":@"美发3"}, @{@"name":@"美发4"}, @{@"name":@"美发5"}]}, @{@"name":@"宠物", @"arr":@[@{@"name":@"狗狗1"}, @{@"name":@"狗狗2"}, @{@"name":@"狗狗3"}, @{@"name":@"狗狗4"}, @{@"name":@"狗狗5"}]}]};
    NSDictionary *item4 = @{@"name":@"运动健身", @"arr":@[@{@"name":@"少林武术", @"arr":@[@{@"name":@"少林棍1"}, @{@"name":@"少林棍2"}, @{@"name":@"少林棍3"}, @{@"name":@"少林棍4"}, @{@"name":@"少林棍5"}]}, @{@"name":@"峨眉派", @"arr":@[@{@"name":@"白骨爪1"}, @{@"name":@"白骨爪2"}, @{@"name":@"白骨爪3"}, @{@"name":@"白骨爪4"}, @{@"name":@"白骨爪5"}]}]};
    NSDictionary *item5 = @{@"name":@"电影", @"arr":@[@{@"name":@"万达院1", @"arr":@[@{@"name":@"王思聪1"}, @{@"name":@"王思聪2"}, @{@"name":@"王思聪3"}, @{@"name":@"王思聪4"}, @{@"name":@"王思聪5"}]}, @{@"name":@"万达院2", @"arr":@[@{@"name":@"IceBear1"}, @{@"name":@"IceBear2"}]}]};
    NSArray *temps = @[item1, item2, item3, item4, item5];
    // 找到已选择的
    NSArray *temp = [self.resultLabel.text componentsSeparatedByString:@"-"];
    NSString *nodeName1 = @"";
    NSString *nodeName2 = @"";
    NSString *nodeName3 = @"";
    if (temp.count == 1) {
        nodeName1 = temp[0];
    }else if (temp.count == 2) {
        nodeName1 = temp[0];
        nodeName2 = temp[1];
    }else if (temp.count == 3) {
        nodeName1 = temp[0];
        nodeName2 = temp[1];
        nodeName3 = temp[2];
    }
    CMNode *rootNode = [[CMNode alloc] initWithParent:nil expand:NO];
    // 这里可根据实际情况进行多层级的列表嵌套,只需要把子节点添加到父节点下就可以了。
    // 后面会根据实际的数据进行UI的设置
    for (int i = 0; i < temps.count; i++) {
        // 一级的列表
        CMNode *node = [CMNode initWithParent:rootNode expand:YES];
        node.name = temps[i][@"name"];
        
        if ((ISEMPTY(self.resultLabel.text) || [nodeName1 isEqualToString:@"全部类目"]) && i==0) {
            node.isChoosed = YES;
            node.expand = YES;
        }else {
            if ([nodeName1 isEqualToString:node.name]) {
                node.isChoosed = YES;
                node.expand = YES;
            }else {
                node.isChoosed = NO;
                node.expand = NO;
            }
        }
        [rootNode.subNodes addObject:node];
        
        NSArray *twoLevelObjs = temps[i][@"arr"];
        for (int j = 0; j < twoLevelObjs.count; j++) {
            // 二级列表
            CMNode *subnode = [CMNode initWithParent:node expand:NO];
            subnode.name = twoLevelObjs[j][@"name"];
            
            if ((ISEMPTY(self.resultLabel.text) || [nodeName1 isEqualToString:@"全部类目"]) && ISEMPTY(nodeName2) && i==0 && j==0) {
                subnode.isChoosed = YES;
            }else {
                if ([nodeName1 isEqualToString:node.name] && [nodeName2 isEqualToString:subnode.name]) {
                    subnode.isChoosed = YES;
                }else {
                    subnode.isChoosed = NO;
                }
            }
            [node.subNodes addObject:subnode];
            
            NSArray *threeLevelObjs = twoLevelObjs[j][@"arr"];
            for (int k = 0; k < threeLevelObjs.count; k++) {
                // 三级的列表 (整理后放右侧陈列)
                CMNode *threeNode = [CMNode initWithParent:subnode expand:NO];
                threeNode.name = threeLevelObjs[k][@"name"];
                if ((ISEMPTY(self.resultLabel.text) || [nodeName1 isEqualToString:@"全部类目"]) && i==0 && j==0 && k==0) {
                    threeNode.isChoosed = YES;
                }else {
                    if ([nodeName1 isEqualToString:node.name] && [nodeName2 isEqualToString:subnode.name] && [nodeName3 isEqualToString:threeNode.name]) {
                        threeNode.isChoosed = YES;
                    }else {
                        threeNode.isChoosed = NO;
                    }
                }
                [subnode.threeNodes addObject:threeNode];
            }
        }
    }
    return rootNode;
}
````

### 如有更好的建议欢迎加Q吐槽：1131991303
### 博客地址：[ClassifyMenuDemo简书](https://www.jianshu.com/p/f67b18b08b36)
