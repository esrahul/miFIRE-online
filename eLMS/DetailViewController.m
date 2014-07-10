//
//  DetailViewController.m
//  eLMS
//
//  Created by MacMini2 on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchResultsViewController.h"

#define ENGINE_NAME      0
#define BLOCK            1
#define MONTH            2
#define STREET_NAME      3
#define LOGOUT           4
#define LOGIN            5
#define STREET_DIRECTION 6
#define TYPE             7
#define NUMBER           8
#define UNIT             9

#define NONE            -1

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController
@synthesize testProdToggleButton;

@synthesize streetNumberTextField;
@synthesize unitTextField;
@synthesize streetDirectionLabel;
@synthesize streetDirectionButton;
@synthesize typeLabel;
@synthesize typeButton;

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

@synthesize usernameTextField = _usernameTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize loginView = _loginView;
@synthesize titleBarView = _titleBarView;
@synthesize backgroundPagesView = _backgroundPagesView;
@synthesize titleLabel;
@synthesize infoButton;

@synthesize completedCheckMarkButton;
@synthesize structureCheckMarkButton;
@synthesize clearAllButton;
@synthesize engineNameButton = _engineNameButton;
@synthesize engineNameLabel = _engineNameLabel;
@synthesize monthButton = _monthButton;
@synthesize blockButton = _blockButton;
@synthesize monthLabel = _monthLabel;
@synthesize blockLabel = _blockLabel;
@synthesize logoutButton = _logoutButton;
@synthesize streetNameButton = _streetNameButton;
@synthesize streetNameLabel = _streetNameLabel;

@synthesize completedSwitch;
@synthesize structureSwitch;

@synthesize searchResult;

@synthesize address;
@synthesize buildVersionLabel;

