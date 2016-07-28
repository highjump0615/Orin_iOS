//
//  LoginSignupView.h
//  Orin
//
//  Created by TianHang on 12/6/13.
//  Copyright (c) 2013 234 Digital Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameUtility.h"




@interface LoginSignupView : UIViewController <RunningServiceDelegate> {
    NSString *m_strUsername;
    NSString *m_strPassword;
    NSString *m_strEmail;
    NSString *m_strFullname;
}

- (void)initString;
- (void)doLogin:(NSString *)strUsername password:(NSString *)strPassword;
- (void)doSignup:(NSString *)strUsername password:(NSString *)strPassword email:(NSString *)strEmail;
- (void)forgetRequest:(NSString *)strEmail;

- (void)loginFromFacebook;
- (void)loginFromTwitter;
- (void)processLogin:(int)fromSocial;

@end
