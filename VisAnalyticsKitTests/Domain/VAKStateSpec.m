//
//  VAKStateSpec.m
//  StateLogger
//
//  Created by VisAnalyticsKit on 24.10.15.
//  Copyright © 2015 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Tests
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

// Custom
#import "VAKState.h"

// --

static NSString *const testType = @"#test";

// --

SpecBegin(VAKState)

describe(@"VAKState", ^{
    
    it(@"is a model and as such has a type", ^{
        VAKState *state = [VAKState create];
        expect(state).to.beKindOf(VAKAbstractModel.class);
        expect(state.type).to.equal(kVAKStateType);
    });
    
    it(@"conforms to VAKStateProtocol", ^{
        VAKState *state = [VAKState create];
        
        expect(state).conformTo(@protocol(VAKStateProtocol));
    });
    
    it(@"has a start date and an id upon creation", ^{
        VAKState *state = [VAKState create];
        
        expect(state.timestamp).to.beKindOf(NSDate.class);
    });
    
    it(@"can be created by a dictionary", ^{
        VAKState *state = [VAKState vak_createWithDictionary:@{
                kVAKStateLogLevel : @(VAKLevelInfo),
                kVAKStateEnvironment : @(VAKAppEnvCustom)
        }];
        
        expect(state.type).to.equal(kVAKStateType);
        expect(state.level).to.equal(VAKLevelInfo);
        expect(state.environment).to.equal(VAKAppEnvCustom);
    });
    
    it(@"has a default log level of info", ^{
        VAKState *state = [VAKState vak_createWithDictionary:@{kVAKStateType : testType}];
        expect(state.level).to.equal(VAKLevelInfo);
    });
    
    it(@"can get a session id once",^{
        NSString *sessionId = @"sessionId";
        VAKState *state = [VAKState vak_createWithDictionary:@{kVAKStateSessionId : sessionId}];
        expect(state.sessionId).to.equal(sessionId);
        
        NSString *sessionId2 = @"sessionId-2";
        state.sessionId = sessionId2;
        expect(state.sessionId).to.equal(sessionId);
    });
    
    it(@"is possible to comment on a state", ^{
        NSString *comment = @"This is a test comment to convey semantics";
        VAKState *state = [VAKState vak_createWithDictionary:@{kVAKStateComment : comment}];
        
        expect(state.comment).to.equal(comment);
    });
  
    it(@"appends a special attribute to the id if set", ^{
        VAKState *state = [VAKState vak_createWithDictionary:@{
          kVAKStateComment:@"TEST",
          kVAKStateIDAttribute:@"t"
        }];
      
        NSDictionary *stateDict = [state vak_objectAsDictionary];
        state = [VAKState vak_createWithDictionary:stateDict];
        expect(state.entityId).to.contain(@"__t");
    });
    
});

// --

static NSString *const firstTag = @"#firstTag";
static NSString *const secondTag = @"#secondTag";
static NSString *const thirdTagThatsTheSameAsFirstTag = @"#firstTag";

// --

describe(@"Taggable State", ^{
    __block VAKState *state;
    
    beforeEach(^{
        state = [VAKState create];
    });
    
    it(@"conforms to the VAKTaggableProtocol", ^{
        expect(state).conformTo(@protocol(VAKTaggableProtocol));
    });
    
    it(@"can add a single tag", ^{
        [state addTag:firstTag];
        
        expect([state hasTag:firstTag]).to.beTruthy();
        expect([state hasTags]).to.beTruthy();
    });
    
    it(@"can add multiple tags at once", ^{
        [state addTags:@[firstTag, secondTag]];
        
        expect([state hasTag:firstTag]).to.beTruthy();
        expect([state hasTag:secondTag]).to.beTruthy();
    });
    
    it(@"won't add duplicates", ^{
        [state addTags:@[firstTag, thirdTagThatsTheSameAsFirstTag]];
        
        expect([state hasTag:firstTag]).to.beTruthy();
        expect([state.tags count]).to.equal(1);
    });
    
    it(@"can remove tags", ^{
        [state addTags:@[firstTag, secondTag]];
        BOOL success = [state removeTag:secondTag];
        expect(success).to.beTruthy();

        BOOL noSuccess = [state removeTag:secondTag];
        expect(noSuccess).to.beFalsy();
    });
    
    it(@"is possible to add tags in the configuration object", ^{
        VAKState *tmpState = [VAKState vak_createWithDictionary:@{
                kVAKStateLogLevel : @(VAKLevelInfo),
                kVAKStateTags : @[firstTag, secondTag]
        }];
        
        expect([tmpState hasTag:firstTag]).to.beTruthy();
        expect([tmpState hasTag:secondTag]).to.beTruthy();
        
    });
});

describe(@"state is transformable", ^{
    
    it(@"a state is also transformable", ^{
        expect(VAKState.class).conformTo(@protocol(VAKTransformableProtocol));
    });
    
    it(@"a state has a nsdictionary representation", ^{
        NSString *sessionId = @"test-session";
        
        VAKState *tmpState = [VAKState vak_createWithDictionary:@{
                kVAKStateLogLevel : @(VAKLevelInfo),
                kVAKStateTags : @[firstTag, secondTag],
                kVAKStateData : @"test data",
                kVAKStateSessionId : sessionId
        }];
        
       NSDictionary *stateDict = [tmpState vak_objectAsDictionary];
       
       expect(stateDict[kVAKStateSessionId]).to.equal(sessionId);

       if (stateDict[kVAKStateTags] && [stateDict[kVAKStateTags] isKindOfClass:NSArray.class]) {
           NSString *firstTagInObj = [stateDict[kVAKStateTags] firstObject];
           expect(firstTagInObj).to.equal(firstTag);
       }
    });

});

SpecEnd
