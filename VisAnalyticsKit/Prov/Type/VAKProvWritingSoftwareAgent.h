//
//  VAKProvAgent.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 04.03.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <Foundation/Foundation.h>

// Custom
#import "VAKProvType.h"

 /**
  *  is a concrete software agent
  *  https://www.w3.org/TR/prov-dm/#concept-software-agent
  *
  *  this agent's only responsiblity is to safe provenance data and as such only acts
  *  on behalf of another agent.
  *  the agents attributes default to the state kit bundle name and version
  */
@interface VAKProvWritingSoftwareAgent : VAKProvType

/**
 *  inits the writing software agent with defaults
 *
 *  @return VAKProvWritingSoftwareAgent
 */
- (instancetype)initWithDefaults;

@end
