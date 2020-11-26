# GLHybrid

__GLHybrid是一个可以让JS与iOS原生代码（Objective-C）互相通信的一个库，内部提供了一系列接口供JS调用。关于JS与Objective-C互相通信主要涉及以下二部分:__

- JS --> Objective-C 
- Objective-C --> JS 

本文档主要介绍如何使用该库，以及其实现原理。以下默认J代表JS端，N代表Native端。

# 如何使用
这里我们以J端调用N端的pickImage方法上传图片至服务器指定的url并返回结果给J端为例，假设J端发起的url为: 

```
gl://pickImage?callid=11111&param={
    "pickType":0,         //pickType 0:让用户选择拍照或选取图片 1:拍照 2:图片
    "allowEdit":0,        //0:读取图片后不允许用户编辑  1:允许
    "uploadUrl":"https://eaifjfe.com",     //网路上传地址
 }
```
在工程中，我们新建GLBridge+Resource这个分类，然后实现如下方法:

```
- (void)pickImage:(GLJsRequest *)request
{
	...//调用原生拍照或取相片方法
	...//调用原生上传图片至服务器方法
	BOOL isSuccess = ...//上传图片是否成功
	GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:isSuccess ? GLBridgeRespCode_OK : GLBridgeRespCode_WRONG_PARAM data:data];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:request.callbackId];
}
```
这里方法名为交互文档中与J端所约定好的方法名，大小写敏感，必须按文档的写，至于入参(GLJsRequest *)request，必须附带。

方法实现中，先实现本地的一些操作方法调用，然后根据调用结果是否成功，回调J端。

+ 首先实例化一个GLBridgeResponse对象，需要入参指定状态码或返回J端的参数字典（请根据该类的文档实例化)
+ 调用GLBridge的interactiveDelegate对象的sendBridgeResponseToJs方法将所实例化的reponse发送给J端。

若需求中需要在分类中增加属性保存一些临时变量，需要在分类中使用objc_setAssociatedObject/objc_getAssociatedObject来增加分类属性。

至此，使用方法就介绍完了。


# 实现原理
## 类结构概览
库的类结构如下所示：

```
├── GLAppDelegate.h   
├── GLAppDelegate.m
├── GLBridge.h	
├── GLBridge.m
├── GLBridgeResponse.h
├── GLBridgeResponse.m
├── GLConfigManager.h
├── GLConfigManager.m
├── GLHybrid.h
├── GLInteractiveDelegate.h
├── GLInteractiveDelegateImpl.h
├── GLInteractiveDelegateImpl.m
├── GLJSON.h
├── GLJSON.m
├── GLJsRequest.h
├── GLJsRequest.m
├── GLMediator
│   ├── GLMediator.h
│   └── GLMediator.m
├── GLViewController.h
├── GLViewController.m
├── GLWKNavigationDelegateImpl.h
├── GLWKNavigationDelegateImpl.m
├── GLWKUIDelegateImpl.h
├── GLWKUIDelegateImpl.m
├── GLWebViewEngine.h
├── GLWebViewEngine.m
└── GLWebViewEngineProtocol.h

```

其中核心交互方法主要集中在**GLInteractiveDelegate**协议中，具体实现由**GLInteractiveDelegateImpl**完成，以下为协议内容：

```
@protocol GLInteractiveDelegate <NSObject>

/**
 执行js请求

 @param url 被拦截的符合约定规则的url
 */
- (void)executeJsRequestFromURL:(NSURL *)url;

/**
 发送Native处理结果给js

 @param response 处理结果
 @param callbackId js发送过来的request附带的callid
 */
- (void)sendBridgeResponseToJs:(GLBridgeResponse *)response callbackId:(NSString *)callbackId;
/**
 在主线程执行js语句

 @param js 被执行语句
 */
- (void)evaluateJs:(NSString *)js;

@end
```

## JS --> Objective-C
合法的J端调用N端，拦截的URL格式为:`gl://action?callid=xxxxxxx&param={...}`

