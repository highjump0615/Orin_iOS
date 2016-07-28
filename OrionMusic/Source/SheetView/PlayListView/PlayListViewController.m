//
//  PlayListViewController.m
//  Orin
//
//  Created by TianHang on 3/2/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import "PlayListViewController.h"
#import "DataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "LBYouTube.h"
#import "CMUtils.h"
#import "ChartsView.h"

#import "GameUtility.h"

@interface PlayListViewController ()

@end

@implementation PlayListViewController

@synthesize playListArray;
@synthesize parentController;

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
    
    NSLog(@"playlist view: %f, %f, %f, %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [GameUtility setPhoneFrame:self.view withHeader:YES];
    
    NSString *path = [CMUtils getDataBasePath:@"youtube"];
    [DataBaseManager bindAtomEntry:path];
    
    self.playListArray = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.playListArray removeAllObjects];
    self.playListArray = [DBOperator selectAllInfo:@"select * from playlist"];
    [self.listTableView reloadData];
    
    [ChartsItemView pauseMusic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteItem:(id)sender {
    if (isEdit) {
        [self setEditing:NO animated:YES];
        //        [editBtn setBackgroundImage:[UIImage imageNamed:@"rdeleteBtn.png"] forState:UIControlStateNormal];
        isEdit = NO;
    }
    else{
        [self setEditing:YES animated:YES];
        //        [editBtn setBackgroundImage:[UIImage imageNamed:@"rdeleteRedBtn.png"] forState:UIControlStateNormal];
        isEdit = YES;
    }
}

#pragma mark -
#pragma mark Table view  delegate methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.playListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)AddItem{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    NSArray*subviews = [[NSArray alloc]initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    NSDictionary *dic = [self.playListArray objectAtIndex:indexPath.row];
    
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
    
    //    UIButton* checkBtn = nil;
    //    checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(245, 25, 74, 34)];
    //    [checkBtn addTarget:self action:@selector(AddItem) forControlEvents:UIControlEventTouchUpInside];
    //    checkBtn.backgroundColor = [UIColor clearColor];
    //
    //    [checkBtn setBackgroundImage:[UIImage imageNamed:@"add_Normal.png"] forState:UIControlStateNormal];
    //    [cell.contentView addSubview:checkBtn];
    //    [checkBtn release];
    
    //    UIImageView *lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, -1, 310, 1)];
    //    [lineImg setImage:[UIImage imageNamed:@"line.png"]];
    //    [cell.contentView addSubview:lineImg];
    //    [lineImg release];
    
    
    UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 45, 40, 25)];
    
    [timeImg setImage:[UIImage imageNamed:@"touming_back.png"]];
    [cell.contentView addSubview:timeImg];
    
    UIImageView *lineImg1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 74, tableView.frame.size.width - 10, 2)];
    [lineImg1 setImage:[UIImage imageNamed:@"line.png"]];
    [cell.contentView addSubview:lineImg1];
    
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
    NSDictionary *dic = [self.playListArray objectAtIndex:indexPath.row];
    
    NSString* strUrl = [NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",[dic objectForKey:@"videoID"]];
    LBYouTubePlayerViewController* controller = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:strUrl] quality:LBYouTubeVideoQualityMedium];
    controller.delegate = parentController;
    
    [parentController presentViewController:controller animated:YES completion:nil];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;//出现—
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    isEdit = NO;
    //    CustomCell *cell = (CustomCell*)[listTableView cellForRowAtIndexPath:indexPath];
    //    cell.imageTitle.hidden = isEdit;
}
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    isEdit = YES;
    //    CustomCell *cell = (CustomCell*)[listTableView cellForRowAtIndexPath:indexPath];
    //    cell.imageTitle.hidden = isEdit;
}
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString* strID = [[self.playListArray objectAtIndex:indexPath.row] objectForKey:@"videoID"];
        NSString* strsql = [NSString stringWithFormat:@"delete from playlist where videoID='%@'",strID];
        [DBOperator dbexecuteQuery:strsql];
        
        [self.playListArray removeAllObjects];
        self.playListArray = [DBOperator selectAllInfo:@"select * from playlist"];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if(editing)
    {
        //        [editBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self tableView:self.listTableView didEndEditingRowAtIndexPath:nil];
    }
    else
    {
    }
    [self.listTableView setEditing:editing animated:animated];
    isEdit = editing;
}


@end
