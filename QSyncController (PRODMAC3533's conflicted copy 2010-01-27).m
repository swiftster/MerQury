//
//  QSyncController.m
//  QSSync
//
//  Created by Jason Tratta on 12/4/09.
//  Copyright 2009 Sound Character . All rights reserved.
//

#import "QSyncController.h"
#import "AsyncSocket.h"
#import "MessageBroker.h"
#import "Message.h"
#import "SGHotKeyCenter.h"
#import	"ImportOp.h"





NSString *kGlobalGoKey = @"Global Go Key";
NSString *kGlobalStopKey = @"Global Stop Key";
NSString *kGlobalUpKey = @"Global Up Key";
NSString *kGlobalDownKey = @"Global Down Key";
NSString *kGlobalBecomePrimaryKey = @"Global Primary Key";



@implementation QSyncController

//Server
@synthesize listeningSocket;
@synthesize connectionSocket;
@synthesize messageBroker;
@synthesize localServerName;

//Client 
@synthesize browser;
@synthesize services;
@synthesize isConnected;
@synthesize connectedService;
@synthesize socket;

//hotkeys
@synthesize hotKeyGoControl;
@synthesize hotKeyStopControl; 
@synthesize hotKeyUpSelectionControl; 
@synthesize hotKeyDownSelectionControl; 
@synthesize hotKeyBecomePrimaryControl; 
@synthesize goKey;
@synthesize stopKey; 
@synthesize upKey; 
@synthesize downKey; 
@synthesize primaryKey; 

//App 
@synthesize preLoad; 

//iPhone 
@synthesize acceptiPhoneControl;



-(id)init
{
	[super init]; 
	qlabScripts = [[QlabScripting alloc] init]; 
	if ([qlabScripts isQlabActive] == TRUE) { 
		[qlabScripts loadQlabArray];  }
	
	
	
	
	queue = [[NSOperationQueue alloc] init];
	
	return self; 
}



-(void)awakeFromNib {    
    
	
	//Client 
	services = [NSMutableArray new];
    self.browser = [[NSNetServiceBrowser new] autorelease];
    self.browser.delegate = self;
    self.isConnected = NO;
	
	
	
	if ([qlabScripts isQlabActive] == YES) { 
		[self importData]; }
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)theNotification {
	
	[self registerHotKeys]; 
	

	
	//Server 
	[self startService];
	[self search:self];
	
}

- (void)applicationWillTerminate:(NSNotification *)theNotification {
	[[NSUserDefaults standardUserDefaults] setObject:[self.goKey.keyCombo plistRepresentation] forKey:kGlobalGoKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.stopKey.keyCombo plistRepresentation] forKey:kGlobalStopKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.upKey.keyCombo plistRepresentation] forKey:kGlobalUpKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.downKey.keyCombo plistRepresentation] forKey:kGlobalDownKey];
	[[NSUserDefaults standardUserDefaults] setObject:[self.primaryKey.keyCombo plistRepresentation] forKey:kGlobalBecomePrimaryKey];
	
	
} 

# pragma mark -
#pragma mark Register HotKeys 

