
//
//  ViewController.m
//  Test_RunTime
//
//  Created by wanghao on 16/5/28.
//  Copyright © 2016年 wanghao. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"
#import "Person+PersonCategory.h"

@interface ViewController ()


//类testBranch

//类 main

@property (nonatomic,retain) Person *per;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _per = [[Person alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获得所有方法
- (IBAction)getAllMethod:(id)sender {
    unsigned int count;
    //获取方法列表，所有在.m里的显示实现的方法都会被找到,包括setter+getter方法
    Method *allMethods = class_copyMethodList([Person class], &count);
    for (int i = 0; i<count; i++) {
        //Method ,为runtime声明一个宏，表示对一个方法的描述
        Method md = allMethods[i];
        //获取SEL
        SEL sel = method_getName(md);
        //得到sel的方法名
        const char *methodName = sel_getName(sel);
        NSLog(@"method: %s",methodName);
    }
    
}

//获得所有成员变量
- (IBAction)getAllVValue:(id)sender {
    unsigned int count = 0;
    //获取类的一个包含所有变量的列表，IVar是runtime声明的一个宏，是实例变量的意思

    Ivar *allVariables = class_copyIvarList([Person class], &count);
    for (int i = 0; i < count; i++) {
        //便利每一个变量
        Ivar ivar = allVariables[i];
        const char *variableName = ivar_getName(ivar);
        const char *variableType = ivar_getTypeEncoding(ivar);
        NSLog(@"name:%s --type:%s",variableName,variableType);
    }
}
//改变私有变量的值
- (IBAction)changePrivateVValue:(id)sender {
   
   
    NSLog(@"改版前:%@",_per);
    unsigned int count = 0;
    Ivar *allList = class_copyIvarList([Person class], &count);
    Ivar ivv = allList[count-1];//从得到所有方法输出的信息，可以看到name 为最后一个实例属性
    object_setIvar(_per, ivv, @"Mike");//强制修改name属性
    NSLog(@"改变后%@",_per);
}
//添加新属性
- (IBAction)addNewProperty:(id)sender {
    _per.height = 12;
    NSLog(@"%f",_per.height);
}
//添加方法
- (IBAction)addNewMethod:(id)sender {
    /* 动态添加方法：
     第一个参数表示Class cls 类型；
     第二个参数表示待调用的方法名称；
     第三个参数(IMP)myAddingFunction，IMP一个函数指针，这里表示指定具体实现方法myAddingFunction；
     第四个参数表方法的参数，0代表没有参数；
     */
    class_addMethod([_per class], @selector(sayHi), (IMP)myAddingFunction, 0);
    
    //调用方法
    [_per performSelector:@selector(sayHi)];

}
- (void)sayHi
{
    NSLog(@"hi");
}
int myAddingFunction(id self, SEL _cmd){
    NSLog(@"已新增方法:NewMethod");
        //具体的实现（方法的内部都默认包含两个参数Class类和SEL方法，被称为隐式参数。）
    
    return 1;
}


//交换两个方法
- (IBAction)exchangeMethod:(id)sender {
    
    Method method1 = class_getInstanceMethod([Person class], @selector(func1));
    Method method2 = class_getInstanceMethod([Person class], @selector(func2));
    
    //交换方法
    method_exchangeImplementations(method1, method2);
    [_per func2];
}

@end
