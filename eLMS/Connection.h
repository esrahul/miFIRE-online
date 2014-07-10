//
//  Connection.h
//  doleApplicationSupport
//
//  Created by Rahul kumar on 12/5/12.
//  Copyright (c) 2012 Vmoksha. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"
#import <sqlite3.h>
#import "DoleAppDelegate.h"
#import "MBProgressHUD.h"

@interface Connection : NSObject <ConnectionDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
	uint _offset;
 	id delegate;                    // set the delegate for the Connection Delegate
 	NSMutableArray *resultArray; 	// Return the results from the response
 	NSMutableData *receiveData;     // Get the data from the server response
    NSMutableDictionary *accountDict;
    NSString *databasePath;
	sqlite3 *contactDB;
    NSTimeInterval start;
    DoleAppDelegate *appDelegate;
}
@property (nonatomic, retain) id delegate;
 
//Call the web service for Get Method
-(void) getMethod:(NSString *) getStr;
//-(void) postMethod:(NSString *) getStr passedURL:(NSString *) getURL;

@end