| 字段 | 描述 |
| ------ | ----------- |
| gl   | 约定scheme|
| action | 所要请求的服务具体操作 |
| callid    | 回调方法标识 |
| param    | 请求操作所带的参数 |

当J根据约定协议触发请求url时，N端WKNavigationWebViewDelegate的`webView:decidePolicyForNavigationAction:decisionHandler:`会被触发调用，核心代码如下:

```
// 在发送请求之前，决定是否跳转，返回 WKNavigationActionPolicyAllow，则开始加载此 URL，返回 WKNavigationActionPolicyCancel，则忽略此 URL
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *url = [[navigationAction request] URL];
    GLViewController *vc = (GLViewController *) self.engine.viewController;
    
    if ([[url scheme] isEqualToString:@"gl"]) { // 判断是否基于约定的请求(gl://)
        decisionHandler(WKNavigationActionPolicyCancel);
        // 将JS的url转换成GLJsRequest对象 & 执行JS请求交互指令
        [vc.interactiveDelegate executeJsRequestFromURL:url];
    }
    ...
}
```
**通过这个方式，J调用N是异步的。**

而实现交互协议**GLInteractiveDelegate**的实例类**GLInteractiveDelegateImpl**中方法为

```
- (void)executeJsRequestFromURL:(NSURL *)url
{
	// 将url转化为native可以执行的对象
    GLJsRequest *request = [GLJsRequest jsRequestFromURL:url];
    
    if (![self execute:request]) {
        NSLog(@"\n【GLHybrid】ERROR: native方法执行失败, callbackId: %@: method: %@\n\n", request.callbackId, request.methodName);
    }
}
```
这里含三步操作：

+ **GLJsRequest**转化url为可执行对象，将`gl://function?callid=1&param={"key":["value1","value2"]}`解析为一个GLJsRequest对象，该对象有三个属性（方法名、回调id、业务入参），并提供了一个便捷的取业务参数的方法

```
@property (nonatomic, readonly, copy) NSString *methodName;     /* <js调用方法名 */
@property (nonatomic, readonly, copy) NSString *callbackId;     /* <js调用回调方法的id */
@property (nonatomic, readonly, copy) NSDictionary *param;      /* <js调用附带参数 */

/**
 取js端传入参数内容

 @param key 约定的key
 @return 对应值
 */
- (id)paramForKey:(NSString *)key;
```
+ 将请求对象作为入参执行，这里主要用到了runtime方法`objc_msgSend(class, selector, cmd)`，由于传入url只有action，没有对应模块参数，因此此处的class只对应GLBridge对象，而selector则对应action，cmd就是传入的request

```
- (BOOL)execute:(GLJsRequest *)cmd
{
    if (cmd.methodName == nil) {
        NSLog(@"\n【GLHybrid】ERROR: JS请求method未找到\n\n");
        return NO;
    }

    GLBridge *obj = [_viewController nativeAPI];

    if (!([obj isKindOfClass:[GLBridge class]])) {
        return NO;
    }
    BOOL exeResult = YES;
    double started = [[NSDate date] timeIntervalSince1970] * 1000.0;

    NSString *methodName = [NSString stringWithFormat:@"%@:", cmd.methodName];
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([obj respondsToSelector:normalSelector]) {
        ((void (*)(id, SEL, id)) objc_msgSend)(obj, normalSelector, cmd);
    }
    else {
        NSLog(@"\n【GLHybrid】ERROR: method '%@' 不在支持接口列表之中\n\n", methodName);
        exeResult = NO;
    }
    double elapsed = [[NSDate date] timeIntervalSince1970] * 1000.0 - started;
    if (elapsed > 100) {
        NSLog(@"\n【GLHybrid】线程警告: ['%@'] 执行耗费 '%f' ms. 请考虑在多线程内执行.\n\n", methodName, elapsed);
    }
    return exeResult;
}
```

