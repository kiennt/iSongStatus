//
//  FB_Utils.h
//  FB_Music
//
//  Created by kiennt on 10/6/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@interface FB_Utils : NSObject<FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
	Facebook *facebook;
	NSMutableArray *permissions_;
	BOOL isLoggedIn;
}

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, assign) BOOL isLoggedIn;
@property (nonatomic, readonly) NSMutableArray *permissions;
+ (id) sharedFB_Utils;

- (void) didLogin;
- (void) didLogout;

- (void) postMessageToWall:(NSString *)message withDelegate:(id <FBRequestDelegate>)delegate;
- (void) postMessageToWall:(NSString *)message;

- (void) deletePostWithId:(NSString *)postId withDelegate:(id <FBRequestDelegate>)delegate;
- (void) deletePostWithId:(NSString *)postId;

@end
