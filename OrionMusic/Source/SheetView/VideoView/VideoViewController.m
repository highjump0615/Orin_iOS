//
//  VideoViewController.m
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import "VideoViewController.h"
#import "AFNetworking.h"
#import "CMUtils.h"
#import "DataBaseManager.h"
#import "MBProgressHUD.h"
#import "GTLYouTube.h"
#import "UIImageView+WebCache.h"
#import "LBYouTube.h"

#import "ChartsView.h"
#import "GameUtility.h"

//#import "GTLUtilities.h"
//#import "GTMHTTPUploadFetcher.h"
//#import "GTMHTTPFetcherLogging.h"
//#import "GTMOAuth2WindowController.h"
//#import "GTMOAuth2ViewControllerTouch.h"
////#import "baseCell.h"
//#import "ImageCache.h"


@interface VideoViewController () {
    int m_nCategoryCnt;
    int m_nCurCategory;
}

@end

@implementation VideoViewController

@synthesize listTableView;
@synthesize popVideosItems;
@synthesize listVideosItems;
@synthesize popVideosID;
@synthesize tableVideosArray;
@synthesize playListArray;
@synthesize myPlayBoard;
@synthesize imageCache;

@synthesize parentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"VideoViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (GTLServiceYouTube *)youTubeService {
    static GTLServiceYouTube *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[GTLServiceYouTube alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
        [service setAPIKey:@"AIzaSyBYttcFm1RH1NKL1oQB6nbrxjgT2SFn-xw"];
    });
    return service;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"video view: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [GameUtility setPhoneFrame:self.view withHeader:YES];

    
    self.listVideosItems = [[NSMutableArray alloc]init];
    self.popVideosItems = [[NSMutableArray alloc]init];
    self.tableVideosArray = [[NSMutableArray alloc]init];
    self.playListArray = [[NSMutableArray alloc]init];
    imageCache = [[ImageCache alloc] init];

    // 在屏幕底部创建标准尺寸的视图。
    int nHeight = self.view.frame.size.height - GAD_SIZE_320x50.height;
    
    bannerView_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                            nHeight,
                                            self.view.frame.size.width,
                                            GAD_SIZE_320x50.height)];
    
    // 指定广告的“单元标识符”，也就是您的 AdMob 发布商 ID。
//    bannerView_.adUnitID = @"a151fb6b069d51e";
    bannerView_.adUnitID = @"ca-app-pub-4431429682869355/4614338428";

    // 告知运行时文件，在将用户转至广告的展示位置之后恢复哪个 UIViewController
    // 并将其添加至视图层级结构。
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // 启动一般性请求并在其中加载广告。
    [bannerView_ loadRequest:[GADRequest request]];
    [bannerView_ setHidden:YES];
//    [MKStoreManager sharedManager].delegate = self;

    NSString *path = [CMUtils getDataBasePath:@"youtube"];
    [DataBaseManager bindAtomEntry:path];
    [listVideosItems removeAllObjects];
    [popVideosItems removeAllObjects];
    [tableVideosArray removeAllObjects];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [listTableView setHidden:YES];
    [self DownloadYoutHtml];
    
    m_nCurCategory = 0;
    m_nCategoryCnt = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.playListArray removeAllObjects];
    self.playListArray = [DBOperator selectAllInfo:@"select * from playlist"];
//    if ([MKStoreManager featureAPurchased])
//    {
//		if(bannerView_) {
//			[bannerView_ removeFromSuperview];
//			bannerView_ = nil;
//		}
//    }
    
    [ChartsItemView pauseMusic];
}


-(void)DownloadYoutHtml{
	// Do any additional setup after loading the view, typically from a nib.
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://www.youtube.com/channel/UC-9-kyTW8ZkZNDHQJ6FgpwQ"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        
        return [documentsDirectoryPath URLByAppendingPathComponent:@"youtube.tmp"];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        [self loadYoutubeHtml];
    }];
    [downloadTask resume];
    
}

