# ZJIndexedContacts
一个常用的带索引的联系人列表, 同时已经处理好了联系人按拼音排序分组, 已经处理好了联系人按拼音首字母搜索的功能

![contacts.gif](http://upload-images.jianshu.io/upload_images/1271831-f63b2c4e28f53b1e.gif?imageMogr2/auto-orient/strip)


```
 NSArray *testArray = @[@"ZeroJ", @"曾晶", @"你好", @"曾晶", @"曾晶" , @"曾晶" , @"曾晶" , @"曾晶" , @"曾晶" , @"曾晶" , @"曾晶",  @"曾好", @"李涵", @"王丹", @"良好", @"124"];
    
    NSMutableArray<ZJContact *> *contacts = [NSMutableArray arrayWithCapacity:testArray.count];
    for (NSString *name in testArray) {
        ZJContact *test = [ZJContact new];
        test.name = name;
        test.icon = [UIImage imageNamed:@"icon"];
        [contacts addObject:test];
    }

    [self setupInitialAllDataArrayWithContacts:contacts];
```

> 这是我写的<iOS_CUSTOMIZE_ANALYSIS>这本书籍中的一个demo, 如果你希望知道具体的实现过程和其他的一些常用效果的实现, 那么你应该能轻易在网上下载到免费的盗版书籍. 

> 当然作为本书的写作者, 还是希望有人能支持正版书籍. 如果你有意购买书籍, 在[这篇文章中](http://www.jianshu.com/p/510500f3aebd), 介绍了书籍中所有的内容和书籍适合阅读的人群, 和一些试读章节, 以及购买链接. 在你准备购买之前, 请一定读一读里面的说明. 否则, 如果不适合你阅读, 虽然书籍售价35不是很贵, 但是也是一笔损失.


> 如果你希望联系到我, 可以通过[简书](http://www.jianshu.com/users/fb31a3d1ec30/latest_articles)联系到我
