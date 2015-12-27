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
    
    // Initialise Settings table content
    _tunables = [[NSMutableArray alloc] init] ;

    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.spa_version" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zpl_version" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.active_vnodes" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.vnop_debug" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.ignore_negatives" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.ignore_positives" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.create_negatives" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.force_formd_normalized" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.skip_unlinked_drain" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_max" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_min" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_meta_limit" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_meta_min" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_grow_retry" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_shrink_shift" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_p_min_shift" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_disable_dup_eviction" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_arc_average_blocksize" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_write_max" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_write_boost" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_headroom" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_headroom_boost" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_feed_secs" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_feed_min_ms" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.max_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.sync_read_min_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.sync_read_max_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.sync_write_min_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.sync_write_max_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.async_read_min_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.async_read_max_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.async_write_min_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.async_write_max_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.scrub_min_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.scrub_max_active" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.async_write_min_dirty_pct" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.async_write_max_dirty_pct" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.aggregation_limit" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.read_gap_limit" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.write_gap_limit" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.arc_reduce_dnlc_percent" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.arc_lotsfree_percent" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_dirty_data_max" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_dirty_data_sync" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_delay_max_ns" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_delay_min_dirty_percent" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_delay_scale" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.spa_asize_inflation" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_mdcomp_disable" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_prefetch_disable" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfetch_max_streams" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfetch_min_sec_reap" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfetch_array_rd_sz" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_default_bs" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_default_ibs" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.metaslab_aliquot" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.spa_max_replication_override" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.spa_mode_global" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_flags" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_txg_timeout" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_vdev_cache_max" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_vdev_cache_size" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_vdev_cache_bshift" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.vdev_mirror_shift" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_scrub_limit" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_no_scrub_io" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_no_scrub_prefetch" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.fzap_default_block_shift" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_immediate_write_sz" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_read_chunk_size" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_nocacheflush" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zil_replay_disable" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.metaslab_gang_bang" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.metaslab_df_alloc_threshold" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.metaslab_df_free_pct" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zio_injection_enabled" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zvol_immediate_write_sz" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_noprefetch" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_feed_again" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.l2arc_norw" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_top_maxinflight" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_resilver_delay" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_scrub_delay" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_scan_idle" Description:@"x"]];
    [_tunables addObject:[[Tunable alloc] initWithProperties:@"kstat.zfs.darwin.tunable.zfs_recover" Description:@"x"]];
    
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
    } else if (tableView == settingsTable) {
        return [self.tunables count];
    }
    
    //else if (tableView == arcStatsTable) {
        return [self.arcStatsTableContent count];
    //}
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
    } else if (tableView == settingsTable) {
        if([identifier isEqualToString:@"sysctl"]) {
            Tunable *t = [self.tunables objectAtIndex:row];
            NSTableCellView *cv = [settingsTable makeViewWithIdentifier:@"sysctl" owner:self];
            cv.textField.stringValue = t.sysctl;
            return cv;
        } else if ([identifier isEqualToString:@"value"]) {
            Tunable *t = [self.tunables objectAtIndex:row];
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


@end
