//
//  ArcStatSample.h
//  testo3xpref
//
//  Created by brendon on 12/12/2015.
//  Copyright © 2015 brendon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcStatSample : NSObject

@property NSDate *date;
@property unsigned long read;
@property unsigned long hits;
@property unsigned long misses;
@property unsigned long missPct;
@property unsigned long dHit;
@property unsigned long dMiss;
@property unsigned long dMissPct;
@property unsigned long pHit;
@property unsigned long pMiss;
@property unsigned long pMissPct;
@property unsigned long mHit;
@property unsigned long mMiss;
@property unsigned long mMissPct;
@property unsigned long size;
@property unsigned long tSize;

-(id)init;
-(id)initFromSysctl;

-(ArcStatSample*)difference: (ArcStatSample*)older;
-(void)calculatePercents;

@end
