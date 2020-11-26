//
//  HJNetworkQuery.m
//  HJFramework
//
//  Created by bibibi on 15/7/20.
//  Copyright (c) 2014 HJ. All rights reserved.
//

#import "HJNetworkQuery.h"

static NSString * const kAFCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * AFPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

static NSString * AFPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string, NSStringEncoding encoding) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kAFCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@implementation HJQueryPair

- (id)initWithKey:(id)aKey value:(id)aValue
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.key = aKey;
    self.value = aValue;
    
    return self;
}

- (NSString *)URLEncodedStringWithEncoding:(NSStringEncoding)aStringEncoding
{
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return AFPercentEscapedQueryStringKeyFromStringWithEncoding([self.key description], aStringEncoding);
    } else {
        return [NSString stringWithFormat:@"%@=%@", AFPercentEscapedQueryStringKeyFromStringWithEncoding([self.key description], aStringEncoding), AFPercentEscapedQueryStringValueFromStringWithEncoding([self.value description], aStringEncoding)];
    }
}

- (NSString *)queryString
{
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return [self.key description].lowercaseString;
    } else {
        return [NSString stringWithFormat:@"%@=%@", [self.key description].lowercaseString, [self.value description]];
    }
}

- (NSComparisonResult)caseInsensitiveCompare:(HJQueryPair *)aQueryPair
{
    return [self.key caseInsensitiveCompare:aQueryPair.key];
}

@end

@implementation HJNetworkQuery

+ (NSString *)queryStringFromParameters:(NSDictionary *)aParameters
                               encoding:(NSStringEncoding)aStringEncoding
{
    NSMutableArray *mutablePairs = [NSMutableArray array];
    NSArray *queryPairs = [self queryPairsFromDictionary:aParameters];
    
    for (HJQueryPair *queryPair in queryPairs) {
        [mutablePairs addObject:[queryPair URLEncodedStringWithEncoding:aStringEncoding]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

+ (NSArray *)queryPairsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *mQueryPairs = [NSMutableArray array];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[sortDescriptor]]) {
        id nestedValue = [dictionary objectForKey:nestedKey];
        if (nestedValue) {
            if ([nestedValue isKindOfClass:[NSDictionary class]]) {
                NSString *jsonStr = [nestedValue yy_modelToJSONString];
                [mQueryPairs addObject:[[HJQueryPair alloc] initWithKey:nestedKey value:jsonStr]];
            } else if ([nestedValue isKindOfClass:[NSArray class]]) {
                NSString *jsonStr = [nestedValue yy_modelToJSONString];
                [mQueryPairs addObject:[[HJQueryPair alloc] initWithKey:nestedKey value:jsonStr]];
            } else if ([nestedValue isKindOfClass:[NSSet class]]) {
                //先转成array
                NSMutableArray *nestedArray = [NSMutableArray array];
                NSArray *sortedArray = [nestedValue sortedArrayUsingDescriptors:@[sortDescriptor]];
                for (id obj in sortedArray) {
                    [nestedArray addObject:obj];
                }
                
                NSString *jsonStr = [nestedArray yy_modelToJSONString];
                [mQueryPairs addObject:[[HJQueryPair alloc] initWithKey:nestedKey value:jsonStr]];
            } else {
                [mQueryPairs addObject:[[HJQueryPair alloc] initWithKey:nestedKey value:nestedValue]];
            }
        }
    }
    
    return mQueryPairs;
}

@end
