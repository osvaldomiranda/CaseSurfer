//
//  GaleryViewController.h
//  casesurfer
//
//  Created by Osvaldo on 09-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaleryViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *zoomScrollView;
@property (nonatomic, retain)  UIScrollView *scrollView;

@property (nonatomic, retain) UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL inZoom;

@end
