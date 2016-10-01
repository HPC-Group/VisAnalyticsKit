#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef VAKReplayViewHelper_h
#define VAKReplayViewHelper_h

/**
 * A helper function that transforms a hex value like #999999 into a UIColor object
 */
static UIColor *VAKUIColorFromHex(NSString *hex) {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hex];
  [scanner setScanLocation:1]; // bypass '#' character
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                         green:((rgbValue & 0xFF00) >> 8) / 255.0
                          blue:(rgbValue & 0xFF) / 255.0
                         alpha:1.0];
}

#endif /* VAKReplayViewHelper_h */
