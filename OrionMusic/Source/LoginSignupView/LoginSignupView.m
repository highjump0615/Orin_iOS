//
//  LoginSignupView.m
//  Orin
//
//  Created by TianHang on 12/6/13.
//  Copyright (c) 2013 234 Digital Limited. All rights reserved.
//

#import "LoginSignupView.h"
#import "MenuView.h"

@interface LoginSignupView ()

@end

@implementation LoginSignupView

- (void)initString {
    m_strUsername = @"";
    m_strPassword = @"";
    m_strEmail = @"";
    m_strFullname = @"";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initString];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)animationView:(CGFloat)yPos {
	if(yPos == self.view.frame.origin.y)
		return;
    //	self.view.userInteractionEnabled = NO;
	[UIView animateWithDuration:0.2
					 animations:^{
						 CGRect rt = self.view.frame;
						 rt.origin.y = yPos;
						 self.view.frame = rt;
					 }completion:^(BOOL finished) {
                         //						 self.view.userInteractionEnabled = YES;
                     }];
}

#pragma mark - KeyBoard notifications
- (void)keyboardWillShow:(NSNotification*)notify {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        [self animationView:-280];
    }
    else {
//        [self animationView:-100];
    }
}

- (void)keyboardWillHide:(NSNotification*)notify {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        [self animationView:0];
    }
}

- (void)forgetRequest:(NSString *)strEmail {
    GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 strEmail, @"email",
						 nil];
	[utils runWebService:@"requestpassword" Param:dic Delegate:self View:self.view];
}

- (void)doLogin:(NSString *)strUsername password:(NSString *)strPassword {
    m_strUsername = strUsername;    // potential error
    m_strPassword = strPassword;    // potential error
    
    GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 m_strUsername, @"name",
						 m_strPassword, @"password",
						 utils.mstrToken, @"token",
						 nil];
	[utils runWebService:@"login" Param:dic Delegate:self View:self.view];
}

- (void)doSignup:(NSString *)strUsername password:(NSString *)strPassword email:(NSString *)strEmail {
    m_strUsername = strUsername;    // potential error
    m_strPassword = strPassword;    // potential error
    m_strEmail = strEmail;          // potential error
    
    GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 strUsername, @"name",
						 strPassword, @"password",
						 strEmail, @"email",
                         utils.mstrToken, @"token",
						 nil];
	[utils runWebService:@"register" Param:dic Delegate:self View:self.view];
}

- (void)loginFromFacebook {
    GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 m_strUsername, @"name",
						 m_strEmail, @"email",
                         m_strFullname, @"fullname",
                         utils.mstrToken, @"token",
						 nil];
	[utils runWebService:@"loginfacebook" Param:dic Delegate:self View:self.view];
}

- (void)loginFromTwitter {
    GameUtility* utils = [GameUtility sharedObject];
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 m_strUsername, @"name",
                         utils.mstrToken, @"token",
						 nil];
	[utils runWebService:@"logintwitter" Param:dic Delegate:self View:self.view];
}

- (void)processLogin:(int)fromSocial {
	GameUtility* utils = [GameUtility sharedObject];
	UserProfile*  profile = [[UserProfile alloc] init];
	profile.userName = [NSString stringWithString:m_strUsername];
	profile.password = m_strPassword;
    profile.fullName = [NSString stringWithString:m_strFullname];
    profile.fromSocial = fromSocial;
	utils.userProfile = profile;
	
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 m_strUsername, @"name",
						 nil];
    
	[utils runWebService:@"getuserprofile" Param:dic Delegate:self View:self.view];
    
    
    // save to NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:m_strUsername forKey:@"username"];
    [userDefaults setObject:[NSNumber numberWithInt:fromSocial] forKey:@"fromsocial"];
    [userDefaults synchronize];
}

#pragma -mark WebService
- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {
	NSString* serviceName = outData[@"serviceName"];
    GameUtility* utils = [GameUtility sharedObject];
    
	if([serviceName isEqualToString:@"login"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			[self processLogin:0];
		}
		else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or password is wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
    else if([serviceName isEqualToString:@"register"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"Error"]) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your name or email is registered already" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			return;
		}
        
        // sign up success, log in
        [self processLogin:0];
	}
    else if([serviceName isEqualToString:@"loginfacebook"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			[self processLogin:1];
		}
		else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Login Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
    else if([serviceName isEqualToString:@"logintwitter"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			[self processLogin:2];
		}
		else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Someone who has same username already exists. Please use your email to register." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
    else if([serviceName isEqualToString:@"requestpassword"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The password is already sent to you thorugh email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
		else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your email is not registered or you are registered with social platform" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
		}
	}
	else if([serviceName isEqualToString:@"getuserprofile"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			NSDictionary* resDic = outData[@"info"];
			
			UserProfile* profile = utils.userProfile;
			profile.email = resDic[@"email"];
			profile.fullName = resDic[@"fullname"];
			profile.website = resDic[@"website"];
			profile.aboutme = resDic[@"aboutme"];
			profile.phone = resDic[@"phone"];
			profile.gender = [resDic[@"gender"] integerValue];
			
			profile.followers = [resDic[@"follower"] integerValue];
			profile.following = [resDic[@"following"] integerValue];
			
			profile.inviteCount = [resDic[@"invitecount"] integerValue];
			profile.downloadCount = [resDic[@"itunecount"] integerValue];
			profile.shareCount = [resDic[@"sharecount"] integerValue];
			
			NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
								 utils.userProfile.userName, @"name",
								 nil];
            
			[utils runWebService:@"getmusiclikecount" Param:dic Delegate:self View:self.view];
            
            m_strUsername = @"";
		}
		else {
		}
	}
	else if([serviceName isEqualToString:@"getmusiclikecount"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			NSDictionary* resDic = outData[@"info"];
			GameUtility* utils = [GameUtility sharedObject];
			UserProfile* profile = utils.userProfile;
			profile.hiphopCount = [resDic[@"hiphop"] integerValue];
			profile.rnbCount = [resDic[@"rnb"] integerValue];
			profile.afrobeatCount = [resDic[@"afrobeat"] integerValue];
			profile.otherLikeCount = [outData[@"count"] integerValue] - profile.hiphopCount - profile.rnbCount - profile.afrobeatCount;
			
			MenuView* controller = [[MenuView alloc] initWithNibName:@"MenuView" bundle:nil];
			[self.navigationController pushViewController:controller animated:YES];
		}
	}
}


@end


