//
//  LBYouTubePlayerController.m
//  LBYouTubeView
//
//  Created by Laurin Brandner on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LBYouTubePlayerViewController.h"




@interface LBYouTubePlayerViewController () 

@property (nonatomic, strong) LBYouTubeExtractor* extractor;

@end
@implementation LBYouTubePlayerViewController

#pragma mark Initialization

-(id)initWithYouTubeURL:(NSURL *)youTubeURL quality:(LBYouTubeVideoQuality)quality {
    return [self initWithYouTubeURL:youTubeURL quality:quality extractionExpression:nil];
}

-(id)initWithYouTubeURL:(NSURL *)youTubeURL quality:(LBYouTubeVideoQuality)quality  extractionExpression:(NSString*)expression {
	return [self initWithYouTubeURL:youTubeURL quality:quality extractionExpression:expression signatureExtracionExpression:nil signatureAlgo:nil];
}

-(id)initWithYouTubeURL:(NSURL*)youTubeURL quality:(LBYouTubeVideoQuality)quality extractionExpression:(NSString*)expression signatureExtracionExpression:(NSString*)signatureExpression signatureAlgo:(NSArray*)algo;
{
	self = [super initWithContentURL:nil];
    if (self) {
        self.extractor = [[LBYouTubeExtractor alloc] initWithURL:youTubeURL quality:quality];
        self.extractor.delegate = self;
        if (expression) {
            self.extractor.extractionExpression = expression;
        }
		if (signatureExpression) {
			self.extractor.signatureExtractionExpression = signatureExpression;
		}
		if (algo) {
			self.extractor.signAlgo = algo;
		}
        [self.extractor startExtracting];
    }
    return self;
}

-(id)initWithYouTubeID:(NSString *)youTubeID quality:(LBYouTubeVideoQuality)quality {
    return [self initWithYouTubeID:youTubeID quality:quality extractionExpression:nil];
}

-(id)initWithYouTubeID:(NSString *)youTubeID quality:(LBYouTubeVideoQuality)quality extractionExpression:(NSString*)expression {
	return [self initWithYouTubeID:youTubeID quality:quality extractionExpression:expression signatureExtracionExpression:nil signatureAlgo:nil];
}
-(id)initWithYouTubeID:(NSString*)youTubeID quality:(LBYouTubeVideoQuality)quality extractionExpression:(NSString*)expression signatureExtracionExpression:(NSString*)signatureExpression signatureAlgo:(NSArray*)algo {
    self = [super initWithContentURL:nil];
    if (self) {
        self.extractor = [[LBYouTubeExtractor alloc] initWithID:youTubeID quality:quality];
        self.extractor.delegate = self;
        if (expression) {
            self.extractor.extractionExpression = expression;
        }
		if (signatureExpression) {
			self.extractor.signatureExtractionExpression = signatureExpression;
		}
		if (algo) {
			self.extractor.signAlgo = algo;
		}

        [self.extractor startExtracting];
    }
    return self;
}

#pragma mark -
#pragma mark LBYouTubeExtractorDelegate

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:didSuccessfullyExtractYouTubeURL:)]) {
        [self.delegate youTubePlayerViewController:self didSuccessfullyExtractYouTubeURL:videoURL];
    }
    
    self.moviePlayer.contentURL = videoURL;
    [self.moviePlayer play];
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(youTubePlayerViewController:failedExtractingYouTubeURLWithError:)]) {
        [self.delegate youTubePlayerViewController:self failedExtractingYouTubeURLWithError:error];
    }
}

#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
//    NSLog(@"shouldAutorotateToInterfaceOrientation");
    
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    
//    NSLog(@"shouldAutorotate");
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    
//    NSLog(@"supportedInterfaceOrientations");
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


@end