## Objective-C --> JS
WKWebView 有一个这样的方法`evaluateJavaScript:completionHandler`，这个方法可以让一个 WKWebView 对象执行一段 JS 代码，这样就可以达到 Objective-C 跟 JS 通信的效果。
 
 **通过这个方式，N调用J是同步的。**

合法的N端回调J端执行的js格式为:

```
callback({
    "callid":11111,
    "errcode":0,
    "errmsg":"ok", // ok, fail, 未登录
    "data":{
        "key": value
    }
})
```

| 参数      |     类型 |    必传|描述  |
| :--------: | :--------:|  :--------:|:------: |
| callid    |   Number | NO | 使用接口时传过来的用于标识请求的值  |
| errcode    |   Number |YES |  错误码 0:成功 1:参数错误 2:未登录  |
| errmsg    |   String |YES |  错误信息  |
| data    |   Json | NO |  业务返回内容  |



前面提到通过objc_msgSend的方式转发了执行的方法，具体实现是业务开发人员会在GLBridge的基础上写一些分类，分类中提供了给J端调用的原生方法的具体实现，如：

```
@implementation GLBridge (Base)
- (void)isLogin:(GLJsRequest *)request
{
    BOOL islogin = isUserLogin();

    GLBridgeResponse *reponse = [GLBridgeResponse reponseWithErrCode:GLBridgeRespCode_OK data:@{ @"result" : @(islogin) }];
    [self.interactiveDelegate sendBridgeResponseToJs:reponse callbackId:request.callbackId];
}
```
方法实现中会实例化一个**GLBridgeResponse**对象，该对象封装了回调J端时的所需参数，并提供了方法将这些参数统一转化为JSON以便回调时作为入参

```
@property (nonatomic, strong, readonly) NSNumber *errcode;  /* <返回给js的错误码 */
@property (nonatomic, strong, readonly) NSString *errmsg;   /* <返回给js的错误提示 */
@property (nonatomic, strong, readonly) id data;            /* <返回给js的业务内容 */
/**
 初始化
 
 @param errcode 错误码
 @param errmsg 错误信息
 @param data 业务内容
 @return 实例
 */
- (instancetype)init;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode data:(id)data;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode errorMessage:(NSString *)errmsg;
+ (GLBridgeResponse *)reponseWithErrCode:(GLBridgeRespCode)errcode errorMessage:(NSString *)errmsg data:(id)data;


/**
 将返回js端信息转化为JSON

 @param callbackId js端回调id
 @return 转化为JSON的callback方法参数
 */
- (NSString *)callBackParamAsJSONWithId:(NSString *)callbackId;
```
最终调用**GLInteractiveDelegateImpl**类的`sendBridgeResponseToJs:callbackId:`方法：
 
```
- (void)sendBridgeResponseToJs:(GLBridgeResponse *)response callbackId:(NSString *)callbackId
{
    if (![self isValidCallbackId:callbackId]) {
        NSLog(@"\n【GLHybrid】ERROR: callbackId无效\n\n");
        return;
    }

    NSString *parameterAsJSON = [response callBackParamAsJSONWithId:callbackId];
    NSString *js = [NSString stringWithFormat:@"callback(\'%@\')", parameterAsJSON];
    [self evaluateJs:js];
}

- (void)evaluateJs:(NSString *)js
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(evaluateJsOnMainThread:) withObject:js waitUntilDone:NO];
    }
    else {
        [self evaluateJsOnMainThread:js];
    }
}

- (void)evaluateJsOnMainThread:(NSString *)js
{
    [_viewController.webViewEngine evaluateJavaScript:js completionHandler:^(id obj, NSError *error) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *returnJSON = (NSString *) obj;
            if ([returnJSON length] > 0) {
                NSLog(@"\n【GLHybrid】执行js结束, 收到responseJSON: %@\n\n", returnJSON);
            }
        }
    }];
}
```
至此，N端与J端的交互便完成了
































