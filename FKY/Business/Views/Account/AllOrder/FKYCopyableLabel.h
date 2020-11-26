//
//  HTCopyableLabel.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 2/6/13.
//  Copyright (c) 2013 Hotel Tonight. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FKYCopyableLabel;


@protocol HTCopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(FKYCopyableLabel *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(FKYCopyableLabel *)copyableLabel;

@end


@interface FKYCopyableLabel : UILabel

@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, weak) id<HTCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

// You may want to add longPressGestureRecognizer to a container view
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end
