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
#import "FB_Utils.h"
#import "UserSettings.h"
#import <MediaPlayer/MediaPlayer.h>

@interface FB_MainView (Private)
/*
 * @purpose
 *		Setup Facebook object and fbLoginBtn
 *		This function was called before viewDidLoad
 *		First, create facebook object and set delegate to this class
 *		Second, check if user already login FB, we will not ask them login again
 * @param
 * @return
 */
- (void) setupFBLoginBtn;
- (void) registerMusicNotificationService;
- (void) handleItemChanged:(NSNotification *)notification;
@end


@implementation FB_MainView
@synthesize songLabel, settingBtn, fbLoginBtn, appStatusLabel;

#pragma mark -
#pragma mark UIViewController functions
/*
 * @purpose
 *		This function was called at beginning when this screen view was loaded
 * @param
 *		nibNameOrNil - name of xib file - this name is raw name without extend (.xib)
 *		Ex: you want to load file FB_SettingsView.xib - nibNameOfNil = @"FB_SettingsView"
 * @param
 *		nibBundleOrNil - name of bundle was loaded
 * @return
 *		UIViewController object
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

/*
 * @purpose
 *		Setup Facebook object and fbLoginBtn
 *		This function was called before viewDidLoad
 *		First, create facebook object and set delegate to this class
 *		Second, check if user already login FB, we will not ask them login again
 * @param
 * @return
 */
- (void) setupFBLoginBtn {
	FB_Utils *fb = [FB_Utils sharedFB_Utils];
	fb.facebook.sessionDelegate = self;
	
	NSLog(@"token: %@", fb.facebook.accessToken);
	fbLoginBtn = [FBLoginButton initWithLoggedInStatus:fb.isLoggedIn];	
	[fbLoginBtn addTarget:self action:@selector(fbLoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];	
	UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:fbLoginBtn];
	[fbLoginBtn release];	
	self.navigationItem.rightBarButtonItem = barItem;
	[barItem release];
}

/*
 * @purpose
 *		This function was called after .xib file was loaded
 * @param
 * @return
 */
- (void)viewDidLoad {
	postDict = [[NSMutableDictionary alloc] init];
	lastPost = nil;
	appStatusLabel.text = @"";
	[self setupFBLoginBtn];
	[self registerMusicNotificationService];
    [super viewDidLoad];
}

/*
 * @purpose
 *		This function was called after .xib file was unloaded
 *		We do some thing like finalized at this function
 * @param
 * @return
 */
- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -
#pragma mark Action controller
/*
 * @purpose:
 *		Handle action when user click on FB login button
 *		If user are not logged in, ask user logged in
 *		Otherwise, logged out for user
 * @param
 *		sender - fbLoginBtn
 */
- (void) fbLoginBtnClick:(id)sender {
	FB_Utils *fbUtil = [FB_Utils sharedFB_Utils];
	if (!fbLoginBtn.isLoggedIn) {
		[fbUtil.facebook authorize:fbUtil.permissions];
	} else {
		[fbUtil.facebook logout:self];
	}
}

- (IBAction) settingBtnSelected:(id)sender {
	FB_SettingsView *settingView = [[FB_SettingsView alloc] initWithNibName:@"FB_SettingsView" bundle:nil];
	[self.navigationController pushViewController:settingView animated:YES];
}

#pragma mark -
#pragma mark Facebook delegate
/*
 * @purpose
 *		Change image of fbLoginButton after user logged in sucessfull
 *		Cached user information of user (access token, epiration date)
 * @param
 * @return
 */
- (void)fbDidLogin {
	fbLoginBtn.isLoggedIn = YES;
	[fbLoginBtn updateImage];
	[[FB_Utils sharedFB_Utils] didLogin];
}

/*
 * @purpose
 *		Called when the user canceled the authorization dialog.
 *		This function was required by FBSessionDelegate 
 * @param
 *		cancelled - 
 * @return
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

/*
 * @purpose
 *		Called when the request logout has succeeded.
 *		This function was required by FBSessionDelegate
 * @param
 * @return
 */
- (void)fbDidLogout {
	fbLoginBtn.isLoggedIn = NO;
	[fbLoginBtn updateImage];	
	[[FB_Utils sharedFB_Utils] didLogout];
}


/*
 * @purpose
 *		Called when the Facebook API request has returned a response. This callback
 *		gives you access to the raw response. It's called before
 *		(void)request:(FBRequest *)request didLoad:(id)result,
 *		which is passed the parsed response object
 * @param
 *		request -
 * @param
 *		response -
 * @return
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

/*
 * @purpose
 *		Called when a request returns and its response has been parsed into
 *		an object. The resulting object may be a dictionary, an array, a string,
 *		or a number, depending on the format of the API response. If you need access
 *		to the raw response, use:
 *
 *		(void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
 * @param 
 *		request - 
 * @param
 *		result - 
 * @return
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	NSLog(@"result: %@", result);
	if (result != nil) {
		NSDictionary *resultDict = (NSDictionary *)result;
		NSString *postId = [resultDict objectForKey:@"id"];
		// post message request
		if (postId != nil) { 
			NSLog(@"post_id: %@", postId);
			lastPost = postId;
			NSString *song = songLabel.text;
			[postDict setValue:postId forKey:song];			
			appStatusLabel.text = @"Post to wall successfull";
		}
	}
}

/*
 * @purpose
 *		Called when an error prevents the Facebook API request from completing
 *		successfully.
 * @param
 *		request -
 * @param
 *		error - 
 * @result
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	NSLog(@"Error: %@", [error localizedDescription]);
	NSLog(@"Error details: %@", [error description]);
	appStatusLabel.text = @"Error occurred";
}

#pragma mark -
#pragma mark Music notification
- (void) registerMusicNotificationService {	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(handleItemChanged:) 
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
											   object:nil];
	MPMusicPlayerController *player = [MPMusicPlayerController iPodMusicPlayer];
	[player beginGeneratingPlaybackNotifications];
}


/*
 * @purpose
 *		This function was called everytime IPOD player change to new song
 * @param
 *		notification - now playing item change notification
 * @return
 */
- (void) handleItemChanged:(NSNotification *)notification {
	MPMediaItem *media = [[MPMusicPlayerController iPodMusicPlayer] nowPlayingItem];	
	NSString *artist = [media valueForProperty:MPMediaItemPropertyArtist];
	NSString *song = [media valueForProperty:MPMediaItemPropertyTitle];	
	
	NSLog(@"FB_Music: current song: %@, artist %@", song, artist);
	songLabel.text = song;

		
	FB_Utils *fbUtils = [FB_Utils sharedFB_Utils];
	
	if ([UserSettings isUseOnePost] && lastPost != nil) {
		[fbUtils deletePostWithId:lastPost withDelegate:self];
	}
	
	if ([UserSettings isUpdateStatus] && song != nil) {
		appStatusLabel.text = @"Posting to facebook";
		NSString *message = [NSString stringWithFormat:@"is listening \"%@\"", song];
		if (artist != nil) {
			message = [NSString stringWithFormat:@"%@ of %@", message, artist];
		}
		[fbUtils postMessageToWall:message withDelegate:self];
	}	
}

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}


@end
