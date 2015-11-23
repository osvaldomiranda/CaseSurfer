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

@interface rollGridViewController ()

@end

@implementation rollGridViewController

@synthesize scrollView;
@synthesize scrollViewH;
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
    
    [self instructionAlert];
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
                                                    message:@"Case Surfer requires that you remove all identifying features, such as: \n Fases, \n Names, \n All dates, \n Locations smaller than a state. \n\n for a full list of identifiers, please tap More Information."
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
    scrollView = [[GridScrollView alloc] initGrid:4 spacing:5 gridWidth:380];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(380,SCREEN_HEIGHT);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, 65, 380, SCREEN_HEIGHT-140);
    scrollView.gridDelegate = self;
    
    
    [self.view addSubview:scrollView];
}


-(void)setHScrollViewProperties{
    scrollViewH = [[HorizontalGrid alloc] initGrid:4 gridHeight:70];
    
    scrollViewH.contentMode = (UIViewContentModeScaleAspectFill);
    scrollViewH.contentSize =  CGSizeMake(400,70);
    scrollViewH.pagingEnabled = NO;
    scrollViewH.showsVerticalScrollIndicator = NO;
    scrollViewH.showsHorizontalScrollIndicator = YES;
    scrollViewH.alwaysBounceVertical = NO;
    scrollViewH.alwaysBounceHorizontal = NO;
    scrollViewH.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollViewH.maximumZoomScale = 1;
    scrollViewH.minimumZoomScale = 1;
    scrollViewH.clipsToBounds = YES;
    scrollViewH.frame = CGRectMake(0, SCREEN_HEIGHT-80, 400, 70);
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
                                     NSLog(@"error: %@", error);
                                 }];
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
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        [[self navigationController]  presentViewController:self.pickerController animated:YES completion:nil];
        self.pickerController.showsCameraControls = YES;
        
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
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        
        [scrollView clearGrid];
        [self loadPhotoLibrary];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}


-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];

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




@end