-(void)registerHotKeys { 
	
	//GO Key
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:goKey];	
	id goKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalGoKey];
	SGKeyCombo *goKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:goKeyComboPlist] autorelease];
	goKey = [[SGHotKey alloc] initWithIdentifier:kGlobalGoKey keyCombo:goKeyCombo target:self action:@selector(goKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:goKey];
	[hotKeyGoControl setKeyCombo:SRMakeKeyCombo(goKey.keyCombo.keyCode, [hotKeyGoControl carbonToCocoaFlags:goKey.keyCombo.modifiers])];
	
	//Stop Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:stopKey];	
	id stopKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalStopKey];
	SGKeyCombo *stopKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:stopKeyComboPlist] autorelease];
	stopKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:stopKeyCombo target:self action:@selector(stopKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:stopKey];
	[hotKeyStopControl setKeyCombo:SRMakeKeyCombo(stopKey.keyCombo.keyCode, [hotKeyGoControl carbonToCocoaFlags:stopKey.keyCombo.modifiers])];
	
	//Up Selection Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:upKey];	
	id upKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalUpKey];
	SGKeyCombo *upKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:upKeyComboPlist] autorelease];
	upKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:upKeyCombo target:self action:@selector(upKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:upKey];
	[hotKeyUpSelectionControl setKeyCombo:SRMakeKeyCombo(upKey.keyCombo.keyCode, [hotKeyUpSelectionControl carbonToCocoaFlags:upKey.keyCombo.modifiers])];
	
	//Down Selection Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:downKey];	
	id downKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalDownKey];
	SGKeyCombo *downKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:downKeyComboPlist] autorelease];
	downKey = [[SGHotKey alloc] initWithIdentifier:kGlobalStopKey keyCombo:downKeyCombo target:self action:@selector(downKeyPressed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:downKey];
	[hotKeyDownSelectionControl setKeyCombo:SRMakeKeyCombo(downKey.keyCombo.keyCode, [hotKeyDownSelectionControl carbonToCocoaFlags:downKey.keyCombo.modifiers])];
	
	//Become Primary Key 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:primaryKey];	
	id primaryKeyComboPlist = [[NSUserDefaults standardUserDefaults] objectForKey:kGlobalBecomePrimaryKey];
	SGKeyCombo *primaryKeyCombo = [[[SGKeyCombo alloc] initWithPlistRepresentation:primaryKeyComboPlist] autorelease];
	primaryKey = [[SGHotKey alloc] initWithIdentifier:kGlobalBecomePrimaryKey keyCombo:primaryKeyCombo target:self action:@selector(becomePrimaryPresssed:)];
	[[SGHotKeyCenter sharedCenter] registerHotKey:primaryKey];
	[hotKeyBecomePrimaryControl setKeyCombo:SRMakeKeyCombo(primaryKey.keyCombo.keyCode, [hotKeyBecomePrimaryControl carbonToCocoaFlags:primaryKey.keyCombo.modifiers])];
	
	
}

-(void)unregisterHotKeys { 
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:goKey];	
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:stopKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:upKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:downKey];
	[[SGHotKeyCenter sharedCenter] unregisterHotKey:primaryKey];
}

-(void)clearKeys { 
	
	[goKey setKeyCombo:nil]; 
	
}



- (void)goKeyPressed:(id)sender {
	
	
	NSLog(@"Go Pressed");  
	Message *newMessage = [[[Message alloc] init] autorelease];
    newMessage.tag = 110;
    [self.messageBroker sendMessage:newMessage];
	[qlabScripts goCue];
}

- (void)stopKeyPressed:(id)sender {
	[qlabScripts stopCue];
	NSLog(@"Stop Pressed");  
    Message *newMessage = [[[Message alloc] init] autorelease];
    newMessage.tag = 120;
    [self.messageBroker sendMessage:newMessage];
}

- (void)upKeyPressed:(id)sender {
	[qlabScripts moveSelectionUp];
	NSLog(@"Up Pressed");  
	//NSData *data = [textView.string dataUsingEncoding:NSUTF8StringEncoding];
    Message *newMessage = [[[Message alloc] init] autorelease];
    newMessage.tag = 130;
    //newMessage.dataContent = data;
    [self.messageBroker sendMessage:newMessage];
}

- (void)downKeyPressed:(id)sender {
	[qlabScripts moveSelectionDown];
	NSLog(@"Down Pressed");  
	//NSData *data = [textView.string dataUsingEncoding:NSUTF8StringEncoding];
    Message *newMessage = [[[Message alloc] init] autorelease];
    newMessage.tag = 140;
    //newMessage.dataContent = data;
    [self.messageBroker sendMessage:newMessage];
}

-(void)becomePrimaryPresssed:(id)sender { 
	
	NSLog(@"Primary Pressed");
	[self enterSlaveMode];
	
}


