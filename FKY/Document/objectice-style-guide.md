所有编码规范与[Coding Guidelines for Cocoa](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CodingGuidelines/CodingGuidelines.html#//apple_ref/doc/uid/10000146-SW1)兼容。

## 文件结构

* 单个文件的代码不能超过1000行
* 单个方法或函数的代码不能超过200行

### .h文件

```objc
// 头文件import区
#import <UIKit/UIKit.h>

// 类声明区
@class HJObject;

// 枚举类型定义

// 注释区
@interface Foo : Bar <
ProtocolA,
ProtocolB
>

// Property声明区

// 注释区
@property (nonatomic, strong, readonly) UIWindow *window;

// 类方法声明区

// 注释区
+ (void)test;

// 实例方法声明区

// 注释区
- (void)cleanImageCache;	

@end
```

### .m文件

```objc
// 头文件import区

// C/C++函数区

@interface PPAppDelegate () <DelegateA>

// 内部property声明区

// 注释区
@property (nonatomic, strong) UIWindow *window;

@end

// 实现对象区
@implementation HJAppDelegate

// Public及重载父类方法

// 方法归类区A
#pragma mark – UIWebViewDelegate

// 方法注释区
- (void)cleanImageCache { // 括号根据项目自行确定
	…
	// 注释区
	…
}

// 方法归类区B
#pragma mark – B

// 方法注释区
- (void)demo {
	…
	// 注释区
	…
}

// 私有方法实现区
#pragma mark – Private

// 方法注释区
- (void)demo {
	…
	// 注释区
	…
}

@end
```

注意Xcode 6.3 中对Swift的语法兼容

### Swift

TBD

## 命名方针

统一采用驼峰式命名，如：

小驼峰式命名法（lower camel case）： 
第一个单字以小写字母开始；第二个单字的首字母大写，例如：firstName、lastName

### Clarity 明确

- **清晰明了**

| Code | Commentary |
| -------- | -------- |
| insertObject:atIndex: | Good. |
| insert:at: | Not clear; what is being inserted? what does “at” signify? |
| removeObjectAtIndex: | Good. |
| removeObject: | Good, because it removes object referred to in argument. |
| remove: | Not clear; what is being removed? |

- **不要缩写**

| Code | Commentary |
| -------- | -------- |
| destinationSelection | Good. |
| displayName | Not clear. |

- **避免歧义**

| Code | Commentary |
| -------- | -------- |
| sendPort | Does it send the port or return it? |
| displayName | Does it display a name or return the receiver’s title in the user interface? |

### Consistency 一致性

| Code | Commentary |
| -------- | -------- |
| - (NSInteger)tag | Defined in UIView, UIBarItem, NSControl. |

### No Self Reference 不标识自己

| Code | Commentary |
| -------- | -------- |
| NSString | Okay. |
| NSStringObject | Self-referential. |

## 命名

创建系统和第三方的Category必须要添加小写的前缀

## 注释

1. 平均10行有1行注释，欢迎更多注释
2. 写有用的注释，注释的代码直接删除

## 换行

多换行以增加代码可读性，不要在一行上写多个内容，这样对代码合并有好处，另外生成的diff也比较内容分辨。

Bad：
```
if (self.hu_pullToRefreshView == nil) {
    Class cls = NSClassFromString(self.hu_pullToRefreshViewClassName);
    NSAssert([cls isSubclassOfClass:[UIView class]], @"必须是UIView");
    self.hu_pullToRefreshView = [[cls alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.pullToRefreshView.bounds), CGRectGetHeight(self.pullToRefreshView.bounds))];
}
```

Good：
```
if (self.hu_pullToRefreshView == nil) {

    Class cls = NSClassFromString(self.hu_pullToRefreshViewClassName);
        
    NSAssert([cls isSubclassOfClass:[UIView class]], @"必须是UIView");
        
    self.hu_pullToRefreshView = [[cls alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      CGRectGetWidth(self.pullToRefreshView.bounds),
                                                                      CGRectGetHeight(self.pullToRefreshView.bounds))];
}
```

Bad：
```
@interface HJAppDelegate : UIResponder <UIApplicationDelegate, PPDataControllerDelegate, WXApiDelegate>
```

Good：
```
@interface HJAppDelegate : UIResponder <
UIApplicationDelegate, 
UITableViewControllerDelegate, 
WXApiDelegate
>
```

## 对齐

不要在一行里写完所有的方法，直接按回车键，Xcode会自动与上一个”:”对齐，这样方便查看参数。另外，不建议参数和”:”之间有空格。

Bad:
```objc
alertView = [[HJAlertView alloc] initWithTitle:@"提示" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定 "otherButtonTitles:nil];
```

Good:
```objc
alertView = [[PPAlertViewPro alloc] initWithTitle:@"提示"
                                          message:notification.alertBody
                                         delegate:nil
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil];
```

枚举定义要对齐

```objc
typedef NS_ENUM(NSUInteger, HUPullToRefreshState) {
    HUPullToRefreshStateStopped   = SVPullToRefreshStateStopped,
    HUPullToRefreshStateTriggered = SVPullToRefreshStateTriggered,
    HUPullToRefreshStateLoading   = SVPullToRefreshStateLoading,
    HUPullToRefreshStateAll       = SVPullToRefreshStateAll
};
```

## 空格

不添加空格的情况

1. 紧挨小括号和中括号内侧
2. 方法返回类型与方法名称

关键词和括号间加空格

```
@property (strong, nonatomic) UIColor *color4Stoped;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position;


```

## 表达式

 * 除非在`-init`, `-dealloc`, 定制的accessor中，不要直接访问实例变量(除特殊情况，试行)
 * 较长三元表达式应该加括号，并且只用于赋值和传参,不能嵌套

```objc
Blah *a = (stuff == thing ? foo : bar);
```

 * 简单形式的缺省值三元表达式不加括号

```objc
Blah *b = thingThatCouldBeNil ?: defaultValue;
```

 * 使用单空格间隔开二元表达式的操作符，一元操作符不加空格

```c
void *ptr = &value + 10 * 3;
NewType a = (NewType)b;

for (int i = 0; i < 10; i++) {
    doCoolThings();
}
```

## 控制结构

 * 除`if( xxx ) return;` 的用法，`if`必须加括号
 * 所有左括号应该和关联的表达式同一行，结尾换行
 * 早返回, 卫语句(建议)

```objc
if (somethingIsBad) return;

if (something == nil) {
	// do stuff
} else {
	// do other stuff
}
```

## 错误、异常和断言的处理

* 不用使用异常做控制流
* 表示错误，使用`NSError **`参数,或者给[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) signal发一个错误

### Dealing with Errors 来自Apple官方的建议

You should not use a try-catch block in place of standard programming checks for Objective-C methods. In the case of an NSArray, for example, you should always check the array’s count to determine the number of items before trying to access an object at a given index. The objectAtIndex: method throws an exception if you make an out-of-bounds request so that you can find the bug in your code early in the development cycle—you should avoid throwing exceptions in an app that you ship to users.

## Block

* 代码块的类型和名字之间加空格
* 代码块定义尽可能的省略返回类型
* 如果为空(void)，省略块定义中的参数
* 代码块定义的参数应该有名字

```objc
As a local variable:

returnType (^blockName)(parameterTypes) = ^returnType(parameters) {...};
As a property:

@property (nonatomic, copy) returnType (^blockName)(parameterTypes);
As a method parameter:

- (void)someMethodThatTakesABlock:(returnType (^)(parameterTypes))blockName;
As an argument to a method call:

[someObject someMethodThatTakesABlock:^returnType (parameters) {...}];
As a typedef:

typedef returnType (^TypeName)(parameterTypes);
TypeName blockName = ^returnType(parameters) {...};
```

[How Do I Declare A Block in Objective-C?](http://fuckingblocksyntax.com/)

## 对象文法

* 数组和字典对象文法内容两边使用一个空格
* 字典文法中，键值和冒号之间不留空格，值和冒号之间使用一个空格

``` objc
NSArray *theStuff = @[ @1, @2, @3 ];

NSDictionary *keyedStuff = @{ GHDidCreateStyleGuide: @YES };
```

* 更长或者更复杂的文法应该分成多行（可选以逗号结尾）

``` objc
NSArray *theStuff = @[
    @"Got some long string objects in here.",
    [AndSomeModelObjects too],
    @"Moar strings."
];

NSDictionary *keyedStuff = @{
    @"this.key": @"corresponds to this value",
    @"otherKey": @"remoteData.payload",
    @"some": @"more",
    @"JSON": @"keys",
    @"and": @"stuff",
};
```

## 扩展

* 扩展应该按照所提供的功能命名，不要将不同的功能混杂在一个扩展中
* 扩展方法一定要加前缀，若仅是内部实现，不需要增加hj开头
* 如果你想给子类或者单元测试暴露私有方法，使用 `Class+Private`命名创建一个分类

## 关于废弃的方法使用

优先使用高版本SDK提供的方法。如：

```objc 
if ([tabController respondsToSelector:@selector(presentViewController:animated:completion:)]) {
    [tabController presentViewController:webViewController 
animated:YES 
  completion:nil];
} else {
    [tabController presentModalViewController:webViewController 
  animated:YES];
}
```

# 其它

- 注释编写工具 [VVDocumenter-Xcode](https://github.com/onevcat/VVDocumenter-Xcode)
- 格式化工具 [ClangFormat-Xcode](https://github.com/travisjeffery/ClangFormat-Xcode) 
- 对齐工具 [XAlign](https://github.com/qfish/XAlign)