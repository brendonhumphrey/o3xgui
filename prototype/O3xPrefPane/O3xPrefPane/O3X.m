//
//  O3X.m
//  testo3xpref
//
//  Created by brendon on 12/12/2015.
//  Copyright © 2015 brendon. All rights reserved.
//

#import "O3X.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation O3X

unsigned long get_ulong_sysctl(char *name)
{
    unsigned long value = 0;
    size_t length = sizeof(value);
    
    sysctlbyname(name, &value, &length, NULL, 0);
    
    return value;
}

NSString* get_string_sysctl(char *name)
{
    // FIXME - this should probably be done properly by dynamically allocating value
    // rather than assuming a maximum length
    char value[128] = {0};
    size_t length = sizeof(value);
    NSString *str = NULL;
    
    sysctlbyname(name, &value, &length, NULL, 0);
    
    str = [NSString stringWithUTF8String:value];
    return str;
}

+(unsigned long)getMemoryInUse;
{
    return get_ulong_sysctl("kstat.spl.misc.spl_misc.os_mem_alloc");
}

+(unsigned long)getThreadsInUse
{
    return get_ulong_sysctl("kstat.spl.misc.spl_misc.active_threads");
}

+(unsigned long)getMutexesInUse
{
    return get_ulong_sysctl("kstat.spl.misc.spl_misc.active_mutex");
}

+(unsigned long)getRwlocksInUse
{
    return get_ulong_sysctl("kstat.spl.misc.spl_misc.active_rwlock");
}

+(NSString*)getZfsKextVersion
{
    return get_string_sysctl("zfs.kext_version");
}

+(NSString*)getSplKextVersion
{
    return get_string_sysctl("spl.kext_version");
}

+(ArcStatSample*)getArcStatSample
{
    ArcStatSample *as = [[ArcStatSample alloc] init];
    
    unsigned long hits = get_ulong_sysctl("kstat.zfs.misc.arcstats.hits");
    unsigned long misses = get_ulong_sysctl("kstat.zfs.misc.arcstats.misses");
    
    as.readVal = hits + misses;
    as.missVal = misses;
    as.missPctVal = (as.readVal > 0) ? 100 - hits/as.readVal : 0;
    
    unsigned long dhit = get_ulong_sysctl("kstat.zfs.misc.arcstats.demand_data_hits") +get_ulong_sysctl("kstat.zfs.misc.arcstats.demand_metadata_hits");

    unsigned long dmiss = get_ulong_sysctl("kstat.zfs.misc.arcstats.demand_data_misses") +get_ulong_sysctl("kstat.zfs.misc.arcstats.demand_metadata_misses");
    
    as.dmisVal = dmiss;
    as.dmisPctVal = (dhit + dmiss > 0) ? 100 - (100 * dhit / (dhit + dmiss)) : 0;

    unsigned long phit =
        get_ulong_sysctl("kstat.zfs.misc.arcstats.prefetch_data_hits") +  get_ulong_sysctl("kstat.zfs.misc.arcstats.prefetch_metadata_hits");

    unsigned long pmiss =
        get_ulong_sysctl("kstat.zfs.misc.arcstats.prefetch_data_misses") +  get_ulong_sysctl("kstat.zfs.misc.arcstats.prefetch_metadata_misses");
    
    unsigned long pread = phit + pmiss;
    
    as.pmisVal = pmiss;
    as.pmisPctVal = (pread > 0) ? 100 - (100 * phit / pread) : 0;
    
    unsigned long mhit =
        get_ulong_sysctl("kstat.zfs.misc.arcstats.prefetch_metadata_hits") +  get_ulong_sysctl("kstat.zfs.misc.arcstats.demand_metadata_hits");
    
    unsigned long mmiss =
    get_ulong_sysctl("kstat.zfs.misc.arcstats.prefetch_metadata_misses") +  get_ulong_sysctl("kstat.zfs.misc.arcstats.demand_metadata_misses");
    
    unsigned long mread = mhit + mmiss;
    
    as.mmisVal = mmiss;
    as.mmisPctVal = (mread > 0) ? 100 - (100 * mhit / mread) : 0;
    
    as.sizeVal = get_ulong_sysctl("kstat.zfs.misc.arcstats.size");
    as.tsizeVal = get_ulong_sysctl("kstat.zfs.misc.arcstats.c");
    
    return as;
}

@end
