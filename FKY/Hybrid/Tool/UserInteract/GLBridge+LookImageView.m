//
//  GLBridge+LookImageView.m
//  FKY
//
//  Created by hui on 2019/8/12.
//  Copyright © 2019年 yiyaowang. All rights reserved.
//

#import "GLBridge+LookImageView.h"

//查看图片
@implementation GLBridge (LookImageView)
/**
 查看图片
 
 gl://lookPics?callid=11111&param={
 currentIndex:0//当前第一个图片
 picturesUrl:[
 "https",
 "https",
 "https"
 ]//图片链接数组
 }
 callback({
 "callid":11111,
 "errcode":0,
 "errmsg":"ok",
 })
 
 */
- (void)lookPics:(GLJsRequest *)request
{
    NSInteger currentIndex = (NSInteger)[request paramForKey:@"currentIndex"];
    NSArray<NSString *> *picUrls = [request paramForKey:@"picturesUrl"];
    NSMutableArray<UIImageView *> *picImageView = [NSMutableArray new];
    if (picUrls.count > 0) {
        UIImage *defalutImage = [[UIImageView new] imageWithColor:UIColorFromRGB(0xf4f4f4) :@"icon_home_placeholder_image_logo" :CGSizeMake(SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0)];
        for (int i = 0; i < picUrls.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setFrame:CGRectMake(SCREEN_WIDTH/4.0, SCREEN_HEIGHT/2.0-SCREEN_WIDTH/4.0, SCREEN_WIDTH/2.0, SCREEN_WIDTH/2.0)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:picUrls[i]] placeholderImage:defalutImage];
            [picImageView addObject:imageView];
        }
        XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
        //imageViewer.delegate = self;
        imageViewer.showPageControl = true;
        //imageViewer.userPageNumber = true;
        imageViewer.hideWhenOnlyOne = true;
        //imageViewer.showSaveBtn = true;
        //防止数组越界
        if (currentIndex > picUrls.count-1) {
            currentIndex = picUrls.count - 1;
        }
        [imageViewer showWithImageViews:picImageView selectedView:picImageView[currentIndex]];
    }
    [self sendOkRespToJSWithData:nil callbackid:request.callbackId];
}
@end
