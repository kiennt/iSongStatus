//
//  FB_MusicAppDelegate.h
//  FB_Music
//
//  Created by kiennt on 10/3/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FB_MusicAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
	IBOutlet UINavigationController *navigationController;
	dispatch_block_t expirationHandler;
	dispatch_queue_t task_queue;
	UIBackgroundTaskIdentifier bgTask; 
	BOOL isCreateBackgrounTask;
	BOOL isInBackgroundMode;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (copy) dispatch_block_t expirationHandler;
@end

