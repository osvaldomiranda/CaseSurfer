
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
#import "MedCase.h"
#import "CreateCaseTableViewController.h"


@interface CropViewController ()

@end

@implementation CropViewController
@synthesize scrollView;
@synthesize assetsLibrary;
@synthesize util;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inCropp = NO;
    self.photosUpload = [[NSMutableArray alloc] init];
    
    self.displayImage.contentMode = UIViewContentModeScaleAspectFit;
    self.displayImage.userInteractionEnabled = YES;
    
    util = [[Utilities alloc] init];
    
    self.indexImage = 0;
    
    [self setScrollViewProperties];
    [self fillHorizontalView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    if (self.isNewCase) {
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    } else{
        [self.nextButton setTitle:@"Save" forState:UIControlStateNormal];
    }
}


-(void)setScrollViewProperties{
    scrollView = [[HorizontalGrid alloc] initGrid:4 gridHeight:70];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(SCREEN_WIDTH,70);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 70);
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

                         
                         UIImage *imageFinal = [util squareImageWithImage:_img];
                         
                         [scrollView insertPicture:imageFinal withAssetURL:img.assetURL index:i];
                         img.image = imageFinal;
                         
                         [self.photosUpload addObject:img];
                         
                         if (i==0) {
                             self.displayImage.image = imageFinal;
                         }
                         
                        
                     }
                 }failureBlock:^(NSError *error) {
                     //      NSLog(@"error: %@", error);
                 }
         ];
        i++;
    }
}



#pragma GridScrollView
- (void)selectHImageWithAssetURL:(UIImage *)image indexImage:(int)indexImage assetUrl:(NSURL *)assetUrl{
    [self setImageOriginal:[util squareImageWithImage:image]];
    self.indexImage = indexImage;
}
#pragma END GridScrollView


-(void) setImageOriginal:(UIImage *) image{
    [self setOriginalImage:image];
    [self.cropper removeFromSuperview];
    self.displayImage.image = image;
}

- (IBAction)trashImage:(id)sender{
    if((self.photos.count > 1) && (self.indexImage < self.photos.count) ){
        [scrollView clearGrid];
        [self setImageOriginal:nil];
        [self.photos removeObjectAtIndex:self.indexImage];
        [self fillHorizontalView];
    }
}


- (IBAction)back:(id)sender {
    [scrollView clearGrid];
    self.photos = nil;
    if (self.isNewCase) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
    }
    
}

- (IBAction)createCase:(id)sender {
    
    if(self.inCropp==YES){
        [self okCroppedImage:self];
        self.inCropp = NO;
        if (self.isNewCase) {
            [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        } else{
            [self.nextButton setTitle:@"Save" forState:UIControlStateNormal];
        }
    }
    else{
        
        if (self.isNewCase) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            CreateCaseTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"NewCase"];
            
            [cController setPhotos: self.photosUpload];
            
            self.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:cController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else{
            [self updateCase:self];
        }
    }
}

- (IBAction)updateCase:(id)sender {
    
        MedCase *medCase = [[MedCase alloc] init];
        medCase.id = self.caseId;
        
        medCase.title = nil;
        medCase.patient = nil;
        medCase.patient_age = nil;
        medCase.patient_gender = nil;
        medCase.descript = nil;
        medCase.stars = @"0";
        medCase.images = self.photosUpload;
        [medCase edit];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:upLoadingObserver
                                                            object:nil];
        
        [self.navigationController setNavigationBarHidden:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:loginObserver
                                                            object:nil];
}


- (IBAction) SetCroppedImage:(id)sender {
    if (self.inCropp) {
        [self.cropper removeFromSuperview];
        self.inCropp = NO;
        if (self.isNewCase) {
            [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
        }else{
            [self.nextButton setTitle:@"Save" forState:UIControlStateNormal];
        }
        
    }
    else{
        [self.cropper removeFromSuperview];
        self.cropper = [[CropInterface alloc]initWithFrame:self.displayImage.bounds Image:self.displayImage.image andRatio:1 andBorder:TRUE];
        self.cropper.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.60];
        [self.displayImage addSubview:self.cropper];
        self.inCropp=YES;
        [self.nextButton setTitle:@"Crop" forState:UIControlStateNormal];
    }
}

- (IBAction) okCroppedImage:(id)sender {
    
    UIImage *croppedImage = [self.cropper getCroppedImage];
    
    [self setImageOriginal: croppedImage];
    
    UIImage *imagePrev = croppedImage;
    int a = imagePrev.size.height*640/imagePrev.size.width  ;
    UIImage *imageFinal = [self imageWithImage:croppedImage convertToSize: CGSizeMake(640,a )];
    
    
    IndexableImageView *img = [[IndexableImageView alloc] initWithImage:imageFinal andAssetURL:nil andIndex:[NSNumber numberWithInt:self.indexImage]];
    
    [self.photosUpload replaceObjectAtIndex:self.indexImage withObject:img];
    
    [scrollView clearGrid];
    
    int i=0;
    for (IndexableImageView *view in self.photos ) {
        [scrollView insertPicture: view.image withAssetURL:view.assetURL index:i];
        i++;
    }
    
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return destImage;
}





@end
