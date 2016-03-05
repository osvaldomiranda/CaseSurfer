//
//  CustomTabBarController.h
//  cranberrychic-iphone-2
//
//  Created by mac1 on 29-09-13.
//  Copyright (c) 2013 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSToolbar.h"

@interface CustomTabBarController : UITabBarController<CStoolbarDelegate>{
    NSInteger currentSelectedIndex;
    BOOL buttonsCreated;
    NSArray *viewControllersArray;
    CSToolBar *tool;

}

@property (nonatomic, strong) NSArray *viewControllersArray;

- (void)changeIndex:(NSInteger)newIndex;

@end
