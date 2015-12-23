//
//  O3xPrefPane.h
//  O3xPrefPane
//
//  Created by Brendon and Wendy Humphrey on 22/12/15.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import <SecurityInterface/SFAuthorizationView.h>
#import "ArcStatSample.h"

@interface O3xPrefPane : NSPreferencePane
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
    __weak IBOutlet NSTextField *arcRead;
    __weak IBOutlet NSTextField *arcMiss;
    __weak IBOutlet NSTextField *arcMissPct;
    __weak IBOutlet NSTextField *arcDmis;
    __weak IBOutlet NSTextField *arcDmisPct;
    __weak IBOutlet NSTextField *arcPmis;
    __weak IBOutlet NSTextField *arcPmisPct;
    __weak IBOutlet NSTextField *arcMmis;
    __weak IBOutlet NSTextField *arcMmisPct;
    __weak IBOutlet NSTextField *arcSize;
    __weak IBOutlet NSTextField *arcTsize;
    
    /* Previous ARC Stats sample */
    ArcStatSample *previousArcStatSample;
    
    /* Periodic update of control panel */
    NSTimer *refreshTimer;
    
    /* Security */
    __weak IBOutlet SFAuthorizationView *authView;
    
}

- (void)mainViewDidLoad;
- (void)updateStats;


@end
