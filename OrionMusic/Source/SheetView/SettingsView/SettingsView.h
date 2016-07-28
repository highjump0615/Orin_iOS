//
//  SettingsView.h
//  OrionMusic
//
//  Created by TianHang on 10/11/13.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface SettingsView : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