-(void)loadYoutubeHtml {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/youtube.tmp",documentsDirectory];
    NSString *tmp;
    NSArray *lines; /*将文件转化为一行一行的*/
    
    lines = [[NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"<"];
    NSEnumerator *nse = [lines objectEnumerator];
    
    //
    BOOL bFoundOneList = NO;
    BOOL bFoundOneCategory = NO;
    NSString *strPlaylist = @"";
    int nCount = 0;
    
    while(tmp = [nse nextObject]) {
        
        NSString *string1 = tmp;
        
        if (bFoundOneList) {
            NSString *string2 = @"a href=\"/playlist?list=";
            NSRange range = [string1 rangeOfString:string2];
            
            if (range.location != NSNotFound) {
                strPlaylist = [tmp substringFromIndex:range.location + range.length];
                NSRange rangePlaylist = [strPlaylist rangeOfString:@"\""];
                strPlaylist = [strPlaylist substringToIndex:rangePlaylist.location];
                
                NSLog(@"playlist: %@", strPlaylist);
                bFoundOneList = NO;
            }
        }
        else {
            NSString *string2 = @"class=\"branded-page-module-title\">";
            NSRange range = [string1 rangeOfString:string2];
            
            if (range.location != NSNotFound) {
                bFoundOneList = YES;
            }
        }
        
        if (bFoundOneCategory) {
            NSString *string2 = @"span class=\"\" >";
            NSRange range = [string1 rangeOfString:string2];
            
            if (range.location != NSNotFound) {
                NSString *strCategory = [tmp substringFromIndex:range.location + range.length];
                strCategory = [strCategory stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
                
                NSLog(@"Category: %@", strCategory);
                
                if (strPlaylist.length > 0) {
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:strCategory forKey:@"Category"];
                    
                    [self GetPlaylistVideoIDs:strPlaylist category:strCategory];
                    
                    strPlaylist = @"";
                    nCount++;
                    m_nCategoryCnt = nCount;
                    
                    if (m_nCategoryCnt >= 5) {
                        break;
                    }
                }
                
                bFoundOneCategory = NO;
            }
        }
        else {
            NSString *string2 = @"class=\"branded-page-module-title-text\">";
            NSRange range = [string1 rangeOfString:string2];
            
            if (range.location != NSNotFound) {
                bFoundOneCategory = YES;
            }
        }
    }
   
//    [self GetVideosData:self.popVideosID];
//    [self GetYoutubeVideosData];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [listTableView setHidden:NO];
    [bannerView_ setHidden:NO];
}

-(NSString*)GetAuthorURL:(NSString*)param{
    GTLServiceYouTube *service = self.youTubeService;
    service.APIKey = @"AIzaSyBYttcFm1RH1NKL1oQB6nbrxjgT2SFn-xw";
    __block NSString *strURL = nil;
    GTLQueryYouTube *query = [GTLQueryYouTube queryForSearchListWithPart:@"snippet"];
    query.q = param;
    query.type = @"channel";
    query.maxResults = 1;
    [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error == nil) {
            GTLYouTubeSearchListResponse *response = (GTLYouTubeSearchListResponse *)object;
            GTLYouTubeVideo *video = response[0];
            strURL= video.snippet.thumbnails.defaultProperty.url;
            if (strURL ==nil ) {
                strURL = video.snippet.thumbnails.high.url;
                if (strURL == nil) {
                    strURL = @"";
                }
            }
            //            NSLog(@"URL: %@", strURL);
            //            return strURL;
            
            [self.listTableView reloadData];
        }else{
            NSLog(@"Error: %@", error.description);
        }
    }];
    
    NSString* str=nil;
    
    return str;
}