- (void)dealloc
{
    [_detailItem release];
    [_detailDescriptionLabel release];
    [_masterPopoverController release];
    [_usernameTextField release];
    [_passwordTextField release];
    
    [_loginView release];
    [_titleBarView release];
    [_backgroundPagesView release];
    
    [completedCheckMarkButton release];
    [structureCheckMarkButton release];
    
    [_engineNameButton release];
    [_engineNameLabel release];
    [_monthButton release];
    [_blockButton release];
    [_monthLabel release];
    [_blockLabel release];
    [_blockButton release];
    [_logoutButton release];
    [_streetNameButton release];
    
    [engineNames release];
    [engineNamesSearch release];
    [blocks release];
    [blocksSearch release];
    [months release];
    [streetNames release];
    [streetNamesSearch release];
    [streetDirections release];
    [types release];
    
    [_streetNameLabel release];
    
    [streetNumberTextField release];
    [unitTextField release];
    [streetDirectionLabel release];
    [streetDirectionButton release];
    [typeLabel release];
    
    [titleLabel release];
    [infoButton release];
    
    [clearAllButton release];
    
    [buildVersionLabel release];
    [testProdToggleButton release];
    
    [searchResults release];
    
    [actId release];
    
    [dbaName release];
    
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        [_detailItem release]; 
        _detailItem = [newDetailItem retain]; 

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   // elmsURL = @"clients.edgesoftinc.com/csi";       //test url
    //elmsURL = @"cogcsi01.glendale.gov:8888/csi";    //prod url
    
    elmsURL = @"clients.edgesoftinc.com/csiIpad";
    
    
    [[NSUserDefaults standardUserDefaults] setObject:elmsURL forKey:@"elmsURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //NSDictionary *test = [[NSBundle mainBundle] infoDictionary];
    //NSLog(@"%@", [NSString stringWithFormat:@"Build %@ of Version (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]);
    //for test/prod. testing
    //buildVersionLabel.text = [NSString stringWithFormat:@"v%@ - %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [elmsURL isEqualToString:@"clients.edgesoftinc.com"] ? @"test" : @"prod"];
    //for prod. release
    buildVersionLabel.text = [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    runTypeIsTest = YES;
    
    [self configureView];
    
    BOOL checkMarkButtonState = [[NSUserDefaults standardUserDefaults] boolForKey:@"completeCheckMarkButton"];
    
    if (checkMarkButtonState)
    {
        [completedCheckMarkButton setBackgroundImage:[UIImage imageNamed:@"greencheckmark1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [completedCheckMarkButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    BOOL structureMarkButtonState = [[NSUserDefaults standardUserDefaults] boolForKey:@"structureCheckMarkButton"];
    
    if (structureMarkButtonState)
    {
        [structureCheckMarkButton setBackgroundImage:[UIImage imageNamed:@"greencheckmark1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [structureCheckMarkButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    clearAllButton.hidden = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logoutButtonPressed"];
    
    searchResults = [[NSMutableArray alloc] init];
    
    loggedIn = NO;
}

- (void)startThreadToLoadStreetNames
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    //NSLog(@"spawning thread to load street names...");
    
    NSXMLParser *parser;

    //get the fire street number data
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/getXml.do?from=ipad&action=getStreetNames", elmsURL]];
    
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    [parser setShouldProcessNamespaces:YES];
    [parser setShouldReportNamespacePrefixes:YES];
    
    [parser parse];
    
    [parser release];
	
    [pool release];
    
    [loadingStreetNamesActivityIndicator stopAnimating];
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    
    [self setLoginView:nil];
    [self setTitleBarView:nil];
    [self setBackgroundPagesView:nil];

    [self setCompletedCheckMarkButton:nil];
    [self setStructureCheckMarkButton:nil];
    
    [self setEngineNameButton:nil];
    
    [self setEngineNameLabel:nil];
    [self setMonthButton:nil];
    [self setBlockButton:nil];
    [self setMonthLabel:nil];
    [self setBlockLabel:nil];
    [self setBlockButton:nil];
    //[self setMenuButton:nil];
    [self setStreetNameButton:nil];
    [self setStreetNameLabel:nil];
    
    [self setStreetNumberTextField:nil];
    [self setUnitTextField:nil];
    [self setStreetDirectionLabel:nil];
    [self setStreetDirectionButton:nil];
    [self setTypeLabel:nil];
    [self setTitleLabel:nil];
    [self setInfoButton:nil];
    
    [self setClearAllButton:nil];
    
    [self setBuildVersionLabel:nil];
    [self setTestProdToggleButton:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"logoutButtonPressed"]) 
    {
        [self logoutButtonPressed:nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logoutButtonPressed"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}

#pragma mark - Buttons Pressed

- (IBAction)loginButtonPressed:(id)sender
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    BOOL loginSubmissionSuccess;
    loginSuccess = NO;
    if (_usernameTextField.text.length > 0 && _passwordTextField.text.length > 0)
    {
        loginSubmissionSuccess = YES;
    }
    else
    {
        loginSubmissionSuccess = NO;
        
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Warning" message:@"You must enter a valid userID and password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginAlert show];
        [loginAlert release];
    }
    
    if (loginSubmissionSuccess)
    {   //user has entered valid input, running login with remote server
        //NSLog(@"attempting login with remote server...");
        
        //set timer to go off after n seconds if login does not succeed
        [self performSelector:@selector(popUpLoginTimeOutWarning) withObject:nil afterDelay:15.0];
        
        elementFound = NONE;
        
        hasCIPPropertyFound = NO;
        stringElementNameFound = NO; //for hasCIPProperty
        hasCIPProperty = NO;
        responsePropertyFound = NO;
        stringElementNameForResponseFound = NO;
        userIdFound = NO;
        fullNameFound = NO;
        
        NSXMLParser *parser;
        
        //login with remote server
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/mobileLogon.do?userName=%@&password=%@", elmsURL, _usernameTextField.text, _passwordTextField.text]];
        //NSLog(@"mobileLogon url: %@", url);
        
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:YES];
        [parser setShouldProcessNamespaces:YES];
        [parser setShouldReportNamespacePrefixes:YES];
        
        [parser parse];
        
        [parser release];
    }
}

- (IBAction)logoutButtonPressed:(id)sender //now the logout button
{
    buttonPressed = LOGOUT;
    
    self.backgroundPagesView.hidden = YES;
    
    self.logoutButton.hidden = YES;
    self.infoButton.hidden = YES;
    
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
    
    self.clearAllButton.hidden = NO;
    
    self.engineNameLabel.text = @"";
    self.typeLabel.text = @"";
    self.monthLabel.text = @"";
    self.blockLabel.text = @"";
    self.streetNumberTextField.text = @"";
    self.streetDirectionLabel.text = @"";
    self.streetNameLabel.text = @"";
    self.unitTextField.text = @"";
    
    loggedIn = NO;
    
    [self animateView:self.loginView duration:keyboardAnimationTime delay:0.3 dy:0.0];
 }

- (IBAction)completedCheckMarkButtonPressed:(id)sender 
{
    BOOL checkMarkButtonState = ![[NSUserDefaults standardUserDefaults] boolForKey:@"completeCheckMarkButton"];
    
    if (checkMarkButtonState)
    {
        [completedCheckMarkButton setBackgroundImage:[UIImage imageNamed:@"greencheckmark1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [completedCheckMarkButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:checkMarkButtonState forKey:@"completeCheckMarkButton"];
}

- (IBAction)structureCheckMarkButtonPressed:(id)sender 
{
    BOOL structureMarkButtonState = ![[NSUserDefaults standardUserDefaults] boolForKey:@"structureCheckMarkButton"];
    
    if (structureMarkButtonState)
    {
        [structureCheckMarkButton setBackgroundImage:[UIImage imageNamed:@"greencheckmark1.png"] forState:UIControlStateNormal];
    }
    else
    {
        [structureCheckMarkButton setBackgroundImage:nil forState:UIControlStateNormal];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:structureMarkButtonState forKey:@"structureCheckMarkButton"];
}

- (IBAction)engineNameButtonPressed:(id)sender
{
    buttonPressed = ENGINE_NAME;
    
    engineNamesSearchActive = NO;
    
    UIViewController *viewController = [[UIViewController alloc] init];
    
    UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.image = [UIImage imageNamed:@"titleBarBackgroung.png"];
    
    UILabel *titleBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBarLabel.text = @"Engine Name";
    titleBarLabel.textColor = [UIColor whiteColor];
    titleBarLabel.center = CGPointMake(titleBar.center.x, titleBar.center.y);
    titleBarLabel.backgroundColor = [UIColor clearColor];
    titleBarLabel.textAlignment = UITextAlignmentCenter;
    //titleBarLabel.font
    
    [viewController.view addSubview:titleBar];
    [viewController.view addSubview:titleBarLabel];
    [viewController.view bringSubviewToFront:titleBarLabel];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(257, 4, 55, 37);
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [viewController.view addSubview:clearButton];
    //[viewController.view bringSubviewToFront:clearButton];
    
    engineNameSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, titleBar.frame.size.height, 320, 44)];
    engineNameSearchBar.barStyle = UIBarStyleDefault;
    engineNameSearchBar.delegate = self;
    
    [viewController.view addSubview:engineNameSearchBar];
    
    engineNameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, engineNameSearchBar.frame.origin.y + titleBar.frame.size.height, 320, 392) style:UITableViewStylePlain];
    engineNameTableView.delegate = self;
    engineNameTableView.dataSource = self;
    
    [viewController.view addSubview:engineNameTableView];
    
    [engineNameTableView release];
    
    engineNamePopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [engineNamePopoverController setPopoverContentSize:CGSizeMake(320, 480)]; 
    engineNamePopoverController.delegate = self;
    
    [engineNamePopoverController presentPopoverFromRect:_engineNameButton.bounds inView:_engineNameButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    ////NSLog(@"center.x= %f center.y= %f", _engineNameButton.center.x, _engineNameButton.center.y);
}

- (IBAction)blockButtonPressed:(id)sender 
{
    buttonPressed = BLOCK;
   
    blocksSearchActive = NO;
    
    UIViewController *viewController = [[UIViewController alloc] init];
    
    UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.image = [UIImage imageNamed:@"titleBarBackgroung.png"];
    
    UILabel *titleBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBarLabel.text = @"Block";
    titleBarLabel.textColor = [UIColor whiteColor];
    titleBarLabel.center = CGPointMake(titleBar.center.x, titleBar.center.y);
    titleBarLabel.backgroundColor = [UIColor clearColor];
    titleBarLabel.textAlignment = UITextAlignmentCenter;
    //titleBarLabel.font
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(257, 4, 55, 37);
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewController.view addSubview:titleBar];
    [viewController.view addSubview:titleBarLabel];
    [viewController.view addSubview:clearButton];
    
    [viewController.view bringSubviewToFront:titleBarLabel];
    //[viewController.view bringSubviewToFront:clearButton];
    
    blockSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, titleBar.frame.size.height, 320, 44)];
    blockSearchBar.barStyle = UIBarStyleDefault;
    blockSearchBar.delegate = self;
    
    [viewController.view addSubview:blockSearchBar];
        
    blockTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, blockSearchBar.frame.origin.y + titleBar.frame.size.height, 320, 392) style:UITableViewStylePlain];
    blockTableView.delegate = self;
    blockTableView.dataSource = self;
    
    [viewController.view addSubview:blockTableView];
    
    [blockTableView release];
    
    blockPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [blockPopoverController setPopoverContentSize:CGSizeMake(320, 480)]; 
    blockPopoverController.delegate = self;
    
    [blockPopoverController presentPopoverFromRect:_blockButton.bounds inView:_blockButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    ////NSLog(@"center.x= %f center.y= %f", _engineNameButton.center.x, _engineNameButton.center.y);
}

- (IBAction)monthButtonPressed:(id)sender 
{
    buttonPressed = MONTH;
    
    UIViewController *viewController = [[UIViewController alloc] init];

    UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.image = [UIImage imageNamed:@"titleBarBackgroung.png"];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(257, 4, 55, 37);
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleBar.frame.size.height, 320, 572) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [viewController.view addSubview:titleBar];
    [viewController.view addSubview:clearButton];
    [viewController.view addSubview:tableView];
    
    [tableView release];
    
    monthPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [monthPopoverController setPopoverContentSize:CGSizeMake(320, 572)]; 
    monthPopoverController.delegate = self;
    
    [monthPopoverController presentPopoverFromRect:_monthButton.bounds inView:_monthButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    ////NSLog(@"center.x= %f center.y= %f", _engineNameButton.center.x, _engineNameButton.center.y);
}

- (IBAction)streetDirectionButtonPressed:(id)sender
{
    buttonPressed = STREET_DIRECTION;
    
    UIViewController *viewController = [[UIViewController alloc] init];
    
    UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.image = [UIImage imageNamed:@"titleBarBackgroung.png"];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(257, 4, 55, 37);
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleBar.frame.size.height, 320, 220) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [viewController.view addSubview:titleBar];
    [viewController.view addSubview:clearButton];
    [viewController.view addSubview:tableView];
    
    [tableView release];
    
    streetDirectionPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [streetDirectionPopoverController setPopoverContentSize:CGSizeMake(320, 220)]; 
    streetDirectionPopoverController.delegate = self;
    
    [streetDirectionPopoverController presentPopoverFromRect:streetDirectionButton.bounds inView:streetDirectionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    ////NSLog(@"center.x= %f center.y= %f", _engineNameButton.center.x, _engineNameButton.center.y);
}

- (IBAction)typeButtonPressed:(id)sender 
{
    buttonPressed = TYPE;
    
    UIViewController *viewController = [[UIViewController alloc] init];

    UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.image = [UIImage imageNamed:@"titleBarBackgroung.png"];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(257, 4, 55, 37);
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, titleBar.frame.size.height, 320, 176) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [viewController.view addSubview:titleBar];
    [viewController.view addSubview:clearButton];
    [viewController.view addSubview:tableView];
    
    [tableView release];
    
    typePopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [typePopoverController setPopoverContentSize:CGSizeMake(320, 176)]; 
    typePopoverController.delegate = self;
    
    [typePopoverController presentPopoverFromRect:typeButton.bounds inView:typeButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    ////NSLog(@"center.x= %f center.y= %f", _engineNameButton.center.x, _engineNameButton.center.y);
}

- (IBAction)infoButtonPressed:(id)sender
{
}

- (IBAction)streetNameButtonPressed:(id)sender
{
    buttonPressed = STREET_NAME;
    
    streetNamesSearchActive = NO;
    
    UIViewController *viewController = [[UIViewController alloc] init];
    
    UIImageView *titleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBar.image = [UIImage imageNamed:@"titleBarBackgroung.png"];
    
    UILabel *titleBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleBarLabel.text = @"Street Name";
    titleBarLabel.textColor = [UIColor whiteColor];
    titleBarLabel.center = CGPointMake(titleBar.center.x, titleBar.center.y);
    titleBarLabel.backgroundColor = [UIColor clearColor];
    titleBarLabel.textAlignment = UITextAlignmentCenter;
    //titleBarLabel.font
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(257, 4, 55, 37);
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewController.view addSubview:titleBar];
    [viewController.view addSubview:titleBarLabel];
    [viewController.view addSubview:clearButton];
    //[viewController.view bringSubviewToFront:clearButton];
    
    [viewController.view bringSubviewToFront:titleBarLabel];
    
    streetNameSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, titleBar.frame.size.height, 320, 44)];
    streetNameSearchBar.barStyle = UIBarStyleDefault;
    streetNameSearchBar.delegate = self;
    
    [viewController.view addSubview:streetNameSearchBar];
    
    if (loadingStreetNames)
    {
        loadingStreetNamesActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [loadingStreetNamesActivityIndicator startAnimating];
        
        [viewController.view addSubview:loadingStreetNamesActivityIndicator];
        
        [viewController.view bringSubviewToFront:loadingStreetNamesActivityIndicator];
    }
    
    streetNameTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, streetNameSearchBar.frame.origin.y + titleBar.frame.size.height, 320, 392) style:UITableViewStylePlain];
    streetNameTableView.delegate = self;
    streetNameTableView.dataSource = self;
    
    [viewController.view addSubview:streetNameTableView];
    
    [streetNameTableView release];
    
    streetNamePopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [streetNamePopoverController setPopoverContentSize:CGSizeMake(320, 480)]; 
    streetNamePopoverController.delegate = self;
    
    [streetNamePopoverController presentPopoverFromRect:_streetNameButton.bounds inView:_streetNameButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    ////NSLog(@"center.x= %f center.y= %f", _engineNameButton.center.x, _engineNameButton.center.y);
}

