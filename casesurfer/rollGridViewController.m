//
//  rollGridViewController.m
//  Cranberry
//
//  Created by Osvaldo on 23-01-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "rollGridViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Definitions.h"
#import "CropViewController.h"
#import "Utilities.h"
#import "InstructionsViewController.h"
@import Photos;

@interface rollGridViewController ()

@end

@implementation rollGridViewController

@synthesize scrollView;
@synthesize scrollViewH;
@synthesize scrollViewCover;
@synthesize assetsLibrary;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    [self setScrollViewProperties];
    [self setHScrollViewProperties];
    
    [self.lblTitle setTextColor:greenColor];
    
    [self requestPermissions];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    self.photos = nil;
    [scrollView clearGrid];
    [scrollViewH clearGrid];
    [self loadPhotoLibrary];
    
}


-(void) instructionAlert{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" Instructions "
                                                    message:@"All uploaded images should not have any identifying features such as: \n\n -Names \n -Faces \n -Dates \n -Tattoos \n -Location \n -Institution \n\nIn some countries it is mandatory to have the written inform consent and authorization of the patient to save and publish their images and information.."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", @"More Infomation", nil];
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)  // 0 ==  cancel button
    {
        [self callInstructions:self];
  
    }
}

- (IBAction) callInstructions:(id)sender{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        InstructionsViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Instructions"];
    
        self.hidesBottomBarWhenPushed =  YES;
        [[self navigationController]  pushViewController:cController animated:YES];
}

-(void)setScrollViewProperties{
    scrollView = [[GridScrollView alloc] initGrid:4 spacing:5 gridWidth:SCREEN_WIDTH + 5];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(SCREEN_WIDTH+5,SCREEN_HEIGHT);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, 65, SCREEN_WIDTH+5, SCREEN_HEIGHT-140);
    scrollView.gridDelegate = self;
    
    [self.view addSubview:scrollView];
}


-(void)setHScrollViewProperties{
    scrollViewH = [[HorizontalGrid alloc] initGrid:4 gridHeight:70];
    
    scrollViewH.contentMode = (UIViewContentModeScaleAspectFill);
    scrollViewH.contentSize =  CGSizeMake(SCREEN_WIDTH,70);
    scrollViewH.pagingEnabled = NO;
    scrollViewH.showsVerticalScrollIndicator = NO;
    scrollViewH.showsHorizontalScrollIndicator = YES;
    scrollViewH.alwaysBounceVertical = NO;
    scrollViewH.alwaysBounceHorizontal = NO;
    scrollViewH.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollViewH.maximumZoomScale = 1;
    scrollViewH.minimumZoomScale = 1;
    scrollViewH.clipsToBounds = YES;
    scrollViewH.frame = CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 70);
    scrollViewH.gridDelegate = self;
    
    [self.view addSubview:scrollViewH];
    
    Utilities *util = [[Utilities alloc] init];
    UIView *sep = [util addSeparator:SCREEN_HEIGHT-84];
    [self.view addSubview:sep];
    
    UIView *sepB = [util addSeparator:SCREEN_HEIGHT-9];
    [self.view addSubview:sepB];
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


- (void)requestPermissions
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    
    switch (status)
    {
        case PHAuthorizationStatusAuthorized:
        {
            [self instructionAlert];
            break;
        }
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus)
             {
                 if (authorizationStatus == PHAuthorizationStatusAuthorized)
                 {
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" Instructions "
                                                                     message:@"To publish a case must authorize the app to access your photos in your iPhone settings."
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"OK", nil];
                     [alert show];
                     
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     [self instructionAlert];
                 }
             }];
            break;
        }
            
        case PHAuthorizationStatusDenied:
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" Instructions "
                                                            message:@"To publish a case must authorize the app to access your photos in your iPhone settings."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
        }
        default:
       //     block(NO);
            break;
    }
}


#pragma GridScrollView
- (void)selectImageWithAssetURL:(NSURL *)assetURL image:(IndexableImageView *)image selected:(BOOL *)selected{
    if(!assetURL){
        [self takePhoto];
    }else{
        if (selected) {
            [self addImageToArray:image];
        }
        else{
            [self delImageToArray:image];
        }
        
    }
}
#pragma END GridScrollView



#pragma HorizontalScrollView
- (void)selectHImageWithAssetURL:(UIImage *)image  indexImage:(int) indexImage assetUrl:(NSURL *) assetUrl{

}
#pragma END HorizontalScrollView


