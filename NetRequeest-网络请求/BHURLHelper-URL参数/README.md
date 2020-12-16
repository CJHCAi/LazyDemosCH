
## BHURLHelper (iOS链接中参数的增删改查)

### 简介
>   **在iOS开发中, 我们常会遇到对链接中参数的获取或者添加, 而BHURLHelper 是针对链接中的参数进行增删改查, 对链接的操作效率的提升.**

### Pod支持:
> **`pod 'BHURLHelper', '~> 1.0.0'`**

### 方法支持: (NSString的类别)

```objectivec
/** 增:
为链接增加参数和值;

@param parameters 要增加的参数和值 eg: @{@"version" : @"1.1.0"}
@return 增加参数后生成一个新的URL String;
*/
- (NSString *)addParameters:(NSDictionary *)parameters;

/** 删:
删除参数为key的键值对;

@param key 要删除的参数对的键;
@return 删除的参数后生成一个新的URL String;
*/
- (NSString *)deleteParameterOfKey:(NSString *)key;

/** 改:
修改参数中的值

@param key 要修改的值对应的键
@param toValue 要求改成的值
@return 修改值后生成一个新的URL String;
*/
- (NSString *)modifyParameterOfKey:(NSString *)key toValue:(NSString *)toValue;

/** 查:
获取URL中的所有参数键值对

@返回值为字典, 字典中key为参数, value为参数值;
*/
- (NSDictionary *)parseURLParameters;

```
### 使用示例

```objectivec
原始链接: self.originalUrlString = @"https://github.com?name=qiaobahui&age=23";

- (void)addParameterTest {
// 添加参数
NSString *addResult = [self.originalUrlString addParameters:@{@"sex" : @"man"}];
NSLog(@"addResult: %@", addResult); 
// 输出结果: https://github.com?name=qiaobahui&age=23&sex=man
}	

- (void)deleteParameterTest {
// 删除"age"对应的参数对;
NSString *deleteResult = [self.originalUrlString deleteParameterOfKey:@"age"];
NSLog(@"deleteResult: %@", deleteResult); 
// 输出结果: https://github.com?name=qiaobahui
}

- (void)modifyParameterTest {
// 修改"age"的值 = 100, 原值为23;
NSString *modifyResult = [self.originalUrlString modifyParameterOfKey:@"age" toValue:@"100"];
NSLog(@"modifyResult: %@", modifyResult); 
// 输出结果: https://github.com?name=qiaobahui&age=100
}

- (void)parseAllParametersTest {
// 获取链接中的参数和值
NSDictionary *parametersResult = [self.originalUrlString parseURLParameters];
NSLog(@"parameterResult: %@", parametersResult); 
// 输出结果: parameterResult: {age = 23; name = qiaobahui;}
}

```
### 交流与建议
- GitHub：<https://github.com/BaHui>
- 邮&nbsp;&nbsp;&nbsp; 箱：<qiaobahuiyouxiang@163.com>