- (void)clearButtonPressed:(id)sender
{
    switch (buttonPressed)
    {
        case ENGINE_NAME:
            _engineNameLabel.text = @"";
            
            [engineNamePopoverController dismissPopoverAnimated:YES];
            break;
        case TYPE:
            typeLabel.text = @"";
            
            [typePopoverController dismissPopoverAnimated:YES];
            break;
        case BLOCK:
            _blockLabel.text = @"";
            
            [blockPopoverController dismissPopoverAnimated:YES];
            break;
        case STREET_NAME:
            _streetNameLabel.text = @"";
            
            [streetNamePopoverController dismissPopoverAnimated:YES];
            break;
        case MONTH:
            _monthLabel.text = @"";
            
            [monthPopoverController dismissPopoverAnimated:YES];
            break;
        case STREET_DIRECTION:
            streetDirectionLabel.text = @"";
            
            [streetDirectionPopoverController dismissPopoverAnimated:YES];
            /*
        case NUMBER:
            streetNumberTextField.text = @"";
            break;
        case UNIT:
            unitTextField.text = @"";
            break;
*/            
        default:
            break;
    }
}

- (IBAction)findButtonPressed:(id)sender
{
    if ([_engineNameLabel.text length] >= 0)
    {
        //searchResults = [[NSMutableArray alloc] init];
        [searchResults removeAllObjects];
        searchResult = nil;
        NSMutableArray *searchParameterObjects = [[NSMutableArray alloc] initWithObjects:_engineNameLabel, typeLabel, _monthLabel, _blockLabel, streetNumberTextField, streetDirectionLabel, _streetNameLabel, unitTextField, structureSwitch, completedSwitch, nil];
        NSMutableArray *searchParameters = [[NSMutableArray alloc] initWithObjects:@"engineName", @"yearType", @"month", @"block", @"streetNumber", @"streetDir", @"streetName", @"unit", @"structure", @"showAllInspection", nil];
        NSMutableString *urlString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"http://%@/mobileCipListAction.do?", elmsURL]];
        
        //build search url with parameters entered by user
        for (id object in searchParameterObjects)
        {
            if ([object isKindOfClass:[UILabel class]])
            {
                if (([((UILabel *)object).text length] > 0) || (object == _engineNameLabel))
                {
                    int objectIndex = [searchParameterObjects indexOfObject:object];
                    if (objectIndex == 0)
                    {
                        [urlString appendString:[NSString stringWithFormat:@"%@=%@", [searchParameters objectAtIndex:objectIndex], ((UILabel *)object).text]];
                    }
                    else 
                    {
                        [urlString appendString:[NSString stringWithFormat:@"&%@=%@", [searchParameters objectAtIndex:objectIndex], ((UILabel *)object).text]];
                    }
                }
            }
            if ([object isKindOfClass:[UITextField class]])
            {
                if ([((UITextField *)object).text length] > 0)
                {
                    int objectIndex = [searchParameterObjects indexOfObject:object];
                    if (objectIndex == 0)
                    {
                        [urlString appendString:[NSString stringWithFormat:@"%@=%@", [searchParameters objectAtIndex:objectIndex], ((UITextField *)object).text]];
                    }
                    else 
                    {
                        [urlString appendString:[NSString stringWithFormat:@"&%@=%@", [searchParameters objectAtIndex:objectIndex], ((UITextField *)object).text]];
                    }
                }
            }
            if ([object isKindOfClass:[UISwitch class]])
            {
                if (((UISwitch *)object).on)
                {
                    int objectIndex = [searchParameterObjects indexOfObject:object];
                    if (objectIndex == 0)
                    {
                        [urlString appendString:[NSString stringWithFormat:@"%@=Y", [searchParameters objectAtIndex:objectIndex]]];
                    }
                    else 
                    {
                        [urlString appendString:[NSString stringWithFormat:@"&%@=Y", [searchParameters objectAtIndex:objectIndex]]];
                    }
                }
            }
        }
        
        dbaNameFound = NO;
        streetNoFound = NO;
        streetFractionFound = NO;
        streetDirFound = NO;
        searchStreetNameFound = NO;
        apartmentFound = NO;
        zipCodeFound = NO;
        compDateFound = NO;
        reInspDateFound = NO;
        engineNameFound = NO;
        engineIdFound = NO;
        monthFound = NO;
        blockFound = NO;
        
        [searchParameterObjects release];
        [searchParameters release];
        
        NSXMLParser *parser;
        
        //NSLog(@"urlString= %@", [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/mobileCipListAction.do?engineName=%@", elmsURL, _engineNameLabel.text]]; //testing purposes
        
        //these two needed to set/reset each time a search is performed; if not, this is what caused the crashing on going back and doing another search
        streetFraction = @"";
        apartment = @"";
        
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:YES];
        [parser setShouldProcessNamespaces:YES];
        [parser setShouldReportNamespacePrefixes:YES];
        
        [parser parse]; //if back button returns to here, crash occurs (EXC_BAD_ACCESS) if Find button pressed again and engineName not changed from before; possible solution: clear entry, forcing user to make selection
        
        [parser release];
        
        [urlString release];
        
        //remove the last element from searchResults - this holds an empty object - because <object class="java.util.ArrayList"></object> causes empty element to be added
        [searchResults removeLastObject];
        
        SearchResultsViewController *pushController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:nil];
        pushController.searchResults = searchResults;
        [self.navigationController pushViewController:pushController animated:YES];
        [pushController release];
    }
    else
    {
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Search Warning" message:@"You must at least enter an engine name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginAlert show];
        [loginAlert release];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSNumber *value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    keyboardAnimationTime = [value doubleValue];
    //NSTimeInterval duration = 0;
    //[value getValue:&duration];
}

