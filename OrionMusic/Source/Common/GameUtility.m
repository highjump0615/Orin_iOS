//
//  GameUtility.m
//  OrionMusic
//
//  Created by TianHang on 10/9/13.
//
//

#import "GameUtility.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"



@implementation UserProfile

@synthesize userName;
@synthesize password;
@synthesize fullName;
@synthesize website;
@synthesize aboutme;
@synthesize email;
@synthesize phone;
@synthesize gender;

@synthesize fromSocial;

@synthesize badges;
@synthesize followers;
@synthesize following;
@synthesize isFollowed;

@synthesize hiphopCount;
@synthesize rnbCount;
@synthesize afrobeatCount;
@synthesize otherLikeCount;

@synthesize inviteCount;
@synthesize downloadCount;
@synthesize shareCount;

@synthesize imageProfile;
@synthesize imageProfileBack;


- (UIImage*)imageProfile {
	return [GameUtility imageProfile:self.userName];
}

- (UIImage*)imageProfileBack {
	return [GameUtility imageProfileBack:self.userName];
}


@end



@protocol RunningServiceDelegate;

@implementation GameUtility

@synthesize serviceDelegate;
@synthesize userProfile = m_userProfile;
@synthesize bShareUnlock;
@synthesize bPushNotification;
@synthesize bUpdatedPhoto;


@synthesize mstrToken;

+ (id)sharedObject {
	static GameUtility* utils = nil;
	if(utils == nil) {
		utils = [[GameUtility alloc] init];
	}
	return utils;
}

- (id)init {
	self = [super init];
	if(self) {
		bShareUnlock = YES;
        bPushNotification = YES;
        bUpdatedPhoto = YES;
	}
	return self;
}

- (void) updateCountValue {
	NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
						 m_userProfile.userName, @"name",
						 m_userProfile.inviteCount, @"invite",
 						 m_userProfile.downloadCount, @"itune",
						 m_userProfile.shareCount, @"share",
						 nil];
	[self runWebService:@"updatecountvalue" Param:dic Delegate:self View:nil];
}

+ (UIImage*)imageProfile:(NSString*)userName {
	NSString* fileURLString = [NSString stringWithFormat:@"%@/userimage/%@.jpg", SERVER_PATH, userName];
    NSURL *fileURL = [NSURL URLWithString:fileURLString];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    UIImage *profileImage = [[UIImage alloc] initWithData:data];
    
    if (!profileImage)
        return [UIImage imageNamed:@"Unknown_character.png"];
    
    return profileImage;
}

+ (UIImage*)imageProfileBack:(NSString*)userName {
	NSString* fileURLString = [NSString stringWithFormat:@"%@/backimage/%@.jpg", SERVER_PATH, userName];
    NSURL *fileURL = [NSURL URLWithString:fileURLString];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    UIImage *profileImage = [[UIImage alloc] initWithData:data];
    
    if (!profileImage) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
            return [UIImage imageNamed:@"sheet_background.png"];
        }
    }
    
    return profileImage;
}

+ (void)setImageFromUrl:(NSString*)imageUrl target:(id)targetCtrl defaultImg:(NSString *)strImg  {
    
    NSURL *urlImage = [NSURL URLWithString:imageUrl];
    
	if (urlImage) {
        
        UIView *targetView = targetCtrl;
        UIView *progressView = [[UIView alloc] initWithFrame:targetView.frame];
        
		progressView = [[UIView alloc] initWithFrame:targetView.frame];
        progressView.frame = CGRectMake(0, 0, targetView.frame.size.width, targetView.frame.size.height);
        
		progressView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
		UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        spinner.center = CGPointMake(targetView.frame.size.width / 2, targetView.frame.size.height / 2);
        
		[spinner startAnimating];
		[progressView addSubview:spinner];
        
		[targetView addSubview:progressView];
        
        
        if ([targetCtrl isKindOfClass:[UIButton class]]) {
            UIButton *targetBtn = targetCtrl;
            // Here we use the new provided setImageWithURL: method to load the web image
            [targetBtn setImageWithURL:[NSURL URLWithString:imageUrl]
                              forState:UIControlStateNormal
                      placeholderImage:[UIImage imageNamed:strImg]
                               options:SDWebImageRetryFailed
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                 // remove spinner
                                 if (progressView != nil) {
                                     [progressView setHidden:YES];
                                     [progressView removeFromSuperview];
                                 }
                             }];
        }
        else if ([targetCtrl isKindOfClass:[UIImageView class]]) {
            UIImageView *targetImg = targetCtrl;
            // Here we use the new provided setImageWithURL: method to load the web image
            [targetImg setImageWithURL:[NSURL URLWithString:imageUrl]
                      placeholderImage:[UIImage imageNamed:strImg]
                               options:SDWebImageRetryFailed
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                 // remove spinner
                                 if (progressView != nil) {
                                     [progressView setHidden:YES];
                                     [progressView removeFromSuperview];
                                 }
                             }];
        }
	}
}


