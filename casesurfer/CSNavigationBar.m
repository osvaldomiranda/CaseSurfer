//
//  CSNavigationBar.m
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CSNavigationBar.h"
#import "Definitions.h"

@implementation CSNavigationBar

-(void)layoutSubviews
{
    [self setBackgroundColor: [UIColor whiteColor]];
    self.translucent = NO;
   
    //config title
    self.titleTextAttributes = @{NSForegroundColorAttributeName: greenColor,
                                               NSFontAttributeName: [UIFont systemFontOfSize:17.0]
                                               };
  
  

}

@end