- (IBAction)clearAllButtonPressed:(id)sender
{
    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";
}

//for test purposes only
- (IBAction)testProdToggleButtonPressed:(id)sender
{
    runTypeIsTest = !runTypeIsTest;
    
    //if (runTypeIsTest) 
    //{
    //    [testProdToggleButton setTitle:@"Test" forState:UIControlStateNormal];
    //}
    //else 
    //{
    //    [testProdToggleButton setTitle:@"Prod" forState:UIControlStateNormal];
    //}
    
    if (runTypeIsTest) 
    {
        elmsURL = @"clients.edgesoftinc.com/csi";       //test url
    }
    else 
    {
        elmsURL = @"cogcsi01.glendale.gov:8888/csi";    //prod url
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:elmsURL forKey:@"elmsURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //NSLog(@"%@", [NSString stringWithFormat:@"Build %@ of Version (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]);
    //for test/prod. testing
    //buildVersionLabel.text = [NSString stringWithFormat:@"v%@ - %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [elmsURL isEqualToString:@"clients.edgesoftinc.com"] ? @"test" : @"prod"];
    //for prod. release
    buildVersionLabel.text = [NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)popUpLoginTimeOutWarning
{
    if (!loggedIn)
    {
        UIAlertView *popUpLoginTimeOutWarningAlert = [[UIAlertView alloc] initWithTitle:@"Login Warning" message:@"Please click on \"Settings\" -> Switch VPN to \"On\". Make sure your user name and password are correct. Call 3027 for help." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        popUpLoginTimeOutWarningAlert.delegate = self;
        [popUpLoginTimeOutWarningAlert show];
        [popUpLoginTimeOutWarningAlert release];
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark
#pragma mark UITextField Methods

#define iPAD_KEYBOARD_HEIGHT 274
#define BORDER                 5

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	_usernameTextField.keyboardType = UIKeyboardTypeDefault;
	_usernameTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    
    self.streetNumberTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.streetNumberTextField.returnKeyType = UIReturnKeyDone;
    self.unitTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.unitTextField.returnKeyType = UIReturnKeyDone;
    
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _usernameTextField)
    {
		if ([_usernameTextField.text length] > 0)
		{
		}
    }
    if (textField == _passwordTextField)
    {
		if ([_passwordTextField.text length] > 0)
		{
		}
    }
    if ([streetNumberTextField.text length] > 0)
    {
    }
    if ([unitTextField.text length] > 0)
    {
    }

	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// When the user presses return, take focus away from the text field so that the keyboard is dismissed.
	if (textField == _usernameTextField)
	{
		[_usernameTextField resignFirstResponder];
		
		if ([_usernameTextField.text length] > 0)
		{
		}
	}
    
	if (textField == _passwordTextField)
	{
		[_passwordTextField resignFirstResponder];
		
		if ([_passwordTextField.text length] > 0)
		{
		}
	}
	
    if (textField == streetNumberTextField)
    {
        [streetNumberTextField resignFirstResponder];
    }
	
    if (textField == unitTextField)
    {
        [unitTextField resignFirstResponder];
    }
    
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{	
	return YES;
}

- (BOOL)textViewShouldReturn:(UITextView *)textView
{
	return YES;
}

#pragma mark
#pragma mark TableView methods

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    switch (buttonPressed)
    {
        case ENGINE_NAME:
            if (engineNamesSearchActive)
            {
                return [engineNamesSearch count];
            }
            else
            {
                return [engineNames count];
            }
            break;
        case BLOCK:
            if (blocksSearchActive)
            {
                return [blocksSearch count];
            }
            else
            {
                return [blocks count];
            }
            break;
        case MONTH:
            return [months count];
            break;
        case STREET_NAME:
            if (streetNamesSearchActive)
            {
                return [streetNamesSearch count];
            }
            else
            {
                return [streetNames count];
            }
            break;
        case STREET_DIRECTION:
            return [streetDirections count];
            break;
        case TYPE:
            return [types count];
            break;
            
        default:
            return 0;
            break;
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
	static NSString *cellID = @"parksNResortsCell";
	
	RootControllerTableCell *cell = (RootControllerTableCell *) [tableView dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil)
	{
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"RootControllerTableCell" owner:self options:nil];
		
		for (id currentObject in nibObjects)
		{
			if ([currentObject isKindOfClass:[RootControllerTableCell class]])
			{
				cell = (RootControllerTableCell *)currentObject;
				break;
			}
		}
	}
	*/
    
    NSString *cellIdentifier = @"engineNamesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (buttonPressed)
    {
        case ENGINE_NAME:
            if (engineNamesSearchActive)
            {
                cell.textLabel.text = [engineNamesSearch objectAtIndex:indexPath.row];
            }
            else
            {
                cell.textLabel.text = [engineNames objectAtIndex:indexPath.row];
            }
            break;
        case BLOCK:
            if (blocksSearchActive)
            {
                cell.textLabel.text = [blocksSearch objectAtIndex:indexPath.row];
            }
            else
            {
                cell.textLabel.text = [blocks objectAtIndex:indexPath.row];
            }
            break;
        case MONTH:
            cell.textLabel.text = [months objectAtIndex:indexPath.row];
            break;
        case STREET_NAME:
            if (streetNamesSearchActive)
            {
                cell.textLabel.text = [streetNamesSearch objectAtIndex:indexPath.row];
            }
            else
            {
                cell.textLabel.text = [streetNames objectAtIndex:indexPath.row];
            }
            break;
        case STREET_DIRECTION:
            cell.textLabel.text = [streetDirections objectAtIndex:indexPath.row];
            break;
        case TYPE:
            cell.textLabel.text = [types objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (buttonPressed)
    {
        case ENGINE_NAME:
            if (engineNamesSearchActive)
            {
                _engineNameLabel.text = [engineNamesSearch objectAtIndex:indexPath.row];
            }
            else
            {
                _engineNameLabel.text = [engineNames objectAtIndex:indexPath.row];
            }
            
            [engineNamePopoverController dismissPopoverAnimated:YES];
            break;
        case BLOCK:
            if (blocksSearchActive)
            {
                _blockLabel.text = [blocksSearch objectAtIndex:indexPath.row];
            }
            else
            {
                _blockLabel.text = [blocks objectAtIndex:indexPath.row];
            }
            
            [blockPopoverController dismissPopoverAnimated:YES];
            break;
        case MONTH:
            _monthLabel.text = [months objectAtIndex:indexPath.row];
            
            [monthPopoverController dismissPopoverAnimated:YES];
            break;
        case STREET_NAME:
            if (streetNamesSearchActive)
            {
                _streetNameLabel.text = [streetNamesSearch objectAtIndex:indexPath.row];
            }
            else
            {
                _streetNameLabel.text = [streetNames objectAtIndex:indexPath.row];
            }
            
            [streetNamePopoverController dismissPopoverAnimated:YES];
            break;
        case STREET_DIRECTION:
            streetDirectionLabel.text = [streetDirections objectAtIndex:indexPath.row];
            
            [streetDirectionPopoverController dismissPopoverAnimated:YES];
            break;
        case TYPE:
            typeLabel.text = [types objectAtIndex:indexPath.row];
            
            [typePopoverController dismissPopoverAnimated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark NSXMLParser Delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{	
	foundElementName = NO;
    
    ////NSLog(@"didStartElement:elementName= %@ attributeDict= %@", elementName, attributeDict);
    
    // Login - start
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"hasCIP"])
    {
        hasCIPPropertyFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"response"])
    {
        responsePropertyFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"userId"])
    {
        userIdFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"fullName"])
    {
        fullNameFound = YES;
    }
    // Login - end
    
    //
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"actId"])
    {
        //if (self.searchResult)
        //{
        //    [searchResults addObject:searchResult];
        //}
        self.searchResult = [[SearchResult alloc] init];
        
        actIdFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"dbaName"])
    {
        dbaNameFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"streetNo"])
    {
        streetNoFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"streetFraction"])
    {
        streetFractionFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"streetDir"])
    {
        streetDirFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"streetName"])
    {
        searchStreetNameFound = YES;
        ////NSLog(@"elemName= %@ nameSpace= %@ qualifiedName= %@ attrib= %@", elementName, namespaceURI, qName, attributeDict);
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"apartment"])
    {
        apartmentFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"zipCode"])
    {
        zipCodeFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"compDate"])
    {
        compDateFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"reInspDate"])
    {
        reInspDateFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"enginName"])
    {
        engineNameFound = YES;
    }
    //if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"engineId"])
    ///{   //this data not sent here. No engineId sent with engineName.
    //    engineIdFound = YES;
    //}
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"month"])
    {
        monthFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"block"])
    {
        blockFound = YES;
    }
    if ( [elementName isEqualToString:@"void"] && [[attributeDict objectForKey:@"property"] isEqualToString:@"add"])
    {
        addFound = YES;
    }
    
    if ( [elementName isEqualToString:@"string"] )
	{
        if (hasCIPPropertyFound)
        {
            stringElementNameFound = YES;
        }
        if (responsePropertyFound)
        {
            stringElementNameForResponseFound = YES;
        }
        
		////NSLog(@"Processing string Element.");
        if (streetNameFound)
        {
            foundElementName = YES;
        }
        return;
    }
    if ( [elementName isEqualToString:@"void"] && (dataRetrieved == STREET_NAME))
	{
		////NSLog(@"Processing void Element.");
        if ([[attributeDict objectForKey:@"property"] isEqualToString:@"streetName"])
        {
            streetNameFound = YES;
        }
        else
        {
            streetNameFound = NO;
        }
        return;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    ////NSLog(@"string found: %@", string);
    
    if (actIdFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:actId= %@", actId);
            
            actId = string;
            
            searchResult.actId = string;
            
            actIdFound = NO;
        }
    }
    if (apartmentFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:apartment= %@", string);
            
            apartment = string;
            
            apartmentFound = NO;
        }
    }
    if (blockFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:block= %@", string);
            
            searchResult.block = string;
            
            blockFound = NO;
        }
    }
    if (compDateFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:compDate= %@", string);
            
            searchResult.lastInspectionDate = string;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/YYYY"];
            NSDate *date = [dateFormat dateFromString:string];
            [dateFormat release];
            
            searchResult.lastInspection = date;
            
            compDateFound = NO;
        }
    }
    if (dbaNameFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:dbaName= %@", string);
            
            if (!dbaName)
            {
                dbaName = [[NSMutableString alloc] initWithString:string];
            }
            else
            {
                [dbaName appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            }
            
            //dbaNameFound = NO;
        }
    }
    if (engineNameFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:engineName= %@", string);
            
            searchResult.engine = string;
            
            engineNameFound = NO;
        }
    }
