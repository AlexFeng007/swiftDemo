//
//  FKYPromationInfoModel.m
//  FKY
//
//  Created by 寒山 on 2018/7/18.
//  Copyright © 2018年 yiyaowang. All rights reserved.
//

#import "FKYPromationInfoModel.h"

@implementation FKYPromationInfoModel
// 数据解析
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(ruleList))]) {
        return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[CartPromotionRule class]];
    }
     
    return nil;
}
#pragma mark - Public
- (NSString *)promotionDescriptionWithoutPromotionType  {
    
    return (self.promationDescription != nil && self.promationDescription.length >0 )? self.promationDescription : [self showPromotionDesc:true andUnit:_unit promotionTypeDes:@""];
}

- (NSString *)showPromotionDesc: (BOOL)showLimit andUnit:(NSString *)unit promotionTypeDes:(NSString *)text {
    __block NSString *promotionDes = @"";
    NSString *des = unit ? unit : @"盒";
    
    if (_promotionType.integerValue == 2 || _promotionType.integerValue == 3) {
        // 满减
        [_ruleList each:^(CartPromotionRule *object) {
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }else{
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            if (self.method.integerValue == 0) {
                // 减多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",减%@元;",object.promotionMinu]];
            }else if (self.method.integerValue == 1){
                // 打多少折
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",打%@折;",object.promotionMinu]];
            }else if (self.method.integerValue == 2){
                // 减多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",每个减%@元;",object.promotionMinu]];
            }
            
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
        
    }else  if (_promotionType.integerValue == 15 || _promotionType.integerValue == 16) {
        // 满减
        [_ruleList each:^(CartPromotionRule *object) {
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }else{
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            if (self.method.integerValue == 0) {
                // 减多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",减%@元;",object.promotionMinu]];
            }else if (self.method.integerValue == 1){
                // 打多少折
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",打%@折;",object.promotionMinu]];
            }else if (self.method.integerValue == 2){
                // 减多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",每个减%@元;",object.promotionMinu]];
            }
            
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
        
    }else if(self.promotionType.integerValue == 7 || self.promotionType.integerValue == 8) {
        // 买送积分
        
        [_ruleList each:^(CartPromotionRule *object) {
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }else{
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            if (self.method.integerValue == 0) {
                // 送多少积分
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",赠%@积分;",object.promotionMinu]];
            }else{
                // 送多少积分
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",每%@赠%@积分;",des,object.promotionMinu]];
            }
            // 送多少积分
            //                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",赠%@积分;",object.promotionMinu]];
            
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
        
    }else if(_promotionType.integerValue == 5 || _promotionType.integerValue == 6){
        
        [_ruleList each:^(CartPromotionRule *object) {
            
            if (self.promotionPre.integerValue == 0) {
                // 满多少元
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@元",object.promotionSum]];
            }else{
                // 满多少件
                promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@"满%@%@",object.promotionSum,des]];
            }
            // 送多少积分
            promotionDes = [promotionDes stringByAppendingString:[NSString stringWithFormat:@",赠%@;",object.promotionMinu]];
            
            promotionDes = [promotionDes stringByAppendingString:@" "];
        }];
    }else if(self.promotionType.integerValue == 9){
        if (self.promotionPre.integerValue == 0) {
            // 满多少元
            for (CartPromotionRule *rule in _ruleList) {
                NSString *strPromotion = [NSString stringWithFormat:@"满%.2f元可换购%@;", [rule.promotionSum floatValue],[(NSArray *)[rule.productPromotionChange valueForKey:@"shortName"] componentsJoinedByString:@"、"]];
                promotionDes = [promotionDes stringByAppendingString:strPromotion];
            }
        }else{
            // 满多少件
            for (CartPromotionRule *rule in _ruleList) {
                NSString *strPromotion = [NSString stringWithFormat:@"满%zi%@可换购%@;", [rule.promotionSum integerValue], unit, [(NSArray *)[rule.productPromotionChange valueForKey:@"shortName"] componentsJoinedByString:@"、"]];
                promotionDes = [promotionDes stringByAppendingString:strPromotion];
            }
        }
    }else{
        if (self.ruleList.count > 0) {
            return [NSString stringWithFormat:@"%@",[_ruleList.firstObject promotionMinu]];
        }
    }
    NSString *limit =  nil;
    if (_limitNum  && _limitNum.integerValue > 0) {
        limit = [NSString stringWithFormat:@"每个用户限参与%@次",_limitNum];
    }else{
        limit = @"";
    }
    NSString *result = [NSString stringWithFormat:@"%@%@%@",text,promotionDes,limit];
    
    
    return result;
}

@end
