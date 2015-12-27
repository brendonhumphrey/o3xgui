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
    
    arcStatsTableContent = [[NSMutableArray alloc] init];
    
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

// ===========================
// = ARC Statistics Table
// ===========================

// The only essential/required tableview dataSource method
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (tableView == kstatTable) {
        return 1;
    }
    return [arcStatsTableContent count];
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSString *identifier = [tableColumn identifier];
    
    if (tableView == kstatTable) {
        if ([identifier isEqualToString:@"kstat"]) {
            NSTableCellView *cv = [kstatTable makeViewWithIdentifier:@"kstat" owner:self];
            cv.textField.stringValue = @"this.is.a.test";
            return cv;
        } else if ([identifier isEqualToString:@"kstatvalue"]){
            NSTableCellView *cv = [kstatTable makeViewWithIdentifier:@"kstatvalue" owner:self];
            cv.textField.stringValue = @"0x222";
            return cv;
        }
    } else if (tableView == arcStatsTable) {
        
        ArcStatSample *stat = [arcStatsTableContent objectAtIndex:row];
        
        if ([identifier isEqualToString:@"time"]) {
    
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"HH:mm:ss"];
            NSString *dateString = [format stringFromDate:stat.date];
            
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"time" owner:self];
            cv.textField.stringValue = dateString;
            return cv;
        } else if ([identifier isEqualToString:@"read"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"read" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.read];
            return cv;
        } else if ([identifier isEqualToString:@"miss"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"miss" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.misses];
            return cv;
        } else if ([identifier isEqualToString:@"misspct"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"misspct" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.missPct];
            return cv;
        }else if ([identifier isEqualToString:@"dmis"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"dmis" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.dMiss];
            return cv;
        }else if ([identifier isEqualToString:@"dmpct"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"dmpct" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.dMissPct];
            return cv;
        }else if ([identifier isEqualToString:@"pmis"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"pmis" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.pMiss];
            return cv;
        }else if ([identifier isEqualToString:@"pmpct"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"pmpct" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.pMissPct];
            return cv;
        }else if ([identifier isEqualToString:@"mmis"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"mmis" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.mMiss];
            return cv;
        }else if ([identifier isEqualToString:@"mmpct"]) {
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"mmpct" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%lu", stat.mMissPct];
            return cv;
        }else if ([identifier isEqualToString:@"size"]) {
            NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"size" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%@", [formatter stringFromByteCount:stat.size]];
            return cv;
        }else if ([identifier isEqualToString:@"tsize"]) {
            NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
            NSTableCellView *cv = [arcStatsTable makeViewWithIdentifier:@"tsize" owner:self];
            cv.textField.stringValue = [NSString stringWithFormat:@"%@", [formatter stringFromByteCount:stat.tSize]];
            return cv;
        }
    }

    return NULL;
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
    
    [arcStatMetaMax setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcMetaMax]]]];
    [arcStatMetaMin setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcMetaMin]]]];
    [arcStatMetaUsed setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcMetaUsed]]]];
    [arcStatArcCMax setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcCMax]]]];
    [arcStatArcCMin setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcCMin]]]];
    [arcStatThrottleCount setStringValue:[NSString stringWithFormat: @"%lu", [O3X getArcMemoryThrottleCount]]];
    
    ArcStatSample *currentArcStatSample = [[ArcStatSample alloc] initFromSysctl];
    
    if (previousArcStatSample != NULL) {
    
        ArcStatSample *diff = [currentArcStatSample difference:previousArcStatSample];
        
        diff.date = currentArcStatSample.date;
        diff.size = currentArcStatSample.size;
        diff.tSize = currentArcStatSample.tSize;
        
        [diff calculatePercents];
        
        [arcStatsTableContent addObject:diff];
        [arcStatsTable reloadData];
        
        // Force the arc stats table to show the most recent sample
        // unless the vertical scrollbar has been moved from the bottom
        // of its range.
        if (arcStatsTableScrollView.verticalScroller.floatValue > 0.9){
            NSInteger numberOfRows = [arcStatsTable numberOfRows];
            
            if (numberOfRows > 0)
                [arcStatsTable scrollRowToVisible:numberOfRows - 1];
        }
        
    }
    
    previousArcStatSample = currentArcStatSample;
}

- (IBAction)zfsIconClicked:(id)sender
{
      [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.openzfsonosx.org"]];
}


@end
