//
//  FB_SettingsView.h
//  FB_Music
//
//  Created by kiennt on 10/4/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FB_SettingsView : UIViewController<UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UISwitch *updateStatusSwitch;
	IBOutlet UITableViewCell *cell1;
	IBOutlet UITableView *table;
}

@property (nonatomic, retain) UISwitch *updateStatusSwitch;
@property (nonatomic, retain) UITableViewCell *cell1;
@property (nonatomic, retain) UITableView *table;

- (IBAction) updateStatusSwitchSelect:(id) sender;
@end
