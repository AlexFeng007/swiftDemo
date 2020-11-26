//
//  LiveEnumInfoObject.swift
//  FKY
//
//  Created by 寒山 on 2020/8/13.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

import UIKit

public let CACHE_TIME_FAST = 1.0  //视频缓存策略急速
public let CACHE_TIME_SMOOTH = 5.0 //视频缓存策略 流畅

//播放网络情况枚举
//播放消息枚举
enum PLAY_EVT_TYPE: Int32 {
    //播放事件
    case PLAY_EVT_CONNECT_SUCC = 2001    //已经连接服务器
    case PLAY_EVT_RTMP_STREAM_BEGIN = 2002    //已经连接服务器，开始拉流（仅播放 RTMP 地址时会抛送）
    case PLAY_EVT_RCV_FIRST_I_FRAME = 2003    //收到首帧数据，越快收到此消息说明链路质量越好
    case PLAY_EVT_PLAY_BEGIN = 2004    //视频播放开始，如果您自己做 loading，会需要它
    case PLAY_EVT_PLAY_PROGRESS = 2005    //播放进度，如果您在直播中收到此消息，可以忽略
    case PLAY_EVT_PLAY_LOADING = 2007    //视频播放进入缓冲状态，缓冲结束之后会有 PLAY_BEGIN 事件
    case PLAY_EVT_START_VIDEO_DECODER = 2008    //视频解码器开始启动（2.0 版本以后新增）
    case PLAY_EVT_CHANGE_RESOLUTION = 2009    //视频分辨率发生变化（分辨率在 EVT_PARAM 参数中）
    case PLAY_EVT_GET_PLAYINFO_SUCC = 2010   // 如果您在直播中收到此消息，可以忽略
    case PLAY_EVT_CHANGE_ROTATION = 2011    //如果您在直播中收到此消息，可以忽略
    case PLAY_EVT_GET_MESSAGE = 2012    //获取夹在视频流中的自定义 SEI 消息，消息的发送需使用 TXLivePusher
    case PLAY_EVT_VOD_PLAY_PREPARED = 2013    //如果您在直播中收到此消息，可以忽略
    case PLAY_EVT_VOD_LOADING_END  = 2014    //如果您在直播中收到此消息，可以忽略
    case PLAY_EVT_STREAM_SWITCH_SUCC = 2015   // 直播流切换完成，请参考 清晰度无缝切换
    
    //结束事件
    case PLAY_EVT_PLAY_END = 2006    //视频播放结束  播放结束，HTTP-FLV 的直播流是不抛这个事件的
    case PLAY_ERR_NET_DISCONNECT = -2301    //网络断连，且经多次重连亦不能恢复，更多重试请自行重启播放
    //警告事件
    case PLAY_WARNING_VIDEO_DECODE_FAIL = 2101    //当前视频帧解码失败
    case PLAY_WARNING_AUDIO_DECODE_FAIL = 2102    //当前音频帧解码失败
    case PLAY_WARNING_RECONNECT = 2103    //网络断连，已启动自动重连（重连超过三次就直接抛送 PLAY_ERR_NET_DISCONNECT）
    case PLAY_WARNING_RECV_DATA_LAG = 2104    //网络来包不稳：可能是下行带宽不足，或由于主播端出流不均匀
    case PLAY_WARNING_VIDEO_PLAY_LAG = 2105    //当前视频播放出现卡顿
    case PLAY_WARNING_HW_ACCELERATION_FAIL = 2106    //硬解启动失败，采用软解
    case PLAY_WARNING_VIDEO_DISCONTINUITY = 2107    //当前视频帧不连续，可能丢帧
    case PLAY_WARNING_DNS_FAIL = 3001    //RTMP-DNS 解析失败（仅播放 RTMP 地址时会抛送）
    case PLAY_WARNING_SEVER_CONN_FAIL = 3002    //RTMP 服务器连接失败（仅播放 RTMP 地址时会抛送）
    case PLAY_WARNING_SHAKE_FAIL = 3003    //RTMP 服务器握手失败（仅播放 RTMP 地址时会抛送）
}

