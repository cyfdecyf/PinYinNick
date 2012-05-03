//
//  PYNickAppDelegate.m
//  PinYinNick
//
//  Created by 陈宇飞 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PYNickAppDelegate.h"
#import "Person.h"
#import "Hanzi2Pinyin/Hanzi2Pinyin.h"
#import <AppKit/NSAlert.h>

@implementation PYNickAppDelegate

@synthesize window = _window;
@synthesize contactTableView = _contactTableView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

static const CGFloat CELL_FONT_SIZE = 13;

- (void)createCell {
    // Setup custom data cell for modified person
    NSColor *blueColor = [NSColor blueColor];
    NSFont *boldSystemFont = [NSFont boldSystemFontOfSize:(CGFloat)CELL_FONT_SIZE];
    
    _fullNameCell = [[NSTextFieldCell alloc] initTextCell:@""];
    [_fullNameCell setEditable:NO];
    [_fullNameCell setTextColor:blueColor];
    [_fullNameCell setFont:boldSystemFont];

    _nickNameCell = [_fullNameCell copy];
    [_nickNameCell setEditable:YES];
}

- (void)loadContacts {
    _ab = [ABAddressBook sharedAddressBook];
    NSArray *abPeople = [_ab people];
    _people = [[NSMutableArray alloc] initWithCapacity:[abPeople count]];

    for (ABPerson *abPerson in abPeople) {
        Person *person = [[Person alloc] initWithPerson:abPerson];
        [_people addObject:person];
    }

    // Sort people using their full name.
    [_people sortUsingComparator:^(id r1, id r2) {
        NSString *namepy1 = [r1 fullNamePinyin];
        NSString *namepy2 = [r2 fullNamePinyin];
        return [namepy1 caseInsensitiveCompare:namepy2];
    }];
}

- (void)awakeFromNib {
    // numberOfRowsInTableView will be called before applicationDidFinishLaunching.
    // So initialization should be done here.
    [self loadContacts];
    [self createCell];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    NSInteger count = [_people count];
    return count;
}

static NSString *FULLNAME_IDENTIFIER = @"fullName";
static NSString *NICKNAME_IDENTIFIER = @"nickName";

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    NSAssert(row < [_people count], @"row exceeds people count");

    Person *person = [_people objectAtIndex:row];
    NSString *columnIdentifier = [tableColumn identifier];
    if ([columnIdentifier isEqual:FULLNAME_IDENTIFIER]) {
        return [person fullName];
    } else {
        return [person nickName];
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSAssert((NSUInteger)row < [_people count], @"row exceeds people count");
    NSAssert([[tableColumn identifier] isEqual:NICKNAME_IDENTIFIER],
             @"Only nick name should be editable");

    Person *person = [_people objectAtIndex:row];
    [person setNickName:object];
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSAssert((NSUInteger)row < [_people count], @"row exceeds people count");
    Person *person = [_people objectAtIndex:row];
    if (!tableColumn)
        return nil;

    if ([person isModified]) {
        NSString *columnIdentifier = [tableColumn identifier];
        if ([columnIdentifier isEqualToString:FULLNAME_IDENTIFIER]) {
            return _fullNameCell;
        } else {
            return _nickNameCell;
        }
    }
    return nil;
}

- (IBAction)saveModifiedContact:(id)sender {
    for (Person *person in _people) {
        NSString *nickName = [person nickName];
        ABPerson *abPerson = [person abPerson];
        [abPerson setValue:nickName forProperty:kABNicknameProperty];
        [person setModified:NO];
    }
    [_ab save];
    [_contactTableView reloadData];
}

- (void)removeNickAlertEnded:(NSAlert *)alert code:(NSInteger)choice context:(void *)v {
    if (choice != NSAlertDefaultReturn) {
        return;
    }
    for (Person *person in _people) {
        if ([Hanzi2Pinyin hasChineseCharacter:[person fullName]]) {
            [person setNickName:@""];
            [person setModified:NO];
            ABPerson *abPerson = [person abPerson];
            [abPerson setValue:nil forProperty:kABNicknameProperty];
        }
    }
    [_ab save];
}

- (IBAction)removeAllPinyinNickNames:(id)sender {
    NSAlert *alert = [NSAlert alertWithMessageText:@"Remove all pinyin nick names"
                                     defaultButton:@"Remove"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@"Nick names associated with contacts which have Chinese characters will be deleted."];
    [alert beginSheetModalForWindow:_window
                      modalDelegate:self
                     didEndSelector:@selector(removeNickAlertEnded:code:context:)
                        contextInfo:NULL];
}

@end
