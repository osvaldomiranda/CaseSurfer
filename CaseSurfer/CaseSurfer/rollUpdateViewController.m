//
//  rollUpdateViewController.m
//  casesurfer
//
//  Created by Osvaldo on 13-09-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "rollUpdateViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Definitions.h"
#import "CropViewController.h"
#import "Utilities.h"
#import "HorizontalGrid.h"

@interface rollUpdateViewController ()

@end

@implementation rollUpdateViewController

@synthesize scrollView;
@synthesize scrollViewCover;
@synthesize assetsLibrary;
@synthesize cameraButton;
@synthesize util;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    util = [[Utilities alloc] init];
    [self setScrollViewProperties];
    [self setToptButtons];
    [self.lblTitle setTextColor:greenColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.photos = nil;
    [scrollView clearGrid];
    [self loadPhotoLibrary];
}

- (void) setToptButtons{
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(done:)];
    
    [self.navigationItem setRightBarButtonItem:rItem animated:YES];
}

-(void)setScrollViewProperties{
    scrollView = [[GridScrollView alloc] initGrid:4 spacing:5 gridWidth:SCREEN_WIDTH];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-10);
    scrollView.gridDelegate = self;
    
    [self.view addSubview:scrollView];
}

-(void)loadPhotoLibrary{
    
    UIImage *imageCamera = [UIImage imageNamed:@"camera_blue.png"];
    
    [scrollView insertPicture:imageCamera withAssetURL:nil indexImage:nil ];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                                     if (group != nil){
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                                             if (result != nil){
                                                 UIImage *img = [UIImage imageWithCGImage:[result thumbnail]];
                                                 
                                                 [scrollView insertPicture:img withAssetURL:[result valueForProperty:ALAssetPropertyAssetURL] indexImage:nil];
                                             }
                                         }];
                                     }
                                 } failureBlock:^(NSError *error) {
                         //            NSLog(@"error: %@", error);
                                 }];
}



#pragma GridScrollView
- (void)selectImageWithAssetURL:(NSURL *)assetURL image:(IndexableImageView *)image selected:(BOOL *)selected{
    
    if(!assetURL){
        [self takePhoto];
    }else{
        [self addImageToArray:image];
    }
}
#pragma END GridScrollView



-(void) addImageToArray: (IndexableImageView *) image{
    if (!self.photos) self.photos = [[NSMutableArray alloc] init];
    if (self.photos.count < 5) {
        [self.photos addObject:image];
    }else{
        [self alertMore];
    }
    [self fillHorizontalGrid];
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertMore {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" Maximum 5 new pictures please! "
                                                    message:@" You can upload more later "
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
}



- (IBAction) done:(id)sender{
    if (self.photos.count > 0) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CropViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"CropView"];
        cController.isNewCase = false;
        cController.caseId = self.caseId;
        cController.delegate = self;
        
        [cController setPhotos: self.photos];
        self.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:cController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
      
      //  [self.delegate selectImages:self.photos];
    }
   // [self.navigationController popViewControllerAnimated:YES];
}



// ****************************  Logica de la camara

- (void)takePhoto{
    [self fillHorizontalGrid];
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    
}


- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.pickerController = [[UIImagePickerController alloc] init];
    self.pickerController.delegate = self;
    self.pickerController.navigationBarHidden = YES;
    
    UIView *cameraCover =  [self coverView];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [[self navigationController]  presentViewController:self.pickerController animated:YES completion:nil];
        
        self.pickerController.showsCameraControls = NO;
        self.pickerController.cameraOverlayView = cameraCover ;
        
    }else{
#if TARGET_IPHONE_SIMULATOR
        NSDictionary *info = [NSDictionary dictionaryWithObject:[UIImage imageNamed:@"caseImage.jpg"]
                                                         forKey:@"UIImagePickerControllerOriginalImage"];
        [self imagePickerController:nil didFinishPickingMediaWithInfo:info];
#endif
    }
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    
    if (info) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [assetsLibrary writeImageToSavedPhotosAlbum:[img CGImage] orientation:(ALAssetOrientation)[img imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            
            if (error) {
                NSLog(@"error");  // oops, error !
            } else {
                if (assetURL != NULL) {
                    
                    UIImage *imageFinal = [util squareImageWithImage:img];
                    IndexableImageView *image = [[IndexableImageView alloc] initWithImage:imageFinal andUrl:assetURL andImageInfo:nil];
                    [self addImageToArray:image];
                    
                    cameraButton.backgroundColor = gray;
                   
                }
                
            }
        }];
        
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [scrollView clearGrid];
    [self loadPhotoLibrary];
    
}


