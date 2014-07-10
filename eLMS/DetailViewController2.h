//
//  DetailViewController.h
//  eLMS
//
//  Created by Rahul kumar on 12/26/12.
//  Copyright (c) 2012 vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
