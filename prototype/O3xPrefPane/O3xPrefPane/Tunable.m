//
//  Tunable.m
//  O3xPrefPane
//
//  Created by brendon on 27/12/2015.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import "Tunable.h"

@implementation Tunable

-(id)init
{
    self = [super init];
    if (self) {
        _sysctl = @"";
        _value = @"";
        _desc = @"";
    }
    
    return self;
}

-(id)initWithProperties:(NSString*)sysctl Description:(NSString*)description
{
    self = [super init];
    
    if (self) {
        _sysctl = sysctl;
        _desc = description;
        _value = @"";
    }
    
    return self;
}

@end
