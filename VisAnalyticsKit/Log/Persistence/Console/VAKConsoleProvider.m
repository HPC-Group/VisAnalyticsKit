//
//  VAKConsoleProvider.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 15.02.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import <VisAnalyticsKit/VisAnalyticsKit.h>
#import "NSString+ReadableLevel.h"

@implementation VAKConsoleProvider

@synthesize storageType = _storageType;

// --

- (instancetype)init {
    if (self = [super init]) {
        _storageType = VAKStorageConsole;

        return self;
    }
    return nil;
}

#pragma mark Persistence Provider Interface

- (NSDictionary<NSString *, id> *)find:(NSString *)retrieveId objectType:(NSString *)type {
    // we can not retrieve data from the log, but to conform to the
    // protocol we need to return a dictionary
    return [NSDictionary dictionary];
}

- (NSArray * _Nonnull)findAllSessions:(NSUInteger)limit offset:(NSUInteger)offset {
    // @see find:retrieveId:objectType
    return @[];
}

- (NSNumber *)countSessions {
    return @0;
}

- (NSArray *_Nonnull)findStatesWithSession:(NSString *)sessionId limit:(NSUInteger)limit offset:(NSUInteger)offset {
    return @[];
}

- (BOOL)save:(NSString *)saveId dataToSave:(NSDictionary<NSString *, id> *)dataToSave {
    BOOL display = YES;

    if (dataToSave[kVAKStateTags]) {
        for (NSString *blacklisted in _tagsBlacklist) {
            for (NSString *tagged in dataToSave[kVAKStateTags]) {
                if ([blacklisted isEqualToString:tagged]) {
                    display = NO;
                    break;
                }
            }
        }
    }

    if (display) {
        printf("%s (%s);\n",
            [[self startFormat:@"Console" id:saveId data:dataToSave] cStringUsingEncoding:[NSString defaultCStringEncoding]],
            [[self dataToString:dataToSave] cStringUsingEncoding:[NSString defaultCStringEncoding]]
        );
    }

    return YES;
}

- (NSString *)startFormat:(NSString *)provider id:(NSString *)id data:(NSDictionary<NSString *, id> *)data {
    return [NSString stringWithFormat:@"- %@::%@",
        provider,
        [NSString vak_level:data[kVAKStateLogLevel]]
    ];
}

- (NSString *)dataToString:(NSDictionary<NSString *, id> *)data {
    NSMutableArray<NSString *> *values = [[NSMutableArray alloc] init];

    // this makes sure the timestamp is always upfront of the output
    if (data[kVAKStateTimestamp]) {
        [values insertObject:data[kVAKStateTimestamp] atIndex:0];
    }

    // check for session and return early
    if ([data[kVAKEntityType] isEqualToString:kVAKSessionType]) {
        [values insertObject:data[kVAKSessionStart] atIndex:0];
        NSString *sessionStr = [NSString stringWithFormat:@"Session >>%@<< started with id: %@",
            data[kVAKSessionAlias],
            data[kVAKEntityId]];
      
        if (data[kVAKSessionEnd]) {
          sessionStr = @"Session closed";
        }
      
        [values addObject:sessionStr];

        return [values componentsJoinedByString:@", "];
    }

    for (NSString *key in [data allKeys]) {
        BOOL hasFields = [_fieldsWhitelist count] > 0;
        BOOL keyInFields = [_fieldsWhitelist containsObject:key];

        if (key != kVAKProv) {
            if (hasFields && keyInFields) {
                [self specificOrder:data forKey:key toValues:values];

            } else if (key != kVAKStateLogLevel && !hasFields) {
                [self specificOrder:data forKey:key toValues:values];
            }

        } else {
            if ([_fieldsWhitelist containsObject:kVAKConfigConsoleShowHasProv]) {
                [values addObject:kVAKUseProvDefaultValue];
            }

            // prints out a state causer if information is present at first position
            NSDictionary *delAgent = data[kVAKProv][kVAKProvAgent][kVAKProvDelegatingSoftwareAgentLabel];
            if ([delAgent[kVAKStateCauser] isKindOfClass:NSDictionary.class]) {
                [values insertObject:[NSString stringWithFormat:@"[%@ %@]",
                                                                delAgent[kVAKStateCauser][kVAKCallerName],
                                                                delAgent[kVAKStateCauser][kVAKMethodCalled]
                ]            atIndex:1];
            }
        }
    };

    // always shows the data last
    if (data[kVAKStateData]) {
        [values addObject:[NSString stringWithFormat:@"%@:%@", kVAKStateData, [self inlineString:data selectedKey:kVAKStateData]]];
    }

    return [values componentsJoinedByString:@", "];
}

- (void)specificOrder:(NSDictionary *)data forKey:(NSString *)key toValues:(NSMutableArray *)values {
    if (key != kVAKStateData && key != kVAKStateTimestamp) {
        [values addObject:[NSString stringWithFormat:@"%@:%@", key, [self inlineString:data selectedKey:key]]];
    }
}

- (NSString *)inlineString:(NSDictionary<NSString *, id> *)data selectedKey:(NSString *)key {
    NSString *inlined = data[key];

    // adds the formatting ability
    if (key == kVAKStateData && [data[key] isKindOfClass:NSDictionary.class]) {
        NSDictionary *dataDict = data[key];

        if (dataDict[kVAKStateDataFormatter]) {
            id formatter = NSClassFromString(dataDict[kVAKStateDataFormatter]);
            BOOL isFormatter = [formatter conformsToProtocol:@protocol(VAKFormatterProtocol)];

            if (isFormatter) {
                if ([formatter respondsToSelector:@selector(vak_formatData:)]) {
                    return [formatter vak_formatData:dataDict];

                } else {
                    NSLog(@"-# VAKDebug: Formatter %@ is missing '+ (NSString *)vak_formatData:' selector!", dataDict[kVAKStateDataFormatter]);
                }
            }
        }
    }

    if ([data[key] isKindOfClass:NSArray.class]) {
        NSArray *tmpData = (NSArray *)data[key];
        NSMutableArray *chunks = [[NSMutableArray alloc] init];

        for (int i = 0; i < [tmpData count]; i++) {
            [chunks addObject:tmpData [(NSUInteger) i]];
        }

        inlined = [NSString stringWithFormat:@"[%@]", [chunks componentsJoinedByString:@", "]];
    }
    return inlined;
}

@end
