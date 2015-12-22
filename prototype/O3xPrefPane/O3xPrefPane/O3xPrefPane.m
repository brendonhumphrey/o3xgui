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

    [resMemoryInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getMemoryInUse]]];
    [resThreadsInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getThreadsInUse]]];
    [resMutexesInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getMutexesInUse]]];
    [resRWLocksInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getRwlocksInUse]]];
    
    
    ArcStatSample *as = [O3X getArcStatSample];
    
    [arcRead setStringValue:[NSString stringWithFormat:@"%lu", as.readVal]];
    [arcMiss setStringValue:[NSString stringWithFormat:@"%lu", as.missVal]];
    [arcMissPct setStringValue:[NSString stringWithFormat:@"%lu", as.missPctVal]];
    [arcDmis setStringValue:[NSString stringWithFormat:@"%lu", as.dmisVal]];
    [arcDmisPct setStringValue:[NSString stringWithFormat:@"%lu", as.dmisPctVal]];
    [arcPmis setStringValue:[NSString stringWithFormat:@"%lu", as.pmisVal]];
    [arcPmisPct setStringValue:[NSString stringWithFormat:@"%lu", as.pmisPctVal]];
    [arcMmis setStringValue:[NSString stringWithFormat:@"%lu", as.mmisVal]];
    [arcMmisPct setStringValue:[NSString stringWithFormat:@"%lu", as.mmisPctVal]];
    [arcSize setStringValue:[NSString stringWithFormat:@"%lu", as.sizeVal]];
    [arcTsize setStringValue:[NSString stringWithFormat:@"%lu", as.tsizeVal]];
}

- (IBAction)zfsIconClicked:(id)sender
{
      [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.openzfsonosx.org"]];
}

@end
