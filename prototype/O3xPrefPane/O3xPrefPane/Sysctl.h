//
//  Sysctl.h
//  O3xPrefPane
//
//  Created by brendon on 23/12/2015.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sysctl : NSObject

+(NSString*)stringValue: (NSString*)name;
+(unsigned long)ulongValue:(NSString*)name;

@end
