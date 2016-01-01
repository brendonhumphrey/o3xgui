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
    
    /* Settings Table */
    __weak IBOutlet NSTableView *settingsTable;
    
    /* Security */
    __weak IBOutlet SFAuthorizationView *authView;
    
    /* Periodic update of control panel */
    NSTimer *refreshTimer;
}

@property NSMutableArray *tunables;

- (void)mainViewDidLoad;
- (void)updateStats;

@end
