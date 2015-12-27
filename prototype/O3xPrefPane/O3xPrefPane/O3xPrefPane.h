//
//  O3xPrefPane.h
//  O3xPrefPane
//
//  Created by Brendon and Wendy Humphrey on 22/12/15.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import <SecurityInterface/SFAuthorizationView.h>

@class ArcStatSample;
@class PerformanceDetails;

@interface O3xPrefPane : NSPreferencePane<NSTableViewDataSource, NSTableViewDelegate>
{
    @private
    
    /* Kext version strings */
    __weak IBOutlet NSTextField *zfsVersionString;
    __weak IBOutlet NSTextField *splVersionString;
    
    /* Resources */
    __weak IBOutlet NSTextField *resMemoryInUse;
    __weak IBOutlet NSTextField *resThreadsInUse;
    __weak IBOutlet NSTextField *resMutexesInUse;
    __weak IBOutlet NSTextField *resRWLocksInUse;
    
    /* ARC Statistics */
    __weak IBOutlet NSTableView *arcStatsTable;
    __weak IBOutlet NSScrollView *arcStatsTableScrollView;
    __weak IBOutlet NSTextField *arcStatArcCMax;
    __weak IBOutlet NSTextField *arcStatArcCMin;
    __weak IBOutlet NSTextField *arcStatThrottleCount;
    __weak IBOutlet NSTextField *arcStatMetaMin;
    __weak IBOutlet NSTextField *arcStatMetaMax;
    __weak IBOutlet NSTextField *arcStatMetaUsed;
    
    /* Kstats Table */
    __weak IBOutlet NSTableView *kstatTable;
    
    /* Security */
    __weak IBOutlet SFAuthorizationView *authView;
    
    /* Previous ARC Stats sample */
    ArcStatSample *previousArcStatSample;
    NSMutableArray *arcStatsTableContent;
    
    /* Periodic update of control panel */
    NSTimer *refreshTimer;
}

- (void)mainViewDidLoad;
- (void)updateStats;

@end
