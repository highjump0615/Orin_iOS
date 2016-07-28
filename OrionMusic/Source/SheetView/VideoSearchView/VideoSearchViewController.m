//
//  VideoSearchViewController.m
//  Orin
//
//  Created by TianHang on 3/2/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import "VideoSearchViewController.h"
#import "DataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "LBYouTube.h"
#import "GameUtility.h"
#import "ChartsView.h"

@interface VideoSearchViewController ()

@end

@implementation VideoSearchViewController

@synthesize service,searchResultArray,searchVideosIDArray,nexPageTokenString,playListArray;


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
    
    NSLog(@"search view: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [GameUtility setPhoneFrame:self.view withHeader:YES];
    
    self.service = [[GTLServiceYouTube alloc] init];
    self.service.retryEnabled = YES;
    self.service.APIKey = @"AIzaSyBYttcFm1RH1NKL1oQB6nbrxjgT2SFn-xw";
    self.searchVideosIDArray = [[NSMutableArray alloc]init];
    self.searchResultArray = [[NSMutableArray alloc]init];
    self.playListArray = [[NSMutableArray alloc]init];
    self.nexPageTokenString = nil;

    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard:)];
    tap.cancelsTouchesInView = NO;
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [ChartsItemView pauseMusic];
}

- (IBAction)ClearAllSearch:(id)sender{
    self.searchField.text = @"";
    
}

-(void)closeKeyboard:(id)sender
{
    [self.searchField resignFirstResponder];
}

#pragma mark -
#pragma mark textField view  delegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //    NSString *newString = nil;
    //	if (range.length == 0) {
    //		newString = [self.searchField.text stringByAppendingString:string];
    //	} else {
    //		NSString *headPart = [self.searchField.text substringToIndex:range.location];
    //		NSString *tailPart = [self.searchField.text substringFromIndex:range.location+range.length];
    //		newString = [NSString stringWithFormat:@"%@%@",headPart,tailPart];
    //	}
    //    NSLog(@"%@",newString);
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.searchResultArray removeAllObjects];
    [self GetYoutubeData:textField.text];
 
    return YES;
}

-(void)GetYoutubeData:(NSString*)param{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForSearchListWithPart:@"id"];
    query.q = param;
    query.type = @"video";
    query.pageToken = self.nexPageTokenString;
    query.maxResults = 10;
    __block NSString* strVideosID=nil;
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error == nil) {
            GTLYouTubeSearchListResponse *response = (GTLYouTubeSearchListResponse *)object;
            NSMutableDictionary *dicRes = response.JSON;
            self.nexPageTokenString = [dicRes objectForKey:@"nextPageToken"];
            for (int i=0; i<[response.items count]; ++i) {
                GTLYouTubeVideo *video = response[i];
                NSMutableDictionary * dicResult = video.JSON;
                //  nexPageTokenString = video.
                NSMutableDictionary * dicID = [dicResult objectForKey:@"id"];
                strVideosID = [NSString stringWithFormat:@"%@,%@",strVideosID,[dicID objectForKey:@"videoId"]];
            }
            [self GetVideosData:strVideosID];
            // [self.listTableView reloadData];
        }else{
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    
}

- (NSString*)parseISO8601Time:(NSString*)duration
{
    NSInteger hours = 0;
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    //Get Time part from ISO 8601 formatted duration http://en.wikipedia.org/wiki/ISO_8601#Durations
    duration = [duration substringFromIndex:[duration rangeOfString:@"T"].location];
    
    while ([duration length] > 1) { //only one letter remains after parsing
        duration = [duration substringFromIndex:1];
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:duration];
        
        NSString *durationPart = [[NSString alloc] init];
        [scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] intoString:&durationPart];
        
        NSRange rangeOfDurationPart = [duration rangeOfString:durationPart];
        
        duration = [duration substringFromIndex:rangeOfDurationPart.location + rangeOfDurationPart.length];
        
        if ([[duration substringToIndex:1] isEqualToString:@"H"]) {
            hours = [durationPart intValue];
        }
        if ([[duration substringToIndex:1] isEqualToString:@"M"]) {
            minutes = [durationPart intValue];
        }
        if ([[duration substringToIndex:1] isEqualToString:@"S"]) {
            seconds = [durationPart intValue];
        }
    }
    if (hours == 0) {
        return [NSString stringWithFormat:@"%d:%02d",  minutes,seconds ];
    }
    return [NSString stringWithFormat:@"%02d:%d:%02d", hours, minutes,seconds];
}


