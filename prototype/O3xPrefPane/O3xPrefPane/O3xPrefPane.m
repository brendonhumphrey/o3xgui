//
//  O3xPrefPane.m
//  O3xPrefPane
//
//  Created by Brendon and Wendy Humphrey on 22/12/15.
//  Copyright © 2015 OpenZFS On OSX. All rights reserved.
//

#import <OpenZFSInterface/O3X.h>
#import <OpenZFSInterface/ArcStatSample.h>
#import <OpenZFSInterface/Sysctl.h>
#import "O3xPrefPane.h"
#import "Tunable.h"

@implementation O3xPrefPane

- (void)mainViewDidLoad
{
    [self updateStats];
        
    // Initialise Statistics table content
    NSMutableArray *sysctlNames = [Sysctl getAllNames];
    
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
    AuthorizationItem items = {"sys.flibble.readwrite./etc/zfs/brendon.txt", 0, NULL, 0};
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
    if (tableView == settingsTable) {
        return [self.tunables count];
    } else {
        return 0;
    }
}

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSString *identifier = [tableColumn identifier];
    
    if (tableView == settingsTable) {
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
    }

    return NULL;
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
    
    FILE *f = fopen("/etc/zfs/brendon.txt", "w");
    if (f) {
        fclose(f);
    } else {
        NSLog(@"%s", "didnt open");
    }
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