/*    if (engineIdFound)
    {
        if ([string length] > 0)
        {
            ////NSLog(@"foundCharacters:engineId= %@", string);
            
            searchResult.engineId = string;
            
            engineIdFound = NO;
        }
    }*/
    if (monthFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:month= %@", string);
            
            searchResult.month = string;
            
            monthFound = NO;
        }
    }
    if (reInspDateFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:reInspDate= %@", string);
            
            searchResult.recentInspectionDate = string;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"MM/dd/YYYY"];
            NSDate *date = [dateFormat dateFromString:string];
            [dateFormat release];
            
            searchResult.recentInspection = date;
            
            reInspDateFound = NO;
        }
    }
    if (streetDirFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:streetDir= %@", string);
            
            streetDir = string;
            
            streetDirFound = NO;
        }
    }
    if (streetFractionFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:streetFraction= %@", string);
            
            streetFraction = string;
            
            streetFractionFound = NO;
        }
    }
    if (searchStreetNameFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:searchStreetName= %@", string);
            
            streetName = searchResult.streetName = string;
            
            searchStreetNameFound = NO;
        }
    }
    if (streetNoFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:streetNo= %@", string);
            
            streetNo = string;
            
            streetNoFound = NO;
        }
    }
    if (zipCodeFound)
    {
        if ([string length] > 0) 
        {
            ////NSLog(@"foundCharacters:zipCode= %@", string);
            
            zipCode = string;
            
            if ([streetFraction length] > 0)
            {
                if ([apartment length] > 0)
                {
                    if ([streetDir length] > 0)
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@", streetNo, streetFraction, streetDir, streetName, apartment, zipCode];
                    }
                    else
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", streetNo, streetFraction, streetName, apartment, zipCode];
                    }
                }
                else
                {
                    if ([streetDir length] > 0)
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", streetNo, streetFraction, streetDir, streetName, zipCode];
                    }
                    else
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@ %@", streetNo, streetFraction, streetName, zipCode];
                    }
                }
            }
            else
            {
                if ([apartment length] > 0)
                {
                    if ([streetDir length] > 0)
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", streetNo, streetDir, streetName, apartment, zipCode];
                    }
                    else 
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@ %@", streetNo, streetName, apartment, zipCode];
                    }
                }
                else
                {
                    if ([streetDir length] > 0)
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@ %@", streetNo, streetDir, streetName, zipCode];
                    }
                    else
                    {
                        address = [NSString stringWithFormat:@"%@ %@ %@", streetNo, streetName, zipCode];
                    }
                }
            }
            ////NSLog(@"full address= %@", address);
            
            searchResult.address = address;
            searchResult.zipCode = zipCode;
            
            zipCodeFound = NO;
            
            ////NSLog(@"resetting data...");
            
            apartment = @"";
            streetNo = @"";
            streetDir = @"";
            streetFraction = @"";
            zipCode = @"";
            
        }
    }
    
    if ((typeFound) && ([string length] > 0))
    {
        switch (dataRetrieved)
        {
            case ENGINE_NAME:
                [engineNames addObject:string];
                break;
            case BLOCK:
                [blocks addObject:string];
                break;
            //case STREET_NAME:
            //    [streetNames addObject:string];
            //    break;
                
            default:
                break;
        }
        
        typeFound = NO;
    }
    
    if ([string isEqualToString:@"type"] )
    {
        ////NSLog(@"foundCharacters:type= %@", string);

        typeFound = YES;
    }
    
    if (dataRetrieved == STREET_NAME) 
    {
        if (foundElementName && ([string length] > 0))
        {
            ////NSLog(@"foundCharacters:dataRetrieved= %@", string);
            
            [streetNames addObject:string];
            
            foundElementName = NO;
            //streetNameFound = NO;
        }
    }
    
    // Login - start
    if (userIdFound)
    {
        if ([string length] > 0)
        {
            userId = string;
            
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            userIdFound = NO;
        }
    }
    if (fullNameFound)
    {
        if ([string length] > 0)
        {
            fullName = string;
            
            [[NSUserDefaults standardUserDefaults] setObject:fullName forKey:@"fullName"];            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            fullNameFound = NO;
        }
    }
    if ((hasCIPPropertyFound) && (stringElementNameFound))
    {
        if ([string isEqualToString:@"Yes"])
        {
            hasCIPProperty = YES;

            hasCIPPropertyFound = NO;
            stringElementNameFound = NO;
        }
        else
        {
            hasCIPProperty = NO;
            
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Warning" message:@"You entered an invalid userID and/or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [loginAlert show];
            [loginAlert release];
        }
    }
    if ((responsePropertyFound) && (stringElementNameForResponseFound) && hasCIPProperty)
    {
        if ([string isEqualToString:@"Success"])
        {
            responsePropertyFound = NO;
            stringElementNameForResponseFound = NO;
            
            loggedIn = YES;
            
            //float delay = 0.3;
            [self animateView:self.loginView duration:keyboardAnimationTime delay:0.3 dy:754.0];
            
            _titleBarView.hidden = NO;
            _backgroundPagesView.hidden = NO;
            _logoutButton.hidden = NO;
            titleLabel.hidden = NO;
            //infoButton.hidden = NO;
            clearAllButton.hidden = YES;
            
            //***** moved to here from viewDidLoad
            engineNames = [[NSMutableArray alloc] init];
            engineNamesSearch = [[NSMutableArray alloc] init];
            blocks = [[NSMutableArray alloc] init];
            blocksSearch = [[NSMutableArray alloc] init];
            streetNames = [[NSMutableArray alloc] init];
            streetNamesSearch = [[NSMutableArray alloc] init];
            months = [[NSMutableArray alloc] initWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil];
            streetDirections = [[NSMutableArray alloc] initWithObjects:@"N", @"S", @"E", @"W", nil];
            types = [[NSMutableArray alloc] initWithObjects:@"Odd", @"Even", @"Annual", nil];
            
            //should add streetFraction and apartment here for alloc/init
            
            engineNamesSearchActive = NO;
            blocksSearchActive = NO;
            streetNamesSearchActive = NO;
            
            typeFound = NO;
            
            NSXMLParser *parser;
            
            foundElementName = NO;
            
            dataRetrieved = ENGINE_NAME;
            
            //get the engine name data
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/getXml.do?from=ipad&action=getFireEngine", elmsURL]];
            
            parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
            
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:YES];
            [parser setShouldProcessNamespaces:YES];
            [parser setShouldReportNamespacePrefixes:YES];
            
            [parser parse];
            
            [parser release];
            
            foundElementName = NO;
            
            dataRetrieved = BLOCK;
            
            //get the fire block data
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/getXml.do?from=ipad&action=getFireBlock", elmsURL]];
            
            parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
            
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:YES];
            [parser setShouldProcessNamespaces:YES];
            [parser setShouldReportNamespacePrefixes:YES];
            
            [parser parse];
            
            [parser release];
            
            foundElementName = NO;
            
            dataRetrieved = STREET_NAME;
            
            loadingStreetNames = YES;
            
            //spawn thread for loading street names
            [NSThread detachNewThreadSelector:@selector(startThreadToLoadStreetNames) toTarget:self withObject:nil];
            //***** moved to here from viewDidLoad
        }
        else
        {
            UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Warning" message:@"You entered an invalid userID and/or password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [loginAlert show];
            [loginAlert release];
        }
    }
    else if ([string isEqualToString:@"UserNotFound"])
    {
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Warning" message:@"User not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginAlert show];
        [loginAlert release];
    }
    else if ([string isEqualToString:@"incorrectPassword"])
    {
        UIAlertView *loginAlert = [[UIAlertView alloc] initWithTitle:@"Login Warning" message:@"You entered an incorrect password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [loginAlert show];
        [loginAlert release];
    }
    // Login - end
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue;
{
    //NSLog(@"foundAttributeDeclarationWithName:elementName= %@ elementName= %@ type= %@ defaultValue= %@", attributeName, elementName, type, defaultValue);
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    ////NSLog(@"didEndElement:elementName= %@", elementName);
    if ( [elementName isEqualToString:@"void"] )
    {
        actIdFound = NO;
        apartmentFound = NO;
        streetNoFound = NO;
        streetFractionFound = NO;
        streetDirFound = NO;
        searchStreetNameFound = NO;
        zipCodeFound = NO;
        compDateFound = NO;
        reInspDateFound = NO;
        engineNameFound = NO;
        engineIdFound = NO;
        monthFound = NO;
        blockFound = NO;
        
        if (dbaNameFound)
        {
            dbaNameFound = NO;
            searchResult.name = dbaName;
            
            [dbaName release];
            dbaName = nil;
        }
    }
    if ( [elementName isEqualToString:@"object"] )
    {   //this will add an extra empty element to searchResults because it's called for end of object for <object class="java.util.ArrayList"> which encapsulates array of returned elements
        ////NSLog(@"didEndElement= object");
        if (self.searchResult)
        {
            [searchResults addObject:searchResult];
        }
        self.searchResult = [[SearchResult alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
	////NSLog(@"found white space...");
}

#pragma mark
#pragma mark Search Bar Methods

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    switch (buttonPressed)
    {
        case ENGINE_NAME:
            //engineNamesSearchActive = NO;
            
            [engineNameSearchBar resignFirstResponder];
            break;
        case BLOCK:
            //blocksSearchActive = NO;
            
            [blockSearchBar resignFirstResponder];
            break;
        case STREET_NAME:
            //streetNamesSearchActive = NO;
            
            [streetNameSearchBar resignFirstResponder];
            break;
            
        default:
            break;
    }
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    switch (buttonPressed)
    {
        case ENGINE_NAME:
            engineNamesSearchActive = NO;
            
            [engineNameSearchBar resignFirstResponder];
            break;
        case BLOCK:
            blocksSearchActive = NO;
            
            [blockSearchBar resignFirstResponder];
            break;
        case STREET_NAME:
            streetNamesSearchActive = NO;
            
            [streetNameSearchBar resignFirstResponder];
            break;
            
        default:
            break;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    switch (buttonPressed)
    {
        case ENGINE_NAME:
            [engineNamesSearch removeAllObjects];
            
            for (NSString *name in engineNames)
            {
                NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (nameRange.location != NSNotFound)
                {
                    [engineNamesSearch addObject:name];
                }
            }
            
            if (searchText.length > 0)
            {
                engineNamesSearchActive = YES;
            }
            else
            {
                engineNamesSearchActive = NO;
            }
            
            ////NSLog(@"searchText= %@ names= %@", searchText, engineNamesSearch);
            
            [engineNameTableView reloadData];
            break;
        case BLOCK:
            [blocksSearch removeAllObjects];
            
            for (NSString *name in blocks)
            {
                NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (nameRange.location != NSNotFound)
                {
                    [blocksSearch addObject:name];
                }
            }
            
            if (searchText.length > 0)
            {
                blocksSearchActive = YES;
            }
            else
            {
                blocksSearchActive = NO;
            }
            
            ////NSLog(@"searchText= %@ names= %@", searchText, blocksSearch);
            
            [blockTableView reloadData];
            break;
        case STREET_NAME:
            [streetNamesSearch removeAllObjects];
            
            for (NSString *name in streetNames)
            {
                NSRange nameRange = [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
                
                if (nameRange.location != NSNotFound)
                {
                    [streetNamesSearch addObject:name];
                }
            }
            
            if (searchText.length > 0)
            {
                streetNamesSearchActive = YES;
            }
            else
            {
                streetNamesSearchActive = NO;
            }
            
            ////NSLog(@"searchText= %@ names= %@", searchText, streetNamesSearch);
            
            [streetNameTableView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark
#pragma mark Animation Methods

- (IBAction)animateView:(UIView*)view duration:(float)duration delay:(float)delay dy:(float)dy
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:delay];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationRepeatCount:0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	view.transform = CGAffineTransformMakeTranslation(0.0, dy);
	[UIView commitAnimations];
}

@end
