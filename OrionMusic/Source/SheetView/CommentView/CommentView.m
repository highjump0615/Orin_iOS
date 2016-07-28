//
//  CommentView.m
//  OrionMusic
//
//  Created by TianHang on 10/10/13.
//
//

#import "CommentView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CommentData

@synthesize picture, userName, content, time;

@end



@interface CommentView ()

@end

@implementation CommentView

@synthesize m_nMusicID;
@synthesize m_nVideoID;

@synthesize m_chartItem;
@synthesize m_videoItem;


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
    // Do any additional setup after loading the view from its nib.
	m_aryComments = [[NSMutableArray alloc] initWithCapacity:256];
	m_btnComment.enabled = NO;
	m_textComment.placeholder = @"Write a comment";
	m_textComment.layer.borderWidth = 1.0f;
	m_textComment.layer.borderColor = [[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.8] CGColor];
	m_tableView.hidden = YES;
	m_labNoComment.hidden = YES;
	
	GameUtility* utils = [GameUtility sharedObject];
    
	
	if (m_chartItem == nil) {
		NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSString stringWithFormat:@"%d",self.m_nVideoID], @"videoid",
							 nil];
		[utils runWebService:@"getvideocomment" Param:dic Delegate:self View:self.view];
	}
	else {
		NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSString stringWithFormat:@"%d",self.m_nMusicID], @"musicid",
							 nil];
		[utils runWebService:@"getmusiccomment" Param:dic Delegate:self View:self.view];
	}
	
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

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onComment:(id)sender {
	if(m_textComment.text.length == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Fill comment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		return;
	}
	GameUtility* utils = [GameUtility sharedObject];
	
	if (m_chartItem == nil) {
		NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
							 utils.userProfile.userName, @"username",
							 [NSString stringWithFormat:@"%d",self.m_nVideoID], @"videoid",
							 m_textComment.text, @"content",
							 nil];
		[utils runWebService:@"addvideocomment" Param:dic Delegate:self View:self.view];
	}
	else {
		NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
							 utils.userProfile.userName, @"username",
							 [NSString stringWithFormat:@"%d",self.m_nMusicID], @"musicid",
							 m_textComment.text, @"content",
							 nil];
		[utils runWebService:@"addmusiccomment" Param:dic Delegate:self View:self.view];
	}
}

- (void)reloadData {
	[m_tableView reloadData];
	if(m_aryComments.count > 0) {
		m_tableView.hidden = NO;
		m_labNoComment.hidden = YES;
	}
	else {
		m_tableView.hidden = YES;
		m_labNoComment.hidden = NO;
	}
}

+ (NSDate *)combineDate:(NSDate *)date withTime:(NSDate *)time {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
    unsigned unitFlagsDate = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [gregorian components:unitFlagsDate fromDate:date];
    unsigned unitFlagsTime = NSHourCalendarUnit | NSMinuteCalendarUnit |  NSSecondCalendarUnit;
    NSDateComponents *timeComponents = [gregorian components:unitFlagsTime fromDate:time];
	
    [dateComponents setSecond:[timeComponents second]];
    [dateComponents setHour:[timeComponents hour]];
    [dateComponents setMinute:[timeComponents minute]];
	
    NSDate *combDate = [gregorian dateFromComponents:dateComponents];
	
    return combDate;
}

- (NSString*)makeCommentTimeString:(NSString*)strDateTime {
	NSString* strDate = [strDateTime substringToIndex:10];
	NSString* strTime = [strDateTime substringFromIndex:11];
	
	NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd"];
	NSDate* date = [dateFormat dateFromString:strDate];
	NSLog(@"%@", [dateFormat stringFromDate:date]);
	
	[dateFormat setDateFormat:@"HH:mm:ss"];
	NSDate* time = [dateFormat dateFromString:strTime];
	NSLog(@"%@", [dateFormat stringFromDate:time]);
	
	NSDate* dateTime = [CommentView combineDate:date withTime:time];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSLog(@"%@", [dateFormat stringFromDate:dateTime]);
	
	NSTimeZone *tz = [NSTimeZone defaultTimeZone];
	NSInteger seconds = [tz secondsFromGMTForDate:dateTime];
	NSDate* currentTime = [NSDate dateWithTimeInterval:seconds sinceDate:dateTime];
	NSTimeInterval second = -[currentTime timeIntervalSinceNow];
	int min = (int)second / 60;
    int hour = min / 60;
    int day = hour / 24;
	if(min < 0) {
		return @"";
	}
	else if(min < 60) {
		return [NSString stringWithFormat:@"%dm", min];
	}
	else if(min >= 60 && min < 60 * 24) {
		if(hour < 24) {
			return [NSString stringWithFormat:@"%dh", hour];
		}
    }
    else {
           return [NSString stringWithFormat:@"%dd", day];
    }
	return @"";
}

