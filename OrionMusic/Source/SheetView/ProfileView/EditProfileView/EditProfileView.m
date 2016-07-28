//
//  EditProfileView.m
//  OrionMusic
//
//  Created by TianHang on 10/19/13.
//
//

#import "EditProfileView.h"
#import "ChangePwdView.h"
#import "GameUtility.h"
#import "ProfileViewController.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"

@interface EditProfileView ()

@end

@implementation EditProfileView

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"edit profile view: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [GameUtility setPhoneFrame:self.view withHeader:NO];
    
	UserProfile* profile = [[GameUtility sharedObject] userProfile];
	m_textFullName.text = profile.fullName;
	m_textUserName.text = profile.userName;
//	m_textWebsite.text = profile.website;
	m_textAboutMe.text = profile.aboutme;
	m_textEmail.text = profile.email;
	m_textPhone.text = profile.phone;
	[m_segGender setSelectedSegmentIndex:profile.gender];
    
    NSString* fileURLString = [NSString stringWithFormat:@"%@/userimage/%@.jpg", SERVER_PATH, profile.userName];
    [GameUtility setImageFromUrl:fileURLString target:m_btnUserPicture defaultImg:@"Unknown_character.png"];
    
    m_imgBackground = nil;
    m_bPhotoSelected = NO;
    
    NSLog(@"scroll view: %f, %f, %f, %f", self.m_scrollView.frame.origin.x, self.m_scrollView.frame.origin.y, self.m_scrollView.frame.size.width, self.m_scrollView.frame.size.height);
    [self.m_scrollView setContentSize:CGSizeMake(self.m_scrollView.frame.size.width, 502)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onDone:(id)sender {
	NSDictionary* dic= [NSDictionary dictionaryWithObjectsAndKeys:
						m_textUserName.text, @"name",
						m_textEmail.text, @"email",
						m_textFullName.text, @"fullname",
//						m_textWebsite.text, @"website",
						m_textAboutMe.text, @"aboutme",
						m_textPhone.text, @"phone",
						[NSString stringWithFormat:@"%d", m_segGender.selectedSegmentIndex], @"gender",
						nil];
	GameUtility* utils = [GameUtility sharedObject];
	[utils runWebService:@"setuserprofile" Param:dic Delegate:self View:self.view];
}

- (IBAction)onChangePasswd:(id)sender {
	ChangePwdView* controller = [[ChangePwdView alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onUserPhoto:(id)sender {
    m_nPhotoImage = 1;
    
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)onBackgroundUpload:(id)sender {
    m_nPhotoImage = 2;
    
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    if (m_nPhotoImage == 1) {   // photo image
        [m_btnUserPicture setImage:image forState:UIControlStateNormal];
        m_bPhotoSelected = YES;
    }
    else if (m_nPhotoImage == 2) {  // background image
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3f);
        UIImage *processedImage = [UIImage imageWithData:imageData];
        m_imgBackground = processedImage;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

static BOOL bAnimation = NO;
- (void)textFieldDidBeginEditing:(UITextField*)sender
{
    if ([sender isEqual:m_textEmail] || [sender isEqual:m_textPhone]) {
        //move the main view, so that the keyboard does not hide it.
		bAnimation = YES;
    }
	else {
		bAnimation = NO;
	}
}

#pragma mark - KeyBoard notifications
- (void)keyboardWillShow:(NSNotification*)notify {
	CGRect rtKeyBoard = [(NSValue*)[notify.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        [self animationView:-100];
    }
    else {
        [self animationView:-rtKeyBoard.size.height];
    }
}

- (void)keyboardWillHide:(NSNotification*)notify {
	[self animationView:0];
}

- (void)animationView:(CGFloat)yPos {
	if(bAnimation == NO)
		return;
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

#pragma -mark WebService
- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {
	NSString* serviceName = outData[@"serviceName"];
    UserProfile* profile = [[GameUtility sharedObject] userProfile];
    
	if([serviceName isEqualToString:@"setuserprofile"]) {
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
			UserProfile* profile = [[GameUtility sharedObject] userProfile];
			profile.userName = m_textUserName.text;
			profile.email = m_textEmail.text;
			profile.fullName = m_textFullName.text;
//			profile.website = m_textWebsite.text;
			profile.aboutme = m_textAboutMe.text;
			profile.phone = m_textPhone.text;
			profile.gender = m_segGender.selectedSegmentIndex;
			
            GameUtility* utils = [GameUtility sharedObject];
            
            if (m_imgBackground) {
                NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     m_imgBackground, @"photo",
                                     profile.userName, @"name",
                                     nil];
                [utils runWebService:@"uploadprofileback" Param:dic Delegate:self View:self.view];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"Uploading Background...";
            }
            else {
                [self uploadPhotoImg];
            }
		}
	}
    else if([serviceName isEqualToString:@"uploadprofileback"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
            
            NSString* fileURLString = [NSString stringWithFormat:@"%@/backimage/%@.jpg", SERVER_PATH, profile.userName];
            [[SDImageCache sharedImageCache] removeImageForKey:fileURLString fromDisk:YES];
//            [[SDImageCache sharedImageCache] removeImageForKey:@"sheet_background.png" fromDisk:YES];
//            [[SDImageCache sharedImageCache] clearMemory];
//            [[SDImageCache sharedImageCache] clearDisk];
//            [[SDImageCache sharedImageCache] cleanDisk];

            
			[self uploadPhotoImg];
		}
		else {
			NSLog(@"upload background Error");
		}
	}
	else if([serviceName isEqualToString:@"uploadphoto"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
		NSString* result = outData[@"status"];
		if([result isEqualToString:@"OK"]) {
            
            NSString* fileURLString = [NSString stringWithFormat:@"%@/userimage/%@.jpg", SERVER_PATH, profile.userName];
            [[SDImageCache sharedImageCache] removeImageForKey:fileURLString fromDisk:YES];
            
			[self.delegate editProfileDoneDelegate:self];
			[self.navigationController popViewControllerAnimated:YES];
            
            GameUtility* utils = [GameUtility sharedObject];
            utils.bUpdatedPhoto = YES;
		}
		else {
			NSLog(@"uploadphoto Error");
		}
	}
}

- (void) uploadPhotoImg {
    GameUtility* utils = [GameUtility sharedObject];
    UserProfile* profile = [utils userProfile];
    
    if (m_bPhotoSelected) {
        UIImage* image = m_btnUserPicture.imageView.image;
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             image, @"photo",
                             profile.userName, @"name",
                             nil];
        [utils runWebService:@"uploadphoto" Param:dic Delegate:self View:self.view];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Uploading Photo...";
    }
    else {
        [self.delegate editProfileDoneDelegate:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
