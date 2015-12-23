//
//  Sysctl.m
//  O3xPrefPane
//
//  Created by brendon on 23/12/2015.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import "Sysctl.h"
#import <sys/types.h>
#import <sys/sysctl.h>

@implementation Sysctl

+(NSString*)stringValue: (NSString*)name
{
    char value[128] = {0};
    size_t length = sizeof(value);
    
    sysctlbyname([name cStringUsingEncoding:NSUTF8StringEncoding], &value, &length, NULL, 0);
    
    return [NSString stringWithUTF8String:value];
}

+(unsigned long)ulongValue:(NSString*)name
{
    unsigned long value = 0;
    size_t length = sizeof(value);
    
    sysctlbyname([name cStringUsingEncoding:NSUTF8StringEncoding], &value, &length, NULL, 0);

    return value;
}

@end
