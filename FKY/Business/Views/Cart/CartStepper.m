//
//  CartStepper.m
//  FKY
//
//  Created by yangyouyong on 2016/9/9.
//  Copyright © 2016年 yiyaowang. All rights reserved.
//

#import "CartStepper.h"
#import "NSString+FKYKit.h"


@interface CartStepper () <UITextFieldDelegate>



@property (nonatomic, assign) NSInteger baseCount;              // (门槛)起订量
@property (nonatomic, assign) NSInteger stepCount;              // 步长(最小拆零包装)...<每加、减一次的数量>
@property (nonatomic, assign) NSInteger stockCount;             // 库存...<最大可加车数量>
@property (nonatomic, assign) NSInteger limitBuyNum;            // 当周限购数量
@property (nonatomic, assign) NSInteger minCount;               // 限购加最小车数
@property (nonatomic, assign, readwrite) NSInteger nowCount;    // 当前加车数量
@property (nonatomic, assign, readwrite) NSInteger jlCount;    // 记录初始化时当前数量
@property (nonatomic, assign) Boolean   isAddBt;                // 点击类型yes代表非减号操作
@property (nonatomic, assign) Boolean   isRturn;                // 点击类型
@property (nonatomic, assign) Boolean   isTJ;                   // 是否特价
@property (nonatomic, assign) NSInteger lastCount;              // 保存上一个count，用于接口校验失败后回退
@property (nonatomic, assign) Boolean   isOtherAdd;             // 弹出框加减器
@property (nonatomic, assign) Boolean   isAtuoOtherAdd;         // 自动textfiled聚焦不需要初始化lastCount
@property (nonatomic, assign) Boolean   isCartNewUI;            // 判断是否是新版购物车ui(判断加减按钮到0或者超过最大数量是否能点击)
@property (nonatomic, assign) Boolean   isStepperEnable;            // 判断加车器 是否需要置为不可点 no 则加大最大不可编辑 yes 加到最大可以编辑
@property (nonatomic, assign) Boolean   isRCStepper;
@property (nonatomic, assign) Boolean   isComboStepper;      //yes代表是固定套餐加车
@property (nonatomic, assign) Boolean isNotJHD;                 // 不是购物车的计数器
@property (nonatomic, copy)   NSString *outMaxReason;           // 超出最大可售数量，最多只能购买9999
@property (nonatomic, copy)   NSString *lessMinReson;           // 该普通商品最小起批量为1
@property (nonatomic,assign) Boolean isNotResetAdd;             // 不重新设置加减按钮为整个布局的宽度的1/4（默认为no）
@property (nonatomic,strong) NSTimer *delayTime;//延迟加车

@property (nonatomic,assign)Boolean isNotDelayAddCar; //ture 不需要延迟加车 默认false需要
@end


@implementation CartStepper

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if (self.addBtn != nil) return self;
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.addBtn != nil) {
        if (self.isNotResetAdd) {
            return;
        }
        if(self.isNotJHD){
            [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(self.frame.size.width / 4.0));
            }];
            [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(self.frame.size.width / 4.0));
            }];
        }
    }
    else {
        [self setupView];
    }
    
}

