//
//  GLQRScanVC.m
//  YYW
//
//  Created by Rabe on 20/03/2017.
//  Copyright © 2017 YYW. All rights reserved.
//

#import "GLQRScanVC.h"
#import "UIColor+HEX.h"
#import "UIDevice+Hardware.h"
#import <AVFoundation/AVFoundation.h>
#import "BlocksKit+UIKit.h"

#define GLQRScreenHeight [UIScreen mainScreen].bounds.size.height
#define GLQRScreenWidth [UIScreen mainScreen].bounds.size.width

static const float kQRViewSizeWidth = 240;

@interface GLTranslucentView : UIView

@end

@implementation GLTranslucentView

- (void)drawRect:(CGRect)rect
{
    CGFloat QRViewWith = kQRViewSizeWidth * (GLQRScreenWidth / 320);
    CGFloat QRViewHeight = QRViewWith;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat px = (width - QRViewWith) / 2;
    CGFloat py = (height - QRViewHeight) / 2;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 0, 0, 0, 0);
    CGContextSetLineWidth(context, 1.);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context,
                     CGRectMake(px, py, QRViewWith, QRViewHeight));
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#0193e8"].CGColor);
    CGContextMoveToPoint(context, px, py + 15);
    CGContextAddLineToPoint(context, px, py);
    CGContextAddLineToPoint(context, px + 15, py);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextMoveToPoint(context, px + QRViewWith - 15, py);
    CGContextAddLineToPoint(context, px + QRViewWith, py);
    CGContextAddLineToPoint(context, px + QRViewWith, py + 15);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextMoveToPoint(context, px, py + QRViewHeight - 15);
    CGContextAddLineToPoint(context, px, py + QRViewHeight);
    CGContextAddLineToPoint(context, px + 15, py + QRViewHeight);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextMoveToPoint(context, px + QRViewWith - 15, py + QRViewHeight);
    CGContextAddLineToPoint(context, px + QRViewWith, py + QRViewHeight);
    CGContextAddLineToPoint(context, px + QRViewWith, py + QRViewHeight - 15);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextSetRGBFillColor(context, 0, 0, 0, 0.4);
    CGContextFillRect(context, CGRectMake(0, 0, width, py));
    CGContextFillRect(context, CGRectMake(0, py, px, QRViewHeight));
    CGContextFillRect(context,
                      CGRectMake(px + QRViewWith, py, px, QRViewHeight));
    CGContextFillRect(context, CGRectMake(0, py + QRViewHeight, width, height - py - QRViewHeight));
    CGContextStrokePath(context);
}

@end

@interface GLQRScanVC () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;                /** 会话对象 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer; /** 图层类 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) UIView *scanningView; /** 扫描的红线 */
@property (nonatomic, strong) GLTranslucentView *translucentView;
@property (nonatomic, copy) GLQRCompletionBlock completionHandler;

@end

@implementation GLQRScanVC

#pragma mark - life cycle

- (instancetype)initWithCompletionHandler:(GLQRCompletionBlock)completionHandler
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _completionHandler = completionHandler;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"扫一扫";

    if ([UIDevice hasCamera]) {
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        BOOL isAuthorized = (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined);
        if (!isAuthorized) {
            [self alertNoAuthorizedToUseDevice];
        }

        if (self.previewLayer) {
            [self.view.layer insertSublayer:self.previewLayer atIndex:0];
            [_session startRunning];
            CGRect interestRect = [self.previewLayer metadataOutputRectOfInterestForRect:self.outputInterestRect];
            [self.output setRectOfInterest:interestRect];
        }

        [self.view addSubview:self.translucentView];
        [self.view addSubview:self.scanningView];
        [self startAnimation];
        [self.view addSubview:self.warnView];
    }
    else {
        [self alertDeviceNotConnected];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![self.session isRunning]) {
        [self.session startRunning];
        [self.scanningView setHidden:NO];
        [self startAnimation];
    }
}

#pragma mark - delegate

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    // 扫描成功之后的提示音
    [self playSoundEffect:@"scan.mp3"];

    // 如果扫描完成，停止会话
    [self.session stopRunning];

    [self.scanningView setHidden:YES];

    if ([metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        [self callbackWithValue:obj.stringValue];
    }
    else {
        [self callbackWithValue:nil];
    }
}

#pragma mark - action

#pragma mark - private

