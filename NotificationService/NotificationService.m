//
//  NotificationService.m
//  NotificationService
//
//  Created by 油菜花 on 2020/7/30.
//  Copyright © 2020 yiyaowang. All rights reserved.
//

#import "NotificationService.h"
#import <GTExtensionSDK/GeTuiExtSdk.h>


@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    [GeTuiExtSdk handelNotificationServiceRequest:request withAttachmentsComplete:^(NSArray *attachments, NSArray *errors) {
        //注意：是否修改下发后的title内容以项目实际需求而定
        //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [需求而定]", self.bestAttemptContent.title];
        // 待展示推送的回调处理需要放到回执完成的回调中
        self.contentHandler(self.bestAttemptContent);
    }];
    
    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//
//    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
