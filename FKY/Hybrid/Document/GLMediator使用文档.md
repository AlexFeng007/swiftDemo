# GLMediator
__GLMediator是一个基于Mediator模式和Target-Action模式的组件间调用方案，中间采用了runtime来完成调用。这套组件化方案将远程应用调用和本地应用调用做了拆分。该库的作者为@Casa Taloyum，以下对于该库的实现说明均摘抄自他的博客。__

# 如何使用
以实现App新老容器的路由为例。

+ 新容器需要跳转**GLWebVC**类，并设置其**urlPath**属性
+ 老容器需要跳转**YWSubjectViewController**类，并设置**urlStr,hideTitleView,isShowFuncView**...等诸多属性

首先，我们在**GLMediato+Category**域内(之所以称域，取决于该区域是以文件夹形式存在于工程内，或以Pod依赖的形式导入在工程内的)新建**GLMediator+WebViewActions**类，该类的.h文件即为像其他组件暴露所有容器组件可供调用的方法，目前我们仅提供返回容器实例的方法:

```
@interface GLMediator (WebViewActions)

/**
 容器模块ViewController，由调用方决定push或present或自定义转场动画
 
 @param params 业务参数
 */
- (UIViewController *)glMediator_webviewViewControllerWithParams:(NSDictionary *)params;

@end
```
在.m文件中实现该方法:

```
#import "GLMediator+WebViewActions.h"
#import "NSDictionary+GLParam.h"

NSString * const kCTMediatorTargetYaoWangWebView = @"yaoWangWebView";
NSString * const kCTMediatorTargetHybridWebView = @"hybridWebView";

NSString * const kGLMediatorActionNativeFetchYaoWangWebViewController = @"jsFetchYaoWangWebViewController";
NSString * const kGLMediatorActionNativeFetchHybridWebViewController = @"jsFetchHybridWebViewController";

@implementation GLMediator (WebViewActions)

- (UIViewController *)glMediator_webviewViewControllerWithParams:(NSDictionary *)params
{
    BOOL oldWebContainer = [params boolParamForKey:@"backward" defaultValue:NO];
    if (oldWebContainer) {
        return [self performTarget:kCTMediatorTargetYaoWangWebView
                            action:kGLMediatorActionNativeFetchYaoWangWebViewController
                            params:params
                 shouldCacheTarget:NO];
    }
    else {
        return [self performTarget:kCTMediatorTargetHybridWebView
                            action:kGLMediatorActionNativeFetchHybridWebViewController
                            params:params
                 shouldCacheTarget:NO];
    }
}

@end
```
该方法的具体实现以由组件库通过runtime分发出去了，具体原理参见后文。

接下来，在**Module Actions**域(之所以称域，取决于该区域是以文件夹形式存在于工程内，或以Pod依赖的形式导入在工程内的)内新建**`Target_hybridWebView`、`Target_yaoWangWebView`**类，其中Target_后的命名，需要与**GLMediator+WebViewActions**类中.m文件中的`kCTMediatorTargetYaoWangWebView`、`kCTMediatorTargetHybridWebView`保持一致，否则runtime时会无法找到对应的类而导致调用失败。

