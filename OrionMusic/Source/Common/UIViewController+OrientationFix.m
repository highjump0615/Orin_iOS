//
//  UIViewController+OrientationFix.m
//  Orin
//
//  Created by TianHang on 3/30/14.
//  Copyright (c) 2014 234 Digital Limited. All rights reserved.
//

#import "UIViewController+OrientationFix.h"

@implementation UIViewController (OrientationFix)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end

@implementation UIImagePickerController (OrientationFix)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

@end