//播放url类型
enum PLAY_TYPE_LIVE_TYPE: Int {
    case PLAY_TYPE_LIVE_RTMP =   0    ///传入的 URL 为 RTMP 直播地址
    case PLAY_TYPE_LIVE_FLV  =  1    //传入的 URL 为 FLV 直播地址
    case PLAY_TYPE_LIVE_RTMP_ACC =   5    //低延迟链路地址（仅适合于连麦场景）
    case PLAY_TYPE_VOD_HLS   = 3    //传入的 URL 为 HLS（m3u8）播放地址
}

/////////////////////////////////////////////////////////////////////////////////
//
//                    【视频相关枚举值定义】
//
/////////////////////////////////////////////////////////////////////////////////

/**
 * 1.1 视频分辨率
 *
 * 在普通模式下，TXLivePusher 只支持三种固定的分辨率，即：360 × 640、540 × 960 以及 720 × 1280。
 *
 *【如何横屏推流】
 * 如果希望使用 640 × 360、960 × 540、1280 × 720 这样的横屏分辨率，需要设置 TXLivePushConfig 中的 homeOrientation 属性，
 * 并使用 TXLivePusher 中的 setRenderRotation 接口进行画面旋转。
 *
 *【自定义分辨率】
 * 如果希望使用其他分辨率，可以设置 TXLivePushConfig 中的 customModeType 为 CUSTOM_MODE_VIDEO_CAPTURE，
 * 自己采集 SampleBuffer 送给 TXLivePusher 的 sendVideoSampleBuffer 接口。
 *
 *【建议的分辨率】
 * 手机直播场景下最常用的分辨率为 9:16 的竖屏分辨率 540 × 960。
 * 从清晰的角度，540 × 960 比 360 × 640 要清晰，同时跟 720 × 1280 相当。
 * 从性能的角度，540 × 960 可以避免前置摄像头开启 720 × 1280 的采集分辨率，对于美颜开销很大的场景能节省不少的计算量。
 */
enum Enum_Type_VideoResolution: Int {
    
    /// 竖屏分辨率，宽高比为 9:16
    case VIDEO_RESOLUTION_TYPE_360_640      = 0   ///< 建议码率 800kbps
    case VIDEO_RESOLUTION_TYPE_540_960      = 1   ///< 建议码率 1200kbps
    case VIDEO_RESOLUTION_TYPE_720_1280     = 2   ///< 建议码率 1800kbps
    case VIDEO_RESOLUTION_TYPE_1080_1920    = 30  ///< 建议码率 3000kbps
    
    
    /// 如下均为内建分辨率，为 SDK 内部使用，不支持通过接口进行设置
    case VIDEO_RESOLUTION_TYPE_640_360      = 3
    case VIDEO_RESOLUTION_TYPE_960_540      = 4
    case VIDEO_RESOLUTION_TYPE_1280_720     = 5
    case VIDEO_RESOLUTION_TYPE_1920_1080    = 31
    
    case VIDEO_RESOLUTION_TYPE_320_480      = 6
    case VIDEO_RESOLUTION_TYPE_180_320      = 7
    case VIDEO_RESOLUTION_TYPE_270_480      = 8
    case VIDEO_RESOLUTION_TYPE_320_180      = 9
    case VIDEO_RESOLUTION_TYPE_480_270      = 10
    
    case VIDEO_RESOLUTION_TYPE_240_320      = 11
    case VIDEO_RESOLUTION_TYPE_360_480      = 12
    case VIDEO_RESOLUTION_TYPE_480_640      = 13
    case VIDEO_RESOLUTION_TYPE_320_240      = 14
    case VIDEO_RESOLUTION_TYPE_480_360      = 15
    case VIDEO_RESOLUTION_TYPE_640_480      = 16
    
    case VIDEO_RESOLUTION_TYPE_480_480      = 17
    case VIDEO_RESOLUTION_TYPE_270_270      = 18
    case VIDEO_RESOLUTION_TYPE_160_160      = 19
}

