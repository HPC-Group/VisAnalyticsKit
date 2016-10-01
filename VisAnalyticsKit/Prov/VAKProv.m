//
//  VAKProv.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 11.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <objc/runtime.h>

// Custom
#import "VAKProv.h"

#define _VAK_ADD_ISSET(dict, key, prop)                     \
    if ([prop isKindOfClass:VAKProvBase.class]) {           \
        dict[key] = [prop vak_objectAsDictionary];              \
    }

@implementation VAKProv

#pragma mark Overrides

+ (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties {
    VAKProv *prov = [[VAKProv alloc] init];
    //NSDictionary<NSString *, NSDictionary *> *props = properties[kVAKProvRootKey];
    
    [properties enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id obj, BOOL *stop) {
        // if the obj is an array we are checking the agents
        if ([key isEqualToString:kVAKProvAgent]) {
        
            for (NSString *agentType in [obj allKeys]) {
                Class typeClass = [agentType isEqualToString:kVAKProvDelegatingSoftwareAgentLabel]
                  ? VAKProvDelegatingSoftwareAgent.class
                  : VAKProvWritingSoftwareAgent.class;
              
                id provProp = [VAKProvBase createProvComponent:typeClass withProperties:@{agentType:obj[agentType]}];
                [prov setValue:provProp forKey:agentType];
            }
          
        } else if ([obj isKindOfClass:NSDictionary.class]) {
            [prov setValueFor:obj withKey:key];
        }
    }];
    return prov;
}

- (void)setValueFor:(id)obj withKey:(NSString *)key {
    objc_property_t prop = class_getProperty(self.class, key.UTF8String);
    const char *propType = property_getAttributes(prop);
            
    NSString *typeString = [NSString stringWithUTF8String:propType];
    NSArray *attributes = [typeString componentsSeparatedByString:@","];
    NSString *typeAttribute = attributes[0];

    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 3) {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
        Class typeClass = NSClassFromString(typeClassName);
                
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            id provProp = [VAKProvBase createProvComponent:typeClass withProperties:obj];
            [self setValue:provProp forKey:key];
        }
    }
}

- (NSDictionary<NSString *, id> *)vak_objectAsDictionary {
    NSMutableDictionary<NSString *, id> *dict = [[NSMutableDictionary alloc] init];

    _VAK_ADD_ISSET(dict, kVAKProvEntity, _entity);
    _VAK_ADD_ISSET(dict, kVAKProvActivity, _activity);
    _VAK_ADD_ISSET(dict, kVAKProvWasGeneratedBy, _wasGeneratedBy);
    _VAK_ADD_ISSET(dict, kVAKProvWasAttributedTo, _wasAttributedTo);
    _VAK_ADD_ISSET(dict, kVAKProvUsed, _used);
    _VAK_ADD_ISSET(dict, kVAKProvActedOnBehalfOf, _actedOnBehalfOf);
    _VAK_ADD_ISSET(dict, kVAKProvWasAssociatedWith, _wasAssociatedWith);
    _VAK_ADD_ISSET(dict, kVAKProvWasDerivedFrom, _wasDerivedFrom);

    // - kind of hackish
    NSString *delAgentId = _delegatingAgent.id;
    NSString *writAgentId = _writingAgent.id;

    NSMutableDictionary *agentsDict = [NSMutableDictionary dictionaryWithDictionary:@{
            delAgentId:@"override",
            writAgentId:@"override",
    }];

    [agentsDict addEntriesFromDictionary:[_delegatingAgent vak_objectAsDictionary]];
    [agentsDict addEntriesFromDictionary:[_writingAgent vak_objectAsDictionary]];

    dict[kVAKProvAgent] = agentsDict;
    dict[kVAKProvPrefix] = @{
      @"default":@"http://example.com/default"
    };

    return dict;
}

@end