- (void) GetPlaylistVideoIDs:(NSString*)playlistName category:(NSString*)categoryName{
    GTLServiceYouTube *service = self.youTubeService;
    GTLQueryYouTube *query = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"contentDetails"];
    query.playlistId = playlistName;
    query.maxResults = 50;
    
    [service executeQuery:query
           completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
               if (!error) {
                   GTLYouTubePlaylistItemListResponse *playlistItems = object;
                   
                   NSString *strVideoIds = @"";
                   int nCount = 0;
                   
                   for (GTLYouTubePlaylistItem *playlistItem in playlistItems) {
                       
                       if (nCount > 0) {
                           strVideoIds = [strVideoIds stringByAppendingString:@","];
                       }
                       
                       GTLYouTubePlaylistItemContentDetails *details = playlistItem.contentDetails;
                       
                       strVideoIds = [strVideoIds stringByAppendingString:details.videoId];

                       nCount++;
                       if (nCount > 5) {
                           break;
                       }
                   }
                   
                   NSLog(@"strVideos:%@",strVideoIds);
                   
                   if (m_nCurCategory > 0) {
                       NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                       [dic setObject:categoryName forKey:@"Category"];
                       
                       [dic setObject:strVideoIds forKey:@"VideoIDs"];
                       [listVideosItems addObject:dic];
                   }
                   else {
                       self.popVideosID = strVideoIds;
                   }
                   
                   m_nCurCategory++;
                   
                   if (m_nCurCategory >= m_nCategoryCnt) {
                       [self GetVideosData:self.popVideosID];
                       [self GetYoutubeVideosData];
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                   }
               }
               else {
                   NSLog(@"%@", error);
               }
           }];
}

-(NSString*)GetPopVideoID:(NSString*)strHtml{
    NSString *string1 = @"video_ids=";
    NSString *string2 = @"\" class=";
    NSString *string3 = @"";
    
    NSRange range1 = [strHtml rangeOfString:string1];
    NSRange range2 = [strHtml rangeOfString:string2];
    
    if (range1.location != NSNotFound && range2.location != NSNotFound) {
        int location1 = range1.location;
        int location2 = range2.location;
        string3 = [strHtml substringWithRange:NSMakeRange(location1+10, location2-location1-10)];
        string3 = [string3 stringByReplacingOccurrencesOfString:@"%2C" withString:@","];
        string3 = [string3 stringByReplacingOccurrencesOfString:@"%" withString:@","];
    }
    return  string3;
}

-(NSString*)GetVideoTitle:(NSString*)strHtml{
    NSString *string3 = [strHtml stringByReplacingOccurrencesOfString:@"<span class=\"\" >" withString:@""];
    string3 = [string3 stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    string3 = [string3 stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return  string3;
}

-(NSString*)GetVideoID:(NSString*)strHtml{
    NSString *string1 = @"video_ids=";
    NSString *string2 = @"amp;title=";
    NSRange range1 = [strHtml rangeOfString:string1];
    NSRange range2 = [strHtml rangeOfString:string2];
    if (range2.location == NSNotFound) {
        NSString *string2 = @"amp;more_u";
        
        range2 = [strHtml rangeOfString:string2];
    }
    int location1 = range1.location;
    int location2 = range2.location;
    NSString *string3 = [strHtml substringWithRange:NSMakeRange(location1+10, location2-location1-11)];
    string3 = [string3 stringByReplacingOccurrencesOfString:@"%2C" withString:@","];
    string3 = [string3 stringByReplacingOccurrencesOfString:@"%" withString:@","];
    return  string3;
}

-(void)GetVideosData:(NSString*)videosID{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosListWithPart:@"snippet"];
    [query setIdentifier:videosID]; // Hard code for now.
    
    __block NSString *result = @"";
    GTLServiceYouTube *service = self.youTubeService;
    // service.APIKey = @"AIzaSyCbwQHCA8wgn5LWDGm45E_HPnh0RRXFZkU";
    
    NSLog(@"Preparing to fetch video description. %@", service);
    if (service) {
        [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (!error) {
                GTLYouTubeVideoListResponse *response = (GTLYouTubeVideoListResponse *)object;
                for (int i=0; i<[response.items count]; ++i) {
                    GTLYouTubeVideo *video = response[i]; // Since we specified the ID of the video we want, there's only one entry in the array. Otherwise, we'd have to iterate through (i.e if we want to search).
//                    NSLog(@"Got description: %@", result);
                    result = video.snippet.descriptionProperty;
                    NSString *strPic = video.snippet.thumbnails.standard.url;
                    if (strPic == nil) {
                        strPic = video.snippet.thumbnails.high.url;
                    }
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:strPic forKey:@"picUrl"];
                    [dic setObject:video.snippet.descriptionProperty.description forKey:@"videoDesc"];
                    [dic setObject:video.snippet.title forKey:@"Title"];
                    [dic setObject:video.identifier forKey:@"videoID"];
                    [popVideosItems addObject:dic];
                }
                // [self performSelectorOnMainThread:@selector(updatetablist:) withObject:nil waitUntilDone:YES];
                [self.listTableView reloadData];
            } else {
                NSLog(@"An error occurred: %@", error);
            }
        }];
    } else {
        NSLog(@"Can't get YouTube service object.");
    }
    
}

