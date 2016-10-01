//
//  VAKProvBase.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 07.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvBase.h"
#import "NSDate+VAKISOFormat.h"

@implementation VAKProvBase

+ (instancetype)createProvComponent:(Class)provClass withProperties:(NSDictionary<NSString *,id> *)properties {
    VAKProvBase *provComponent = [[provClass alloc] init];
    [provComponent enumeratingSetter:properties];
    
    return provComponent;
}

#pragma mark Transformable Protocol

+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
    VAKProvBase *provObj = [[VAKProvBase alloc] init];
    [provObj enumeratingSetter:properties];
    
    return provObj;
}

- (void)enumeratingSetter:(NSDictionary<NSString *, id> *)properties {
    NSString *separator = @":";
    NSDictionary *dictToUse = [self getInner:properties] ?: properties;

    [dictToUse enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        NSString *cleanKey = key;
        
        if ([key containsString:separator]) {
            cleanKey = [key componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:separator]][1];
        }
        
        if ([key isEqualToString:kVAKProvTimePrefixed] || [key isEqualToString:kVAKProvStart] || [key isEqualToString:kVAKProvEnd]) {
            if ([value isKindOfClass:NSString.class]) {
                value = [NSDate vak_dateFromIS08601:value];
            }
        }
        
        if ([value isKindOfClass:VAKProvBase.class]) {
            value = ((VAKProvBase *) value).id;
        }
        
        if ([self respondsToSelector:NSSelectorFromString(cleanKey)]) {
            [self setValue:value forKey:cleanKey];
            
        } else {
            [self addProp:_attributes forKey:key withProp:value];
        }
    }];
}

- (void)addProp:(NSMutableDictionary<NSString *, id> *)props forKey:(NSString *)key withProp:(id)prop {
    if (prop) {
        props[key] = prop;
    }
}

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSAssert(_id != nil, @"-- PROV: an id must have been set");
    
    NSMutableDictionary<NSString *, id> *inner = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [_attributes allKeys]) {
        inner[key] = _attributes[key];
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:@{ _id:inner }];
}

- (NSDictionary<NSString *, id> *)getInner:(NSDictionary<NSString *, NSDictionary<NSString *,id> *> *)dictionary {
    NSString *idString = _id;
    
    if (!idString) {
        idString = [[dictionary allKeys] firstObject];
        _id = idString;
    }
    
    return dictionary[idString];
}

#pragma mark base methods

- (instancetype)init {
    if (self = [super init]) {
        _attributes = [[NSMutableDictionary alloc] init];
        
        return self;
    }
    
    return nil;
}

- (void)setAttributesWithDictionary:(NSDictionary<NSString *, id> *)dictionary {
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id attribute, id value, BOOL *stop) {
        [self setAttribute:attribute value:value];
    }];
}

- (void)setAttribute:(NSString *)key value:(id)value {
    _attributes[key] = value;
}

- (BOOL)hasAttribute:(NSString *)attribute {
    return nil != _attributes[attribute];
}

- (id)getAttribute:(NSString *)attribute {
    id ret = nil;

    if ([self hasAttribute:attribute]) {
        ret = _attributes[attribute];
    }
    
    return ret;
}

@end
