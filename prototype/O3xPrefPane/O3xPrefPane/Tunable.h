//
//  Tunable.h
//  O3xPrefPane
//
//  Created by brendon on 27/12/2015.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tunable : NSObject

@property NSString *desc;
@property NSString *sysctl;
@property NSString *value;

-(id)init;
-(id)initWithProperties:(NSString*)sysctl Description:(NSString*)description;

@end
