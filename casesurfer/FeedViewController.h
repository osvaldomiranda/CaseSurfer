//
//  FeedViewController.h
//  casesurfer
//
//  Created by Osvaldo on 07-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "LoadingView.h"

@interface FeedViewController : UIViewController <SDWebImageManagerDelegate> {
     NSMutableArray *itemsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *feedTableView;
@property (nonatomic, assign) BOOL pullRefreshVisible;
@property (nonatomic, retain) LoadingView *refreshLoadingView;


@end
