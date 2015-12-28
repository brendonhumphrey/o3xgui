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
#import "Tunable.h"
#import "Sysctl.h"

@implementation O3xPrefPane

- (void)mainViewDidLoad
{
    [self updateStats];
    
    // Initialise ARC table content
    self.arcStatsTableContent = [[NSMutableArray alloc] init];
    
    // Initialise Statistics table content
    NSMutableArray *sysctlNames = [Sysctl getAllNames];
    
    _kstats = [[NSMutableArray alloc] init] ;
    
    for (int i = 0; i < [sysctlNames count]; i++) {
        NSString *sysctlName = [sysctlNames objectAtIndex:i];
        
        if ([sysctlName containsString:@"kstat"] &&
            ![sysctlName containsString:@"tunable"]) {
            [_kstats addObject:[[Tunable alloc] initWithProperties:sysctlName Description:@"x"]];
        }
    }
        
    [self applyFilterWithString:@""];
    
    // Initialise Settings table content
    _tunables = [[NSMutableArray alloc] init] ;
    
    for (int i = 0; i < [sysctlNames count]; i++) {
        NSString *sysctlName = [sysctlNames objectAtIndex:i];
        
        if ([sysctlName containsString:@"kstat"] &&
            [sysctlName containsString:@"tunable"]) {
            [_tunables addObject:[[Tunable alloc] initWithProperties:sysctlName Description:@"x"]];
        }
    }
    

    // Initialise the authorisation view
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
        return [self.filteredKstats count];
    } else if (tableView == settingsTable) {
        return [self.tunables count];
    } else {
        return [self.arcStatsTableContent count];
    }
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSString *identifier = [tableColumn identifier];
    
    if (tableView == kstatTable) {
        Tunable *t = [self.filteredKstats objectAtIndex:row];
        if ([identifier isEqualToString:@"kstat"]) {
            NSTableCellView *cv = [kstatTable makeViewWithIdentifier:@"kstat" owner:self];
            cv.textField.stringValue = t.sysctl;
            return cv;
        } else if ([identifier isEqualToString:@"kstatvalue"]){
            NSTableCellView *cv = [kstatTable makeViewWithIdentifier:@"kstatvalue" owner:self];
            cv.textField.stringValue = t.value;
            return cv;
        }
    } else if (tableView == settingsTable) {
        Tunable *t = [self.tunables objectAtIndex:row];
        if([identifier isEqualToString:@"sysctl"]) {
            NSTableCellView *cv = [settingsTable makeViewWithIdentifier:@"sysctl" owner:self];
            cv.textField.stringValue = t.sysctl;
            return cv;
        } else if ([identifier isEqualToString:@"value"]) {
            NSTableCellView *cv = [settingsTable makeViewWithIdentifier:@"value" owner:self];
            cv.textField.stringValue = t.value;
            return cv;
        }
    } else if (tableView == arcStatsTable) {
        ArcStatSample *stat = [self.arcStatsTableContent objectAtIndex:row];
        
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

- (void)controlTextDidChange:(NSNotification *)obj {
    if (obj.object == kstatSearchField) {
        [self applyFilterWithString:kstatSearchField.stringValue];
    }
}

-(void)applyFilterWithString:(NSString*)filter {
    if (filter.length>0) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"sysctl CONTAINS[cd] %@", filter];
        self.filteredKstats = [self.kstats filteredArrayUsingPredicate:filterPredicate];
    }
    else {
        self.filteredKstats = self.kstats.copy;
    }
    [kstatTable reloadData];
}

- (void)updateStats
{
    NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];

    // Get Kext Version strings
    [zfsVersionString setStringValue:[O3X getZfsKextVersion]];
    [splVersionString setStringValue:[O3X getSplKextVersion]];

    // Get resource usage kstats
    [resMemoryInUse setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getMemoryInUse]]]];
    [resThreadsInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getThreadsInUse]]];
    [resMutexesInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getMutexesInUse]]];
    [resRWLocksInUse setStringValue:[NSString stringWithFormat: @"%lu", [O3X getRwlocksInUse]]];
    
    // Update ARC statistics
    [arcStatMetaMax setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcMetaMax]]]];
    [arcStatMetaMin setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcMetaMin]]]];
    [arcStatMetaUsed setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcMetaUsed]]]];
    [arcStatArcCMax setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcCMax]]]];
    [arcStatArcCMin setStringValue:[NSString stringWithFormat: @"%@", [formatter stringFromByteCount:[O3X getArcCMin]]]];
    [arcStatThrottleCount setStringValue:[NSString stringWithFormat: @"%lu", [O3X getArcMemoryThrottleCount]]];
    
    ArcStatSample *currentArcStatSample = [[ArcStatSample alloc] initFromSysctl];
    
    if (self.previousArcStatSample != NULL) {
    
        ArcStatSample *diff = [currentArcStatSample difference:self.previousArcStatSample];
        
        diff.date = currentArcStatSample.date;
        diff.size = currentArcStatSample.size;
        diff.tSize = currentArcStatSample.tSize;
        
        [diff calculatePercents];
        
        [self.arcStatsTableContent addObject:diff];
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
    
    self.previousArcStatSample = currentArcStatSample;
    
    // Read statistical kstats
    for (int i=0; i < [_filteredKstats count]; i++) {
        Tunable *t = [_filteredKstats objectAtIndex:i];
        t.value = [NSString stringWithFormat: @"%lu", [Sysctl ulongValue:t.sysctl]];
    }
    
    // Read tunables
    for (int i=0; i < [_tunables count]; i++) {
        Tunable *t = [_tunables objectAtIndex:i];
        t.value = [NSString stringWithFormat: @"%lu", [Sysctl ulongValue:t.sysctl]];
    }
}

- (IBAction)zfsIconClicked:(id)sender
{
      [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.openzfsonosx.org"]];
}


//
// SFAuthorization delegates
//

- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)view {
    //[touchButton setEnabled:[self isUnlocked]];
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)view {
    //[touchButton setEnabled:[self isUnlocked]];
}

- (BOOL)isUnlocked {
    return [authView authorizationState] == SFAuthorizationViewUnlockedState;
}

-(void)doPrivilegedThing
{
    // Collect arguments into an array.
    NSMutableArray *args = [NSMutableArray array];
    [args addObject:@"-c"];
    [args addObject:@" touch /var/log/test.txt"];
    
    // Convert array into void-* array.
    const char **argv = (const char **)malloc(sizeof(char *) * [args count] + 1);
    int argvIndex = 0;
    for (NSString *string in args) {
        argv[argvIndex] = [string UTF8String];
        argvIndex++;
    }
    argv[argvIndex] = nil;
    
    OSErr processError = AuthorizationExecuteWithPrivileges([[authView authorization] authorizationRef], [@"/bin/sh" UTF8String],
                                                            kAuthorizationFlagDefaults, (char *const *)argv, nil);
    free(argv);
    
    if (processError != errAuthorizationSuccess)
        NSLog(@"Error: %d", processError);
}
@end
