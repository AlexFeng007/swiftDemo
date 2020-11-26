//
//  FKYSearchBar.h
//  FKY
//
//  Created by yangyouyong on 15/9/8.
//  Copyright (c) 2015年 yiyaowang. All rights reserved.
//  搜索界面之顶部搜索框

#import <UIKit/UIKit.h>
@class FKYSearchBar;


@protocol FKYSearchBarDelegate <NSObject>

@optional
- (void)searchBar:(FKYSearchBar *)searchBar textDidChange:(NSString *)searchText;
- (void)searchBar:(FKYSearchBar *)searchBar textDidEndEditing:(NSString *)searchText;
- (void)searchBar:(FKYSearchBar *)searchBar textFieldDidBeginEditing:(NSString *)searchText;
- (void)searchBar:(FKYSearchBar *)searchBar textFieldidChangingText:(NSString *)searchText;
- (void)searchBarSearchButtonClicked:(FKYSearchBar *)searchBar;
- (void)searchBarTextClear;

@end


typedef NS_ENUM(NSUInteger, LeftIconStyle) {
    LeftIconStyle_TypeList = 1,
    LeftIconStyle_SearchIcon,
    LeftIconStyle_SearchIconNone,
};


@interface FKYSearchBar : UIView
/// 搜索事件
@property (nonatomic,copy,class,readonly)NSString *searchAction;
@property (nonatomic, assign) LeftIconStyle leftIconSyle;
@property (nonatomic, strong, setter=setLeftIconName:) NSString *leftIconName;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, copy) void (^selectedSearchType)(void);

@property (nonatomic, weak) id<FKYSearchBarDelegate> delegate;
@property (nonatomic, copy) void(^inputVoiceAction)(void);

- (instancetype)initWithLeftIconType:(LeftIconStyle)leftIconStyle;
- (void)setLeftIconName:(NSString *)tile;
- (void)placeholderChange:(NSString *)text;
- (void)newUIStyleLayout;
- (void)setupView;
@end

