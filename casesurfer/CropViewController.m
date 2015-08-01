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
    
    self.inCropp = NO;
     self.okCroppButton.hidden = YES;
    
    self.displayImage.contentMode = UIViewContentModeScaleAspectFit;
    self.displayImage.userInteractionEnabled = YES;
    self.displayImage.image = self.originalImage;
    
    self.indexImage = 0;
    
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
    scrollView.contentSize =  CGSizeMake(400,70);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, SCREEN_HEIGHT-80, 400, 70);
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
    
    NSLog(@"Indice de la imagen: %d", indexImage);
}
#pragma END GridScrollView




-(void) setImageOriginal:(UIImage *) image{
    [self setOriginalImage:image];
    
    [self.cropper removeFromSuperview];
    self.displayImage.image = self.originalImage;
    
    
}

- (IBAction)trashImage:(id)sender{
    
    if(self.photos.count > 1){
        [scrollView clearGrid];
        [self setImageOriginal:nil];
        [self.photos removeObjectAtIndex:self.indexImage];
        [self fillHorizontalView];
    }
}


- (IBAction)back:(id)sender {
    [scrollView clearGrid];
    self.photos = nil;
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

- (IBAction) SetCroppedImage:(id)sender {
    
    
    if (self.inCropp) {
        [self.cropper removeFromSuperview];
        self.displayImage.image = self.originalImage;
        self.inCropp = NO;
        self.okCroppButton.hidden = YES;
    }
    else{
        [self.cropper removeFromSuperview];
        self.cropper = [[CropInterface alloc]initWithFrame:self.displayImage.bounds Image:self.originalImage andRatio:1];
        self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
        [self.displayImage addSubview:self.cropper];
        self.inCropp=YES;
        self.okCroppButton.hidden = NO;
    }
}

- (IBAction) okCroppedImage:(id)sender {
    
     self.okCroppButton.hidden = YES;
    
     UIImage *croppedImage = [self.cropper getCroppedImage];
     
     [self setImageOriginal: croppedImage];
     IndexableImageView *img = [[IndexableImageView alloc] initWithImage:croppedImage andAssetURL:nil andIndex:[NSNumber numberWithInt:self.indexImage]];
     [self.photos replaceObjectAtIndex:self.indexImage withObject:img];
     
     [scrollView clearGrid];
     
     int i=0;
     for (IndexableImageView *view in self.photos ) {
     [scrollView insertPicture: view.image withAssetURL:view.assetURL index:i];
     i++;
     }
    
}

@end
