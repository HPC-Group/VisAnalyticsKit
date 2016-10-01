//
//  VAKProvDelegationSpec.m
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 08.03.16.
//  Copyright 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKProvDelegation.h"


SpecBegin(VAKProvDelegation)

describe(@"VAKProvDelegation", ^{
    __block VAKProvDelegation *delegate;
    NSString *delegateId = @"testDelegate";
    NSString *responsibleId = @"testResponsible";
    NSString *activityId = @"testActivity";
    
    beforeAll(^{
        delegate = [[VAKProvDelegation alloc] init];
        delegate.id = @"testId";
        delegate.delegate = delegateId;
        delegate.activity = activityId;
        delegate.responsible = responsibleId;
    });
    
    it(@"can be instantiated from a dictionary", ^{
        NSDictionary<NSString *, id> *asObj = [delegate vak_objectAsDictionary];
        
        VAKProvDelegation *fromDict = [VAKProvDelegation
            createProvComponent:VAKProvDelegation.class
            withProperties:asObj
        ];
        
        expect(fromDict.delegate).to.equal(delegateId);
        expect(fromDict.responsible).to.equal(responsibleId);
        expect(fromDict.activity).to.equal(activityId);
    });
});

SpecEnd
