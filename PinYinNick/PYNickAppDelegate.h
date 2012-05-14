//  Created by Chen Yufei on 12-4-29.
//  Copyright (c) 2012. All rights reserved.

#import <Cocoa/Cocoa.h>
#import <Appkit/NSTextFieldCell.h>
#import <AddressBook/AddressBook.h>

@interface PYNickAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate> {
    ABAddressBook *_ab;
    NSTextFieldCell *_fullNameCell;
    NSTextFieldCell *_nickNameCell;
}

@property (readonly, strong, nonatomic) NSMutableArray *people;

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTableView *contactTableView;

- (IBAction)saveModifiedContact:(id)sender;
- (IBAction)removeAllPinyinNickNames:(id)sender;

@end
