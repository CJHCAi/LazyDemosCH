# SelwynFormDemo
This is a form system for Objective-C
![image](http://a2.qpic.cn/psb?/V14ONEhc0D5t8a/0JqojcDhSXUVR8JH6xZZIidkNu0V.NOjn2oyTQfA6ak!/b/dD8BAAAAAAAA&bo=gAJxBAAAAAADB9U!&rf=viewer_4)

![image](http://a2.qpic.cn/psb?/V14ONEhc0D5t8a/EwMOqTaePUq9va.lY4Bi6.8HXCr1opSHMG2zOHpNvLk!/b/dNAAAAAAAAAA&bo=gAJlBAAAAAADB8E!&rf=viewer_4)

详解戳这里：http://www.jianshu.com/p/a2263a64ae3f

简单通过添加条目的方式创建复杂的表单系统

核心代码：

    NSMutableArray *datas = [NSMutableArray array];
    
    SelwynFormItem *name = SelwynItemMake(@"姓名", @"", SelwynFormCellTypeInput, UIKeyboardTypeDefault, YES, YES);
    
    [datas addObject:name];
    
    SelwynFormItem *phoneNumber = SelwynItemMake(@"手机号", @"", SelwynFormCellTypeInput, UIKeyboardTypeNumberPad, YES, YES);
    phoneNumber.maxInputLength = 11;
    
    [datas addObject:phoneNumber];
    
    SelwynFormItem *gender = SelwynItemMake(@"性别", @"", SelwynFormCellTypeSelect, UIKeyboardTypeDefault, NO, YES);
    gender.selectHandle = ^(SelwynFormItem *item) {
        
        [self selectGenderWithItem:item];
    };
    [datas addObject:gender];
    
    SelwynFormItem *intro = SelwynItemMake(@"个人简介", @"", SelwynFormCellTypeTextViewInput, UIKeyboardTypeDefault, YES, NO);
    
    [datas addObject:intro];
    
    SelwynFormSectionItem *sectionItem = [[SelwynFormSectionItem alloc]init];
    sectionItem.cellItems = datas;
    
    [self.mutableArray addObject:sectionItem];
    
    NSMutableArray *datas1 = [NSMutableArray array];
    
    SelwynFormItem *address = SelwynItemMake(@"住址", @"", SelwynFormCellTypeInput, UIKeyboardTypeDefault, YES, NO);
    
    [datas1 addObject:address];
    
    SelwynFormSectionItem *sectionItem1 = [[SelwynFormSectionItem alloc]init];
    sectionItem1.cellItems = datas1;
    sectionItem1.headerHeight = 30;
    sectionItem1.headerColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    sectionItem1.footerHeight = 30;
    sectionItem1.footerColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
    sectionItem1.footerTitle = @"section footer";
    sectionItem1.headerTitle = @"section header";
    sectionItem1.headerTitleColor = [UIColor orangeColor];
    sectionItem1.footerTitleColor = [UIColor greenColor];
    
    [self.mutableArray addObject:sectionItem1];

    __weak typeof(self) weakSelf = self;
    
    self.genderSelectCompletion = ^(NSInteger index) {
      
        if (index!=0) {
            
            gender.formDetail = weakSelf.genders[index-1];
            
            [weakSelf.formTableView reloadData];
        }
    };

        
        
