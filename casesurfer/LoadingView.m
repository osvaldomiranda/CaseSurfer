//
//  LoadingView.m
//  Cranberry
//
//  Created by Nicolas Pinilla on 3/23/15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "LoadingView.h"
#import "Definitions.h"

@implementation LoadingView

@synthesize loadingIndicator, loadingMessage;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        loadingIndicator.frame = CGRectMake(145, 10, 30, 30);
        loadingIndicator.hidesWhenStopped = NO;
        [self addSubview:loadingIndicator];
        
        loadingMessage = [[UILabel alloc]init];
        loadingMessage.text = @"Loading";
        loadingMessage.textAlignment = NSTextAlignmentLeft;
        [loadingMessage setFont:[UIFont systemFontOfSize:10.0f]];
        [loadingMessage setTextColor:greenColor];
        loadingMessage.frame = CGRectMake(137, 30, 75, 30);
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