- (void)callbackWithValue:(NSString *)value
{
    if (_completionHandler) {
        _completionHandler(value);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startAnimation
{
    CGFloat hegiht = kQRViewSizeWidth * (GLQRScreenWidth / 320) - 2;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.repeatCount = MAX_CANON;
    animation.fromValue = @(self.scanningView.frame.origin.y);
    animation.toValue = @(self.scanningView.frame.origin.y + hegiht);
    animation.duration = 2;
    animation.autoreverses = YES;
    [self.scanningView.layer addAnimation:animation forKey:@"BASIC"];
}

#pragma mark - - - 扫描提示声
/** 播放音效文件 */
- (void)playSoundEffect:(NSString *)name
{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];

    // 1、获得系统声音ID
    SystemSoundID soundID = 0;

    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);

    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompletionCallback, NULL);

    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}
/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompletionCallback(SystemSoundID soundID, void *clientData)
{
    NSLog(@"播放完成...");
}

#pragma mark - property

- (UILabel *)warnView
{
    CGFloat px = 20;
    CGFloat width = kQRViewSizeWidth * (GLQRScreenWidth / 320);
    CGFloat py = (GLQRScreenHeight - width) / 2 + width + 24 + 64;
    if (py + 50 >= GLQRScreenHeight) {
        py = GLQRScreenHeight - 60;
    }

    UILabel *warnView = [[UILabel alloc] initWithFrame:CGRectMake(px, py, GLQRScreenWidth - 40, 50)];
    [warnView setNumberOfLines:0];
    [warnView setBackgroundColor:[UIColor clearColor]];
    [warnView setTextColor:[UIColor whiteColor]];
    [warnView setTextAlignment:NSTextAlignmentCenter];
    [warnView setFont:[UIFont systemFontOfSize:14]];
    [warnView setText:@"调整条码和镜头的距离，软件将自动扫描\n尽量避免逆光和阴影"];
    return warnView;
}

- (CGRect)outputInterestRect
{
    CGFloat width = GLQRScreenWidth;
    CGFloat QRViewWith = kQRViewSizeWidth * (GLQRScreenWidth / 320);
    CGFloat QRViewHeight = QRViewWith;
    CGFloat px = (width - QRViewWith) / 2;
    CGFloat py = (GLQRScreenHeight - QRViewHeight - 64) / 2;
    CGRect rect = CGRectMake(px, py, QRViewWith, QRViewHeight);
    return rect;
}

- (GLTranslucentView *)translucentView
{
    if (_translucentView == nil) {
        _translucentView = [[GLTranslucentView alloc] initWithFrame:CGRectMake(0, 64, GLQRScreenWidth, GLQRScreenHeight - 64)];
        [_translucentView setBackgroundColor:[UIColor clearColor]];
    }
    return _translucentView;
}

- (UIView *)scanningView
{
    if (_scanningView == nil) {
        CGSize screen = [[UIScreen mainScreen] bounds].size;
        CGFloat width = kQRViewSizeWidth * (GLQRScreenWidth / 320);

        CGFloat px = (screen.width - width) / 2 + 1;
        CGFloat py = (GLQRScreenHeight - 64 - width) / 2 + 64 + 1;

        _scanningView = [[UIView alloc] initWithFrame:CGRectMake(px, py, width - 2, 1)];
        [_scanningView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"scan_redline"]]];
    }
    return _scanningView;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (_previewLayer == nil) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];

        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        if (input) {
            _output = [[AVCaptureMetadataOutput alloc] init];
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            if ([_session canAddInput:input])
                [_session addInput:input];
            if ([_session canAddOutput:_output])
                [_session addOutput:_output];
            _output.metadataObjectTypes = @[ AVMetadataObjectTypeUPCECode,
                                             AVMetadataObjectTypeEAN13Code,
                                             AVMetadataObjectTypeEAN8Code,
                                             AVMetadataObjectTypeCode128Code,
                                             AVMetadataObjectTypeQRCode ];
        }
        else {
            //处理错误信息
            if (error.code == AVErrorApplicationIsNotAuthorizedToUseDevice) { //没有用户使用权限
                [self alertNoAuthorizedToUseDevice];
            }
            else if (error.code == AVErrorDeviceNotConnected) { //没有相机功能不能进行录制问题
                [self alertDeviceNotConnected];
            }
            return nil;
        }
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    }
    return _previewLayer;
}

- (void)alertNoAuthorizedToUseDevice
{
    @weakify(self);
    [UIAlertView bk_showAlertViewWithTitle:@"1药城没有权限访问您的相机" message:@"请进入\"设置>隐私>相机\"开启摄像头权限" cancelButtonTitle:@"知道了" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        @strongify(self);
        [self callbackWithValue:nil];
    }];
}

- (void)alertDeviceNotConnected
{
    @weakify(self);
    [UIAlertView bk_showAlertViewWithTitle:@"扫描无法使用" message:@"本设备不支持扫描" cancelButtonTitle:@"知道了" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        @strongify(self);
        [self callbackWithValue:nil];
    }];
}

@end
