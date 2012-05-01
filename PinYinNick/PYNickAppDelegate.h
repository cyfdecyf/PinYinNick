//
//  PYNickAppDelegate.h
//  PinYinNick
//
//  Created by 陈宇飞 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/AddressBook.h>

@interface PYNickAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource> {
    ABAddressBook *_ab;
    NSMutableArray *_people;
}

@property (assign) IBOutlet NSWindow *window;

@end