- (void)setupView
{
    _isStepperEnable = NO;
    
    self.bgView = ({
        UIView *iv = [UIView new];
        [self addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        iv.layer.borderWidth = 1;
        iv.layer.borderColor = UIColorFromRGB(0xd5d9da).CGColor;
        iv.layer.cornerRadius = 4;
        iv.layer.masksToBounds = true;
        iv;
    });
    
    UIButton *addBottomButton = [UIButton new];
    [self.bgView addSubview:addBottomButton];
    
    UIButton *minnusBottomButtom = [UIButton new];
    [self.bgView addSubview:minnusBottomButtom];
    
    self.addBtn = ({
        UIButton *btn = [UIButton new];
        [self.bgView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"icon_jia"] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:@"icon_jia_gray"] forState:UIControlStateDisabled];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self.bgView);
            make.width.equalTo(@(FKYWH(70)/4));
            //make.width.equalTo(@(FKYWH(26)));
        }];
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            safeBlock(self.changeActionBlock,ProductNumAddClickType);
            safeBlock(self.addBlock);
            
            if(self.isCartNewUI && self.isStepperEnable == NO){
                [self.minusBtn setEnabled:YES];
            }
            
            if(self.isOtherAdd == false){
                [self.countLabel endEditing:true];
            }
            self.lastCount = self.nowCount;
            if (self.nowCount == 0 && self.isTJ && self.minCount > 0) {
                //详情特价第一次加车
                self.nowCount = self.minCount;
            }else {
                if (self->_isFixedCombo) {
                    if (self.nowCount + self.stepCount<= self.stockCount) {
                        if (self.limitBuyNum > 0) {
                            if (self.nowCount + self.stepCount<=self.limitBuyNum) {
                                self.nowCount = self.nowCount + self.stepCount;
                            }
                        }else {
                            self.nowCount = self.nowCount + self.stepCount;
                        }
                    }else {
                        self.nowCount = self.nowCount + self.stepCount;
                    }
                }else{
                    self.nowCount = self.nowCount + self.stepCount;
                }
            }
            if (self.nowCount > 0 && self.isStepperEnable == NO) {
                self.minusBtn.enabled = true;
            }
            self.isAddBt = YES;
            [self updateCountLabelAndIsTextInPut:NO];
            if(self.isOtherAdd){
                //[self.countLabel becomeFirstResponder];
                self.isAtuoOtherAdd = YES;
            }
        }];
        // line
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xd5d9da);
        [btn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(btn);
            make.width.equalTo(@(1));
        }];
        btn;
    });
    
    self.minusBtn = ({
        UIButton *btn = [UIButton new];
        [self.bgView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"icon_jian"] forState:UIControlStateNormal];
        //[btn setImage:[UIImage imageNamed:@"icon_jian_gray"] forState:UIControlStateDisabled];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.bgView);
            make.width.equalTo(@(FKYWH(70)/4));
        }];
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            if (self.nowCount == 0) {
                return ;
            }
            if(self.isCartNewUI && self.isStepperEnable == NO){
                [self.addBtn setEnabled:YES];
            }
            
            safeBlock(self.changeActionBlock,ProductNumMinusClickType);
            if(self.isOtherAdd == false){
                [self.countLabel endEditing:true];
            }
            if (self.isStepperEnable == NO){
                [self.addBtn setEnabled:YES];
            }
            
            self.isAddBt = false;
            self.lastCount = self.nowCount;
            if (self.isTJ && self.nowCount <= self.minCount && self.minCount > 0 && self.isNotJHD) {
                //特价商品
                self.nowCount = 0; //self.nowCount - self.minCount;
            }else{
                self.nowCount = self.nowCount - self.stepCount;
            }
            if (self.nowCount==0) {
                
            }
            [self updateCountLabelAndIsTextInPut:NO];
            if(self.isOtherAdd){
                //[self.countLabel becomeFirstResponder];
                self.isAtuoOtherAdd = YES;
            }
        }];
        // line
        UIView *line = [UIView new];
        line.backgroundColor = UIColorFromRGB(0xd5d9da);
        [btn addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(btn);
            make.width.equalTo(@(1));
        }];
        btn;
    });
    [addBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addBtn.mas_top);
        make.left.equalTo(self.addBtn.mas_left);
        make.right.equalTo(self.addBtn.mas_right);
        make.bottom.equalTo(self.addBtn.mas_bottom);
    }];
    [minnusBottomButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.minusBtn.mas_top);
        make.left.equalTo(self.minusBtn.mas_left);
        make.right.equalTo(self.minusBtn.mas_right);
        make.bottom.equalTo(self.minusBtn.mas_bottom);
    }];
    self.countLabel = ({
        UITextField *tf = [UITextField new];
        tf.textAlignment = NSTextAlignmentCenter;
        tf.font = FKYSystemFont(FKYWH(13));
        tf.textColor = UIColorFromRGB(0x666666);
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.delegate = self;
//        [tf addTarget:self action:@selector(inputTextChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.bgView addSubview:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.minusBtn.mas_right);
            make.right.equalTo(self.addBtn.mas_left);
        }];
        tf;
    });
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *inputCount = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([inputCount isPureInteger]) {
        
        NSInteger intCount = inputCount.integerValue;
        // 整数倍
        if ((intCount % self.stepCount) != 0) {
            intCount = intCount - (intCount % self.stepCount) + self.stepCount;;
        }
        NSInteger maxNum ;
        if (self.limitBuyNum > 0) {
            if (self.stockCount < self.limitBuyNum) {
                //库存小于限购数量
                maxNum = self.stockCount;
            }else {
                maxNum = self.limitBuyNum;
            }
        }else {
            maxNum = self.stockCount;
        }
        // 过大
        if (intCount > maxNum && maxNum > 0) {
            textField.text = [NSString stringWithFormat:@"%lu",(long)(maxNum-(maxNum % self.stepCount))];
            if (self.isNotJHD) {
                NSString *tip;
                if (maxNum < self.stepCount) {
                    tip = [NSString stringWithFormat:@"超出最大可售数量，最多只能买%lu",(long)maxNum];
                }else {
                    tip = [NSString stringWithFormat:@"超出最大可售数量，最多只能买%lu",(long)(maxNum-(maxNum % self.stepCount))];
                }
                if(self.isCartNewUI && self.isStepperEnable == NO){
                    [self.addBtn setEnabled:NO];
                }
                
                if(self.outMaxReason){
                    safeBlock(self.toastBlock,self.outMaxReason);
                }else{
                    safeBlock(self.toastBlock,tip);
                }
            }
            if (self.isNotJHD) {
                
            }else{
                [textField resignFirstResponder];
            }
            [self textChange:textField.text.integerValue];
            return NO;
        }
        [self textChange:intCount];
    }else {
        [self textChange:textField.text.integerValue];
        return NO;
    }
    return YES;
    
}
//商品详情弹出去的加车器
- (void)textChange:(NSInteger )intCount{
    //商品详情中加车弹起框
    if(self.isOtherAdd && self.isNotJHD){
        if (self.nowCount != intCount) {
            self.lastCount = self.nowCount;
            self.nowCount = intCount;
            safeBlock(self.numChangedBlock);
        }
        if(self.isCartNewUI){
            NSInteger maxNum ;
            if (self.limitBuyNum > 0) {
                if (self.stockCount < self.limitBuyNum) {
                    //库存小于限购数量
                    maxNum = self.stockCount;
                }else {
                    maxNum = self.limitBuyNum;
                }
            }else {
                maxNum = self.stockCount;
            }
            if (self.isStepperEnable == NO){
                if (intCount < maxNum) {
                    [self.addBtn setEnabled:true];
                }
                if (intCount > 0) {
                    [self.minusBtn setEnabled:true];
                }else{
                    [self.minusBtn setEnabled:false];
                }
            }
            
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.nowCount = [textField.text integerValue];
    [textField endEditing:true];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //输入数据改变时触发判断
    if (self.lastCount != [textField.text integerValue]) {
        self.lastCount = self.nowCount;
        self.nowCount = [textField.text integerValue];
        self.isAddBt = YES;
        [self updateCountLabelAndIsTextInPut:YES];
        safeBlock(self.numChangedBlock);
    }
}
//- (void)inputTextChanged:(UITextField *)textField
//{
//    //输入数据改变时触发判断
//    //非购物车
////    if (self.lastCount != [textField.text integerValue] && self.isNotJHD) {
////        self.lastCount = self.nowCount;
////        self.nowCount = [textField.text integerValue];
////        self.isAddBt = YES;
////        [self updateCountLabelAndIsTextInPut:YES];
////        safeBlock(self.numChangedBlock);
////    }
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.isAtuoOtherAdd) {
        self.lastCount = self.nowCount;
    }else{
        self.isAtuoOtherAdd = false;
    }
    safeBlock(self.changeActionBlock,ProductNumChangeClickType);
    return YES;
}

