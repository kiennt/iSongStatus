//
//  FB_Utils.m
//  FB_Music
//
//  Created by kiennt on 10/6/11.
//  Copyright 2011 Kien Nguyen Trung. All rights reserved.
//

#import "FB_Utils.h"
#import "UserSettings.h"


//#define APP_ID @"225060547551085" // iSongStatus from second account
//#define APP_ID @"145634995501895" // GraphAPI app
#define APP_ID @"122530647850544" // iSongStatus from 1st account

static FB_Utils *sharedFBUtils_ = nil;

@implementation FB_Utils
@synthesize facebook, isLoggedIn, permissions = permissions_;

+ (id) sharedFB_Utils {
	if (sharedFBUtils_ == nil) {
		sharedFBUtils_ = [[FB_Utils alloc] init];
	}
	
	return sharedFBUtils_;
}

- (id) init {
	if ((self = [super init])) {
		permissions_ =  [[NSArray arrayWithObjects:
						 @"read_stream", @"publish_stream", @"offline_access",nil] retain];
		facebook = [[Facebook alloc] initWithAppId:APP_ID
									   andDelegate:self];
		
		
		NSString *accessToken = [UserSettings getAccessToken];
		if (accessToken) {		
			facebook.accessToken = accessToken;
			facebook.expirationDate = [UserSettings getExpirationDate];
			isLoggedIn = YES;
		} else {
			isLoggedIn = NO;
		}
	}	
	return self;
}

- (void) didLogin {
	isLoggedIn = YES;
	[UserSettings setAccessToken:facebook.accessToken];
	[UserSettings setExpirationDate:facebook.expirationDate]; 
}

- (void) didLogout {
	isLoggedIn = NO;
	[UserSettings setAccessToken:nil];
	[UserSettings setExpirationDate:nil];
}

/*
 * @purpose
 *		Post message to FB 's wall
 *		NOTE that action only was performed if user is logged in FB account
 * @param
 *		message - the message was posted
 * @return 
 */
- (void) postMessageToWall:(NSString *) message withDelegate:(id<FBRequestDelegate>) delegate {
	if (isLoggedIn) {
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   message, @"message",
									   nil];
		[facebook requestWithGraphPath:@"me/feed" 
							 andParams:params 
						 andHttpMethod:@"POST" 
						   andDelegate:delegate];
	}
}

- (void) postMessageToWall:(NSString *) message {
	[self postMessageToWall:message withDelegate:self];
}


/*
 * @purpose
 *		Delete an message with id
 *		NOTE that action only was performed if user is logged in FB account
 * @param
 *		postId - id of message was deleted
 * @return 
 */
- (void) deletePostWithId:(NSString *)postId withDelegate:(id <FBRequestDelegate>)delegate {
	if (isLoggedIn) {
		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   @"DELETE", @"method",
									   nil];
		[facebook requestWithGraphPath:postId
							 andParams:params
						 andHttpMethod:@"POST" 
						   andDelegate:delegate];
	}
}
- (void) deletePostWithId:(NSString *)postId {
	[self deletePostWithId:postId withDelegate:self];
}

/*
 * @purpose
 *		Cached user information of user (access token, epiration date)
 * @param
 * @return
 */
- (void)fbDidLogin {
	[self didLogin];
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
	[self didLogout];
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
	NSLog(@"received response: %@", request.responseText);
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
	NSLog(@"request finish: %@", request.responseText);
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
	NSLog(@"%@", [error localizedDescription]);
}


@end
