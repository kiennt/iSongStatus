//
//  FB_MusicAppDelegate.m
//  FB_Music
//
//  Created by kiennt on 10/3/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import "FB_MusicAppDelegate.h"
#import "FB_MainView.h"
#import <Foundation/Foundation.h>
#import <unistd.h>

@implementation FB_MusicAppDelegate

@synthesize window, navigationController, expirationHandler;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 		
    [self.window makeKeyAndVisible]; 
	[self.window addSubview:navigationController.view];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"enter background");
//	UIApplication *app = [UIApplication sharedApplication];	
//	bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
//	
//	expirationHandler = ^{
//		NSLog(@"handler expiration");
//		[app endBackgroundTask:bgTask];
//		bgTask = UIBackgroundTaskInvalid;				
//		bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
//	};
//	
//    // Start the long-running task and return immediately.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		int count = 0;
//		while (1) {
//			NSLog(@"long running task: %d", ++count);
//			sleep(1);
//		}
//    }); 
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
	// close background task 
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"Application was terminated");
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	FB_MainView *mainView = (FB_MainView *)[navigationController topViewController];
	return [mainView.facebook handleOpenURL:url];
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
