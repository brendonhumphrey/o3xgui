//
//  O3X.m
//  testo3xpref
//
//  Created by brendon on 12/12/2015.
//  Copyright © 2015 brendon. All rights reserved.
//

#import "O3X.h"
#import "Sysctl.h"

@implementation O3X

+(unsigned long)getMemoryInUse;
{
    return [Sysctl ulongValue:@"kstat.spl.misc.spl_misc.os_mem_alloc"];
}

+(unsigned long)getThreadsInUse
{
    return [Sysctl ulongValue:@"kstat.spl.misc.spl_misc.active_threads"];
}

+(unsigned long)getMutexesInUse
{
    return [Sysctl ulongValue:@"kstat.spl.misc.spl_misc.active_mutex"];
}

+(unsigned long)getRwlocksInUse
{
    return [Sysctl ulongValue:@"kstat.spl.misc.spl_misc.active_rwlock"];
}

+(NSString*)getZfsKextVersion
{
    return [Sysctl stringValue:@"zfs.kext_version"];
}

+(NSString*)getSplKextVersion
{
    return [Sysctl stringValue:@"spl.kext_version"];
}


@end
