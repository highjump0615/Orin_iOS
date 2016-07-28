//
//  AppDelegate.h
//  OrionMusic
//
//  Created by TianHang on 10/5/13.
//
//

#import <UIKit/UIKit.h>

#import "SA_OAuthTwitterEngine.h"

#define kOAuthConsumerKey				@"70xPyMq1kqtdvm2QhGVhw"
#define kOAuthConsumerSecret			@"QCuv4kQSiad4A4lKkTDFXtwfERqzm6BNg2fvxIYwmPc"


@class MainView;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    SA_OAuthTwitterEngine *_engine;
	
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainView *viewController;
@property (strong, nonatomic) UINavigationController* navigationController;

@property (strong, nonatomic) SA_OAuthTwitterEngine *_engine;

@end
