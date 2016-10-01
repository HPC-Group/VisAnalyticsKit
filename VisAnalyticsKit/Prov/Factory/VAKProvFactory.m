//
//  ProvFactory.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 22.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import "VAKProvFactory.h"
#import "VAKMacros.h"

@implementation VAKProvFactory

+ (VAKProv *)createComponents:(VAKProv *)prov {
    NSString *salt = [self.class vak_shortId];

    prov.delegatingAgent = [[VAKProvDelegatingSoftwareAgent alloc] initWithDefaults];
    [prov.delegatingAgent setScreenInfo];
    [prov.delegatingAgent setCauser:prov.causer];
    
    prov.writingAgent = [[VAKProvWritingSoftwareAgent alloc] initWithDefaults];
    prov.activity = [[VAKProvActivity alloc] initWithDefaults];
    
    // Relations
    NSDictionary *entityActivityTime = @{
        kVAKProvEntity:prov.entity,
        kVAKProvActivity:prov.activity,
        kVAKProvTimePrefixed:prov.activity.start
    };
  
    NSString *genId = VAK_ID(@"%@%s%@", @"_:gen", kVAKProvDelimiter, salt);
    prov.wasGeneratedBy = [VAKProvGeneration
        createProvComponent:VAKProvGeneration.class
        withProperties:@{ genId:entityActivityTime }
    ];
  
    NSString *attrId = VAK_ID(@"%@%s%@", @"_:wAT", kVAKProvDelimiter, salt);
    prov.wasAttributedTo = [VAKProvAttribution
        createProvComponent:VAKProvAttribution.class
        withProperties:@{
            attrId:@{
                kVAKProvEntity:prov.entity,
                kVAKProvAgent:prov.delegatingAgent
            }
        }
    ];
  
    NSString *usedId = VAK_ID(@"%@%s%@", @"_:wUB", kVAKProvDelimiter, salt);
    prov.used = [VAKProvUsage createProvComponent:VAKProvUsage.class
        withProperties:@{ usedId:entityActivityTime }
    ];
  
    NSString *delId = VAK_ID(@"%@%s%@", @"_:aOB", kVAKProvDelimiter, salt);
    prov.actedOnBehalfOf = [VAKProvDelegation
        createProvComponent:VAKProvDelegation.class
        withProperties:@{
            delId:@{
                kVAKProvDelegatePrefixed:prov.delegatingAgent,
                kVAKProvResponsiblePrefixed:prov.writingAgent,
                kVAKProvActivityPrefixed:prov.activity
            }
        }
    ];
  
    NSString *assocId = VAK_ID(@"%@%s%@", @"_:wAW", kVAKProvDelimiter, salt);
    prov.wasAssociatedWith = [VAKProvAssociation
        createProvComponent:VAKProvAssociation.class
        withProperties:@{
            assocId:@{
                kVAKProvActivityPrefixed:prov.activity,
                kVAKProvAgentPrefixed:prov.delegatingAgent
            }
        }
    ];
    
    prov.id = VAK_ID(@"provenance-%.f", [prov.activity.start timeIntervalSince1970]);
    
    return prov;
}

@end
