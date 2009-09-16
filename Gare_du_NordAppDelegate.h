//
//  Gare_du_NordAppDelegate.h
//  Gare du Nord
//
//  Created by Wesley Moore on 15/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Gare_du_NordAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSProgressIndicator *progress_bar;
	NSTextField *progress_label;
	NSButton *go_button;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSProgressIndicator *progress_bar;
@property (assign) IBOutlet NSTextField *progress_label;
@property (assign) IBOutlet NSButton *go_button;

- (IBAction)depart:(id)sender;

- (NSArray *)linesInString:(NSString *)string;

@end
