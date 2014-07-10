//
//  ConnectionDelegate.h
//  doleApplicationSupport
//
//  Created by Rahul kumar on 12/5/12.
//  Copyright (c) 2012 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>

//Protocol for Connection class
@protocol ConnectionDelegate
//This method would be return the data as response from the server
-(void) getResult : (id) _result;

@end
