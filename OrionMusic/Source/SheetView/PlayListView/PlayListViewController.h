//
//  PlayListViewController.h
//  Orin
//
//  Created by TianHang on 3/2/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListViewController : UIViewController {
    NSMutableArray* playListArray;
    BOOL isEdit;
}

@property (strong) id parentController;

@property(nonatomic, retain)   NSMutableArray* playListArray;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

- (IBAction)deleteItem:(id)sender;

@end