#pragma mark - Public

- (void)configStepperBaseCount:(NSInteger)baseCount
                     stepCount:(NSInteger)stepCount
                    stockCount:(NSInteger)stockCount
                   limitBuyNum:(NSInteger)limitBuyNum
                      quantity:(NSInteger)quantity
                           and:(BOOL)isTJ
                           and:(NSInteger)minCount
{
    // 为0时，重置为1
    if (stepCount == 0) {
        stepCount = 1;
    }
    
    //兼容部分代码加车时未去购物车中的数量导致最小起批数量与最小拆包不整除的问题(进入商品详情中时，商品未加车，quantity为0时，不修复最小起批数量与最小拆包不整除的问题，列表界面quantity不会为0)
    if (quantity != 0 && quantity <= minCount && minCount%stepCount != 0) {
        quantity = (minCount/stepCount + 1)*stepCount;
    }
    
    self.countLabel.text = @(quantity).stringValue;
    self.nowCount = quantity;
    self.jlCount = quantity;
    self.baseCount = baseCount;
    self.stockCount = stockCount;
    self.limitBuyNum = limitBuyNum;
    self.minCount = minCount;
    self.isTJ = isTJ;
    self.stepCount = stepCount;
    
    //当最小起批数量不是最小拆包数量的整数倍的时候，动态向上取整
    if (self.minCount > 0 && self.minCount%self.stepCount != 0) {
        self.minCount = (self.minCount/self.stepCount + 1)*self.stepCount;
    }
    
    [self resetAddButtonEable];
}

