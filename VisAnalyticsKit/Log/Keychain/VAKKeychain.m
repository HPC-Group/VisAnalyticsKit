//
//  VAKKeyChain.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 05.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

// External
#import <Security/Security.h>

// Custom
#import "VAKKeyChain.h"
 
@implementation VAKKeychain
 
+ (instancetype)initWithService:(NSString *)service {
    VAKKeychain *keychain = [[VAKKeychain alloc] init];
    keychain.service = service;
    
    return keychain;
}

- (NSMutableDictionary*)prepareDict:(NSString *)key {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
   
    dict[(__bridge id) kSecClass] = (__bridge id) kSecClassGenericPassword;
 
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    dict[(__bridge id) kSecAttrGeneric] = encodedKey;
    dict[(__bridge id) kSecAttrAccount] = encodedKey;
    dict[(__bridge id) kSecAttrService] = _service;
    dict[(__bridge id) kSecAttrAccessible] = (__bridge id) kSecAttrAccessibleAlwaysThisDeviceOnly;

    return dict;
}

- (BOOL)create:(NSString *)key data:(NSData *)data {
    NSMutableDictionary *dict = [self prepareDict:key];
    
    dict[(__bridge id) kSecValueData] = data;
 
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
    if (errSecSuccess != status) {
        NSLog(@"Unable to create key:%@, error:%d", key, (int) status);
    }
    
    return (errSecSuccess == status);
}

- (NSData *)read:(NSString *)key {
    NSMutableDictionary *dict = [self prepareDict:key];
    dict[(__bridge id) kSecMatchLimit] = (__bridge id) kSecMatchLimitOne;
    dict[(__bridge id) kSecReturnData] = (id) kCFBooleanTrue;

    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)dict, &result);
 
    if (status != errSecSuccess) {
        NSLog(@"Unable to read key: %@, error:%d", key, (int) status);
        return nil;
    }
 
    return (__bridge NSData *)result;
}

- (NSString *)readAsString:(NSString *)key {
    NSData *readData = [self read:key];
    return [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
}
 
- (BOOL)update:(NSString *)key data:(NSData *) data {
    NSMutableDictionary *dictKey = [self prepareDict:key];
    NSMutableDictionary *dictUpdate = [[NSMutableDictionary alloc] init];
    
    dictUpdate[(__bridge id) kSecValueData] = data;
 
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)dictKey, (__bridge CFDictionaryRef)dictUpdate);

    if (errSecSuccess != status) {
        NSLog(@"Unable to update key: %@, error:%d", key, (int) status);
    }
    
    return errSecSuccess == status;
}

- (BOOL)remove:(NSString *)key {
    BOOL success = YES;
    NSMutableDictionary *dict = [self prepareDict:key];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dict);
    
    if (status != errSecSuccess) {
        NSLog(@"Unable to remove item for key %@ with error:%d", key, (int) status);
        success = NO;
    }
    
    return success;
}

@end