-(void)GetVideosData:(NSString*)videosID{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosListWithPart:@"snippet,contentDetails,statistics"];
    [query setIdentifier:videosID]; // Hard code for now.
    
    __block NSString *result = @"";
    
    NSLog(@"Preparing to fetch video description. %@", service);
    if (service) {
        [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (!error) {
                GTLYouTubeVideoListResponse *response = (GTLYouTubeVideoListResponse *)object;
                for (int i=0; i<[response.items count]; ++i) {
                    GTLYouTubeVideo *video = response[i]; // Since we specified the ID of the video we want, there's only one entry in the array. Otherwise, we'd have to iterate through (i.e if we want to search).
                    NSLog(@"Got description: %@", result);
                    result = video.snippet.descriptionProperty;
                    NSString *strPic = video.snippet.thumbnails.defaultProperty.url;
                    if (strPic == nil) {
                        strPic = video.snippet.thumbnails.high.url;
                    }
                    
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:strPic forKey:@"picUrl"];
                    [dic setObject:video.snippet.descriptionProperty.description forKey:@"videoDesc"];
                    [dic setObject:video.snippet.title forKey:@"Title"];
                    [dic setObject:video.snippet.channelTitle forKey:@"Author"];
                    [dic setObject:[self parseISO8601Time:video.contentDetails.duration] forKey:@"videoTime"];
                    [dic setObject:video.statistics.viewCount forKey:@"ViewCount"];
                    [dic setObject:video.statistics.commentCount forKey:@"CommentCount"];
                    [dic setObject:video.identifier forKey:@"videoID"];
                    [self.searchResultArray addObject:dic];
                }
                [self.listTableView reloadData];
                [self finishReloadingData];
                self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
                [self setFooterView];
            } else {
                NSLog(@"An error occurred: %@", error);
            }
        }];
    } else {
        NSLog(@"Can't get YouTube service object.");
    }
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
	
	//  model should call this when its done loading
	_reloading = NO;
    
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listTableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.listTableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
	_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
	[self.listTableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

-(void)removeHeaderView{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = nil;
}

-(void)setFooterView{
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.listTableView.contentSize.height, self.listTableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.listTableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.listTableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.listTableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

#pragma mark-
#pragma mark force to show the refresh headerView
-(void)showRefreshHeader:(BOOL)animated{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.listTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        // scroll the table view to the top region
        [self.listTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
	}
	else
	{
		self.listTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[self.listTableView scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
	}
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//表格视图正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}
//表格视图停止滚动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}


#pragma mark -
#pragma mark EGORefreshTableDelegate1 Methods
//释放更新事件:开始点
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	
	[self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	return [NSDate date]; // should return date data source was last changed
}





#pragma mark-
#pragma mark overide methods
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        // pull down to refresh data
        [self performSelector:@selector(testRealRefreshDataSource) withObject:nil afterDelay:2.0];
    }else if(aRefreshPos == EGORefreshFooter){
        // pull up to load more data
        [self performSelector:@selector(testRealLoadMoreData) withObject:nil afterDelay:2.0];
    }
}

-(void)testRealRefreshDataSource{
    
}

-(void)testRealLoadMoreData{
    [self GetYoutubeData:self.searchField.text];
    //    {
    //        [self finishReloadingData];
    //        self.listTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    //        [self removeFooterView];
    //    }
}


-(void)testFinishedLoadData{
    // after loading data, should reloadData and set the footer to the proper position
    [self.listTableView reloadData];
    [self finishReloadingData];
    [self setFooterView];
}


#pragma mark -
#pragma mark Table view  delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)AddItem:(id)sender
{
    UIButton *myBtn=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[myBtn superview].superview.superview;
    NSLog(@"您点击了第 %d %d行",[self.listTableView indexPathForCell:cell].section,[self.listTableView indexPathForCell:cell].row  );
    
    // NSMutableArray *ar = [self.searchResultArray objectAtIndex:[self.listTableView indexPathForCell:cell].row];
    NSMutableDictionary *dic = [self.searchResultArray objectAtIndex:[self.listTableView indexPathForCell:cell].row];
    BOOL bFind = NO;
    for (int i=0; i< [self.playListArray count]; ++i) {
        NSMutableDictionary* dic1 = [self.playListArray objectAtIndex:i];
        if ([[dic1 objectForKey:@"videoID"] isEqualToString:[dic objectForKey:@"videoID"]]) {
            bFind = YES;
        }
    }
    if (!bFind) {
        NSString *strTitle = [dic objectForKey:@"Title"];
        strTitle = [strTitle stringByReplacingOccurrencesOfString:@"'" withString:@"#"];
        [dic setObject:@"" forKey:@"videoDesc"];
        [dic setObject:strTitle forKey:@"Title"];
        [DBOperator dbexecuteQuery:[DBOperator getInsertSqlFromDic:dic andTableName:@"playlist"]];
    }else{
        NSString *strVideoID = [dic objectForKey:@"videoID"];
        NSString* strsql = [NSString stringWithFormat:@"delete from playlist where videoID='%@'",strVideoID];
        [DBOperator dbexecuteQuery:strsql];
    }
    [self.playListArray removeAllObjects];
    self.playListArray = [DBOperator selectAllInfo:@"select * from playlist"];
    [self.listTableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSArray*subviews = [[NSArray alloc]initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    NSDictionary *dic = [self.searchResultArray objectAtIndex:indexPath.row];
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 65)];
    [backImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picUrl"]]
            placeholderImage:[UIImage imageNamed:@"placeholder"] ];
    //   [backImg setImage:[UIImage imageNamed:@"cellback.png"]];
    [cell.contentView addSubview:backImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, tableView.frame.size.width - 100, 24)];
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.text = [dic objectForKey:@"Title"];
    [cell.contentView addSubview:nameLab];
    
    UILabel *authorLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, tableView.frame.size.width - 120, 24)];
    authorLab.font = [UIFont systemFontOfSize:12];
    authorLab.backgroundColor = [UIColor clearColor];
    authorLab.textColor = [UIColor grayColor];
    NSString *strAuthor = [NSString stringWithFormat:@"by %@",[dic objectForKey:@"Author"]];
    authorLab.text = strAuthor;
    [cell.contentView addSubview:authorLab];
    
    UILabel *viewsLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 46, tableView.frame.size.width - 120, 24)];
    viewsLab.font = [UIFont systemFontOfSize:13];
    viewsLab.backgroundColor = [UIColor clearColor];
    viewsLab.textColor = [UIColor grayColor];
    NSString *str1 = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ViewCount"]];
    int j =0;
    NSString * newString=@"";
    for(int i =[str1 length]; i > 0 ; --i)
    {
        char c = [str1 characterAtIndex:i-1];
        newString = [NSString stringWithFormat:@"%@%c",newString,c];
        ++j;
        if (j%3==0 && j!= [str1 length]) {
            newString = [NSString stringWithFormat:@"%@,",newString];
        }
        
        
        //       NSLog(@"字符串第 %d 位为 %c",i,c);
    }
    
    NSString * newString1=@"";
    for(int i =[newString length]; i > 0 ; --i)
    {
        
        char c = [newString characterAtIndex:i-1];
        newString1 = [NSString stringWithFormat:@"%@%c",newString1,c];
        //       NSLog(@"字符串第 %d 位为 %c",i,c);
    }
    NSString *strdesc = [NSString stringWithFormat:@"%@ views",newString1];
    viewsLab.text =strdesc ;
    [cell.contentView addSubview:viewsLab];
    
    UIButton* checkBtn = nil;
    checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 75, 25, 74, 34)];
    [checkBtn addTarget:self action:@selector(AddItem:) forControlEvents:UIControlEventTouchUpInside];
    checkBtn.backgroundColor = [UIColor clearColor];
    
    BOOL bFind = NO;
    for (int i=0; i< [self.playListArray count]; ++i) {
        NSMutableDictionary* dic1 = [self.playListArray objectAtIndex:i];
        if ([[dic1 objectForKey:@"videoID"] isEqualToString:[dic objectForKey:@"videoID"]]) {
            bFind = YES;
        }
    }
    if (bFind) {
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"add_Selected.png"] forState:UIControlStateNormal];
    }else{
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"add_Normal.png"] forState:UIControlStateNormal];
    }
    [cell.contentView addSubview:checkBtn];
    
    UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 45, 40, 25)];
    
    [timeImg setImage:[UIImage imageNamed:@"touming_back.png"]];
    [cell.contentView addSubview:timeImg];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 74, tableView.frame.size.width - 10, 2)];
    [lineImg setImage:[UIImage imageNamed:@"line.png"]];
    [cell.contentView addSubview:lineImg];
    
    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 42, 40, 24)];
    dateLab.font = [UIFont systemFontOfSize:13];
    dateLab.textColor = [UIColor whiteColor];
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.text = [dic objectForKey:@"videoTime"];
    [cell.contentView addSubview:dateLab];
    
    
    //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.searchResultArray objectAtIndex:indexPath.row];
    
    NSString* strUrl = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",[dic objectForKey:@"videoID"]];
    LBYouTubePlayerViewController* controller = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:strUrl] quality:LBYouTubeVideoQualityMedium];
    controller.delegate = self.parentController;
    
    [self.parentController presentViewController:controller animated:YES completion:nil];
}


@end