- (void)configStepperInfoBaseCount:(NSInteger)baseCount
                         stepCount:(NSInteger)stepCount
                        stockCount:(NSInteger)stockCount
                       limitBuyNum:(NSInteger)limitBuyNum
                          quantity:(NSInteger)quantity
                               and:(BOOL)isTJ
                               and:(NSInteger)minCount
                               and:(NSString *)maxReason
                               and:(NSString *)minReason
{
    //兼容部分代码加车时未去购物车中的数量导致最小起批数量与最小拆包不整除的问题(进入商品详情中时，商品未加车，quantity为0时，不修复最小起批数量与最小拆包不整除的问题，列表界面quantity不会为0)
    if (quantity != 0 && quantity <= minCount && minCount%stepCount != 0) {
        quantity = (minCount/stepCount + 1)*stepCount;
    }
    _isStepperEnable = YES;
    self.countLabel.text = @(quantity).stringValue;
    self.nowCount = quantity;
    self.jlCount = quantity;
    self.baseCount = baseCount;
    self.stockCount = stockCount;
    self.limitBuyNum = limitBuyNum;
    self.minCount = minCount;
    self.isTJ = isTJ;
    if(stepCount == 0){
        self.stepCount = 1;
    }else{
        self.stepCount = stepCount;
    }
    if (self.nowCount == 0) {
        //
    }
    //购物车中//当最小起批数量不是最小拆包数量的整数倍的时候，动态向上取整
    if (self.minCount > 0 && self.minCount%self.stepCount != 0) {
        self.baseCount = (self.baseCount/self.stepCount + 1)*self.stepCount;
        self.minCount = (self.minCount/self.stepCount + 1)*self.stepCount;
    }
    [self resetAddButtonEable];
    self.outMaxReason = maxReason;
    self.lessMinReson = minReason;
}

- (void)resetAddButtonEable
{
    if(self.isNotJHD){
        if(self.isCartNewUI){
            if (_isStepperEnable == NO){
#pragma mark 判断最小多少不能点击减号《0或者最小起批数量》
                if (self.isSinglePackageRate == true){
                    //单品包邮价《单品包邮商品，只能减到最小起批数量》
                    if(self.nowCount <= self.minCount){
                        [self.minusBtn setEnabled:NO];
                    }else{
                        [self.minusBtn setEnabled:YES];
                    }
                }else {
                    //普通商品可以减到0
                    if(self.nowCount == 0){
                        [self.minusBtn setEnabled:NO];
                    }else{
                        [self.minusBtn setEnabled:YES];
                    }
                }
            }
            
            NSInteger maxNum ;
            if (self.limitBuyNum > 0) {
                if (self.stockCount < self.limitBuyNum) {
                    maxNum = self.stockCount;
                }else{
                    maxNum = self.limitBuyNum;
                }
            }else {
                maxNum = self.stockCount;
            }
            if (_isStepperEnable == NO){
                if(self.nowCount >= maxNum){
                    [self.addBtn setEnabled:NO];
                }else{
                    [self.addBtn setEnabled:YES];
                }
            }
            
        }
    }else{
        if(self.isCartNewUI && self.isStepperEnable == NO){
            if(self.nowCount <= self.baseCount){
                [self.minusBtn setEnabled:NO];
            }else{
                [self.minusBtn setEnabled:YES];
            }
            if(self.nowCount >= self.limitBuyNum){
                [self.addBtn setEnabled:NO];
            }else{
                [self.addBtn setEnabled:YES];
            }
        }
        
    }
}

- (void)resetStepperToLastCount
{
    self.nowCount = self.lastCount;
    self.countLabel.text = @(self.nowCount).stringValue;
    if (self.nowCount == 0) {
        //
    }
    [self resetAddButtonEable];
}


#pragma mark - Private

