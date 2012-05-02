//
//  PYNickAppDelegate.m
//  PinYinNick
//
//  Created by 陈宇飞 on 12-4-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PYNickAppDelegate.h"
#import "Hanzi2Pinyin/Hanzi2Pinyin.h"
#import <AppKit/NSAlert.h>

@implementation PYNickAppDelegate

@synthesize window = _window;
@synthesize contactTableView = _contactTableView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

// I use the people array to store contact information. Each element in this people
// array is an array containing related information.
// The following constants define the index of various informatino.
static const NSUInteger PERSON_IDX = 0;
static const NSUInteger FULLNAME_IDX = 1;
static const NSUInteger NICKNAME_IDX = 2;
static const NSUInteger MODIFIED_IDX = 3;
static const NSUInteger FULLNAME_PINYIN_IDX = 4;

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
    NSArray *people = [_ab people];
    _people = [[NSMutableArray alloc] initWithCapacity:[people count]];
    
    for (ABPerson *person in people) {
        NSString *fullName = [self fullNameForPerson:person];
        
        // If the person has nick name, use it. Otherwise, create pinyin nick
        NSString *nick = [person valueForProperty:kABNicknameProperty];
        BOOL modified = NO;
        if (!nick) {
            nick = [self pynickForPerson:person fullName:fullName];
            modified = [nick isEqualToString:@""] ? NO : YES;
        }
        
        NSMutableArray *record = [[NSMutableArray alloc] initWithObjects:person,
                                  fullName, nick, [NSNumber numberWithBool:modified],
                                  [Hanzi2Pinyin convert:fullName],
                                  nil];
        [_people addObject:record];
    }
    
    // Sort people using their full name. Put person with no nick at last.
    [_people sortUsingComparator:^(id r1, id r2) {
        NSString *namepy1 = [r1 objectAtIndex:FULLNAME_PINYIN_IDX];
        NSString *namepy2 = [r2 objectAtIndex:FULLNAME_PINYIN_IDX];
        
        return [namepy1 caseInsensitiveCompare:namepy2];
    }];
}

- (void)awakeFromNib {
    // numberOfRowsInTableView will be called before applicationDidFinishLaunching.
    // So initialization should be done here.
    [self loadContacts];
    [self createCell];
}

- (NSString *)fullNameForPerson:(ABPerson *)person {
    NSString *firstName = [person valueForProperty:kABFirstNameProperty];
    NSString *lastName = [person valueForProperty:kABLastNameProperty];
    NSMutableString *fullName = [[NSMutableString alloc] initWithCapacity:10];
    if (lastName != nil) {
        [fullName appendString:lastName];
    }
    if (firstName != nil) {
        if (lastName == nil)
            [fullName appendString:firstName];
        else
            [fullName appendFormat:@" %@", firstName];
    }
    return [NSString stringWithString:fullName];
}

- (NSString *)pynickForPerson:(ABPerson *)person fullName:(NSString *)fullName {
    if (!fullName) {
        fullName = [self fullNameForPerson:person];
    }
    NSString *pynick = [Hanzi2Pinyin convertToAbbreviation:fullName];
    // If the full name does not include Chinese, don't create nick
    if ([pynick isEqualToString:fullName]) {
        pynick = @"";
    }

    return pynick;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    NSInteger count = [_people count];
    return count;
}

static NSString *FULLNAME_IDENTIFIER = @"fullName";
static NSString *NICKNAME_IDENTIFIER = @"nickName";

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    NSArray *record = [_people objectAtIndex:row];
    NSString *columnIdentifier = [tableColumn identifier];
    if ([columnIdentifier isEqualToString:FULLNAME_IDENTIFIER]) {
        return [record objectAtIndex:FULLNAME_IDX];
    } else {
        return [record objectAtIndex:NICKNAME_IDX];
    }
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object
            forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableArray *record = [_people objectAtIndex:row];
    
    if ([object isEqualToString:[record objectAtIndex:NICKNAME_IDX]]) {
        return;
    }
    
    NSString *columnIdentifier = [tableColumn identifier];
    if ([columnIdentifier isEqualToString:NICKNAME_IDENTIFIER]) {
        [record replaceObjectAtIndex:NICKNAME_IDX withObject:object];
        [record replaceObjectAtIndex:MODIFIED_IDX withObject:[NSNumber numberWithBool:YES]];
    }
}

- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    NSArray *record = [_people objectAtIndex:row];
    if (!tableColumn)
        return nil;

    if ([[record objectAtIndex:MODIFIED_IDX] boolValue]) {
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
    for (NSMutableArray *record in _people) {
        NSString *nickName = [record objectAtIndex:NICKNAME_IDX];
        ABPerson *person = [record objectAtIndex:PERSON_IDX];
        [person setValue:nickName forProperty:kABNicknameProperty];
        [record replaceObjectAtIndex:MODIFIED_IDX withObject:[NSNumber numberWithBool:NO]];
    }
    [_ab save];
    [_contactTableView reloadData];
}

- (void)alertEnded:(NSAlert *)alert code:(NSInteger)choice context:(void *)v {
    if (choice == NSAlertDefaultReturn) {
        NSLog(@"removing nick name");
        for (NSMutableArray *record in _people) {
            if ([Hanzi2Pinyin hasChineseCharacter:[record objectAtIndex:FULLNAME_IDX]]) {
                [record replaceObjectAtIndex:NICKNAME_IDX withObject:@""];
                [record replaceObjectAtIndex:MODIFIED_IDX withObject:[NSNumber numberWithBool:NO]];
                ABPerson *person = [record objectAtIndex:PERSON_IDX];
                [person setValue:nil forProperty:kABNicknameProperty];
            }
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
                     didEndSelector:@selector(alertEnded:code:context:)
                        contextInfo:NULL];
}

@end
