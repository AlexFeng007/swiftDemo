//
//  CartStepper.h
//  FKY
//
//  Created by yangyouyong on 2016/9/9.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//  (购物车)购物车数字输入框

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ProductNumAddClickType,               // 加数量
    ProductNumMinusClickType,             // 减数量
    ProductNumChangeClickType             // 直接修改数量
} CartProductNumClickType;


@interface CartStepper : UIView

@property (nonatomic, strong) UITextField *countLabel;      // 输入框
@property (nonatomic, assign, readonly) NSInteger nowCount;
@property (nonatomic, assign) BOOL isFixedCombo; // 判断当前数字输入框是否用于固定套餐的套餐数量的修改
@property (nonatomic, assign) BOOL isDapeiCombo; // 判断当前数字输入框是否用于搭配套餐的套餐数量的修改
@property (nonatomic, assign) BOOL isSinglePackageRate; //判断是否是单品包邮
@property (nonatomic, strong) UIButton *addBtn;             // 加
@property (nonatomic, strong) UIButton *minusBtn;           // 减

@property (nonatomic, copy) void(^toastBlock)(NSString *string);
@property (nonatomic, copy) void(^addBlock)(void);
@property (nonatomic, copy) void(^numChangedBlock)(void);
@property (nonatomic, copy) void(^updateProductBlock)(NSInteger count,NSInteger typeIndex); //typeIndex加车类型，1表示立即发请求，2表示数量增加不请求，有动画 3表示数量减少不请求，无动画
@property (nonatomic, copy) void(^changeActionBlock)(CartProductNumClickType type);
@property (nonatomic, copy) void(^clickCountLabel)(NSInteger count);//点击计数器编辑框
@property (nonatomic, strong) UIView *bgView;                   // 背景视图
/**
 *  @brief   设置数量输入控件
 *
 *  @param baseCount   起订量（门槛）
 *  @param stepCount   最小拆零包装（步长）
 *  @param stockCount   库存（最大可加车数量）
 *  @param quantity   当前展示(已加车)的数量
 *  @param isTJ   是否是特价商品
 *  @param minCount   限购商品最低数量
 */
- (void)configStepperBaseCount:(NSInteger)baseCount
                     stepCount:(NSInteger)stepCount
                    stockCount:(NSInteger)stockCount
                   limitBuyNum:(NSInteger)limitBuyNum
                      quantity:(NSInteger)quantity
                           and:(BOOL)isTJ
                           and:(NSInteger)minCount;

/**
 *  @brief   设置数量输入控件
 *
 *  @param baseCount   起订量（门槛）
 *  @param stepCount   最小拆零包装（步长）
 *  @param stockCount   库存（最大可加车数量）
 *  @param quantity   当前展示(已加车)的数量
 *  @param isTJ   是否是特价商品
 *  @param minCount   限购商品最低数量
 *  @param maxReason  最大的提示语
 *  @param minReason 最小提示语
 */
- (void)configStepperInfoBaseCount:(NSInteger)baseCount
                         stepCount:(NSInteger)stepCount
                        stockCount:(NSInteger)stockCount
                       limitBuyNum:(NSInteger)limitBuyNum
                          quantity:(NSInteger)quantity
                               and:(BOOL)isTJ
                               and:(NSInteger)minCount
                               and:(NSString *)maxReason
                               and:(NSString *)minReason;

//自动加数
- (void)addNumWithAuto;
- (void)cartUiUpdatePattern;
- (void)cartUiUpdateFixComboPattern;
- (void)comboPattern;
- (void)seckillPattern;
- (void)productDetailUiUpdatePattern;
- (void)changeViewPattern;
// 加车弹框加车器样式
- (void)productPopAddCarUiUpdatePattern;
-(void)togeterBuyDetailPattern;
-(void)oftenBuyPattern:(NSInteger)type;
- (void)resetCountLabelPattern;
- (void)resetcountLableValue:(NSInteger)num;
- (void)changeViewPatternWithSingle;
- (void)rcUiUpdatePattern;
//一起购
-(void)togeterBuyUIPattern;
//设置加车器不可点击
- (void)setStepperCanNotTip;
/**
 *  @brief   数量更改失败时重置到之前的数量
 */
- (void)resetStepperToLastCount;
//- (void)disableAddBtn;
//- (void)enableAddBtn;

- (void)setAddFlag:(BOOL)flag;

@end
