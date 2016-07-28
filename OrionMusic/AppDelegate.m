//
//  AppDelegate.m
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import "AppDelegate.h"
#import "MainView.h"
#import "Appirater.h"
#import <Crashlytics/Crashlytics.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "GameUtility.h"

#import <FacebookSDK/FacebookSDK.h>
#import "UIViewController+OrientationFix.h"

@implementation AppDelegate

@synthesize _engine;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    UIImage *image = [UIImage imageNamed:@"logo.png"];
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	self.viewController = [[MainView alloc] initWithNibName:@"MainView" bundle:nil];
	
	self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
	self.navigationController.view.frame = [[UIScreen mainScreen] bounds];
    [self.window setRootViewController:self.navigationController];
	self.navigationController.navigationBarHidden = YES;
    
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    
	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    [self.window makeKeyAndVisible];
	[Appirater setAppId:@"729548913"];
    [Crashlytics startWithAPIKey:@"42bba0238ec262ee7b802ca612510be4af811a13"];
//	[Appirater setDaysUntilPrompt:1];
//	[Appirater setUsesUntilPrompt:10];
//	[Appirater setSignificantEventsUntilPrompt:-1];
//	[Appirater setTimeBeforeReminding:2];
//	[Appirater setDebug:YES];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
		
		[application setStatusBarStyle:UIStatusBarStyleLightContent];
		
//        self.window.clipsToBounds =YES;
		
//        self.window.frame =  CGRectMake(0,0,self.window.frame.size.width,self.window.frame.size.height);
    }
    
    return YES;
}

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)w {
//    
//    return (NSUInteger)[application supportedInterfaceOrientationsForWindow:w] | (1<<UIInterfaceOrientationPortrait);
//    
//}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // if the app is going away, we close the session object
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];

	NSLog(@"My token is: %@", newToken);
	
    GameUtility *util = [GameUtility sharedObject];
	util.mstrToken = [NSString stringWithString:newToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
	
	UserProfile* profile = [[GameUtility sharedObject] userProfile];
	if (profile != nil) {
	}
	
//	[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}



@end


