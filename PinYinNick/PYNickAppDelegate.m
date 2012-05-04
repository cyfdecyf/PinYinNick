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

@synthesize people = _people;

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
        [self startObservingPerson:person];
    }

    // Sort people using their full name.
    [_people sortUsingComparator:^(id r1, id r2) {
        NSString *namepy1 = [r1 fullNamePinyin];
        NSString *namepy2 = [r2 fullNamePinyin];
        return [namepy1 caseInsensitiveCompare:namepy2];
    }];
}

- (id)init {
    // When using NSArrayController, it's important to do initialization in init.
    // NSArrayController may access the binded content array before awakeFromNib is called.
    self = [super init];
    if (self) {
        [self loadContacts];
        [self createCell];
    }
    return self;
}

// For undo support.

static void *PYNickAppDelegateKVOContext;

- (void)startObservingPerson:(Person *)person
{
    [person addObserver:self
             forKeyPath:@"nickName"
                options:NSKeyValueObservingOptionOld
                context:&PYNickAppDelegateKVOContext];
    [person addObserver:self
             forKeyPath:@"modified"
                options:NSKeyValueObservingOptionOld
                context:&PYNickAppDelegateKVOContext];
}

- (void)changeKeyPath:(NSString *)keyPath
             ofObject:(id)obj
              toValue:(id)newValue
{
    // setValue:forKeyPath: will cause the key-value observing method
    // to be called, which takes care of the undo stuff
    [obj setValue:newValue forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context != &PYNickAppDelegateKVOContext) {
        // If the context does not match, this message
        // must be intended for our superclass.
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }

    id oldValue = [change objectForKey:NSKeyValueChangeOldKey];

    // NSNull objects are used to represent nil in a dictionary
    if (oldValue == [NSNull null]) {
        oldValue = nil;
    }
//    NSLog(@"oldValue = %@", oldValue);
    NSUndoManager *undo = [_window undoManager];
    [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                  ofObject:object
                                                   toValue:oldValue];
    [undo setActionName:[NSString stringWithFormat:@"Edit %@", [object fullName]]];
}

// Make modified row use bold and blue font

static NSString *FULLNAME_IDENTIFIER = @"fullName";
static NSString *NICKNAME_IDENTIFIER = @"nickName";

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
    NSUndoManager *undo = [_window undoManager];
    [undo removeAllActions];
    [undo disableUndoRegistration];
    for (Person *person in _people) {
        NSString *nickName = [person nickName];
        ABPerson *abPerson = [person abPerson];
        [abPerson setValue:nickName forProperty:kABNicknameProperty];
        [person setModified:NO];
    }
    [undo enableUndoRegistration];
    [_ab save];
    [_contactTableView reloadData];
}

- (void)removeNickAlertEnded:(NSAlert *)alert code:(NSInteger)choice context:(void *)v {
    if (choice != NSAlertDefaultReturn) {
        return;
    }
    NSUndoManager *undo = [_window undoManager];
    [undo removeAllActions];
    [undo disableUndoRegistration];
    for (Person *person in _people) {
        if ([Hanzi2Pinyin hasChineseCharacter:[person fullName]]) {
            [person setNickName:@""];
            [person setModified:NO];
            ABPerson *abPerson = [person abPerson];
            [abPerson setValue:nil forProperty:kABNicknameProperty];
        }
    }
    [undo enableUndoRegistration];
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
