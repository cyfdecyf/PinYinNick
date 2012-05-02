//
//  PYNickAppDelegate.h
//  PinYinNick
//
//  Created by 陈宇飞 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Appkit/NSTextFieldCell.h>
#import <AddressBook/AddressBook.h>

@interface PYNickAppDelegate : NSObject <NSApplicationDelegate,
NSTableViewDataSource, NSTableViewDelegate> {
    ABAddressBook *_ab;
    NSMutableArray *_people;
    NSTextFieldCell *_fullNameCell;
    NSTextFieldCell *_nickNameCell;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *contactTableView;

- (IBAction)saveModifiedContact:(id)sender;
- (IBAction)removeAllPinyinNickNames:(id)sender;

@end
