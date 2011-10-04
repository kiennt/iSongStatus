//
//  FB_MainView.h
//  FB_Music
//
//  Created by kiennt on 10/4/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class FBLoginButton;
@class Facebook;

@interface FB_MainView : UIViewController
	<UINavigationBarDelegate, FBRequestDelegate, FBDialogDelegate, FBSessionDelegate>
{
	IBOutlet UILabel *songLabel;
	IBOutlet UIBarButtonItem *settingBtn;
	
	FBLoginButton *fbLoginBtn;
	Facebook *facebook;
	NSMutableArray *permissions;	
}

@property (nonatomic, retain) UILabel *songLabel;
@property (nonatomic, retain) UIBarButtonItem *settingBtn;
@property (nonatomic, retain) FBLoginButton *fbLoginBtn;
@property (nonatomic, retain) Facebook *facebook;

- (IBAction) settingBtnSelected:(id) sender;
- (void) fbLoginBtnClick:(id)sender;
@end