-(void)GetYoutubeVideosData{
    for (int i=0; i< [self.listVideosItems count]; ++i) {
        NSMutableDictionary *dic = [self.listVideosItems objectAtIndex:i];
        [self GetVideosListData:[dic objectForKey:@"VideoIDs"] objIndex:i];
    }
//    YoutubeAppDelegate *app = [YoutubeAppDelegate App];
//    app.VideosArray =  self.tableVideosArray;      // by tian
    
    //    if ([app.VideosArray count] >0) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_GetDataSuccess" object:nil userInfo:nil];
    //    }
}

-(void)GetVideosListData:(NSString*)videosID objIndex:(int)_index{
    GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosListWithPart:@"snippet,contentDetails,statistics"];
    [query setIdentifier:videosID]; // Hard code for now.
    
    NSLog(@"videos: %@", videosID);
//    [query setIdentifier:@"zUy9ytCkEjk,QOqZhLP1HrM"];
    
    __block NSString *result = @"";
    GTLServiceYouTube *service = self.youTubeService;
    // service.APIKey = @"AIzaSyCbwQHCA8wgn5LWDGm45E_HPnh0RRXFZkU";
    
    NSLog(@"Preparing to fetch video description. %@", service);
    if (service) {
        [service executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            NSMutableArray* tmpContntArray = [[NSMutableArray alloc] initWithCapacity:10];
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
                    //[dic setObject:[[self.listVideosItems objectAtIndex:i]objectForKey:@"Category"] forKey:@"Category"];
                    [dic setObject:strPic forKey:@"picUrl"];
                    [dic setObject:video.snippet.descriptionProperty.description forKey:@"videoDesc"];
                    [dic setObject:video.snippet.title forKey:@"Title"];
                    [dic setObject:video.snippet.channelTitle forKey:@"Author"];
                    [dic setObject:[self parseISO8601Time:video.contentDetails.duration] forKey:@"videoTime"];
                    [dic setObject:video.statistics.viewCount forKey:@"ViewCount"];
                    [dic setObject:video.statistics.commentCount forKey:@"CommentCount"];
                    [dic setObject:video.identifier forKey:@"videoID"];
                    [tmpContntArray addObject:dic];
                }
                NSMutableDictionary* dic1 = [[NSMutableDictionary alloc] init];
                [dic1 setObject:[[self.listVideosItems objectAtIndex:_index]objectForKey:@"Category"] forKey:@"Category"];
                [dic1 setObject:tmpContntArray forKey:@"Content"];
                [self.tableVideosArray addObject:dic1];
                //[self performSelectorOnMainThread:@selector(updatetablist:) withObject:nil waitUntilDone:YES];
                
                [self.listTableView reloadData];
            } else {
                NSLog(@"An error occurred: %@", error);
            }
        }];
    } else {
        NSLog(@"Can't get YouTube service object.");
    }
    
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view  delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableVideosArray count]+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    return 20.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"aaa %d",section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    v.backgroundColor = [UIColor clearColor];
    if (section==0) {
        v.frame = CGRectMake(0, 0, tableView.frame.size.width, 20);
        return v;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    label.text = [NSString stringWithFormat:@"  %@",[[self.tableVideosArray objectAtIndex:section-1] objectForKey:@"Category"]];
    if (section == 1) {
        //        UIColor *bkColor= [UIColor colorWithRed:190/255.0 green:0.0 blue:0.0 alpha:1];
        label.backgroundColor = [UIColor darkGrayColor];
    }else{
        // UIColor *bkColor= [UIColor colorWithRed:190/255.0 green:0.0 blue:0.0 alpha:1];
        label.backgroundColor = [UIColor darkGrayColor];
    }
    
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [v addSubview:label];
    
    return v;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
	return [[[self.tableVideosArray objectAtIndex:section-1] objectForKey:@"Content"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        return 240;
    }
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0)
    {
        if ([tableVideosArray count]>0) {
            return [self customBillBoardCell];
        }
        static NSString *CellIdentifier = @"CellIdentifierTitle";
        UITableViewCell *cell = [listTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        for (UIView *view in [cell subviews])
        {
            [view removeFromSuperview];
        }
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSArray *subviews = [[NSArray alloc]initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    NSDictionary *dic = [[[self.tableVideosArray objectAtIndex:indexPath.section-1] objectForKey:@"Content"] objectAtIndex:indexPath.row];
    
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 65)];
    [backImg setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picUrl"]]
            placeholderImage:[UIImage imageNamed:@"placeholder"] ];
    //   [backImg setImage:[UIImage imageNamed:@"cellback.png"]];
    [cell.contentView addSubview:backImg];
    
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, tableView.frame.size.width - 100, 24)];
    nameLab.font = [UIFont systemFontOfSize:14];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.text = [dic objectForKey:@"Title"];
