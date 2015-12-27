//
//  O3X.h
//  testo3xpref
//
//  Created by brendon on 12/12/2015.
//  Copyright © 2015 brendon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcStatSample.h>

@interface O3X : NSObject

+(unsigned long)getMemoryInUse;
+(unsigned long)getThreadsInUse;
+(unsigned long)getMutexesInUse;
+(unsigned long)getRwlocksInUse;
+(unsigned long)getArcCMax;
+(unsigned long)getArcCMin;
+(unsigned long)getArcMetaUsed;
+(unsigned long)getArcMetaMin;
+(unsigned long)getArcMetaMax;
+(unsigned long)getArcMemoryThrottleCount;
+(NSString*)getZfsKextVersion;
+(NSString*)getSplKextVersion;

@end

