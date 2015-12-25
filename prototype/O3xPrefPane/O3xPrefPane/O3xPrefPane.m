//
//  O3xPrefPane.m
//  O3xPrefPane
//
//  Created by Brendon and Wendy Humphrey on 22/12/15.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import "O3xPrefPane.h"
#import "O3X.h"
#import "ArcStatSample.h"
#import "PerformanceDetails.h"

@implementation O3xPrefPane

- (void)mainViewDidLoad
{
    [self updateStats];
    
    AuthorizationItem items = {kAuthorizationRightExecute, 0, NULL, 0};
    AuthorizationRights rights = {1, &items};
    [authView setAuthorizationRights:&rights];
    authView.delegate = self;
    [authView updateStatus:nil];
    
    refreshTimer = [NSTimer timerWithTimeInterval:1.0
                            target:self
                            selector:@selector(updateStats)
                            userInfo:nil
                            repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:refreshTimer forMode:NSRunLoopCommonModes];
}

- (void)updateStats
{
    [zfsVersionString setStringValue:[O3X getZfsKextVersion]];
    [splVersionString setStringValue:[O3X getSplKextVersion]];

    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
    
    [resMemoryInUse setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getMemoryInUse]]]];
    [resThreadsInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getThreadsInUse]]];
    [resMutexesInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getMutexesInUse]]];
    [resRWLocksInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getRwlocksInUse]]];
    
    ArcStatSample *currentArcStatSample = [[ArcStatSample alloc] initFromSysctl];
    
    if (previousArcStatSample != NULL) {
    
        ArcStatSample *diff = [currentArcStatSample difference:previousArcStatSample];
        
        [diff calculatePercents];
        
        [arcRead setStringValue:[NSString stringWithFormat:@"%lu", diff.read]];
        [arcMiss setStringValue:[NSString stringWithFormat:@"%lu", diff.misses]];
        [arcMissPct setStringValue:[NSString stringWithFormat:@"%lu", diff.missPct]];
        [arcDmis setStringValue:[NSString stringWithFormat:@"%lu", diff.dMiss]];
        [arcDmisPct setStringValue:[NSString stringWithFormat:@"%lu", diff.dMissPct]];
        [arcPmis setStringValue:[NSString stringWithFormat:@"%lu", diff.pMiss]];
        [arcPmisPct setStringValue:[NSString stringWithFormat:@"%lu", diff.pMissPct]];
        [arcMmis setStringValue:[NSString stringWithFormat:@"%lu", diff.mMiss]];
        [arcMmisPct setStringValue:[NSString stringWithFormat:@"%lu", diff.mMissPct]];
        [arcSize setStringValue:[NSString stringWithFormat:@"%@", [formatter stringFromByteCount:currentArcStatSample.size]]];
        [arcTsize setStringValue:[NSString stringWithFormat:@"%@", [formatter stringFromByteCount:currentArcStatSample.tSize]]];
    }
    
    previousArcStatSample = currentArcStatSample;
}

- (IBAction)zfsIconClicked:(id)sender
{
      [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.openzfsonosx.org"]];
}

- (IBAction) performanceDetailsClickAction:(id)sender
{
    if (!performanceDetails) {
        performanceDetails = [[PerformanceDetails alloc] initWithWindowNibName:@"PerformanceDetails"];
    }
    
    [arcTsize setStringValue:[NSString stringWithFormat:@"%@", @"xxxx"]];

    [performanceDetails showWindow:self];
}

@end
