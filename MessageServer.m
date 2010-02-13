//
//  ChatterServer.m
//  QSync
//
////  Created by Jason Tratta on 2/2/10
//  Copyright 2009 Sound Character . All rights reserved.
//


#import "MessageServer.h"

NSString * const JATServerGoNotification = @"ServerGoNote";
NSString * const JATServerSelectionUpNotification = @"ServerUpNote";
NSString * const JATServerSelectionDownNotification = @"ServerDownNote";
NSString * const JATServerStopNotification = @"ServerStopNote";

@implementation MessageServer


@synthesize appDelegate;
@synthesize mainMOC;

- (id)initWithDelegate:(QSyncController*)delegate
{
	
	//NSLog(@"Import Op Called"); 
	if (!(self = [super init])) return nil;
	
	
	appDelegate = delegate;
	
	mainMOC = [self newContextToMainStore];
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
	
	return self; 
	
}

#pragma mark Core Data 


- (NSManagedObjectContext*)newContextToMainStore 
{ 
	
	NSManagedObjectContext *moc = [appDelegate managedObjectContext]; 
	
	return [moc autorelease]; 
} 

- (void)contextDidSave:(NSNotification*)notification
{
	SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
	[[appDelegate managedObjectContext] performSelectorOnMainThread:selector
														 withObject:notification
													  waitUntilDone:YES]; 
}



//Methods called by clients 
-(oneway void)sendCommand:(in int)command
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
	
	//NSLog(@"Reciveing Message"); 
    if ( command == 100 ) {
		NSLog(@"Tag = 100"); }
	
	if (command == 110) {
		NSLog(@"Client Go Message Recieved Send Command");
		[nc postNotificationName:JATQlabGoNotification object:self]; 
	}
	
	if (command == 120) {
		[nc postNotificationName:JATQlabStopNotification object:self];
	}
	
	if (command == 130) {
		[nc postNotificationName:JATQlabSelectionUpNotification object:self]; 
	}
	
	if (command == 140) {
		[nc postNotificationName:JATQlabSelectionDownNotification object:self];

	}
	
	
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
	
	return objects; 
}

-(byref NSManagedObject *)createObject 
{ 
	NSManagedObjectContext *context = mainMOC; 
	NSManagedObject *object = nil; 
	object = [NSEntityDescription insertNewObjectForEntityForName:@"Server"
										   inManagedObjectContext:context];
	return object; 
}

-(oneway void)deleteObject:(byref NSManagedObject *)object
{
	NSManagedObject *local = [mainMOC objectWithID:[object objectID]];
	if ([local isDeleted]) {
		return; }
		 
	if (![local isInserted]) { 
			 [self saveAction:self]; }
		 
	[mainMOC deleteObject:local]; 

		 
}
//Probably dont need this one.
-(byref NSManagedObject *)createChildForObject:(byref NSManagedObject *)parent 
{ 
	NSManagedObject *localParent = [mainMOC objectWithID:[parent objectID]];
	NSManagedObject *object = nil; 
	object = [NSEntityDescription insertNewObjectForEntityForName:@"Child"
										   inManagedObjectContext:mainMOC]; 
	
	[object setValue:localParent forKey:@"parent"];
	return object; 
}

-(byref NSArray *)objectsOfName:(bycopy NSString *)name 
					withPredicate:(bycopy NSPredicate *)predicate
{
	NSError *error = nil;
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	[request setEntity:[NSEntityDescription entityForName:name
								   inManagedObjectContext:mainMOC]];
	 [request setPredicate:predicate];
	 NSArray *results = [mainMOC executeFetchRequest:request error:&error];
	 [request release], request = nil;
	 
	 if (error) { 
		 NSLog(@"%@;%s Error on fetch %@", [self class], _cmd, error);
		 return nil; } 
	
	 return results; 
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
	[proxy sendCommand:110];
	NSLog(@"Send Server Command");
}

-(void)serverStopNote:(NSNotificationCenter *)note 
{ 
	//[self recieveCommand:120]; 
	
}

-(void)serverUpNote:(NSNotificationCenter *)note 
{ 
	//[self recieveCommand:130]; 
}

-(void)serverDownNote:(NSNotificationCenter *)note
{ 
	//[self recieveCommand:140]; 
}
	
	
@end
