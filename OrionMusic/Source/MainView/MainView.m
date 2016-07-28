//
//  MainView.m
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import "MainView.h"
#import "TourView.h"
#import "MenuView.h"
#import "LoginView.h"
#import "SignupView.h"

#import "AppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MainView ()

@end

@implementation MainView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FBLoginView *fbLoginview = [[FBLoginView alloc] init];
    fbLoginview.readPermissions = @[@"email"];
    fbLoginview.publishPermissions = @[@"publish_stream"];
    fbLoginview.defaultAudience = FBSessionDefaultAudienceEveryone;

	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            fbLoginview.frame = CGRectMake(653, 572, 258, 35);
        }
        else {
            fbLoginview.frame = CGRectMake(31, 455, 258, 37);
        }
    }
    else {
        fbLoginview.frame = CGRectMake(31, 435, 258, 37);
    }
    
    fbLoginview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    for (id obj in fbLoginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton *loginButton =  obj;
            loginButton.frame = CGRectMake(0, 0, 258, 35);
            loginButton.contentMode = UIViewContentModeScaleToFill;
            UIImage *loginImage = [UIImage imageNamed:@"signup_facebook_but.png"];
            [loginButton setImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            
            loginLabel.hidden = YES;
            
            loginLabel.text = @"";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.frame = CGRectMake(0, 0, 271, 37);
        }
    }
    
    fbLoginview.delegate = self;
    
    [self.view addSubview:fbLoginview];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    // read from NSUserDefault
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    m_strUsername = [userDefaultes stringForKey:@"username"];
    NSString *socialNum = [userDefaultes stringForKey:@"fromsocial"];
    if (m_strUsername != nil && ![m_strUsername isEqualToString:@""]) {
        [self processLogin:[socialNum intValue]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginFaceBook:(id)sender {
}


- (IBAction)onLoginTwitter:(id)sender {
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (!appDelegate._engine) {
        appDelegate._engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
        appDelegate._engine.consumerKey = kOAuthConsumerKey;
        appDelegate._engine.consumerSecret = kOAuthConsumerSecret;
    }
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:appDelegate._engine delegate: self];
	
	if (controller) {
		[self presentViewController: controller animated: YES completion:^{
		}];
    }
	else {
		[appDelegate._engine sendUpdate: [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]]];
	}

}

- (IBAction)onLoginMail:(id)sender {
	[self showLoginView];
}

- (IBAction)onSignupMail:(id)sender {
    
    // Show Signup View
    SignupView *controller = [[SignupView alloc] initWithNibName:@"SignupView" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showLoginView {
	LoginView* controller = [[LoginView alloc] initWithNibName:@"LoginView" bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"loginViewFetchedUserInfo");
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    NSLog(@"loginViewShowingLoggedInUser");

    if (m_strUsername == nil || [m_strUsername isEqualToString:@""]) {
        // Fetch user data
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,
                                                               id<FBGraphUser> fbUserData,
                                                               NSError *error) {
            [self initString];
            
            if (!error) {
                m_strEmail = [NSString stringWithString:[fbUserData objectForKey:@"email"]];
                m_strUsername = [NSString stringWithString:[fbUserData objectForKey:@"username"]];
                
                if ((m_strUsername != nil && ![m_strUsername isEqualToString:@""]) &&
                    (m_strEmail != nil && ![m_strEmail isEqualToString:@""])) {
                    
                    m_strFullname = [NSString stringWithString:[fbUserData objectForKey:@"name"]];
                    
                    [self loginFromFacebook];
                    
                    return;
                }
            }
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured while fetching user data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            [FBSession.activeSession closeAndClearTokenInformation];
        }];
    }
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
    NSLog(@"storeCachedTwitterOAuthData: data=%@, username=%@", data, username);
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	NSLog(@"Authenicated for %@", username);
    
    if (username != nil && ![username isEqualToString:@""]) {
        
        m_strUsername = [NSString stringWithString:username];
        
        [self loginFromTwitter];
        
        return;
    }
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Twitter Authentication Failed!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	NSLog(@"Authentication Canceled.");
}

@end
