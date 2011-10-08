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
	<UINavigationBarDelegate, FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>
{
	IBOutlet UILabel *songLabel;
	IBOutlet UILabel *appStatusLabel;
	IBOutlet UIBarButtonItem *settingBtn;	
	FBLoginButton *fbLoginBtn;
	NSMutableDictionary *postDict;
	NSString *lastPost;
}

@property (nonatomic, retain) UILabel *songLabel;
@property (nonatomic, retain) UILabel *appStatusLabel;
@property (nonatomic, retain) UIBarButtonItem *settingBtn;
@property (nonatomic, retain) FBLoginButton *fbLoginBtn;

/*
 * @purpose:
 *		Handle action when user click on FB login button
 *		If user are not logged in, ask user logged in
 *		Otherwise, logged out for user
 * @param
 *		sender - fbLoginBtn
 */
- (void) fbLoginBtnClick:(id)sender;

- (IBAction) settingBtnSelected:(id)sender;
@end
