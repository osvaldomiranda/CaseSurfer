//
//  AvatarTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 07-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "AvatarTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "User.h"
#import "session.h"

@interface AvatarTableViewController ()

@end

@implementation AvatarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.image.layer setMasksToBounds:YES];
    [self.image.layer setCornerRadius:100.0f];
    
    [self setSelectedImage: self.imageInfo];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:FALSE];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)setSelectedImage:(IndexableImageView *)image;
{
    ALAssetsLibrary *assetsL = [[ALAssetsLibrary alloc] init];
    
    [assetsL assetForURL: image.assetURL
             resultBlock:^(ALAsset *asset){
                 if (asset != nil){
                     ALAssetRepresentation *repr = [asset defaultRepresentation];
                     UIImage *_img = [UIImage imageWithCGImage:[repr fullResolutionImage] scale:1.0f orientation:(UIImageOrientation)[repr orientation]];
                     
                     self.image.image = _img;
                     self.imageInfo.image  = _img;
                 }
             }failureBlock:^(NSError *error) {
                 NSLog(@"error: %@", error);
             }
     ];
}

- (IBAction)update:(id)sender {
    
    User *user = [[User alloc] init];
    [user updateProfilePic: self.imageInfo];
    
    [self back];
    
}

- (void) back  {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
      //  if ([aViewController isKindOfClass:[RequiredViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
      //  }
    }
}

@end