- (NSArray*)getTotalBadges {
	NSMutableArray* aryBadges = [NSMutableArray arrayWithCapacity:20];
	
	[aryBadges addObject:@"Badge_Newbie"];
	[aryBadges addObject:@"Badge_Rising Star"];
	[aryBadges addObject:@"Badge_Super Star"];
	[aryBadges addObject:@"Badge_Connoisseur"];
	[aryBadges addObject:@"Badge_Maestro"];
	[aryBadges addObject:@"Badge_Pro"];
	[aryBadges addObject:@"Badge_Hip-Hop"];
	[aryBadges addObject:@"Badge_RnB"];
	[aryBadges addObject:@"Badge_Afro-beat"];
    [aryBadges addObject:@"Badge_Crunked"];
	[aryBadges addObject:@"Badge_Buyer"];
	[aryBadges addObject:@"Badge_Sharer"];
    
    return aryBadges;
}

- (NSArray*)getBadges:(UserProfile*)profile {
	NSMutableArray* aryBadges = [NSMutableArray arrayWithCapacity:20];
	
	[aryBadges addObject:@"Badge_Newbie"];
//	[aryBadges addObject:@"Badge_Rising Star"];
//	[aryBadges addObject:@"Badge_Super Star"];
//	[aryBadges addObject:@"Badge_Connoisseur"];
//	[aryBadges addObject:@"Badge_Maestro"];
//	[aryBadges addObject:@"Badge_Pro"];
//	[aryBadges addObject:@"Badge_Crunked"];
//	[aryBadges addObject:@"Badge_Hip-Hop"];
//	[aryBadges addObject:@"Badge_RnB"];
//	[aryBadges addObject:@"Badge_Afro-beat"];
//	[aryBadges addObject:@"Badge_Buyer"];
//	[aryBadges addObject:@"Badge_Sharer"];
	
	if(profile.inviteCount >= 20)
		[aryBadges addObject:@"Badge_Rising Star"];
	if(profile.following >= 100)
		[aryBadges addObject:@"Badge_Super Star"];
	
	int nLikeCount = profile.hiphopCount + profile.rnbCount + profile.afrobeatCount + profile.otherLikeCount;
	if(nLikeCount >= 50)
		[aryBadges addObject:@"Badge_Connoisseur"];
	if(nLikeCount >= 100)
		[aryBadges addObject:@"Badge_Maestro"];
	if(nLikeCount >= 300)
		[aryBadges addObject:@"Badge_Pro"];
	if(nLikeCount >= 500)
		[aryBadges addObject:@"Badge_Crunked"];
	
	if(profile.hiphopCount >= 100)
		[aryBadges addObject:@"Badge_Hip-Hop"];
	if(profile.rnbCount >= 100)
		[aryBadges addObject:@"Badge_RnB"];
	if(profile.afrobeatCount >= 100)
		[aryBadges addObject:@"Badge_Afro-beat"];
	
	if(profile.downloadCount >= 50)
		[aryBadges addObject:@"Badge_Buyer"];
	if(profile.shareCount >= 100)
		[aryBadges addObject:@"Badge_Sharer"];
	
	return aryBadges;
}




#pragma mark- WebSevice

- (void)uploadPhoto:(UIImage*)image Name:(NSString*)fileName serviceName:(NSString *)serviceName {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/webservice.php", API_PATH]];
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
	request.requestMethod = @"POST";
	[request addPostValue:serviceName forKey:@"type"];
	[request addPostValue:fileName forKey:@"name"];
	
	// Upload an image
//	UIImage *img = [UIImage imageNamed:fileName];
	NSData *imageData = UIImageJPEGRepresentation(image, 90);
//	NSLog(@"imageData ==> %@", imageData);
	[request setData:imageData withFileName:fileName andContentType:@"image/jpeg" forKey:@"image"];
	[request setDelegate:self];
	[request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
//	[[[UIAlertView alloc]
//	   initWithTitle:@"Message"
//	   message:@"Success!!!"
//	   delegate:self
//	   cancelButtonTitle:@"OK"
//	   otherButtonTitles:nil]
//	 show];
	NSString* response = [request responseString];
	NSLog(@"requestFinished : %@", response);
	
	NSError* error;
	id dic = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
	if([dic[@"status"] isEqualToString:@"OK"]) {
		[self.serviceDelegate finishedRunningServiceDelegate:dic];
	}
	else {
		 
	}
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width height:(float)i_height
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, i_height));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString*)stringFromImage:(UIImage*)image {
    if(image) {
		UIImage* convertImage = [GameUtility imageWithImage:image scaledToSize:CGSizeMake(80, 80)];
        NSData *dataObj = UIImageJPEGRepresentation(convertImage, 30);
        return [dataObj base64Encoding];
    }
	return @"";
}

- (UIImage*)imageFromString:(NSString*)imageString {
    NSData* imageData =[[NSData alloc] initWithBase64Encoding:imageString];
    return [UIImage imageWithData:imageData];
}