- (void)updateCountLabelAndIsTextInPut:(BOOL)isTextInPut
{
    self.isRturn = false;
    if (self.isNotJHD) {
        //非购物车
        [self firstOtherUpdateCountLabel:true textInPut:isTextInPut];
    }else{
        [self firstUpdateCountLabel:true textInPut:isTextInPut];
    }
    
    if (self.isRturn && !self.isAddBt ) {
        return;
    }
    if (self.isRCStepper == false && self.isComboStepper == false && self.isNotDelayAddCar == false ) {
        safeBlock(self.updateProductBlock,self.nowCount,self.nowCount > self.lastCount ? 2 : 3);
        if (self.delayTime != nil) {
            [self.delayTime invalidate];
            self.delayTime = nil;
        }
        self.delayTime = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(delayUpdateCount) userInfo:nil repeats:NO];
        [NSRunLoop.currentRunLoop addTimer:self.delayTime forMode:NSRunLoopCommonModes];
    }else{
        safeBlock(self.updateProductBlock,self.nowCount,1);
    }
    
}
- (void)delayUpdateCount{
    safeBlock(self.updateProductBlock,self.nowCount,1);
    [self.delayTime invalidate];
    self.delayTime = nil;
}
// 购物车的更新
- (void)firstUpdateCountLabel:(BOOL)showToast textInPut:(BOOL)isTextInPut
{
    // 步长
    if (!self.stepCount) {
        self.stepCount = 1;
    }
    //输入为0时初始化(如果是减号则不需要判断)
    if (self.isAddBt) {
        if (self.nowCount == 0) {
            self.nowCount = 1;
        }
    }
    
    // 整数倍
    if ((self.nowCount%self.stepCount) != 0 && isTextInPut) {
        self.nowCount = self.nowCount - (self.nowCount%self.stepCount) + self.stepCount;
    }
    
    NSInteger maxNum ;
    if (self.limitBuyNum > 0) {
        if (self.stockCount < self.limitBuyNum) {
            //库存小于限购数量
            maxNum = self.stockCount;
        }else {
            maxNum = self.limitBuyNum;
        }
    }else {
        maxNum = self.stockCount;
    }
    //    //手动输入数据后，导致可能会购买量超过库存
    //    if (self.nowCount > maxNum) {
    //        self.nowCount = self.nowCount - self.stepCount;
    //    }
    
    //非固定套餐
    // if (!_isFixedCombo) {
    //判断是否在库存内修改了产品数量
    if (self.nowCount > maxNum ) {
        if(self.isCartNewUI && _isStepperEnable == NO){
            [self.addBtn setEnabled:NO];
        }
        
        if (showToast) {
            if(self.outMaxReason){
                safeBlock(self.toastBlock,self.outMaxReason);
            }else{
                if (maxNum < self.stepCount) {
                    safeBlock(self.toastBlock,[NSString stringWithFormat:@"超出最大可售数量，最多只能买%lu",(long)maxNum]);
                }else{
                    safeBlock(self.toastBlock,[NSString stringWithFormat:@"超出最大可售数量，最多只能买%lu",(long)(maxNum-(maxNum % self.stepCount))]);
                }
            }
        }
        //防止用户第一次加入购物车后，刷新数据后，最大购买数量变小后，再次点击减少数量时，永远减不到最大购买数量
        if (self.lastCount > maxNum) {
            self.lastCount = maxNum;
        }
        self.nowCount = self.lastCount;
        self.isRturn = YES;
        self.isAddBt = false;
    }
    //  }
    
    // 过小
    if (self.nowCount < self.baseCount && self.baseCount > 0) {
        self.nowCount = self.baseCount;
        NSString *str = [NSString stringWithFormat:@"最小拆零包装为%@件",@(self.stepCount)];
        if (_isFixedCombo) {
            // 固定套餐
            str = [NSString stringWithFormat:@"固定套餐最小加车数量为%@",@(self.stepCount)];
        }else if (_isDapeiCombo){
            // 搭配套餐
            str = [NSString stringWithFormat:@"套餐最小起批量为%@",@(self.baseCount)];
        }
        if (showToast) {
            if(self.isCartNewUI && _isStepperEnable == NO){
                [self.minusBtn setEnabled:NO];
            }
            
            if(self.lessMinReson){
                safeBlock(self.toastBlock,self.lessMinReson);
            }else{
                safeBlock(self.toastBlock,str);
            }
        }
        self.isRturn = YES;
    }
    if (_isStepperEnable == NO){
        if (self.isRCStepper){
            if (self.nowCount == self.baseCount){
                [self.minusBtn setEnabled:NO];
            }else if(self.nowCount > self.baseCount){
                [self.minusBtn setEnabled:YES];
            }
            if (self.nowCount == maxNum){
                [self.addBtn setEnabled:NO];
            }else if (self.nowCount < maxNum){
                [self.addBtn setEnabled:YES];
            }
        }
    }
    
    // 当前数量
    self.countLabel.text = @(self.nowCount).stringValue;
}

