//
//  MainView.h
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import <UIKit/UIKit.h>

#import <FacebookSDK/FacebookSDK.h>
#import "SA_OAuthTwitterController.h"
#import "LoginSignupView.h"


@interface MainView : LoginSignupView <FBLoginViewDelegate, SA_OAuthTwitterControllerDelegate, SA_OAuthTwitterControllerDelegate> {
	
}

@end
