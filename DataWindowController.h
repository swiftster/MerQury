//
//  DataViewController.h
//  QSync
//
//  Created by Jason Tratta on 1/3/10.
//  Copyright 2010 Sound Character. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LevelTextField.h"
#import "OmniFader.h"
#import "MasterTable.h"
@class QSyncController; 


@interface DataWindowController : NSWindowController  {
	
	QSyncController *appDelegate;
	NSManagedObjectContext *moc; 
	IBOutlet NSTreeController *cuesController; 
	IBOutlet MasterTable *masterTable; 
	IBOutlet NSTextField *notesField; 
	
	IBOutlet NSArrayController *serverController; 
	IBOutlet NSArrayController *workSpaceController;
	IBOutlet NSArrayController *cueListController;
	
	IBOutlet LevelTextField *masterText; 
	IBOutlet LevelTextField *outputOne, *outputTwo, *outputThree, *outputFour, *outputFive, *outputSix, *outputSeven, *outputEight, *outputNine, 
							*outputTen, *outputEleven, *outputTweleve, *outputThirteen, *outputFourteen, *outputFifteen, *outputSixteen, *outputSeventeen, 
							*outputEightteen, *outputNineteen, *outputTwenty, *outputTwentyOne, *outputTwentyTwo, *outputTwentyThree, *outputTwentyFour, 
							*outputTwentyFive, *outputTwentySix, *outputTwentySeven, *outputTwentyEight, *outputTwentyNine, *outputThirty, *outputThirtyOne,
							*outputThirtyTwo, *outputThirtyThree, *outputThirtyFour, *outputThirtyFive, *outputThirtySix, *outputThirtySeven, *outputThirtyEight,
							*outputThirtyNine, *outputFourty, *outputFourtyOne, *outputFourtyTwo, *outputFourtyThree, *outputFourtyFour, *outputFourtyFive, 
							*outputFourtySix, *outputFourtySeven, *outputFourtyEight;
	
	IBOutlet OmniFader *fader; 
	
}

@property (assign) QSyncController *appDelegate;


- (void)setManagedObjectContext:(NSManagedObjectContext *)value;
- (NSManagedObjectContext *)managedObjectContext;

- (DataWindowController *)initWithManagedObjectContext:(NSManagedObjectContext *)inMoc appDelegate:(QSyncController *)delegate;



- (NSArray*)allCuesSortedBySortID; 
-(IBAction)refreshData:(id)sender;
-(IBAction)test:(id)sender; 

-(void)sortByID;
-(NSArray *)selectedCue;

-(double)formatLevelText:(NSString *)string;
-(NSNumber *)stringToDouble:(NSString *)string;



@end
