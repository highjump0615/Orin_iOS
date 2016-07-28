//
//  GameUtility.h
//  OrionMusic
//
//  Created by TianHang on 10/9/13.
//
//

#import <Foundation/Foundation.h>

#define API_PATH @"http://orin.io/webservice/api/1.0"
#define SERVER_PATH @"http://orin.io/webservice"
//#define API_PATH @"http://www.twoservices.net/work/tian/orion"

@interface UserProfile : NSObject

@property (strong) NSString* userName;
@property (strong) NSString* password;
@property (strong) NSString* fullName;
@property (strong) NSString* website;
@property (strong) NSString* aboutme;
@property (strong) NSString* email;
@property (strong) NSString* phone;
@property (nonatomic) NSInteger gender;

@property (nonatomic) NSInteger fromSocial;     // 1: facebook
                                                // 2: twitter
                                                // 0: none

@property (nonatomic) NSInteger badges;
@property (nonatomic) NSInteger followers;
@property (nonatomic) NSInteger following;
@property (nonatomic) BOOL isFollowed;

@property (nonatomic) NSInteger hiphopCount;
@property (nonatomic) NSInteger rnbCount;
@property (nonatomic) NSInteger afrobeatCount;
@property (nonatomic) NSInteger otherLikeCount;

@property (nonatomic) NSInteger inviteCount;
@property (nonatomic) NSInteger downloadCount;
@property (nonatomic) NSInteger shareCount;

@property (strong, nonatomic) UIImage* imageProfile;
@property (strong, nonatomic) UIImage* imageProfileBack;

@end


@protocol RunningServiceDelegate;

@interface GameUtility : NSObject {
	id <RunningServiceDelegate> serviceDelegate;
	UserProfile*	m_userProfile;
}

@property (strong) id <RunningServiceDelegate> serviceDelegate;
@property (strong) UserProfile* userProfile;
@property (nonatomic) BOOL bShareUnlock;
@property (nonatomic) BOOL bPushNotification;

@property (nonatomic) BOOL bUpdatedPhoto;

@property (strong) NSString* mstrToken;

+ (id)sharedObject;
- (void)runWebService:(NSString*)strURL Delegate:(id)delegate View:(UIView*)displayView;
- (void)runWebService:(NSString*)type Param:(NSDictionary*)param Delegate:(id)delegate View:(UIView*)displayView;
+ (NSString*)urlencode:(NSString*)url;
+ (void)setPhoneFrame:(UIView *)targetView withHeader:(BOOL)bwithHeader;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width height:(float)i_height;
+ (void)setImageFromUrl:(NSString*)imageUrl target:(id)targetCtrl defaultImg:(NSString *)strImg;

- (NSArray*)getTotalBadges;
- (NSArray*)getBadges:(UserProfile*)profile;
+ (UIImage*)imageProfile:(NSString*)userName;
+ (UIImage*)imageProfileBack:(NSString*)userName;

- (void) updateCountValue;

@end

@protocol RunningServiceDelegate <NSObject>
- (void)finishedRunningServiceDelegate:(NSDictionary*)outData;
@end
