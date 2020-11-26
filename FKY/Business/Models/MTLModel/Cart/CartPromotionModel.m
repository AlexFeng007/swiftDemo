//
//  CartPromotionModel.m
//  FKY
//
//  Created by yangyouyong on 2017/1/5.
//  Copyright © 2017年 yiyaowang. All rights reserved.
//

#import "CartPromotionModel.h"
#import "CartPromotionRule.h"
#import "NSArray+Block.h"

@implementation CartPromotionModel

#pragma mark - Private

- (NSString *)getPromotionTypeDes
{
    NSString *text = @"";
    if (_promotionType.integerValue == 2) {
        text = @"单品满减：";
    }
    if (_promotionType.integerValue == 3) {
        text = @"多品满减：";
    }
    if (_promotionType.integerValue == 5 || _promotionType.integerValue == 7) {
        text = @"单品满赠：";
    }
    if (_promotionType.integerValue == 6 || _promotionType.integerValue == 8) {
        text = @"多品满赠：";
    }
    if (_promotionType.integerValue == 9) {
        text = @"单品换购：";
    }
    if (_promotionType.integerValue == 15) {
        text = @"单品满折：";
    }
    if (_promotionType.integerValue == 16) {
        text = @"多品满折：";
    }
    return text;
}

- (NSString *)showPromotionDesc:(BOOL)showLimit andUnit:(NSString *)unit promotionTypeDes:(NSString *)text
{
    __block NSString *promotionDes = @"";
    NSString *des = unit ? unit : @"盒";
    
    if (_promotionType.integerValue == 2 || _promotionType.integerValue == 3) {
        // 单品满减 or 多品满减
        [_productPromotionRules each:^(CartPromotionRule *object) {
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }
            else {
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            if (self.promotionMethod.integerValue == 0) {
                // 减多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"减%@元;",object.promotionMinu]];
            }
            else if (self.promotionMethod.integerValue == 1) {
                // 打多少折...<满折属于满减类型>
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"打%@折;",object.promotionMinu]];
            }
            else if (self.promotionMethod.integerValue == 2) {
                // 减多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"每个减%@元;",object.promotionMinu]];
            }
            
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
    }
    else if (self.promotionType.integerValue == 7 || self.promotionType.integerValue == 8) {
        // 单品满送积分 or 多品满送积分
        [_productPromotionRules each:^(CartPromotionRule *object) {
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }
            else {
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            if (self.promotionMethod.integerValue == 0) {
                // 送多少积分
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"送%@积分;",object.promotionMinu]];
            }
            else {
                // 送多少积分
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"每%@送%@积分;",des,object.promotionMinu]];
            }
            // 送多少积分
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
    }
    else if (_promotionType.integerValue == 5 || _promotionType.integerValue == 6) {
        // 单品满赠 or 多品满赠
        [_productPromotionRules each:^(CartPromotionRule *object) {
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }
            else {
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"送%@;",object.promotionMinu]];
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
    }
    else if (self.promotionType.integerValue == 9) {
        // 单品换购
        if (self.promotionPre.integerValue == 0) {
            // 满多少元
            for (CartPromotionRule *rule in _productPromotionRules) {
                NSString *strPromotion = [NSString stringWithFormat:@"满%.2f元可换购%@;", [rule.promotionSum floatValue],[(NSArray *)[rule.productPromotionChange valueForKey:@"shortName"] componentsJoinedByString:@"、"]];
                promotionDes = [promotionDes stringByAppendingString:strPromotion];
            }
        }
        else {
            // 满多少件
            for (CartPromotionRule *rule in _productPromotionRules) {
                NSString *strPromotion = [NSString stringWithFormat:@"满%zi%@可换购%@;", [rule.promotionSum integerValue], unit, [(NSArray *)[rule.productPromotionChange valueForKey:@"shortName"] componentsJoinedByString:@"、"]];
                promotionDes = [promotionDes stringByAppendingString:strPromotion];
            }
        }
    }
    else if (_promotionType.integerValue == 15 || _promotionType.integerValue == 16) {
        // 单品满折 or 多品满折
        [_productPromotionRules each:^(CartPromotionRule *object) {
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }
            else {
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            
            if (self.promotionMethod.integerValue == 0) {
                // 减多少元...<error>
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"减%@元;",object.promotionMinu]];
            }
            else if (self.promotionMethod.integerValue == 1) {
                // 打多少折...<当满折时，只可能返回1>
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"打%@折;",object.promotionMinu]];
            }
            else if (self.promotionMethod.integerValue == 2) {
                // 减多少元...<error>
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"每个减%@元;",object.promotionMinu]];
            }
            
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
    }
    else {
        if (self.productPromotionRules.count > 0) {
            return [NSString stringWithFormat:@"%@",[_productPromotionRules.firstObject promotionMinu]];
        }
    }
    
    NSString *limit = nil;
    if (_limitNum  && _limitNum.integerValue > 0) {
        limit = [NSString stringWithFormat:@"每个用户限参与%@次", _limitNum];
    }
    else {
        limit = @"";
    }
    NSString *result = [NSString stringWithFormat:@"%@%@%@", text, promotionDes, limit];
    return result;
}

#pragma mark - <MTLJSONSerializing>

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    
    if ([key isEqualToString:NSStringFromSelector(@selector(productPromotionRules))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CartPromotionRule class]];
    }
    return nil;
}

#pragma mark - Getter

- (NSString *)promotionDescription
{
    return [self showPromotionDesc:true andUnit:_unit promotionTypeDes:[self getPromotionTypeDes]];
}

#pragma mark - Public

- (NSString *)promotionDescriptionWithoutPromotionType
{
    
    return [self showPromotionDesc:true andUnit:_unit promotionTypeDes:@""];
}

- (NSString *)promotionDescWithUnit:(NSString *)unit
{
    return [self showPromotionDesc:true andUnit:unit promotionTypeDes:[self getPromotionTypeDes]];
}

@end