- (void)takePhoto{
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
      //  self.pickerController.showsCameraControls = YES;
        
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
                    
                    UIImage *imagePrev = img;
                    int a = imagePrev.size.height*640/imagePrev.size.width  ;
                    UIImage *imageFinal = [self imageWithImage:img convertToSize: CGSizeMake(640,a )];
                    
                    IndexableImageView *image = [[IndexableImageView alloc] initWithImage:imageFinal andUrl:assetURL andImageInfo:nil];
                    [self addImageToArray:image];
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
    sleep(1);
    
    [self loadPhotoLibrary];

}


- (IBAction) callCrop:(id)sender{
 
    if (self.photos.count > 0) {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        CropViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"CropView"];
        
        [cController setPhotos: self.photos];
        
        self.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:cController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

}



-(void) addImageToArray: (IndexableImageView *) image{
    
    if (!self.photos) self.photos = [[NSMutableArray alloc] init];
    if (self.photos.count < 5) {
        [self.photos addObject:image];
    }else{
        [self alertMore];
    }
    
    [self fillHorizontalGrid];
    [self fillcoverGrid];
}

-(void) delImageToArray: (IndexableImageView *) image{
    
    int i=0;
    int j= -1;
    for (IndexableImageView *img in self.photos) {

        if (image.assetURL == img.assetURL) {
            j = i;
        }
        i++;
    }
    
    if(j>=0){
        [self.photos removeObjectAtIndex:j];
    }
    
    [self fillHorizontalGrid];
}

-(void) fillHorizontalGrid{
    [scrollViewH clearGrid];
    for (IndexableImageView *image in self.photos) {
        [scrollViewH insertPicture:image.image withAssetURL:nil index:0];
    }
}

-(void) fillcoverGrid{
    [scrollViewCover clearGrid];
    for (IndexableImageView *image in self.photos) {
        [scrollViewCover insertPicture:image.image withAssetURL:nil index:0];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertMore {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" Maximum 5 pictures please! "
                                                    message:@" You can upload more later "
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
    [self callCrop:self];
}



- (UIView *) coverView {
    
    scrollViewCover = [[HorizontalGrid alloc] initGrid:4 gridHeight:70];
    
    scrollViewCover.contentMode = (UIViewContentModeScaleAspectFill);
    scrollViewCover.contentSize =  CGSizeMake(SCREEN_WIDTH,70);
    scrollViewCover.pagingEnabled = NO;
    scrollViewCover.showsVerticalScrollIndicator = NO;
    scrollViewCover.showsHorizontalScrollIndicator = YES;
    scrollViewCover.alwaysBounceVertical = NO;
    scrollViewCover.alwaysBounceHorizontal = NO;
    scrollViewCover.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollViewCover.maximumZoomScale = 1;
    scrollViewCover.minimumZoomScale = 1;
    scrollViewCover.clipsToBounds = YES;
    scrollViewCover.frame = CGRectMake(0, SCREEN_HEIGHT-135, SCREEN_WIDTH, 70);
    scrollViewCover.gridDelegate = self;
    
    UIColor *normal   =graySep;
    
    CGFloat screenHeight = [UIScreen mainScreen].applicationFrame.size.height;
    
    UIView *cameraCover =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, screenHeight)];;
    
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
    UIButton *cameraButton;
    
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
    
    Utilities *util = [[Utilities alloc] init];
    UIView *sep = [util addSeparator:SCREEN_HEIGHT-139];
    [cameraCover addSubview:sep];
    
    UIView *sepB = [util addSeparator:SCREEN_HEIGHT-64];
    [cameraCover addSubview:sepB];
    
    rollButton   .frame = CGRectMake(0  , screenHeight-35, 125, 50);
    cameraButton .frame = CGRectMake(125, screenHeight-35, 70 , 50);
    cancelButton .frame = CGRectMake(195, screenHeight-35, 125, 50);
    frontCam     .frame = CGRectMake(250, 25, 50, 50);
    
    [cameraCover addSubview:cancelButton];
    [cameraCover addSubview:cameraButton];
    [cameraCover addSubview:rollButton  ];
    [cameraCover addSubview:frontCam  ];
    [cameraCover addSubview:scrollViewCover];
    
    return cameraCover;
}



- (IBAction) cancelAction:(id)sender{
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
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
    [self.pickerController takePicture];
}

- (IBAction) rollAction:(id)sender{
    [self callCrop:self];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return destImage;
}

@end
