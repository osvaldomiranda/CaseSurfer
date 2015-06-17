//
//  CaseViewController.m
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseTableViewCell.h"
#import "CommentViewController.h"
#import "Definitions.h"
#import "LargerImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MedCase.h"
#import "UIImageView+WebCache.h"

@interface CaseViewController ()

@end

@implementation CaseViewController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setScrollViewProperties];
    
    MedCase *medCase = [[MedCase alloc] init];
    
    [medCase find:self.caseId Success:^(NSMutableDictionary *items) {
        
         NSLog(@"Items %@ %d",items, self.caseId);
        
        [self fillCase: items];
    } Error:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

-(void) fillCase: (NSMutableDictionary*) item{
    
   
    
    self.lblTitle.text = [item valueForKeyPath:@"title"];
    self.lblDescription.text = [item valueForKeyPath:@"description"];
    
    NSString *patient = [item valueForKeyPath:@"patient"];
    NSString *gender = [item valueForKeyPath:@"patient_gender"];
    NSString *age = [item valueForKeyPath:@"patient_age"];
    
    self.lblData.text = [NSString stringWithFormat:@"%@, %@, %@ years old", patient, gender, age ];
    
    self.images = [item valueForKeyPath:@"medcase_images"];
    
    [self fillHorizontalView:self.images];
    
    
}

-(void) fillHorizontalView:(NSArray *) images{
    
    int i = 0;
    for (NSDictionary *image in images) {
        
        NSDictionary *img = [image valueForKeyPath:@"image"];
        NSDictionary *thumb = [img valueForKeyPath:@"thumb"];
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",BASE_PATH, [thumb valueForKeyPath:@"url"]];
        NSURL *urlImgCase = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
   //     IndexableImageView *imageInfo = [[IndexableImageView alloc] initWithUrl:urlImgCase andImageInfo:image];
        
        UIImageView *coverAlbum = [[UIImageView alloc] init];
        [coverAlbum setImageWithURL:urlImgCase placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
            
            [scrollView insertPicture:image withAssetURL:urlImgCase index:i];
            
        } failure:^(NSError *error) {
        }];
        
        i++;
    }
 
}

-(void)setScrollViewProperties{
    scrollView = [[HorizontalGrid alloc] initGrid:8 gridHeight:85];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(400,85);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, 191, 400, 85);
    scrollView.gridDelegate = self;
    
    [self.view addSubview:scrollView];
}

-(void)loadPhotoLibrary{
    
     ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                                     if (group != nil){
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                                             if (result != nil){
                                                 UIImage *img = [UIImage imageWithCGImage:[result thumbnail]];
                                                 [scrollView insertPicture:img withAssetURL:[result valueForProperty:ALAssetPropertyAssetURL] index:0];
                                             }
                                         }];
                                     }
                                 } failureBlock:^(NSError *error) {
                                     NSLog(@"error: %@", error);
                                 }];
}



#pragma GridScrollView

- (void) selectImageWithAssetURL:(UIImage *)image indexImage:(int)indexImage assetUrl:(NSURL *)assetUrl
{
    
    NSDictionary *imageInfo = self.images[indexImage];
    NSDictionary *img = [imageInfo valueForKeyPath:@"image"];
    NSDictionary *thumb = [img valueForKeyPath:@"normal"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",BASE_PATH, [thumb valueForKeyPath:@"url"]];
    NSURL *urlImgCase = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    [imageView setImageWithURL:urlImgCase placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
        
        [self setSelectedImage:image];
        [self callLargeImage:self];
        
    } failure:^(NSError *error) {
    }];
  

  
}
#pragma END GridScrollView



#pragma Table View
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCell"];
    [cell.contentView clearsContextBeforeDrawing];

    
    return cell;
}

#pragma END Table View


- (IBAction)comment:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CommentViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Comments"];
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

- (IBAction)callLargeImage:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LargerImageViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"LargeImage"];
    
    cController.originalImage = self.selectedImage;
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
