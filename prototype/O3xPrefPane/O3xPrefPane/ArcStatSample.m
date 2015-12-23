//
//  ArcStatSample.m
//  testo3xpref
//
//  Created by brendon on 12/12/2015.
//  Copyright © 2015 brendon. All rights reserved.
//

#import "ArcStatSample.h"
#import "Sysctl.h"

@implementation ArcStatSample

-(id)init
{
    return [super init];
}

-(id)initFromSysctl
{
    self = [super init];
    
    if (self) {
        _hits = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.hits"];
        
        _misses = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.misses"];
        
        _dHit = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.demand_data_hits"] + [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.demand_metadata_hits"];
        
        _dMiss = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.demand_data_misses"] + [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.demand_metadata_misses"];
        
        _pHit = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.prefetch_data_hits"] + [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.prefetch_metadata_hits"];
        
        _pMiss = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.prefetch_data_misses"] +  [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.prefetch_metadata_misses"];
        
        _mHit = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.prefetch_metadata_hits"] +  [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.demand_metadata_hits"];
        
        _mMiss = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.prefetch_metadata_misses"] +  [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.demand_metadata_misses"];
        
        _size = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.size"];
            
        _tSize = [Sysctl ulongValue:@"kstat.zfs.misc.arcstats.c"];
    }
    
    return self;
}

-(ArcStatSample*)difference: (ArcStatSample*)older;
{
    ArcStatSample *diff = [ArcStatSample alloc];
    
    diff.read = _read - older.read;
    diff.hits = _hits - older.hits;
    diff.misses = _misses - older.misses;
    diff.dHit = _dHit - older.dHit;
    diff.dMiss = _dMiss - older.dMiss;
    diff.pHit = _pHit - older.pHit;
    diff.pMiss = _pMiss - older.pMiss;
    diff.mHit = _mHit - older.mHit;
    diff.mMiss = _mMiss - older.mMiss;

    return diff;
}

-(void)calculatePercents
{
    unsigned long pread = _pHit + _pMiss;
    unsigned long mread = _mHit + _mMiss;

    _read = _hits + _misses;
    _missPct = (_read > 0) ? 100 - (100 * _hits/_read) : 0;
  
    _dMissPct = (_dHit + _dMiss > 0) ? 100 - (100 * _dHit / (_dHit + _dMiss)) : 0;
    
    _pMissPct = (pread > 0) ? 100 - (100 * _pHit / pread) : 0;
    
    _mMissPct = (mread > 0) ? 100 - (100 * _mHit / mread) : 0;
}

@end