// 其他界面的加车逻辑
- (void)firstOtherUpdateCountLabel:(BOOL)showToast textInPut:(BOOL)isTextInPut
{
    // 步长
    if (!self.stepCount) {
        self.stepCount = 1;
    }
    // 整数倍
    if ((self.nowCount%self.stepCount) != 0 && isTextInPut && self.nowCount != 0) {
        self.nowCount = self.nowCount - (self.nowCount%self.stepCount) + self.stepCount;
    }
    //单品包邮不能小于最小起批数量
    if (self.isSinglePackageRate == true){
        if (self.nowCount < self.minCount){
            self.nowCount = self.minCount;
        }
    }
    
    NSInteger maxNum ;
    if (self.limitBuyNum > 0) {
        if (self.stockCount < self.limitBuyNum) {
            maxNum = self.stockCount;
        }else{
            maxNum = self.limitBuyNum;
        }
    }else {
        maxNum = self.stockCount;
    }
    
    //判断是否在库存内修改了产品数量
    if ( self.nowCount > maxNum || maxNum == 0 ) {
        if(self.isCartNewUI && _isStepperEnable == NO){
            [self.addBtn setEnabled:NO];
        }
        
        if (showToast) {
            if(self.outMaxReason){
                safeBlock(self.toastBlock,self.outMaxReason);
            }else{
                if (maxNum < self.stepCount) {
                    safeBlock(self.toastBlock,[NSString stringWithFormat:@"超出最大可售数量，最多只能买%lu",(long)maxNum]);
                }else {
                    safeBlock(self.toastBlock,[NSString stringWithFormat:@"超出最大可售数量，最多只能买%lu",(long)(maxNum-(maxNum % self.stepCount))]);
                }
            }
        }
        //防止用户第一次加入购物车后，刷新数据后，最大购买数量变小后，再次点击减少数量时，永远减不到最大购买数量
        if (self.lastCount > maxNum) {
            self.lastCount = maxNum;
        }
        self.nowCount = self.lastCount;
        self.isRturn = YES;
        self.isAddBt = false;
    }else{
        if (self.nowCount == maxNum && self.addBtn.enabled == false ) {
            //通过输入框修改商品数量，超过最大数量 nowCount被设置为了最大数量，加车按钮被置灰,此情况不在重复设置加车按钮的颜色
        }else{
            if(self.isCartNewUI && _isStepperEnable == NO){
                [self.addBtn setEnabled:true];
            }
            
        }
    }
    
    
    // 过小
    //    if (self.nowCount < self.baseCount && self.baseCount > 0 && !self.isTJ) {
    //        self.nowCount = self.baseCount;
    //        NSString *str = [NSString stringWithFormat:@"最小拆零包装为%@件",@(self.stepCount)];
    //        if (_isFixedCombo) {
    //            // 固定套餐
    //            str = [NSString stringWithFormat:@"固定套餐最小加车数量为%@",@(self.stepCount)];
    //        }
    //        if (showToast) {
    //            safeBlock(self.toastBlock,str);
    //        }
    //        self.isRturn = YES;
    //    }
    
    // 当前数量
    self.countLabel.text = @(self.nowCount).stringValue;
    if (self.isCartNewUI && _isStepperEnable == NO) {
#pragma mark 判断最小多少不能点击减号《0或者最小起批数量》
        if (self.isSinglePackageRate == true){
            //单品包邮价《单品包邮商品，只能减到最小起批数量》
            if(self.nowCount <= self.minCount){
                [self.minusBtn setEnabled:NO];
            }else{
                [self.minusBtn setEnabled:YES];
            }
        }else {
            if (self.nowCount == 0) {
                [self.minusBtn setEnabled:NO];
            }else {
                [self.minusBtn setEnabled:true];
            }
        }
    }
    
}

// 点击大加号主动触发判断
- (void)addNumWithAuto
{
    safeBlock(self.changeActionBlock,ProductNumAddClickType);
    [self.countLabel endEditing:true];
    self.isAddBt = YES;
    self.lastCount = 0;
    self.nowCount = self.jlCount;
    [self updateCountLabelAndIsTextInPut:NO];
}

// 非购物车
- (void)changeViewPattern
{
    self.isNotJHD = YES;
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.bgView.layer.borderColor = UIColorFromRGB(0xFF2D5C).CGColor;
    self.addBtn.backgroundColor = UIColorFromRGB(0xFF2D5C);
    [self.addBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.minusBtn.backgroundColor = UIColorFromRGB(0xFF2D5C);
    [self.minusBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
}

// 商品详细页加车按钮
- (void)productDetailUiUpdatePattern
{
    _isCartNewUI = YES;
    self.isNotJHD = YES;
    self.countLabel.backgroundColor = UIColorFromRGB(0xffffff);
    self.countLabel.font = FKYBoldSystemFont(FKYWH(16));
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = FKYWH(4);
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    for (UIView *view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_new"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_new"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(26)));
    }];
    [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(26)));
    }];
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.minusBtn.mas_right).offset(FKYWH(10));
        make.right.equalTo(self.addBtn.mas_left).offset(FKYWH(-10));
    }];
}

