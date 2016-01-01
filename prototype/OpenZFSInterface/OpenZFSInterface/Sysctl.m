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

+(NSMutableArray*)getAllNames
{
    NSMutableArray *all = [[NSMutableArray alloc] init];
    
    int name1[22], name2[22];
    int i, j;
    
    int len = 0;
    int *oid = 0;
    
    size_t l1, l2;
    
    name1[0] = 0;
    name1[1] = 2;
    l1 = 2;
    if (len) {
        memcpy(name1+2, oid, len*sizeof (int));
        l1 += len;
    } else {
        name1[2] = 1;
        l1++;
    }
    while (1) {
        l2 = sizeof name2;
        j = sysctl(name1, l1, name2, &l2, 0, 0);
        if (j < 0) {
            //if (errno == ENOENT)
                return all;
            //else
            //    err(1, "sysctl(getnext) %d %ld", j, l2);
        }
        
        l2 /= sizeof (int);
        
        if (l2 < len)
            return all;
        
        for (i = 0; i < len; i++)
            if (name2[i] != oid[i])
                return all;
        
        {
            char name[BUFSIZ];
            int qoid[CTL_MAXNAME+2];
            int i;
            unsigned long nlen = l2;
            
            size_t j;
            
            qoid[0] = 0;
            memcpy(qoid + 2, name2, nlen * sizeof(int));
            
            qoid[1] = 1;
            j = sizeof name;
            i = sysctl(qoid, nlen + 2, name, &j, 0, 0);
            
            [all addObject:[NSString stringWithCString:name encoding:NSUTF8StringEncoding]];
        }
        
        memcpy(name1+2, name2, l2*sizeof (int));
        l1 = 2 + l2;
    }
    
    return all;
}

@end
