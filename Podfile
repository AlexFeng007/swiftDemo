source 'https://github.com/CocoaPods/Specs.git'
platform:ios,'8.0'
inhibit_all_warnings!
# 下面这行的作用是将swfit的第三方库打包成静态库
use_frameworks!

# swift库
def swiftPods
    pod 'SwiftyJSON', '~> 4.2.0'
    pod 'SnapKit',    '~> 4.2.0'
    #pod 'Result',     '~> 5.0.0'
    #pod 'Moya',       '~> 9.0.0'
    pod 'RxSwift',    '~> 4.5.0'
    pod 'RxCocoa',    '~> 4.5.0'
    pod 'RxBlocking', '~> 4.5.0'
    # HexColors颜色转换
    pod 'HexColors',  '~> 6.0.0'
    # swift二维码条形码扫描
    # pod 'swiftScan', '~> 1.1.5'
    pod 'HandyJSON', '~> 5.0.2'
    #pod 'EBBannerViewSwift', '~> 1.1.3'
    pod 'UIImageColors', '~> 2.1.0'
end

# oc库
def objectiveCPods
    # Blocks
    pod 'BlocksKit'
    # 代码处理AutoLayout
    pod 'Masonry'
    # 文件/路径工具类
    #pod 'FCFileManager'
    # CoreData
    pod 'MagicalRecord'
    # HUD
    pod 'MBProgressHUD'
    # 自动计算TableViewCell高度
    pod 'UITableView+FDTemplateLayoutCell'
    # Date工具类
    #pod 'DateTools', '~> 1.5.0'
    # sqlite
    pod 'FMDB'
    # facebook 动画库
    pod 'pop', '~> 1.0.7'
    # 个推推送SDK
    pod 'GTSDK', '1.6.4.1'
    # AFN
    pod 'AFNetworking', '2.6.3'
    # Mantle
    pod 'Mantle', '1.5.5'
    # TableBarController
    pod 'RDVTabBarController'
    # 刷新控件
    pod 'SVPullToRefresh', :git => 'https://github.com/samvermette/SVPullToRefresh.git', :commit => 'a5f9dfee86a27c4e994d7edf93d0768c881d58bb'
    pod 'MJRefresh', '3.1.12'
    # log日志框架
    pod 'CocoaLumberjack'
    # 收集了很多构思优秀的NSFormatter子类
    #pod 'FormatterKit'
    # AOP切面编程库
    pod 'Aspects'
    # RAC & MVVM
    pod 'ReactiveCocoa', :git => 'https://github.com/zhao0/ReactiveCocoa.git', :tag => '2.5.2'
    # 图片加载解析库
    pod 'SDWebImage', '3.8.2'
    pod 'SDWebImage/WebP'
    # 提供UIView的left、right、 top、bottom、centerX、centerY等属性
    pod 'UIView+Positioning', '1.0'
    # 无限循环控件
    pod 'SDCycleScrollView', '1.65.0'
    # 百度地图控件
    pod 'BaiduMapKit', '3.1.0'
    # keychain
    pod 'SAMKeychain'
    #图片解析库
    pod 'YYWebImage', '~> 1.0.5'
    
    # model解析框架
    pod 'YYModel'
    # 第三方富文本Label
    pod 'YYText'
    
    # 线上异常、闪退跟踪框架
    pod 'Bugly'
    # 空页面视图框架
    pod 'DZNEmptyDataSet'
    # segment分页控件
    pod 'HMSegmentedControl'
    # 弹层
    pod 'WYPopoverController', '~> 0.3.8'
    # 友盟sdk
    pod 'UMCCommon'
    # 听云 app监测与统计
    pod 'tingyunApp'
    # 腾讯小直播
    pod 'TXLiteAVSDK_Professional'
    # 腾讯IM即时通讯
    pod 'TXIMSDK_iOS' ,'~> 4.9.1'
    # 网络状态检测
    pod 'RealReachability'
    # 无埋点SDK...<百度移动统计>
    #pod 'BaiduMobStatCodeless'
    # 检测内存泄露 & 检测循环引用
    pod 'MLeaksFinder'
    pod 'FBRetainCycleDetector'
    # APM开发助手
    pod 'DoraemonKit/Core' , :configurations => ['Debug']
    pod 'DoraemonKit/WithLogger' , :configurations => ['Debug']
    pod 'DoraemonKit/WithLoad', :configurations => ['Debug']
    #push弹窗
    pod 'EBBannerView', '~> 1.1.2'
    #pod 'DoraemonKit/WithGPS', '~> 1.2.1', :configurations => ['Debug']
    #pod 'DoraemonKit/WithWeex', '~> 1.2.1', :configurations => ['Debug']
    #pod 'DoraemonKit/WithDatabase', '~> 1.2.1', :configurations => ['Debug']
end

target 'FKY' do
    swiftPods
    objectiveCPods
end

target 'FKY-DEV' do
    swiftPods
    objectiveCPods
end

target 'FKY-TEST' do
    swiftPods
    objectiveCPods
end

target 'FKY-Beta' do
    swiftPods
    objectiveCPods
end


#Test BDD单元测试
target 'FKYTests' do
    # 单测
#    pod 'Kiwi'
    # 伪造网络数据
#    pod 'FBSnapshotTestCase'
    # V6.1.0 removed by Xia Zhiyong
#    pod 'Expecta+Snapshots','~> 3.0'
#    pod 'OHHTTPStubs'
#    pod 'XCTest+OHHTTPStubSuiteCleanUp'
#    pod 'Specta' , '~> 1.0'
#    pod 'Expecta'
#    pod 'OCMock'
#    pod 'OHHTTPStubs'
#    pod 'FBSnapshotTestCase/Core'
end

target 'NotificationService' do
    platform :ios, "10.0"
    pod 'GTExtensionSDK'
end