//    nameLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:nameLab];
    
    UILabel *authorLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, tableView.frame.size.width - 120, 24)];
    authorLab.font = [UIFont systemFontOfSize:12];
    authorLab.backgroundColor = [UIColor clearColor];
    authorLab.textColor = [UIColor grayColor];
//    authorLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSString *strAuthor = [NSString stringWithFormat:@"by %@",[dic objectForKey:@"Author"]];
//    labelComment.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    authorLab.text = strAuthor;
    [cell.contentView addSubview:authorLab];
    
    UILabel *viewsLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 46, tableView.frame.size.width - 120, 24)];
    viewsLab.font = [UIFont systemFontOfSize:13];
    viewsLab.backgroundColor = [UIColor clearColor];
    viewsLab.textColor = [UIColor grayColor];
//    viewsLab.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
    
//    checkBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [cell.contentView addSubview:checkBtn];
    
    
    UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 45, 40, 25)];
    
    [timeImg setImage:[UIImage imageNamed:@"touming_back.png"]];
    [cell.contentView addSubview:timeImg];
    
    
    UILabel *dateLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 42, 40, 24)];
    dateLab.font = [UIFont systemFontOfSize:13];
    dateLab.textColor = [UIColor whiteColor];
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.text = [dic objectForKey:@"videoTime"];
    [cell.contentView addSubview:dateLab];
    
    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 74, tableView.frame.size.width - 10, 2)];
    [lineImg setImage:[UIImage imageNamed:@"line.png"]];