- (void)runWebService:(NSString*)type Param:(NSDictionary*)param Delegate:(id)delegate View:(UIView*)displayView {
	NSMutableString* strApi = [NSMutableString stringWithFormat:@"%@/webservice.php?type=%@", API_PATH, type];
	if([type isEqualToString:@"uploadphoto"]) {
		UIImage* image = param[@"photo"];
		NSString* fileName = param[@"name"];
		UIImage* convertImage = [GameUtility imageWithImage:image scaledToSize:CGSizeMake(100, 100)];
		[self uploadPhoto:convertImage Name:fileName serviceName:@"uploadphoto"];
		return;
	}
    else if([type isEqualToString:@"uploadprofileback"]) {
		UIImage* image = param[@"photo"];
		NSString* fileName = param[@"name"];
		UIImage* convertImage = [GameUtility imageWithImage:image scaledToSize:CGSizeMake(320, 290)];
		[self uploadPhoto:convertImage Name:fileName serviceName:@"uploadprofileback"];
		return;
	}
    
	if (param != nil) {
		for(NSString* strKey in param.allKeys) {
			id data = [param objectForKey:strKey];
			if([data isKindOfClass:[NSString class]]) {
				NSString* str = [GameUtility urlencode:data];
				[strApi appendFormat:@"&%@=%@", strKey, str];
			}
			else if([data isKindOfClass:[UIImage class]]) {
//				NSData *dataObj = UIImageJPEGRepresentation(convertImage, 30);
//				NSString* str = [self stringFromImage:data];
//				[strApi appendFormat:@"&%@=%@", strKey, str];
			}
			else {
				return;
			}
		}
	}
	[self runWebService:strApi Delegate:delegate View:displayView];
}

- (void)runWebService:(NSString*)strURL Delegate:(id)delegate View:(UIView*)displayView {
	self.serviceDelegate = delegate;
	
	NSLog(@"excuteApi=%@", strURL);
	
	static UIView* overlayView = nil;
	
	if (displayView != nil) {
		
		if(overlayView) {
			[overlayView removeFromSuperview];
			overlayView = nil;
		}
	//	UIView* overlayView = [displayView viewWithTag:1000000];
		overlayView = [[UIView alloc] initWithFrame:displayView.frame];
        CGRect rt = [[UIScreen mainScreen] bounds];
        
        if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
            overlayView.frame = CGRectMake(0, 0, rt.size.width, rt.size.height);
        }
        else {
            overlayView.frame = CGRectMake(0, 0, rt.size.height, rt.size.width);
        }
        
		overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		spinner.center = displayView.center;
		spinner.color = [UIColor grayColor];
		[spinner startAnimating];
		[overlayView addSubview:spinner];
        
        [displayView.window addSubview:overlayView];
		[displayView addSubview:overlayView];
		overlayView.tag = 1000000;
	}

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		//code executed in the background
		NSData* kivaData = [NSData dataWithContentsOfURL:
							[NSURL URLWithString:strURL]
							];
		NSDictionary* json = nil;
		NSError* error = nil;
		if (kivaData) {
			json = [NSJSONSerialization
					JSONObjectWithData:kivaData
					options:kNilOptions
					error:&error];
			if(error)
				NSLog(@"error: %@", error);
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			//code executed on the main queue
			
//			UIActivityIndicatorView* spinner = (UIActivityIndicatorView*)[displayView viewWithTag:1000000];
//			[spinner stopAnimating];
			if (overlayView != nil) {
				[overlayView setHidden:YES];
				[overlayView removeFromSuperview];
				overlayView = nil;
				NSLog(@"[overlayView removeFromSuperview];");
			}
			[self receivedJson:json];
//			curView.userInteractionEnabled = YES;
		});
	});
}

- (void)receivedJson:(NSDictionary*)json {
	if(json == nil) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network is fail" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
//	NSString* status = json[@"status"];
//	if([status isEqualToString:@"Error"]) {
//		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is no registered user" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		return;
//	}
	[self.serviceDelegate finishedRunningServiceDelegate:json];
}

#pragma mark- static

+ (NSString*)urlencode:(NSString*)url
{
	if(url == nil)
		return nil;
	NSMutableString *escaped = [[NSMutableString alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSRange wholeString = NSMakeRange(0, escaped.length);
	[escaped replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:wholeString];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:wholeString];
	return escaped;
}

+ (void)setPhoneFrame:(UIView *)targetView withHeader:(BOOL)bwithHeader {
    
    int nHeight = 0;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        if (iPhone5) {
            nHeight = 568;
        }
        else {
            nHeight = 480;
        }
        
        if (bwithHeader) {
            nHeight -= 64;
        }
        
        [targetView setFrame:CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y, targetView.frame.size.width, nHeight)];
    }
    else {
        nHeight = 768;
        
        if (bwithHeader) {
            nHeight -= 64;
        }
        
        [targetView setFrame:CGRectMake(targetView.frame.origin.x, targetView.frame.origin.y, 1024, nHeight)];
    }
}

@end