#pragma mark -
#pragma mark ShortcutRecorder Delegate Methods

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason {	
	return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	SGKeyCombo *keyCombo = [SGKeyCombo keyComboWithKeyCode:[aRecorder keyCombo].code
												 modifiers:[aRecorder cocoaToCarbonFlags:[aRecorder keyCombo].flags]];
	
	if (aRecorder == hotKeyGoControl) {		
		self.goKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.goKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalGoKey];
	} 
	
	if (aRecorder == hotKeyStopControl) {		
		self.stopKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.stopKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalStopKey];
	} 
	
	if (aRecorder == hotKeyUpSelectionControl) {		
		self.upKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.upKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalUpKey];
	} 
	
	if (aRecorder == hotKeyDownSelectionControl) {		
		self.downKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.downKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalDownKey];
	} 
	
	if (aRecorder == hotKeyBecomePrimaryControl) {		
		self.primaryKey.keyCombo = keyCombo;
		
		// Re-register the new hot key
		[[SGHotKeyCenter sharedCenter] registerHotKey:self.primaryKey];
		[defaults setObject:[keyCombo plistRepresentation] forKey:kGlobalBecomePrimaryKey];
	} 
	
	
	
	[defaults synchronize];
}




//Client
-(void)dealloc {
    self.connectedService = nil;
    self.browser = nil;
    self.socket = nil;
    self.messageBroker.delegate = nil;
    self.messageBroker = nil;
    [services release];
	
	[self stopService];
    [super dealloc];
	
}


//Server
	
-(void)startService {
    // Start listening socket
	NSLog(@"Listening, Service Started");
    NSError *error;
    self.listeningSocket = [[[AsyncSocket alloc]initWithDelegate:self] autorelease];
    if ( ![self.listeningSocket acceptOnPort:0 error:&error] ) {
        NSLog(@"Failed to create listening socket");
        return;
    }
    
    // Advertise service with bonjour
    NSString *serviceName = [NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] hostName]];
    netService = [[NSNetService alloc] initWithDomain:@"" type:@"_merqury._tcp." name:serviceName port:self.listeningSocket.localPort];
    netService.delegate = self;
    [netService publish];
	localServerName = [netService name];
	NSLog(@"Local Name is: %@", localServerName);
	
	[serverStopButton setEnabled:YES];
	[serverStartButton setEnabled:NO];
	
}

-(void)stopService {
    self.listeningSocket = nil;
    self.connectionSocket = nil;
    self.messageBroker.delegate = nil;
    self.messageBroker = nil;
    [netService stop]; 
    [netService release]; 
	
	[serverStopButton setEnabled:NO];
	[serverStartButton setEnabled:YES];
	NSLog(@"Service Stopped");
  
}

-(IBAction)startServer:(id)sender { 
	
	[self startService]; 
}

-(IBAction)stopServer:(id)sender {
	
	[self stopService]; 
}


//
#pragma mark Socket Callbacks
-(BOOL)onSocketWillConnect:(AsyncSocket *)sock {
    if ( self.connectionSocket == nil ) {
        self.connectionSocket = sock;
        return YES;
    }
    return NO;
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
	
	NSLog(@"Disconnected");
    if ( sock == self.connectionSocket ) {
        self.connectionSocket = nil;
        self.messageBroker = nil;
    }
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	
    MessageBroker *newBroker = [[[MessageBroker alloc] initWithAsyncSocket:sock] autorelease];
    newBroker.delegate = self;
    self.messageBroker = newBroker;
	NSLog(@"Connected, Host:%@  Port:%d",host,port);
}






