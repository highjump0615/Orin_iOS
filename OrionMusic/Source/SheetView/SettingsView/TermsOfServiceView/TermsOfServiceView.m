//
//  TermsOfServiceView.m
//  OrionMusic
//
//  Created by TianHang on 10/21/13.
//
//

#import "TermsOfServiceView.h"

@interface TermsOfServiceView ()

@end

@implementation TermsOfServiceView

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
