//
//  rollGridChoseImageViewController.m
//  casesurfer
//
//  Created by Osvaldo on 14-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "rollGridChoseImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Definitions.h"
#import "CropViewController.h"
#import "CreateCaseTableViewController.h"
#import "AvatarTableViewController.h"
#import "UserViewController.h"

@interface rollGridChoseImageViewController ()

@end

@implementation rollGridChoseImageViewController

@synthesize scrollView;
@synthesize assetsLibrary;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    [self setScrollViewProperties];
    [self loadPhotoLibrary];
    [self.lblTitle setTextColor:greenColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:TRUE];
    self.hidesBottomBarWhenPushed =  YES;
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


- (void)selectImageWithAssetURL:(NSURL *)assetURL image:(IndexableImageView *)image selected:(BOOL *)selected{
    if(!assetURL){
        [self takePhoto];
    }else{
        [self selectImage:image];
    }
}

- (void)takePhoto{
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    
}


- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.pickerController = [[UIImagePickerController alloc] init];
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
        UIImage *img = [info valueForKeyPath:@"UIImagePickerControllerOriginalImage"];
        UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
        [scrollView clearGrid];
        [self loadPhotoLibrary];
    }
}



-(void) selectImage: (IndexableImageView *) image{
    
    [self.delegate onSelectImage:image];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([self.callerViewController class]== [UserViewController class])
    {
        AvatarTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Avatar"];
        cController.imageInfo = image;
        self.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:cController animated:YES];
    } else {
         
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
