//
//  CropViewController.m
//  casesurfer
//
//  Created by Osvaldo on 26-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CropViewController.h"
#import "Definitions.h"
#import "IndexableImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CreateCaseTableViewController.h"


@interface CropViewController ()

@end

@implementation CropViewController
@synthesize scrollView;
@synthesize assetsLibrary;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayImage.contentMode = UIViewContentModeScaleAspectFit;
    self.displayImage.userInteractionEnabled = YES;
    
    self.cropper = [[CropInterface alloc]initWithFrame:self.displayImage.bounds Image:self.originalImage andRatio:1.0];
    self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    [self.displayImage addSubview:self.cropper];
    
    self.indexImage = 1;
    
    [self setScrollViewProperties];
    [self fillHorizontalView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:TRUE];
}


-(void)setScrollViewProperties{
    scrollView = [[HorizontalGrid alloc] initGrid:4 gridHeight:70];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(320,70);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, SCREEN_HEIGHT-80, 320, 70);
    scrollView.gridDelegate = self;
    
    [self.view addSubview:scrollView];
}

-(void) fillHorizontalView{
    
    int i = 0 ;
    for (IndexableImageView *img in self.photos){
        ALAssetsLibrary *assetsL = [[ALAssetsLibrary alloc] init];
        
        [assetsL assetForURL: img.assetURL
                 resultBlock:^(ALAsset *asset){
                     if (asset != nil){
                         ALAssetRepresentation *repr = [asset defaultRepresentation];
                         UIImage *_img = [UIImage imageWithCGImage:[repr fullResolutionImage] scale:1.0f orientation:(UIImageOrientation)[repr orientation]];
                         if (i==0){
                             [self setImageOriginal:_img];
                         }
                         [scrollView insertPicture:_img withAssetURL:img.assetURL index:i];
                     }
                 }failureBlock:^(NSError *error) {
                     NSLog(@"error: %@", error);
                 }
         ];

        
        i++;
    }
    
}




#pragma GridScrollView
- (void)selectImageWithAssetURL:(UIImage *)image indexImage:(int)indexImage assetUrl:(NSURL *)assetUrl{
    
   [self setImageOriginal:image];
    self.indexImage = indexImage;
}
#pragma END GridScrollView




-(void) setImageOriginal:(UIImage *) image{
    [self setOriginalImage:image];
     self.displayImage.image = self.originalImage;
    
}

- (IBAction)trashImage:(id)sender{
    [scrollView clearGrid];
    [self setImageOriginal:nil];
    [self.photos removeObjectAtIndex:self.indexImage];
    [self fillHorizontalView];
    
}


- (IBAction)back:(id)sender {
    [scrollView clearGrid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createCase:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CreateCaseTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"NewCase"];
    
    [cController setPhotos: self.photos];
    
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:cController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

@end
