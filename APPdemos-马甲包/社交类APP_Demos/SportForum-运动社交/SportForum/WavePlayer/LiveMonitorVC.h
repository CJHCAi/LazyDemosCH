//
//  LiveMonitorVC.h
//  ECG
//
//  Created by Will Yang (yangyu.will@gmail.com) on 4/29/11.
//  Copyright 2013 WMS Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeadPlayer.h"

@interface LiveMonitorVC : UIView {

	NSMutableArray *leads, *buffer;
	NSTimer *drawingTimer, *readDataTimer, *recordingTimer, *popDataTimer, *playSoundTimer;
	
	int second;
	BOOL stopTheTimer, autoStart, DEMO, monitoring;
	
	UIScrollView *scrollView;
	
	int layoutScale;  // 0: 3x4   1: 2x6   2: 1x12
	int startRecordingIndex, endRecordingIndex, HR;
	
	NSString *now;
	BOOL liveMode;

	int countOfPointsInQueue, countOfRecordingPoints;
	int currentDrawingPoint, bufferCount;
	
	
	LeadPlayer *firstLead;
	
	int lastHR;
    int newBornMode, errorCount;
}

@property (nonatomic, strong) NSMutableArray *leads, *buffer;
@property (nonatomic) BOOL liveMode, DEMO;
@property (nonatomic) int startRecordingIndex, HR, newBornMode;
@property (nonatomic) BOOL stopTheTimer;

-(id)init;

@end
