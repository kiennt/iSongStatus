//
//  FB_SettingsView.m
//  FB_Music
//
//  Created by kiennt on 10/4/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import "FB_SettingsView.h"
#import "UserSettings.h"

@implementation FB_SettingsView
@synthesize updateStatusSwitch, useOnePostSwitch, cell1, cell2, table;

#pragma mark -
#pragma mark View functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
	self.navigationItem.title = @"Settings";
	self.navigationItem.leftBarButtonItem.title = @"Back";
	updateStatusSwitch.on = [UserSettings isUpdateStatus];
	useOnePostSwitch.on = [UserSettings isUseOnePost];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Control functions
- (IBAction) updateStatusSwitchSelect:(id)sender {
	[UserSettings setUpdateStatus:updateStatusSwitch.on];
}

- (IBAction) useOnePostSwitchSelect:(id) sender {
	[UserSettings setUseOnePost:useOnePostSwitch.on];
}


#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark TableView functions
/*
 * @purpose
 *		Set up title for header in section
 * @param
 *		tableView - tableView was setup
 * @param
 *		section - section index of tableView
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView.tag==0) {
        if (section == 0) {
			return @"Facebook status";
        }
	}
	return 0;
}


/*
 * @purpose
 *		Set up row for table
 * @param
 * @param
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPath row] == 0) 
		return cell1;
	if ([indexPath row] == 1)
		return cell2;
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


@end
