//
//  DetailViewController.h
//  eLMS
//
//  Created by MacMini2 on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate, UISearchBarDelegate>
{
    double keyboardAnimationTime;
    
    NSMutableArray *engineNames;
    NSMutableArray *engineNamesSearch;
    NSMutableArray *blocks;
    NSMutableArray *blocksSearch;
    NSMutableArray *months;
    NSMutableArray *streetNames;
    NSMutableArray *streetNamesSearch;
    NSMutableArray *streetDirections;
    NSMutableArray *types;

	BOOL foundElementName;
    int typeFound;
    int streetNameFound;
    int dataRetrieved;
    int buttonPressed;
    BOOL loadingStreetNames;
    int elementFound;
    BOOL hasCIPPropertyFound;
    BOOL hasCIPProperty;
    BOOL stringElementNameFound;
    BOOL responsePropertyFound;
    BOOL stringElementNameForResponseFound;
    BOOL userIdFound;
    BOOL fullNameFound;
    
    NSString *userId;
    NSString *fullName;
    
    BOOL engineNamesSearchActive;
    BOOL blocksSearchActive;
    BOOL streetNamesSearchActive;
    
    UIActivityIndicatorView *loadingStreetNamesActivityIndicator;
    
    UITableView *engineNameTableView;
    UITableView *blockTableView;
    UITableView *streetNameTableView;
    
    UISearchBar *engineNameSearchBar;
    UISearchBar *blockSearchBar;
    UISearchBar *streetNameSearchBar;
    
    BOOL loginSuccess;
    
    NSMutableArray *searchResults;
    
    SearchResult *searchResult;
    
    BOOL actIdFound;
    BOOL dbaNameFound;
    BOOL streetNoFound;
    BOOL streetFractionFound;
    BOOL streetDirFound;
    BOOL searchStreetNameFound;
    BOOL apartmentFound;
    BOOL zipCodeFound;
    BOOL compDateFound;
    BOOL reInspDateFound;
    BOOL engineNameFound;
    BOOL engineIdFound;
    BOOL monthFound;
    BOOL blockFound;
    BOOL addFound;
    
    NSString *actId;
    NSString *address;
    NSString *streetNo;
    NSString *streetFraction;
    NSString *streetName;
    NSString *streetDir;
    NSString *apartment;
    NSString *zipCode;
    //NSString *compDate;
    //NSString *reInspDate;
    //NSString *engineName;
    //NSString *month;
    //NSString *block;
    NSMutableString *dbaName;
    
    UIPopoverController *engineNamePopoverController;
    UIPopoverController *blockPopoverController;
    UIPopoverController *monthPopoverController;
    UIPopoverController *streetDirectionPopoverController;
    UIPopoverController *typePopoverController;
    UIPopoverController *streetNamePopoverController;
    
    NSString *elmsURL;
    
    //for test purposes only
    BOOL runTypeIsTest;
    
    BOOL loggedIn;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (retain, nonatomic) IBOutlet UITextField *usernameTextField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTextField;
@property (retain, nonatomic) IBOutlet UIView *loginView;
@property (retain, nonatomic) IBOutlet UIView *titleBarView;
@property (retain, nonatomic) IBOutlet UIView *backgroundPagesView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *infoButton;

@property (retain, nonatomic) IBOutlet UIButton *logoutButton;

@property (retain, nonatomic) IBOutlet UIButton *engineNameButton;
@property (retain, nonatomic) IBOutlet UILabel *engineNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *typeButton;
@property (retain, nonatomic) IBOutlet UILabel *typeLabel;
@property (retain, nonatomic) IBOutlet UIButton *monthButton;
@property (retain, nonatomic) IBOutlet UILabel *monthLabel;
@property (retain, nonatomic) IBOutlet UIImageView *blockButton;
@property (retain, nonatomic) IBOutlet UILabel *blockLabel;
@property (retain, nonatomic) IBOutlet UITextField *streetNumberTextField;
@property (retain, nonatomic) IBOutlet UILabel *streetDirectionLabel;
@property (retain, nonatomic) IBOutlet UIButton *streetDirectionButton;
@property (retain, nonatomic) IBOutlet UIButton *streetNameButton;
@property (retain, nonatomic) IBOutlet UILabel *streetNameLabel;
@property (retain, nonatomic) IBOutlet UITextField *unitTextField;
@property (retain, nonatomic) IBOutlet UISwitch *structureSwitch;
@property (retain, nonatomic) IBOutlet UISwitch *completedSwitch;
@property (retain, nonatomic) IBOutlet UIButton *completedCheckMarkButton;
@property (retain, nonatomic) IBOutlet UIButton *structureCheckMarkButton;
@property (retain, nonatomic) IBOutlet UIButton *clearAllButton;

@property (retain, nonatomic) SearchResult *searchResult;

@property (retain, nonatomic) NSString *address;

@property (retain, nonatomic) IBOutlet UILabel *buildVersionLabel;

- (void)startThreadToLoadStreetNames;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)completedCheckMarkButtonPressed:(id)sender;
- (IBAction)structureCheckMarkButtonPressed:(id)sender;
- (IBAction)engineNameButtonPressed:(id)sender;
- (IBAction)monthButtonPressed:(id)sender;
- (IBAction)blockButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)streetNameButtonPressed:(id)sender;
- (IBAction)findButtonPressed:(id)sender;
- (IBAction)streetDirectionButtonPressed:(id)sender;
- (IBAction)typeButtonPressed:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;
- (IBAction)clearAllButtonPressed:(id)sender;

- (IBAction)animateView:(UIView*)view duration:(float)duration delay:(float)delay dy:(float)dy;

- (void)clearButtonPressed:(id)sender;

//for test purposes only
@property (retain, nonatomic) IBOutlet UIButton *testProdToggleButton;
- (IBAction)testProdToggleButtonPressed:(id)sender;

@end