- (void)rcUiUpdatePattern
{
    self.isRCStepper = YES;
}
// 加车弹框加车器样式
- (void)productPopAddCarUiUpdatePattern
{
    self.isNotDelayAddCar = true;
    self.isNotResetAdd = YES;
    _isCartNewUI = YES;
    self.isNotJHD = YES;
    self.countLabel.backgroundColor = UIColorFromRGB(0xF6F6F6);
    self.countLabel.font = FKYBoldSystemFont(FKYWH(16));
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = FKYWH(4);
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    for (UIView *view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_new"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_new"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right).offset(-FKYWH(30));
        make.width.equalTo(@(FKYWH(32)));
    }];
    [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.bgView.mas_left).offset(FKYWH(30));
        make.width.equalTo(@(FKYWH(32)));
    }];
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.minusBtn.mas_right).offset(FKYWH(29));
        make.right.equalTo(self.addBtn.mas_left).offset(FKYWH(-29));
    }];
}

// 一起购详情加车按钮
- (void)togeterBuyDetailPattern
{
    self.isNotResetAdd = YES;
    _isCartNewUI = YES;
    self.isNotJHD = YES;
    self.countLabel.backgroundColor = UIColorFromRGB(0xffffff);
    self.countLabel.font = FKYBoldSystemFont(FKYWH(16));
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = FKYWH(4);
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    for (UIView *view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_new"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_new"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.width.equalTo(@(FKYWH(30)));
    }];
    [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.width.equalTo(@(FKYWH(30)));
    }];
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.minusBtn.mas_right).offset(FKYWH(10));
        make.right.equalTo(self.addBtn.mas_left).offset(FKYWH(-10));
    }];
}

// 一起购中加车样式
- (void)togeterBuyUIPattern
{
    _isCartNewUI = YES;
    self.isNotJHD = YES;
    self.countLabel.backgroundColor = UIColorFromRGB(0xF6F6F6);
    self.countLabel.font = FKYBoldSystemFont(FKYWH(16));
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = FKYWH(4);
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    for (UIView *view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_new"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_new"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_disable_new"] forState:UIControlStateDisabled];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_disable_new"] forState:UIControlStateDisabled];
    self.minusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(36)));
    }];
    [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(36)));
    }];
    if(_isCartNewUI){
        self.addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.minusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.minusBtn.mas_right);
            make.right.equalTo(self.addBtn.mas_left);
        }];
    }
}

// 固定套餐样式
- (void)comboPattern
{
    self.isNotJHD = YES;
    _isCartNewUI = YES;
    self.isComboStepper = YES;
    self.isNotResetAdd = YES;
    
    self.countLabel.backgroundColor = UIColorFromRGB(0xF6F6F6);
    self.countLabel.font = FKYBoldSystemFont(FKYWH(16));
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = FKYWH(4);
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    for (UIView *view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_new"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_new"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_gray_new"] forState:UIControlStateDisabled];
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.right.equalTo(self.bgView.mas_right);
        make.width.equalTo(@(FKYWH(50)));
    }];
    [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.bgView.mas_left);
        make.width.equalTo(@(FKYWH(50)));
    }];
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.minusBtn.mas_right).offset(FKYWH(25));
        make.right.equalTo(self.addBtn.mas_left).offset(FKYWH(-25));
    }];
    
}

// 购物车新UI
- (void)cartUiUpdatePattern
{
    _isCartNewUI = YES;
    //self.backgroundColor = [UIColor redColor];
    self.countLabel.backgroundColor = UIColorFromRGB(0xF6F6F6);
    self.countLabel.font = FKYBoldSystemFont(FKYWH(16));
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = FKYWH(4);
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    for (UIView *view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_new"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_new"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_disable_new"] forState:UIControlStateDisabled];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_disable_new"] forState:UIControlStateDisabled];
    self.minusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(36)));
    }];
    [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(36)));
    }];
    if(_isCartNewUI){
        self.addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.minusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.minusBtn.mas_right);
            make.right.equalTo(self.addBtn.mas_left);
        }];
    }
}