/**
 * 1.2 画面质量挡位
 *
 * 如果您希望调整直播的编码参数，建议您直接使用 TXLivePusher 提供的 setVideoQuality 接口。
 * 由于视频编码参数中的分辨率，码率和帧率对最终效果都有着复杂的影响，如果您之前没有相关操作经验，不建议直接修改这些编码参数。
 * 我们在 setVideoQuality 接口中提供了如下几个挡位供您选择：
 *
 *  1. 标清：采用 360 × 640 的分辨率，码率调控范围 300kbps - 800kbps，关闭网络自适应时的码率为 800kbps，适合网络较差的直播环境。
 *  2. 高清：采用 540 × 960 的分辨率，码率调控范围 600kbps - 1500kbps，关闭网络自适应时的码率为 1200kbps，常规手机直播的推荐挡位。
 *  3. 超清：采用 720 × 1280 的分辨率，码率调控范围 600kbps - 1800kbps，关闭网络自适应时的码率为 1800kbps，能耗高，但清晰度较标清提升并不明显。
 *  4. 连麦（大主播）：主播从原来的“推流状态”进入“连麦状态”后，可以通过 setVideoQuality 接口调整自 MAIN_PUBLISHER 挡位。
 *  5. 连麦（小主播）：观众从原来的“播放状态”进入“连麦状态”后，可以通过 setVideoQuality 接口调整自 SUB_PUBLISHER 挡位。
 *  6. 视频通话：该选项后续会逐步废弃，如果您希望实现纯视频通话而非直播功能，推荐使用腾讯云 [TRTC](https://cloud.tencent.com/product/trtc) 服务。
 *
 * 【推荐设置】如果您对整个平台的清晰度要求比较高，推荐使用 setVideoQuality(HIGH_DEFINITION, NO, NO) 的组合。
 *             如果您的主播有很多三四线城市的网络适配要求，推荐使用 setVideoQuality(HIGH_DEFINITION, YES, NO) 的组合。
 *
 * @note 在开启硬件加速后，您可能会发现诸如 368 × 640 或者 544 × 960 这样的“不完美”分辨率。
 *       这是由于部分硬编码器要求像素能被 16 整除所致，属于正常现象，您可以通过播放端的填充模式解决“小黑边”问题。
 */
enum Enum_Type_VideoQuality: Int {
    case VIDEO_QUALITY_STANDARD_DEFINITION       = 1   ///< 标清：采用 360 × 640 的分辨率
    case VIDEO_QUALITY_HIGH_DEFINITION           = 2    ///< 高清：采用 540 × 960 的分辨率
    case VIDEO_QUALITY_SUPER_DEFINITION          = 3   ///< 超清：采用 720 × 1280 的分辨率
    case VIDEO_QUALITY_ULTRA_DEFINITION          = 7    ///< 蓝光：采用 1080 × 1920 的分辨率
    case VIDEO_QUALITY_LINKMIC_MAIN_PUBLISHER    = 4    ///< 连麦场景下的大主播使用
    case VIDEO_QUALITY_LINKMIC_SUB_PUBLISHER     = 5    ///< 连麦场景下的小主播（连麦的观众）使用
    case VIDEO_QUALITY_REALTIME_VIDEOCHAT        = 6   ///< 纯视频通话场景使用（已废弃）
};

/**
 * 1.3 画面旋转方向
 */
enum Enum_Type_HomeOrientation: Int {
    case HOME_ORIENTATION_RIGHT     = 0    ///< HOME 键在右边，横屏模式
    case HOME_ORIENTATION_DOWN      = 1    ///< HOME 键在下面，手机直播中最常见的竖屏直播模式
    case HOME_ORIENTATION_LEFT      = 2    ///< HOME 键在左边，横屏模式
    case HOME_ORIENTATION_UP        = 3    ///< HOME 键在上边，竖屏直播（适合小米 MIX2）
};

/**
 * 1.4 画面填充模式
 */
enum Enum_Type_RenderMode: Int  {
    case RENDER_MODE_FILL_SCREEN    = 0    ///< 图像铺满屏幕，不留黑边，如果图像宽高比不同于屏幕宽高比，部分画面内容会被裁剪掉。
    case RENDER_MODE_FILL_EDGE      = 1    ///< 图像适应屏幕，保持画面完整，但如果图像宽高比不同于屏幕宽高比，会有黑边的存在。
};

enum ENUM_TYPE_CACHE_STRATEGY: Int {
    case CACHE_STRATEGY_FAST           = 1  // 极速
    case CACHE_STRATEGY_SMOOTH         = 2  // 流畅
    case CACHE_STRATEGY_AUTO           = 3 // 自动
};