下面以新容器**`Target_hybridWebView`**的实现为例(老容器的实现机制与此一致，不再重复），在.h文件中暴露方法(也可不用在.h文件中写，因为runtime会自己找到.m中的实现执行),

```
@interface Target_hybridWebView : NSObject

/**
 返回容器类ViewController
 
 @param params 业务参数
 @return 容器类ViewController
 */
- (id)Action_jsFetchHybridWebViewController:(NSDictionary *)params;

@end
```
此处Action_后的方法命名需与**GLMediator+WebViewActions**类中.m文件中的`kGLMediatorActionNativeFetchHybridWebViewController`保持一致。

接下来是.m文件实现:

```
#import "Target_hybridWebView.h"
#import "GLWebVC.h"
#import "NSDictionary+GLParam.h"

@implementation Target_hybridWebView

- (id)Action_jsFetchHybridWebViewController:(NSDictionary *)params
{
    NSString *urlString = [params paramForKey:@"url" defaultValue:nil class:NSString.class];
    if (urlString.length) {
        GLWebVC *vc = [[GLWebVC alloc] init];
        vc.urlPath = urlString;
        return vc;
    }
    else {
        return nil;
    }
}

@end
```
其中params的参数怎么取，是native业务方之间的约定，与框架无关。此处我们返回了一个配置好url属性的新容器实例给调用方，那么在使用时，调用方可以通过以下写法来获取新容器，而又不用依赖新容器的任何类，从而达到解耦的目的，具体原理参见后文。

```
// 容器模块
#import "GLMediator+WebViewActions.h"

...
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            UIViewController *viewController = [[GLMediator sharedInstance] glMediator_webviewViewControllerWithParams:params];
#pragma clang diagnostic pop
            ret = viewController == nil ? NO : YES;
            if ([animation integerValue] == kForwardAnimationTypePush) { // 路由动画为push
                [self.viewController.navigationController pushViewController:viewController animated:YES];
            }
            else if ([animation integerValue] == kForwardAnimationTypePresent) { // 路由动画为present
                [self.viewController.navigationController presentViewController:viewController animated:YES completion:nil];
            }
```

# 实现原理
## 简化版架构描述

```
             --------------------------------------
             | [GLMediator sharedInstance]        |
             |                                    |
             |                openUrl:       <<<<<<<<<  (AppDelegate)  <<<<  Call From Other App With URL
             |                                    |
             |                   |                |
             |                   |                |
             |                   |/               |
             |                                    |
             |                parseUrl            |
             |                                    |
             |                   |                |
             |                   |                |
.................................|...............................
             |                   |                |
             |                   |                |
             |                   |/               |
             |                                    |
             |  performTarget:action:params: <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  Call From Native Module
             |                                    |
             |                   |                |
             |                   |                |
             |                   |                |
             |                   |/               |
             |                                    |
             |             -------------          |
             |             |           |          |
             |             |  runtime  |          |
             |             |           |          |
             |             -------------          |
             |               .       .            |
             ---------------.---------.------------
                           .           .
                          .             .
                         .               .
                        .                 .
                       .                   .
                      .                     .
                     .                       .
                    .                         .
-------------------.-----------      ----------.---------------------
|                 .           |      |          .                   |
|                .            |      |           .                  |
|               .             |      |            .                 |
|              .              |      |             .                |
|                             |      |                              |
|           Target            |      |           Target             |
|                             |      |                              |
|         /   |   \           |      |         /   |   \            |
|        /    |    \          |      |        /    |    \           |
|                             |      |                              |
|   Action Action Action ...  |      |   Action Action Action ...   |
|                             |      |                              |
|                             |      |                              |
|                             |      |                              |
|Business A                   |      | Business B                   |
-------------------------------      --------------------------------
```

## 调用方式

先说本地应用调用，本地组件A在某处调用**`[[GLMediator sharedInstance] performTarget:targetName action:actionName params:@{...}]`**向**`GLMediator`**发起跨组件调用，**`GLMediator`**根据获得的target和action信息，通过objective-C的runtime转化生成target实例以及对应的action选择子，然后最终调用到目标业务提供的逻辑，完成需求。

在远程应用调用中，远程应用通过openURL的方式，由iOS系统根据info.plist里的scheme配置找到可以响应URL的应用（在当前我们讨论的上下文中，这就是你自己的应用），应用通过**`AppDelegate`**接收到URL之后，调用**`GLMediator`**的**`openUrl:`**方法将接收到的URL信息传入。当然，**`GLMediator`**也可以用**`openUrl:options:`**的方式顺便把随之而来的option也接收，这取决于你本地业务执行逻辑时的充要条件是否包含option数据。传入URL之后，**`GLMediator`**通过解析URL，将请求路由到对应的target和action，随后的过程就变成了上面说过的本地应用调用的过程了，最终完成响应。

针对请求的路由操作很少会采用本地文件记录路由表的方式，服务端经常处理这种业务，在服务端领域基本上都是通过正则表达式来做路由解析。App中做路由解析可以做得简单点，制定URL规范就也能完成，最简单的方式就是**`scheme://target/action`**这种，简单做个字符串处理就能把target和action信息从URL中提取出来了。

## 组件仅通过Action暴露可调用接口
所有组件都通过组件自带的Target-Action来响应，也就是说，模块与模块之间的接口被固化在了Target-Action这一层，避免了实施组件化的改造过程中，对业务代码的侵入，同时也提高了组件化接口的可维护性。

```
            --------------------------------
            |                              |
            |           Business A         |
            |                              |
            ---  ----------  ----------  ---
              |  |        |  |        |  |
              |  |        |  |        |  |
   ...........|  |........|  |........|  |...........
   .          |  |        |  |        |  |          .
   .          |  |        |  |        |  |          .
   .        ---  ---    ---  ---    ---  ---        .
   .        |      |    |      |    |      |        .
   .        |action|    |action|    |action|        .
   .        |      |    |      |    |      |        .
   .        ---|----    -----|--    --|-----        .
   .           |             |        |             .
   .           |             |        |             .
   .       ----|------     --|--------|--           .
   .       |         |     |            |           .
   .       |Target_A1|     |  Target_A2 |           .
   .       |         |     |            |           .
   .       -----------     --------------           .
   .                                                .
   .                                                .
   ..................................................
   
```
大家可以看到，虚线圈起来的地方就是用于跨组件调用的target和action，这种方式避免了由BusinessA直接提供组件间调用会增加的复杂度，而且任何组件如果想要对外提供调用服务，直接挂上target和action就可以了，业务本身在大多数场景下去进行组件化改造时，是基本不用动的。

## 组件化方案中的去model设计
组件间调用时，是需要针对参数做去model化的。如果组件间调用不对参数做去model化的设计，**就会导致业务形式上被组件化了，实质上依然没有被独立**。

假设模块A和模块B之间采用model化的方案去调用，那么调用方法时传递的参数就会是一个对象。

如果对象不是一个面向接口的通用对象，那么mediator的参数处理就会非常复杂，因为要区分不同的对象类型。如果mediator不处理参数，直接将对象以范型的方式转交给模块B，那么模块B必然要包含对象类型的声明。假设对象声明放在模块A，那么B和A之间的组件化只是个形式主义。如果对象类型声明放在mediator，那么对于B而言，就不得不依赖mediator。但是，大家可以从上面的架构图中看到，对于响应请求的模块而言，依赖mediator并不是必要条件，因此这种依赖是完全不需要的，这种依赖的存在对于架构整体而言，是一种污染。

如果参数是一个面向接口的对象，那么mediator对于这种参数的处理其实就没必要了，更多的是直接转给响应方的模块。而且接口的定义就不可能放在发起方的模块中了，只能放在mediator中。响应方如果要完成响应，就也必须要依赖mediator，然而前面我已经说过，响应方对于mediator的依赖是不必要的，因此参数其实也并不适合以面向接口的对象的方式去传递。

**因此，使用对象化的参数无论是否面向接口，带来的结果就是业务模块形式上是被组件化了，但实质上依然没有被独立**。

在这种跨模块场景中，参数最好还是以去model化的方式去传递，在iOS的开发中，就是以字典的方式去传递。这样就能够做到只有调用方依赖mediator，而响应方不需要依赖mediator。然而在去model化的实践中，由于这种方式自由度太大，我们至少需要保证调用方生成的参数能够被响应方理解，然而在组件化场景中，限制去model化方案的自由度的手段，相比于网络层和持久层更加容易得多。

因为组件化天然具备了限制手段：参数不对就无法调用！无法调用时直接debug就能很快找到原因。所以接下来要解决的去model化方案的另一个问题就是：如何提高开发效率。

在去model的组件化方案中，影响效率的点有两个：调用方如何知道接收方需要哪些key的参数？调用方如何知道有哪些target可以被调用？其实后面的那个问题不管是不是去model的方案，都会遇到。为什么放在一起说，因为我接下来要说的解决方案可以把这两个问题一起解决。

## 解决方案就是使用category
mediator这个repo维护了若干个针对mediator的category，每一个对应一个target，每个category里的方法对应了这个target下所有可能的调用场景，这样调用者在包含mediator的时候，自动获得了所有可用的target-action，无论是调用还是参数传递，都非常方便。接下来我要解释一下为什么是category而不是其他：

+ category本身就是一种组合模式，根据不同的分类提供不同的方法，此时每一个组件就是一个分类，因此把每个组件可以支持的调用用category封装是很合理的。

+ 在category的方法中可以做到参数的验证，在架构中对于保证参数安全是很有必要的。当参数不对时，category就提供了补救的入口。

+ category可以很轻松地做请求转发，如果不采用category，请求转发逻辑就非常难做了。

+ category统一了所有的组件间调用入口，因此无论是在调试还是源码阅读上，都为工程师提供了极大的方便。

由于category统一了所有的调用入口，使得在跨模块调用时，对于param的hardcode在整个App中的作用域仅存在于category中，在这种场景下的hardcode就已经变成和调用宏或者调用声明没有任何区别了，因此是可以接受的。

这里是业务方使用category调用时的场景，大家可以看到非常方便，不用去记URL也不用纠结到底应该传哪些参数。

```
@interface GLMediator (CartDemandActions)

/**
 购物车/需求清单业务ViewController，由调用方决定push或present或自定义转场动画
 
 @param params 业务参数
 */
- (UIViewController *)glMediator_cartViewController;
- (UIViewController *)glMediator_tabBarCartViewController;
- (UIViewController *)glMediator_mprxDemandViewController;

/**
 跳转购物车/需求清单业务ViewController
 */
- (BOOL)glMediator_pushCartViewController;
- (BOOL)glMediator_pushMprxDemandViewController;

@end
```

## 总结
本文提供的组件化方案是采用Mediator模式和苹果体系下的Target-Action模式设计的。

然而这款方案有一个很小的缺陷在于对param的key的hardcode，这是为了达到最大限度的解耦和灵活度而做的权衡。在我的网络层架构和持久层架构中，都没有hardcode的场景，这也从另一个侧面说明了组件化架构的特殊性。

权衡时，考虑到这部分hardcode的影响域仅仅存在于mediator的category中。在这种情况下，hardcode对于调用者的调用是完全透明的。对于响应者而言，处理方式等价于对API返回的参数的处理方式，且响应者的处理方式也被限制在了Action中。

因此这部分的hardcode的存在虽然确实有点不干净，但是相比于这些不干净而带来的其他好处而言，在权衡时是可以接受的，如果不采用hardcode，那势必就会导致请求响应方也需要依赖mediator，然而这在逻辑上是不必要的。

组件化方案在App业务稳定，且规模（业务规模和开发团队规模）增长初期去实施非常重要，它助于将复杂App分而治之，也有助于多人大型团队的协同开发。但组件化方案不适合在业务不稳定的情况下过早实施，至少要等产品已经经过MVP阶段时才适合实施组件化。因为业务不稳定意味着链路不稳定，在不稳定的链路上实施组件化会导致将来主业务产生变化时，全局性模块调度和重构会变得相对复杂。

当决定要实施组件化方案时，对于组件化方案的架构设计优劣直接影响到架构体系能否长远地支持未来业务的发展，对App的组件化不只是仅仅的拆代码和跨业务调页面，还要考虑复杂和非常规业务参数参与的调度，非页面的跨组件功能调度，组件调度安全保障，组件间解耦，新旧业务的调用接口修改等问题。