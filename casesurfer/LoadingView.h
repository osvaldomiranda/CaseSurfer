//
//  LoadingView.h
//  Cranberry
//
//  Created by Nicolas Pinilla on 3/23/15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

@property (nonatomic, retain) UILabel *loadingMessage;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;

- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;

@end
