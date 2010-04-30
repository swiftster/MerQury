//
//  ChatterServer.m
//  QSync
//
////  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import "MessageServer.h"
#import "CommandMessagesProto.h"


NSString * const JATServerGoNotification = @"ServerGoNote";
NSString * const JATServerSelectionUpNotification = @"ServerUpNote";
NSString * const JATServerSelectionDownNotification = @"ServerDownNote";
NSString * const JATServerStopNotification = @"ServerStopNote";
NSString * const JATGetClientSharedDataNotification = @"ClientDataShare";

@implementation MessageServer


@synthesize appDelegate;
@synthesize mainMOC; 



-(id)initWithDelegate:(QSyncController *)delegate
{	
	
	if (!(self = [super init])) return nil;
	
	appDelegate = delegate;
	mainMOC = [appDelegate managedObjectContext];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self
			   selector:@selector(contextDidSave:) 
				   name:NSManagedObjectContextDidSaveNotification 
				 object:mainMOC];;
	
	clients = [[NSMutableArray alloc] init];
	
	
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	[nc addObserver:self selector:@selector(serverGoNote:) name:JATServerGoNotification object:nil];
	[nc addObserver:self selector:@selector(serverUpNote:) name:JATServerSelectionUpNotification object:nil];
	[nc addObserver:self selector:@selector(serverDownNote:) name:JATServerSelectionDownNotification object:nil];
	[nc addObserver:self selector:@selector(serverStopNote:) name:JATServerStopNotification object:nil];
	[nc addObserver:self selector:@selector(updateModalFromClient:) name:JATGetClientSharedDataNotification object:nil];
	
	return self; 
	
}

-(void)dealloc 
{ 
	
	appDelegate = nil; 
	[clients release]; 
	[mainMOC release];
	[super dealloc];
	
}


#pragma mark Core Data 


- (NSManagedObjectContext*)newContextToMainStore 
{ 
	 
	NSPersistentStoreCoordinator *coord = [[appDelegate managedObjectContext] persistentStoreCoordinator];
	NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
	[moc setPersistentStoreCoordinator:coord];
	
	return [moc autorelease]; 
} 

- (void)contextDidSave:(NSNotification*)notification
{
	SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
	[[appDelegate managedObjectContext] performSelectorOnMainThread:selector
														 withObject:notification
													  waitUntilDone:YES]; 
}


-(byref NSArray *)allObjects
{ 
	
	NSManagedObjectContext *context = mainMOC;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Server"
											  inManagedObjectContext:context];
	[request setEntity:entity]; 
	
	NSError *error = nil; 
	
	NSArray *objects = [context executeFetchRequest:request error:&error];
	[request release], request = nil;
	
	if (error) {
		NSLog(@"%@:%s error %@", [self class], _cmd, error); 
		return nil; 
	}
	
	NSLog(@"Main Thread Object Count:%d", [objects count]);
	return objects;
	
}


-(void)changeLevelFromClient:(in NSString *)unID inRow:(in NSInteger)r inColumn:(in NSInteger)c db:(in double)d 
{

	[appDelegate changeLevelForID:unID inRow:r inColumn:c db:d];	

}

-(void)changeCueNameFromClient:(in NSString *)unID inRow:(in NSInteger)r inColumn:(in NSInteger)c name:(in NSString *)s
{
	
	[appDelegate changeCueNameForID:unID inRow:r inColumn:c name:s];
	
}

-(void)changeNotesFromClient:(in NSString *)unID inRow:(in NSInteger)r inColumn:(in NSInteger)c string:(in NSString *)s
{
	[appDelegate changeNotesForID:unID inRow:r inColumn:c string:s];
}
	 
-(void)changePreWaitForID:(in NSString *)unID db:(in double)d
{ 
	[appDelegate changePreWaitForID:unID db:d]; 
}

-(void)changePostWaitForID:(in NSString *)unID db:(in double)d
{ 
	[appDelegate changePostWaitForID:unID db:d];
	
}



-(BOOL)connectClient:(in byref id <ServerMessage>)newClient
{ 

	NSLog(@"adding client"); 
	
	[clients addObject:newClient]; 
	
	return YES; 
} 
						
-(void)disconnectClient:(in byref id <ServerMessage>) client
{ 
	
	NSDistantObject *clientProxy = (NSDistantObject *)client; 
	NSConnection *connection = [clientProxy connectionForProxy]; 
	[clients removeObject:client];
	[connection invalidate]; 
	NSLog(@"Client Removed"); 
}
						
//Notification Handle 

-(void)serverGoNote:(NSNotificationCenter *)note 
{
	
	NSEnumerator *enumerator; 
	id currentClient; 
	
	enumerator = [clients objectEnumerator]; 
	
	while (currentClient = [enumerator nextObject]) { 
		[currentClient commandFromServer:110]; }
	
}

-(void)serverStopNote:(NSNotificationCenter *)note 
{ 
	
	NSEnumerator *enumerator; 
	id currentClient; 
	
	enumerator = [clients objectEnumerator]; 
	
	while (currentClient = [enumerator nextObject]) { 
		[currentClient commandFromServer:120]; }
	
}

-(void)serverUpNote:(NSNotificationCenter *)note 
{ 
	
	NSEnumerator *enumerator; 
	id currentClient; 
	
	enumerator = [clients objectEnumerator]; 
	
	while (currentClient = [enumerator nextObject]) { 
		[currentClient commandFromServer:130]; }
	
}

-(void)serverDownNote:(NSNotificationCenter *)note
{ 
	
	NSEnumerator *enumerator; 
	id currentClient; 
	
	enumerator = [clients objectEnumerator]; 
	
	while (currentClient = [enumerator nextObject]) { 
		[currentClient commandFromServer:140]; }
	
}


#pragma mark FROM CLient messages

-(void)updateModalFromClient:(NSNotification *)note
{ 
	NSLog(@"Server Update Note Arrived");
	NSEnumerator *enumerator; 
	id currentClient;
	NSArray *objects; 
	
	enumerator = [clients objectEnumerator]; 
	
	while (currentClient = [enumerator nextObject]) { 
		
		objects = [currentClient allObjectsClient]; 
		NSLog(@"Client Data Count:%d", [objects count]);
	}	
	
}


	
	
@end