#pragma mark MessageBroker Delegate Methods
-(void)messageBroker:(MessageBroker *)server didReceiveMessage:(Message *)message {
	NSLog(@"Reciveing Message"); 
    if ( message.tag == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (message.tag == 110) {
		NSLog(@"Go Message Recieved");
		[qlabScripts goCue]; }
	
	if (message.tag == 120) {
		[qlabScripts stopCue]; }
	
	if (message.tag == 130) {
		[qlabScripts moveSelectionUp]; }
	
	if (message.tag == 140) {
		[qlabScripts moveSelectionDown]; }
	
	//iPhone Command Block
	if (message.tag == 200) { 
	}
	
}

#pragma mark Net Service Delegate Methods
-(void)netService:(NSNetService *)aNetService didNotPublish:(NSDictionary *)dict {
    NSLog(@"Failed to publish: %@", dict);
}

#pragma mark Client Methods 

-(IBAction)search:(id)sender {
	
	[browser stop]; 
	
	[servicesController remove:self];
	
    [self.browser searchForServicesOfType:@"_merqury._tcp." inDomain:@""];
}

-(IBAction)connect:(id)sender {
    NSNetService *remoteService = servicesController.selectedObjects.lastObject;
    remoteService.delegate = self;
    [remoteService resolveWithTimeout:30];
}


-(IBAction)disconnect:(id)sender { 
	//NSNetService *service = servicesController.selectedObjects.lastObject; 
	//service.delegate = self; 
   // self.connectedService = service;
    //self.socket = [[[AsyncSocket alloc] initWithDelegate:nil] autorelease];
    [self.socket disconnect];
	NSLog(@"Disconnected");
	
}


#pragma mark Net Service Browser Delegate Methods
-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didFindService:(NSNetService *)aService moreComing:(BOOL)more 
{
	
	BOOL match; 
	match = [localServerName isEqual:[aService name]];
	
	if (match == FALSE) {
		[servicesController addObject:aService];
		
	} else { 
		
		NSLog(@"Excluding self from server browser"); }
	
	
}

	 
	 
-(void)netServiceBrowser:(NSNetServiceBrowser *)aBrowser didRemoveService:(NSNetService *)aService moreComing:(BOOL)more {
    [servicesController removeObject:aService];
    if ( aService == self.connectedService ) self.isConnected = NO;
}

-(void)netServiceDidResolveAddress:(NSNetService *)service {
    NSError *error;
    self.connectedService = service;
    self.socket = [[[AsyncSocket alloc] initWithDelegate:self] autorelease];
    [self.socket connectToAddress:service.addresses.lastObject error:&error];
}

-(void)netService:(NSNetService *)service didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"Could not resolve: %@", errorDict);
}



#pragma mark App Controls	

-(IBAction)openAboutWindow: (id) sender
{ 
	
	
	//Is About window Nil?
	if (!aboutWindow) { 
		aboutWindow = [[AboutWindowControl alloc] init]; 
	} 
	NSLog(@"showing %@", aboutWindow); 
	[aboutWindow showWindow:self]; 
	
	
	
}

-(IBAction)openDataViewWindow: (id) sender
{ 
	
	
DataWindowController *newWindowController = [[DataWindowController alloc] initWithManagedObjectContext:[self managedObjectContext]];
	[newWindowController setShouldCloseDocument:NO];
	[self addWindowController:newWindowController];
	[newWindowController showWindow:sender];
	
}

-(IBAction)openAdjustPanel:(id)sender { 

}


-(IBAction)adjustNow: (id) sender  {
	
	[qlabScripts adjustLoadTime:[timeAdjustmentField doubleValue]];
}


-(IBAction)modeSelection: (id) sender { 
	
	
	
	int i = [keyCaptureButton state];
	
	if (i == 1) {
		[self enterMasterMode];}
	
	if (i == 0) { 
		[self enterSlaveMode]; }
	

}




-(void)enterMasterMode { 
	
	NSLog(@"Master Mode");
	[self registerHotKeys];
	[qlabScripts loadQlabArray];
	[toggleKeysMenuItem setState:1];
		
	
}

-(void)enterSlaveMode { 
	
	NSLog(@"Slave Mode");
	[self unregisterHotKeys];
	[qlabScripts loadQlabArray];
	[toggleKeysMenuItem setState:0];
	
	
}


#pragma mark -
#pragma mark Qlab Data Import Methods


-(void)importData
{ 
	ImportOp *operation = nil;
	operation = [[ImportOp alloc] initWithDelegate:self];
	if (!queue) {
		queue = [[NSOperationQueue alloc] init]; }
	
	
	ImportOp *op = nil;
	op = [[ImportOp alloc] initWithDelegate:self];
	
	if (!genericOperationQueue) {
		genericOperationQueue = [[NSOperationQueue alloc] init];
	}
	
	[genericOperationQueue addOperation:op];
	[op release], op = nil;
	
}



@end


