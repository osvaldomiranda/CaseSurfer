//
//  UploadingView.h
//  casesurfer
//
//  Created by Osvaldo on 16-09-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadingView : UIView

@property (nonatomic, retain) UILabel *loadingMessage;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicator;

- (void)startLoadingIndicator;
- (void)stopLoadingIndicator;

@end