- (UIView *) coverView {
    scrollViewCover = [[HorizontalGrid alloc] initGrid:4 gridHeight:100];
    
    scrollViewCover.contentMode = (UIViewContentModeScaleAspectFill);
    scrollViewCover.contentSize =  CGSizeMake(SCREEN_WIDTH,100);
    scrollViewCover.pagingEnabled = NO;
    scrollViewCover.showsVerticalScrollIndicator = NO;
    scrollViewCover.showsHorizontalScrollIndicator = YES;
    scrollViewCover.alwaysBounceVertical = NO;
    scrollViewCover.alwaysBounceHorizontal = NO;
    scrollViewCover.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollViewCover.maximumZoomScale = 1;
    scrollViewCover.minimumZoomScale = 1;
    scrollViewCover.clipsToBounds = YES;
    scrollViewCover.frame = CGRectMake(0, SCREEN_HEIGHT-170, SCREEN_WIDTH, 100);
    scrollViewCover.gridDelegate = self;
    
    UIColor *normal   =graySep;
    
    CGFloat screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
    
    UIView *cameraCover =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, screenHeight)];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    UIImage *imageBcancel = [UIImage imageNamed:@"icon_action_button_cancel.png"];
    [cancelButton setImage:imageBcancel forState:UIControlStateNormal];
    
    [cancelButton setTitle:@" Next" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(rollAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    
    [cancelButton setTitleColor:[UIColor colorWithRed:0.47 green:0.35 blue:0.37 alpha:1]
                       forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:normal];
    
    // ******************************
    
    cameraButton = [[UIButton alloc] init];
    UIImage *imageB3 = [UIImage imageNamed:@"icon_bar_button_shot.png"];
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [cameraButton addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cameraButton.backgroundColor = gray;
    [cameraButton setImage:imageB3 forState:UIControlStateNormal];
    
    
    // ******************************
    UIButton *frontCam;
    UIImage *imageFronCam = [UIImage imageNamed:@"front_camera.png"];
    frontCam = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [frontCam addTarget:self action:@selector(swithCamAction:) forControlEvents:UIControlEventTouchUpInside];
    
    frontCam.backgroundColor = [UIColor clearColor];
    [frontCam setImage:imageFronCam forState:UIControlStateNormal];
    
    // ******************************
    
    UIButton *rollButton = [[UIButton alloc] init];
    
    UIImage *imageBroll = [UIImage imageNamed:@"icon_action_button_gallery.png"];
    [rollButton setImage:imageBroll forState:UIControlStateNormal];
    
    [rollButton setTitle:@" Cancel" forState:UIControlStateNormal];
    [rollButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [rollButton setTitleColor:[UIColor colorWithRed:0.47 green:0.35 blue:0.37 alpha:1]
                     forState:UIControlStateNormal];
    [rollButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [rollButton setBackgroundColor:normal];
    
    
    UIView *cameraMaskTop =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIView *cameraMaskFoot =  [[UIView alloc] initWithFrame:CGRectMake(0,SCREEN_WIDTH+70, SCREEN_WIDTH, SCREEN_HEIGHT-(SCREEN_WIDTH+70))];
    cameraMaskTop.backgroundColor = [UIColor whiteColor];
    cameraMaskFoot.backgroundColor = [UIColor whiteColor];
    
   
    UIView *sep = [util addSeparator:0];
    [cameraMaskFoot addSubview:sep];
    
    UIView *sepB = [util addSeparator:113];
    [cameraMaskFoot addSubview:sepB];
    
    rollButton   .frame = CGRectMake(0  , screenHeight-35, 125, 50);
    cameraButton .frame = CGRectMake(125, screenHeight-35, 70 , 50);
    cancelButton .frame = CGRectMake(195, screenHeight-35, 125, 50);
    frontCam     .frame = CGRectMake(250, 0, 50, 50);
    
    [cameraCover addSubview:cameraMaskTop];
    [cameraCover addSubview:cameraMaskFoot];
    [cameraCover addSubview:cancelButton];
    [cameraCover addSubview:cameraButton];
    [cameraCover addSubview:rollButton  ];
    [cameraCover addSubview:frontCam  ];
    [cameraCover addSubview:scrollViewCover];
    
    return cameraCover;
}


#pragma HorizontalScrollView
- (void)selectHImageWithAssetURL:(UIImage *)image  indexImage:(int) indexImage assetUrl:(NSURL *) assetUrl{
    
}
#pragma END HorizontalScrollView

-(void) fillHorizontalGrid{
    [scrollViewCover clearGrid];
    for (IndexableImageView *image in self.photos) {
        [scrollViewCover insertPicture:image.image withAssetURL:nil index:0];
    }
}



- (IBAction) swithCamAction:(id)sender{
    if (self.pickerController.cameraDevice == UIImagePickerControllerCameraDeviceRear) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerCameraDeviceFront]) {
            self.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }else {
        self.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
}

- (IBAction) cameraAction:(id)sender{
    cameraButton.backgroundColor = darkGray;
    [self.pickerController takePicture];
}

- (IBAction) rollAction:(id)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self done:self];
}

- (IBAction) cancelAction:(id)sender{
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
}



#pragma cropDelegate
- (void)selectImages:(NSMutableArray *)images{
}
#pragma END cropDelegate



@end