- (void)finishedRunningServiceDelegate:(NSDictionary *)outData {
	NSString* serviceName = outData[@"serviceName"];
	GameUtility* utils = [GameUtility sharedObject];

	if([serviceName isEqualToString:@"getvideocomment"] ||
	   [serviceName isEqualToString:@"getmusiccomment"]) {
		NSArray* ary = outData[@"info"];
		[m_aryComments removeAllObjects];
		for(id obj in ary) {
			NSString* strName = obj[@"username"];
			NSString* strComment = obj[@"content"];
			NSString* strDate = obj[@"time"];
			
			CommentData* data = [[CommentData alloc] init];
			data.userName = strName;
			data.content = strComment;
			data.time = [self makeCommentTimeString:strDate];
			[m_aryComments addObject:data];
		}
		
		[self reloadData];
		
		[m_textComment setText:@""];
	}
	else if([serviceName isEqualToString:@"addvideocomment"]) {
		NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSString stringWithFormat:@"%d",self.m_nVideoID], @"videoid",
							 nil];
		[utils runWebService:@"getvideocomment" Param:dic Delegate:self View:self.view];
		
        m_videoItem.m_nComments++;
		[m_videoItem showCommentNum];
		
		[m_textComment setText:@""];
	}
	else if ([serviceName isEqualToString:@"addmusiccomment"]) {
		NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSString stringWithFormat:@"%d",self.m_nMusicID], @"musicid",
							 nil];
		[utils runWebService:@"getmusiccomment" Param:dic Delegate:self View:self.view];
		
		m_chartItem.m_nComments++;
		[m_chartItem showCommentNum];
		
		[m_textComment setText:@""];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return m_aryComments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kSourceCellID = @"Comment";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSourceCellID];
    
    CommentData* data = [m_aryComments objectAtIndex:indexPath.row];
    
    // background
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 73)];
    backView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    backView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cell addSubview:backView];
    
    cell.backgroundColor = [UIColor clearColor];
    
    // user photo
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 50, 50)];
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:25.0];
    
    NSString* fileURLString = [NSString stringWithFormat:@"%@/userimage/%@.jpg", SERVER_PATH, data.userName];
    [GameUtility setImageFromUrl:fileURLString target:imageView defaultImg:@"Unknown_character.png"];
//    imageView.image = [GameUtility imageProfile:data.userName];
    [cell addSubview:imageView];
    
    // username
    UILabel* labelUserName = [[UILabel alloc] initWithFrame:CGRectMake(79, 8, 153, 22)];
    labelUserName.backgroundColor = [UIColor clearColor];
    labelUserName.textColor = [UIColor whiteColor];
    labelUserName.font = [UIFont systemFontOfSize:18];
    labelUserName.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:labelUserName];
    labelUserName.text = data.userName;
    
    // label comment
    UILabel* labelComment = [[UILabel alloc] initWithFrame:CGRectMake(79, 30, 234, 42)];
    labelComment.backgroundColor = [UIColor clearColor];
    labelComment.textColor = [UIColor whiteColor];
    labelComment.font = [UIFont systemFontOfSize:14];
    labelComment.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [cell addSubview:labelComment];
    labelComment.text = data.content;
    
    // clock image
    UIImageView* imgclock = [[UIImageView alloc] initWithFrame:CGRectMake(270, 15, 12, 12)];
    [imgclock setImage:[UIImage imageNamed:@"chart_clock.png"]];
    imgclock.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [cell addSubview:imgclock];
    
    // date
    UILabel* labelDate = [[UILabel alloc] initWithFrame:CGRectMake(286, 10, 27, 21)];
    labelDate.backgroundColor = [UIColor clearColor];
    labelDate.textColor = [UIColor whiteColor];
    labelDate.font = [UIFont systemFontOfSize:12];
//    labelDate.textAlignment = NSTextAlignmentRight;
    labelDate.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [cell addSubview:labelDate];
    labelDate.text = data.time;
		
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)animationView:(CGFloat)yPos {

    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait)
    { //phone

        CGSize sz = [[UIScreen mainScreen] bounds].size;
        if(yPos == sz.height - self.view.frame.size.height)
            return;
        self.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect rt = self.view.frame;
                             rt.size.height = sz.height - yPos;
                             self.view.frame = rt;
                         }completion:^(BOOL finished) {
                             self.view.userInteractionEnabled = YES;
                         }];
    }
    else
    { //pad
        CGSize sz = [[UIScreen mainScreen] bounds].size;
        
//        if(yPos == sz.height - self.view.frame.size.height)
//            return;
        
//        self.view.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.2
                         animations:^{
                             CGRect rt = self.view.frame;
                             rt.size.width = sz.width - yPos;

                             self.view.frame = rt;
                         }completion:^(BOOL finished) {
//                             self.view.userInteractionEnabled = YES;
                         }];
    }
}

#pragma mark - KeyBoard notifications
- (void)keyboardWillShow:(NSNotification*)notify {
	CGRect rtKeyBoard = [(NSValue*)[notify.userInfo valueForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];

    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        [self animationView:rtKeyBoard.size.width];
    }
    else {
        [self animationView:rtKeyBoard.size.height];
    }
}

- (void)keyboardWillHide:(NSNotification*)notify {
	[self animationView:0];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
//	return NO;
//}
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//	if(m_textComment.text.length > 0) {
//		m_btnComment.enabled = YES;
//	}
//	else {
//		m_btnComment.enabled = NO;
//	}
//	return YES;
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if(m_textComment.text.length > 0) {
		m_btnComment.enabled = YES;
	}
	else {
		m_btnComment.enabled = NO;
	}
	return YES;
}

@end
