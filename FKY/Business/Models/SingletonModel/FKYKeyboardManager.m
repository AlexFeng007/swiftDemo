//
//  FKYKeyboardManager.m
//  FKY
//
//  Created by yangyouyong on 15/10/22.
//  Copyright © 2015年 yiyaowang. All rights reserved.
//

#import "FKYKeyboardManager.h"

@interface FKYKeyboardManager ()
{
    BOOL _keyboardDidAppear;
}
@end

@implementation FKYKeyboardManager

+ (FKYKeyboardManager *)defaultManager {
    static dispatch_once_t onceToken;
    static FKYKeyboardManager *staticInstance;
    
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    
    return staticInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(keyboardDidShow:)
                       name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self
                   selector:@selector(keyboardDidHide:)
                       name:UIKeyboardDidHideNotification object:nil];
    }
    _keyboardDidAppear = NO;
    return self;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    _keyboardDidAppear = YES;
    [self p_initilizeWithNotification:notification];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    _keyboardDidAppear = NO;
    [self p_initilizeWithNotification:notification];
}

- (void)p_initilizeWithNotification:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat keyboardHeight = keyboardSize.height;
    NSValue *animationDurationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    _keyboardAnimationDuration = animationDuration;
    _keyboardHeight = keyboardHeight;
}

- (BOOL)fky_keyboardDidAppear {
    return _keyboardDidAppear;
}

@end
