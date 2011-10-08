//
//  FB_MusicAppDelegate.m
//  FB_Music
//
//  Created by kiennt on 10/3/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import "FB_MusicAppDelegate.h"
#import "FB_MainView.h"
#import "FB_Utils.h"
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <unistd.h>

//@interface FB_MusicAppDelegate (Private)
//- (void) registerMusicNotificationService;
//- (void) handleItemChanged:(NSNotification *)notification;
//@end


@implementation FB_MusicAppDelegate

@synthesize window, navigationController, expirationHandler;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 		
    [self.window makeKeyAndVisible]; 
	[self.window addSubview:navigationController.view];
	isCreateBackgrounTask = NO;
	isInBackgroundMode = NO;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void) initBackgroundTasks {
	UIApplication *app = [UIApplication sharedApplication];	
	bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	isInBackgroundMode = YES;
	
	if (!isCreateBackgrounTask) {
		[self initBackgroundTasks];
		
		expirationHandler = ^{
			// close old background task
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSLog(@"handler expiration");
				UIApplication *app = [UIApplication sharedApplication];
				[app endBackgroundTask:bgTask];
				bgTask = UIBackgroundTaskInvalid;				
			});
			
			[self initBackgroundTasks];
		};							
		
		isCreateBackgrounTask = YES;		
	}		
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	isInBackgroundMode = NO;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"Application was terminated");
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	FB_Utils *fbUtil = [FB_Utils sharedFB_Utils];
	return [fbUtil.facebook handleOpenURL:url];
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	NSLog(@"receive notification");
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	
}


- (void)dealloc {
	[navigationController release];
    [window release];
    [super dealloc];
}


@end
