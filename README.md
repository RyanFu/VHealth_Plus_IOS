
# Created by pingjun lin on 2016/11/14.

# V健康+

 
 > 项目介绍：V健康+
 
## Intro

V健康+是一款轻量级的应用，更多的复杂逻辑集中在服务端。主要的功能

1. 应用的主要服务于企业和工会，可以定制化的给企业进行消息发布。
2. 企业，工会可以发布活动，员工利用APP参与到活动中。
3. 记录使用者的每天的运动步数，兑换成积分。
4. 福利商城中可以使用积分，或者金钱购买商品。
 
## 框架iOS前端介绍

iOS的前端主要分为5个主要模块，分别是"动态(`Dynamic`)","活动(`Activity`)","福利(`Shop`)","发现(`Discover`)","我(`Me`)"。UI布局主要采用的Storyboard方式，将每一个模块单独出一个Storyboard，既方便团队开发管理，也减少加载资源的时间和内存。

代码开发结构采用的是传统MVC模式。具体到每一个模块，采用的是UITabViewController中嵌套UINavigationController的方式。模块之间保持代码间的独立，不会产生代码的侵染，也很好的使用了UITabViewController懒加载的特性。

## 模块介绍

### 动态(Dynamic)

"动态"的展现模式是使用`UITableView`展示，列表Cell分为三种类型，分别为单图，大图，三图。对应的type = 1, type = 2, type = 3。根据不一样的type使用不一样的cell。每一个Cell的点击之后具体信息的展示为`H5`页面，通过调用通用的`PublicWKWebViewController`页面即可。

### 活动(Activity)

"活动"模块用于企业发布活动。该模块是是通过`Html`进行展示的，所以提供了`WKWebView`(App仅支持iOS8+)。其中通过和JS的交互，完成开启定位，签到，关闭定位等功能。

### 福利(Shop)

"福利"模块是基于Web的项目(`ecshop`)，用于商品的购买，购买可以使用积分，也可以使用金币。前端提供`WKWebView`，通过和JS的交互，实现调用支付宝，微信(待开发)，进行支付。

### 发现(Discover)

"发现"模块用于企业消息发布，前端采用的布局使用的`UICollectionView`，通过服务器进行配置，在前端展示不同的消息模块，具体的模块展示，是通过调用`H5`页面，所以项目中有一个通用的`PublicWKWebViewController`类，通过传递`H5`链接即可。

### 我(Me)

"我"的模块，主要是展示用户的信息，修改用该用户信息等功能等。该模块最主要的是有**计步**功能。

计步能力来自于两方面：

1. 绑定手环后的手环数据
2. 未绑定手环时候的`HealthKit`数据


## 主要技术点和应用介绍

### Native(原生)和H5交互

由于项目支持最低从`iOS8.0`开始，所以项目中使用的是从`iOS8.0`推出的API-`WKWebView`，`WKWebView`使用了和Safari同样的内核，速度更快，占用内存更少。在本项目中使用集中在**活动**，**福利**和`PublicWKWebViewController`中。

1. 创建`WKWebView`进行配置
2. 创建`WKWebViewConfiguration`，并配置JS交互的对象vhswebview `[configration.userContentController addScriptMessageHandler:self name:@"vhswebview"];`
3. 设置代理
4. `WKWebView`调用JS——`[self.contentWKWebView evaluateJavaScript:jsMethod completionHandler:^(id _Nullable any, NSError * _Nullable error) {}];`
5. JS调用Native，是通过实现代理(`WKScriptMessageHandler`)，并对参数进行截获的方式调用的。

JS端调用Native使用如下方法：
	
	var message = {
						'method' : 'hello',
                 	'param1' : 'liuyanwei',
                  };
	window.webkit.messageHandlers.vhswebview.postMessage(message);
	
	
具体参照项目中`PublicWKWebViewController`类

参考资料：[UIWebView和WKWebView的使用及js交互](http://liuyanwei.jumppo.com/2015/10/17/ios-webView.html)

### 网络请求

网络模块采用的是对`AFNetworking`进行封装。主要集中在类`VHSHttpEngine`，还有一个配置类`VHSRequestMessage`，该类封装了网络请求的参数，请求类型，请求路径，请求超时，请求图片等的设置。

设置好配置类，直接使用`VHSHttpEngine`的单利，调用

	// 发起请求
	- (void)sendMessage:(VHSRequestMessage*)message success:(RequestSuccess)successBlock fail:(RequestFailure)failBlock;

### 本地数据持久化

本地数据持久化通过使用封装`FMDB`实现，项目中数据的持久化主要针对运动步数的保存。主要的实现类在`VHSDataBaseManager`中，实现了数据库的创建，表的创建，以及对数据的增删改出操作。具体的业务对表的操作集中在`VHSStepAlgorithm`中。

### 手环计步，手机(`HealthKit`)计步

### 项目第三方架包管理


 

