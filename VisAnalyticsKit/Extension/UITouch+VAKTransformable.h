//
//  UITouch+Transformable.h
//  VisAnalyticsKit
//
//  Created by VisAnalyticsKit on 09.04.16.
//  Copyright © 2016 VisAnalyticsKit. MIT
//

#import <UIKit/UIKit.h>

 /**
  *  Monkey patch the UIKit touch event, to be able to serialize it
  *  actually this should have implemented the transformableProtocol, but some how
  *  categories can not implement protocols
  */
@interface UITouch (VAKTransformable)

/**
 *  @see VAKTransformableProtocol
 *  serializes a uitouch to a NSDictionary to be able to save it to a persitent
 *  storage type
 *
 *  @return NSDictionary
 */
- (NSDictionary<NSString *, id> *)vak_objectAsDictionary;

/**
 *  @see VAKTransformableProtocol
 *  properties NSDictionary
 *
 *  @return UITouch
 */
- (instancetype)vak_createWithDictionary:(NSDictionary<NSString *, id> *)properties;

@end