- (void)seckillPattern
{
    _isCartNewUI = YES;
    self.isNotJHD = YES;
    //self.backgroundColor = [UIColor redColor];
    self.countLabel.backgroundColor = UIColorFromRGB(0xF6F6F6);
    self.countLabel.font = FKYBoldSystemFont(FKYWH(16));
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = FKYWH(4);
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    for (UIView *view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_new"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_new"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_disable_new"] forState:UIControlStateDisabled];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_disable_new"] forState:UIControlStateDisabled];
    self.minusBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(36)));
    }];
    [self.minusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bgView);
        make.width.equalTo(@(FKYWH(36)));
    }];
    if(_isCartNewUI){
        self.addBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.minusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.bgView);
            make.left.equalTo(self.minusBtn.mas_right);
            make.right.equalTo(self.addBtn.mas_left);
        }];
    }
}

// 固定套餐加车样式
- (void)cartUiUpdateFixComboPattern
{
    [self.countLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.minusBtn.mas_right).offset(FKYWH(29));
        make.right.equalTo(self.addBtn.mas_left).offset(FKYWH(-29));
    }];
}

// 常购清单样式(type : 1为全部商品样式，2为搜索，推荐药品中样式)
- (void)oftenBuyPattern:(NSInteger)type
{
    self.isNotJHD = YES;
    self.countLabel.textColor = UIColorFromRGB(0x333333);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.font = [UIFont boldSystemFontOfSize:FKYWH(13)];
    self.countLabel.backgroundColor = [UIColor clearColor];
    
    self.bgView.layer.borderColor = UIColorFromRGB(0xFF2D5C).CGColor;
    self.bgView.layer.borderWidth = 1;
    if (type == 1) {
        self.bgView.layer.cornerRadius = FKYWHWith2ptWH(11);
    }else {
        self.bgView.layer.cornerRadius = FKYWHWith2ptWH(13);
    }
    self.bgView.layer.masksToBounds = true;
    
    for (UIView * view in self.addBtn.subviews) {
        [view removeFromSuperview];
    }
    self.addBtn.backgroundColor = [UIColor clearColor];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_red_bold"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_jia_red_bold"] forState:UIControlStateDisabled];
    
    for (UIView * view in self.minusBtn.subviews) {
        [view removeFromSuperview];
    }
    self.minusBtn.backgroundColor = [UIColor clearColor];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_red_bold"] forState:UIControlStateNormal];
    [self.minusBtn setImage:[UIImage imageNamed:@"icon_jian_red_bold"] forState:UIControlStateDisabled];
    [self.countLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bgView);
        make.left.equalTo(self.minusBtn.mas_right);
        make.right.equalTo(self.addBtn.mas_left);
    }];
}

// 设置编辑框不可以编辑当可点击
- (void)resetCountLabelPattern
{
    UIButton *bt = [UIButton new];
    [bt addTarget:self action:@selector(tapCountLabel) forControlEvents:UIControlEventTouchUpInside];
    [self.countLabel addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.countLabel);
    }];
}

//
- (void)tapCountLabel
{
    if (self.clickCountLabel) {
        self.clickCountLabel(self.countLabel.text.integerValue);
    }
}

// 重置countlabel的值
- (void)resetcountLableValue:(NSInteger)num
{
    safeBlock(self.changeActionBlock,ProductNumAddClickType);
    self.isAddBt = YES;
    self.lastCount = self.nowCount;
    //特价商品重置时候，需要判断num值，不能比最小起批数量小
    if ( self.isTJ && self.minCount > 0 && num > 0 && num < self.minCount ) {
        //详情特价第一次加车
        self.nowCount = self.minCount;
    }else {
        self.nowCount = num;
    }
    [self updateCountLabelAndIsTextInPut:YES];
}

// 设置单独的弹起框
- (void)changeViewPatternWithSingle
{
    [self changeViewPattern];
    self.isOtherAdd = YES;
}

//

- (void)setAddFlag:(BOOL)flag
{
    //NDC_ADD_SELF_NOBJ(@selector(textChange), UITextFieldTextDidChangeNotification);
    self.isOtherAdd = YES;
    self.isNotDelayAddCar = true;
}

- (void)setStepperCanNotTip
{
    self.countLabel.text = @"0";
    self.countLabel.textColor = UIColorFromRGB(0x666666);
    [self.countLabel setEnabled:NO];
    if (_isStepperEnable == NO){
        [self.addBtn setEnabled:NO];
        [self.minusBtn setEnabled:NO];
    }
    
}


@end
