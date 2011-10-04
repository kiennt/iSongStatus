//
//  FB_MainView.m
//  FB_Music
//
//  Created by kiennt on 10/4/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import "FB_MainView.h"
#import "Facebook.h"
#import "FBLoginButton.h"
#import "FB_SettingsView.h"
#import "UserSettings.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FB_MainView (Private)
- (void) setupFBLoginBtn;
- (void) registerLocationService;
- (void) registerMusicNotificationService;
- (void) registerLocationServiceAfter:(int) secs withBody:(NSString *) body withAction:(NSString *) action;
@end

#define APP_ID @"225060547551085"

@implementation FB_MainView
@synthesize songLabel, settingBtn, fbLoginBtn, facebook;

#pragma mark -
#pragma mark UIViewController functions
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

/*
 * @purpose: 
 *   Setup Facebook object and fbLoginBtn
 *   This function was called before viewDidLoad
 *   First, create facebook object and set delegate to this class
 *   Second, check if user already login FB, we will not ask them login again
 */
- (void) setupFBLoginBtn {
	permissions =  [[NSArray arrayWithObjects:
					 @"read_stream", @"publish_stream", @"offline_access",nil] retain];
	facebook = [[Facebook alloc] initWithAppId:APP_ID
								   andDelegate:self];	
	
	NSString *accessToken = [UserSettings getAccessToken];
	if (accessToken) {		
		facebook.accessToken = accessToken;
		facebook.expirationDate = [UserSettings getExpirationDate];
		NSLog(@"current accessToken: %@, expirationDate: %@", facebook.accessToken, facebook.expirationDate);
		fbLoginBtn = [FBLoginButton initWithLoggedInStatus:YES];
	} else {
		fbLoginBtn = [FBLoginButton initWithLoggedInStatus:NO];
	}
	
	[fbLoginBtn addTarget:self action:@selector(fbLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];	
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:fbLoginBtn];
	[fbLoginBtn release];	
	self.navigationItem.rightBarButtonItem = barItem;
	[barItem release];
}


- (void)viewDidLoad {
	[self setupFBLoginBtn];
	[self registerMusicNotificationService];
    [super viewDidLoad];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Action controller
/*
 * @purpose:
 *   Handle action when user click on setting button
 *   Open Setting view
 */
- (IBAction) settingBtnSelected:(id) sender {
	FB_SettingsView *settingController = [[FB_SettingsView alloc] initWithNibName:@"FB_SettingsView" bundle:nil];
	[self.navigationController pushViewController:settingController animated:YES];
	[settingController release];
}

/*
 * @purpose:
 *   Handle action when user click on FB login button
 *   If user are not logged in, ask user logged in
 *   Otherwise, logged out for user
 */
- (void) fbLoginBtnClick:(id)sender {
	if (!fbLoginBtn.isLoggedIn) {
		[facebook authorize:permissions];
	} else {
		[facebook logout:self];
	}
}


#pragma mark -
#pragma mark Facebook delegate
- (void) fbPostMessageToWall:(NSString *) message {
	if (fbLoginBtn.isLoggedIn) {
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   message, @"message",
									   nil];
		[facebook requestWithGraphPath:@"me/feed" 
							 andParams:params 
						 andHttpMethod:@"POST" 
						   andDelegate:self];
	}
}

/*
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	fbLoginBtn.isLoggedIn = YES;
	[fbLoginBtn updateImage];
	
	[UserSettings setAccessToken:facebook.accessToken];
	[UserSettings setExpirationDate:facebook.expirationDate];
}

/*
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/*
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	fbLoginBtn.isLoggedIn = NO;
	[fbLoginBtn updateImage];
	
	[UserSettings setAccessToken:nil];
	[UserSettings setExpirationDate:nil];
}


/*
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

/*
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	self.songLabel.text = [NSString stringWithFormat:@"post %@ to wall", self.songLabel.text];
}

/*
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"%@", [error localizedDescription]);
	[self.songLabel setText:[error localizedDescription]];
}

#pragma mark -
#pragma mark Music functions
- (void) registerMusicNotificationService {	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(handleItemChanged:) 
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
											   object:nil];
	MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
	[player beginGeneratingPlaybackNotifications];
}
 
- (void) handleItemChanged:(NSNotification *)notification {
	MPMediaItem *media = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];	
	NSString *artist = [media valueForProperty:MPMediaItemPropertyArtist];
	NSString *song = [media valueForProperty:MPMediaItemPropertyTitle];	
	NSLog(@"current song: %@, artist %@", song, artist);
	NSString *message = [NSString stringWithFormat:@"is listenning \"%@\"", song];
	// change label
	self.songLabel.text = song;
	
	// post to wall
	if ([UserSettings isUpdateStatus]) {		
		[self fbPostMessageToWall:message];
	}
}

#pragma mark -
#pragma mark Local notification
- (void) registerLocationServiceAfter:(int) secs withBody:(NSString *) body withAction:(NSString *) action {
	UILocalNotification *localNotif = [[UILocalNotification alloc] init];
	localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:secs];
	NSLog(@"notif fireDate: %@", localNotif.fireDate);
	localNotif.timeZone = [NSTimeZone defaultTimeZone];
	localNotif.alertBody = body;
	localNotif.alertAction = action;	
	[[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
	[localNotif release];
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[permissions release];
	[facebook release];
    [super dealloc];
}


@end
