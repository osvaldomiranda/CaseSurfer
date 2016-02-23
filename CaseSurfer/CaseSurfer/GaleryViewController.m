//
//  GaleryViewController.m
//  casesurfer
//
//  Created by Osvaldo on 09-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "GaleryViewController.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"

@interface GaleryViewController ()

@end

@implementation GaleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *image1 = @"logo.png";
    self.imageView.image =  [UIImage imageNamed:image1];
    self.inZoom = NO;

    self.zoomScrollView.hidden = TRUE;
    
   
    
    [self setScroll];
    [self fillImages];
    [self setPageControlInScroll];
    [self addGestures];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:FALSE];
    [self setScrollWillApperar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) setScrollWillApperar{
    CGRect scrollViewFrame = self.view.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 2.0f;
    self.scrollView.zoomScale = minScale;
    [self centerScrollViewContents];
 
}

-(void) setScroll {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.origin.y - 100;
    self.scrollView.frame = frame;
    self.scrollView.tag = 0;
    [self.view addSubview:self.scrollView];
}


-(void) fillImages{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.images.count, self.scrollView.frame.size.height);
 
    int i=0;
    for (NSDictionary *image in self.images) {
        NSDictionary *img = [image valueForKeyPath:@"image"];
        NSDictionary *thumb = [img valueForKeyPath:@"normal"];
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@", DEV_BASE_PATH, [thumb valueForKeyPath:@"url"]];
        NSURL *urlImgCase = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        imgView.frame = frame;
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
         UIImageView *_imgView = [[UIImageView alloc] init];
        [_imgView setImageWithURL:urlImgCase placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
            
            imgView.image = image;
            [self.scrollView addSubview:imgView];
            
        } failure:^(NSError *error) {
        }];
        i++;
    }
    
}

-(void) setPageControlInScroll{
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(110,500,100,100);
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPage = 0;
    self.page = 0;
    
    [self.view addSubview:self.pageControl];
}

-(void) addGestures{
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *doubleTapZoomRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.zoomScrollView addGestureRecognizer:doubleTapZoomRecognizer];
}


#pragma Zoom

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    
    CGFloat newZoomScale = self.scrollView.zoomScale / 3.0f;
    newZoomScale = MIN(newZoomScale, self.scrollView.minimumZoomScale);
    [self.zoomScrollView setZoomScale:newZoomScale animated:YES];
    
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    CGRect rectToZoomTo ;
    if (self.inZoom) {
        self.inZoom = NO;
        rectToZoomTo = self.imageView.frame;
        [self.zoomScrollView zoomToRect:rectToZoomTo animated:YES];
        self.zoomScrollView.hidden = YES;
        self.scrollView.hidden = NO;
    }
    else {
        self.inZoom = YES;
        int i=0;
        for (UIImageView *v in self.scrollView.subviews) {
            if (i==self.page) {
                self.imageView.image = v.image;
            }
            i++;
        }
        
        
    //    rectToZoomTo = CGRectMake(location.x, location.y,180,180  );
        self.scrollView.hidden = YES;
        self.zoomScrollView.hidden = NO;

     //   [self.zoomScrollView zoomToRect:rectToZoomTo animated:NO];
        CGFloat newZoomScale = self.scrollView.zoomScale*3.0f;
        newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
        [self.zoomScrollView setZoomScale:newZoomScale animated:YES];
        

    //    [self.zoomScrollView zoomToRect:rectToZoomTo animated:YES];

    }
}




- (void)centerScrollViewContents {
    
    CGSize boundsSize = self.zoomScrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    self.imageView.frame = contentsFrame;
    
}
#pragma endZoom



#pragma delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 0) {
        if (scrollView.contentOffset.y != 0) {
            CGPoint offset = scrollView.contentOffset;
            offset.y = 0;
            scrollView.contentOffset = offset;
        }
        CGFloat pageWidth = self.scrollView.frame.size.width;
        float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
        NSInteger cPage = lround(fractionalPage);
        self.pageControl.currentPage = cPage;
        
        self.page = (int)cPage;
    }
}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {

    if (scrollView.tag == 0) {
        return nil;
    }
 
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollViewContents];
}
#pragma end delegate


@end
