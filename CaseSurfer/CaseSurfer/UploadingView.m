//
//  UploadingView.m
//  casesurfer
//
//  Created by Osvaldo on 16-09-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "UploadingView.h"
#import "Definitions.h"

@implementation UploadingView

@synthesize loadingIndicator, loadingMessage;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        loadingIndicator.frame = CGRectMake(175, 10, 30, 30);
        loadingIndicator.hidesWhenStopped = NO;
        [self addSubview:loadingIndicator];
        
        loadingMessage = [[UILabel alloc]init];
        loadingMessage.text = @"Uploading Case";
        loadingMessage.textAlignment = NSTextAlignmentCenter;
        [loadingMessage setFont:[UIFont systemFontOfSize:10.0f]];
        [loadingMessage setTextColor:greenColor];
        loadingMessage.frame = CGRectMake(137, 30, 100, 30);
        [self addSubview:loadingMessage];
    }
    return self;
}

- (void)startLoadingIndicator{
    [loadingIndicator startAnimating];
}

- (void)stopLoadingIndicator{
    [loadingIndicator stopAnimating];
}

@end
