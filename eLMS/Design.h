//
//  Design.h
//  doleApplicationSupport
//
//  Created by Rahul kumar on 12/5/12.
//  Copyright (c) 2012 Vmoksha. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Design : NSObject
    
+(void)createActivityIndicatorStart:(id)parentController;
+(void)createActivityIndicatorFinish:(id)parentController;
+(void)createAlertView:(NSString*)title :(NSString*)bodyText :(id)sender;
+(void)createNetworkAlert:(id)parentController;
+(void)okClicked:(UIButton*)button;

@end
