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


@interface rollGridViewController ()

@end

@implementation rollGridViewController

@synthesize scrollView;
@synthesize assetsLibrary;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    [self setScrollViewProperties];
    
    
    [self.lblTitle setTextColor:greenColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    self.photos = nil;
    [scrollView clearGrid];
    [self loadPhotoLibrary];
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
    scrollView.frame = CGRectMake(0, 65, 380, SCREEN_HEIGHT-60);
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
                                     NSLog(@"error: %@", error);
                                 }];
}

#pragma GridScrollView
- (void)selectImageWithAssetURL:(NSURL *)assetURL image:(IndexableImageView *)image{
    
  
    
    if(!assetURL){
        [self takePhoto];
    }else{
        [self addImageToArray:image];
    }
}
#pragma END GridScrollView

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
        
  /*      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" IMAGE "
                                                        message:@" Se guardó imagen"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    */    
        
    }
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
    if (self.photos.count < 10) {
        [self.photos addObject:image];
    }else{
        [self alertMore];
    }
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertMore {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" Maximum 10 pictures please! "
                                                    message:@" You can upload more later "
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
    [self callCrop:self];
}




@end