//    lineImg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [cell.contentView addSubview:lineImg];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return;
    }
    
    NSDictionary *dic = [[[self.tableVideosArray objectAtIndex:indexPath.section-1] objectForKey:@"Content"] objectAtIndex:indexPath.row];
    
    NSString* strUrl = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",[dic objectForKey:@"videoID"]];
    LBYouTubePlayerViewController* controller = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:strUrl] quality:LBYouTubeVideoQualityMedium];
    controller.delegate = parentController;
    
    [parentController presentViewController:controller animated:YES completion:nil];
}

#pragma mark -

- (UITableViewCell*)customBillBoardCell
{
    static NSString *CellIdentifier = @"CellIdentifierHead";
    UITableViewCell *cell = [listTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //海报
    if (self.myPlayBoard == nil)
    {
        self.myPlayBoard = [[MyBillBoard alloc] initWithFrame:CGRectMake((self.listTableView.frame.size.width - 320) / 2, -2, 320, 240)];
        [cell.contentView addSubview:myPlayBoard];
        myPlayBoard.delegate = self;
    }
    for (int i = 0; i < [[myPlayBoard subviews] count]; i++)
    {
        UIView *subView = [[myPlayBoard subviews] objectAtIndex:i];
        if ([subView isKindOfClass:[UIButton class]])
        {
            [subView removeFromSuperview];
        }
    }
    int arraryCount = 0;
    if ([popVideosItems isKindOfClass:[NSDictionary class]]) {
        arraryCount = 1;
    }
    else if([popVideosItems isKindOfClass:[NSArray class]])
    {
        arraryCount = [popVideosItems count];
    }
    if (arraryCount > 0)
    {
        NSMutableArray *urlarray = [[NSMutableArray alloc] initWithCapacity:5];
        NSMutableArray *contentNameArray = [[NSMutableArray alloc] initWithCapacity:5];
        NSMutableArray *contentId = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < [popVideosItems count]; i++)
        {
            NSDictionary *dic = [popVideosItems objectAtIndex:i];
            NSString *imageUrl = [dic objectForKey:@"picUrl"];
            NSString *name = [dic objectForKey:@"Title"];
            [urlarray addObject:imageUrl];
            [contentNameArray addObject:name];
            [contentId addObject:imageUrl];
        }
        [myPlayBoard initBillBordWithImageUrl:urlarray ContentNameArray:contentNameArray ContentUrlArray:contentId  PageCtrlStyle:PAGECONTROL_BOTTOM_NOBACK AutoScroll:YES TimeInterval:5.0f];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)AddItem:(id)sender
{
    UIButton *myBtn=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[myBtn superview].superview.superview;
    NSLog(@"您点击了第 %d %d行",[self.listTableView indexPathForCell:cell].section,[self.listTableView indexPathForCell:cell].row  );
    
    NSMutableArray *ar = [[self.tableVideosArray objectAtIndex:[self.listTableView indexPathForCell:cell].section-1] objectForKey:@"Content"];
    NSMutableDictionary *dic = [ar objectAtIndex:[self.listTableView indexPathForCell:cell].row];
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


- (void)OnPlayBoardTouched:(NSString *)sUrl
{
    NSDictionary *dic = [self getDicFromBillBoard:sUrl];
    NSString* strUrl = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",[dic objectForKey:@"videoID"]];
    LBYouTubePlayerViewController* controller = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:strUrl] quality:LBYouTubeVideoQualityMedium];
    controller.delegate = parentController;
    
    [parentController presentViewController:controller animated:YES completion:nil];
    
    return;
}
- (NSDictionary *)getDicFromBillBoard:(NSString *)cid
{
    NSMutableDictionary *dic = nil;
    for (int i = 0; i < [self.popVideosItems count]; i++) {
        NSDictionary *dic1 = [popVideosItems objectAtIndex:i];
        NSString *imgUrl = [dic1 objectForKey:@"picUrl"];
        
        if ([imgUrl isEqualToString:cid]) {
            return dic1;;
        }
    }
    return dic;
}

@end
