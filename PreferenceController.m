/*
 ---------------------------------------------------------------------------
 CocoaPad -- PreferenceController.m
 By Henry Weiss
 ---------------------------------------------------------------------------
 Makes the preference feature.
 
 Major events:
 
 - 01/17/04: CocoaPad started
 - 03/10/04: Added notification handling
 - 03/11/04: Mysterious flakiness from the system causes Xcode to fail writing
             to the document, and then cannot save the project.  Before I can
             copy the code, it switches me to MyDocument.m.  I eventually
             reinstall Mac OS X and Xcode.
 - 03/16/04: Rewrote PreferenceController.m, and it's better than ever.
 - 03/31/04: Added choice of new document format
 - 03/31/04: Changed the reset alert to a sheet
 - 03/31/04: Made all strings localized
 - 04/05/04: Added choice of font and font size
 - 04/08/04: Removed all of the debugging stuff, and cleaned up the code
 - 04/26/04: Completed CocoaPad 1.0b1 beta Release 1
 - 06/18/04: Completed CocoaPad 1.0b2 beta Release 2
 - 09/21/04: Added toolbar preference and notifications
 - 11/16/04: Removed irritating notification code, made an Apply To All button.
 - 01/31/05: Removed debugging stuff, cleaned up the code
 - 02/02/05: Fixed reset preferences, which didn't have Show Toolbar
 - 02/02/05: Finished CocoaPad 1.0 pre-release
 - 03/30/05: Added Automatic Backup support
 - 05/16/05: Added “smart quotes”
 - 05/23/05: Added word count
 - 06/07/05: FINALLY COMPLETED COCOAPAD 1.0!!!
 - 10/14/07: Released CocoaPad v1.1, with 2 bug fixes!
 
 */

#import "PreferenceController.h"
#import "MyDocument.h"
#import "InterfaceController.h"
#import "LocalizedStrings.h"

/*************/
/* Constants */
/*************/

// These are the tags for the default format checkboxes

enum FORMAT { CPDFORMAT = 0, RTFFORMAT = 1, RTFDFORMAT = 2, DOCFORMAT = 3, TXTFORMAT = 4 };


@implementation PreferenceController

/**************************/
/* Initialization methods */
/**************************/

- (id)init
{
    if (self = [super initWithWindowNibName:@"Preferences"])
    {
        [self setWindowFrameAutosaveName:@"PreferencePanelLocation"];  // Keep the location of preference panel
        
        fontText = L_FORMATTING_STRING;  // The format string used to display the font
        [[NSFontManager sharedFontManager] setDelegate:self];  // Set ourselves as the font manager's delegate
    }
    
    return self;
}

/***** Initialize the preference panel *****/

- (void)windowDidLoad
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  // Load the preferences;
    NSData *colorAsData, *textColorAsData;
    NSFont *rtfFont, *textFont;
    BOOL supportsWordFormat = [[[NSDocumentController sharedDocumentController] currentDocument] supportsWordFormat];
    int cell = 0;
    
    //
    // Extract some preferences that aren't regular booleans or strings
    //
    
    colorAsData = [prefs objectForKey:CP_BackgroundColor];
    textColorAsData = [prefs objectForKey:CP_TextColor];
    rtfFont = [NSFont userFontOfSize:0.0];
    textFont = [NSFont userFixedPitchFontOfSize:0.0];
    
    //
    // Now set the pref window's controls to what they're supposed to be
    //
    
    // The two color wells
    
    [textColorWell setColor:[NSUnarchiver unarchiveObjectWithData:textColorAsData]];
    [colorWell setColor:[NSUnarchiver unarchiveObjectWithData:colorAsData]];
    
    // The checkboxes
    
    [showRulerCheckBox setState:[prefs boolForKey:CP_ShowRuler]];
    [continuousSpellCheck setState:[prefs boolForKey:CP_SpellChecking]];
    [showToolbarCheckBox setState:[prefs boolForKey:CP_ShowToolbar]];
    [ignoreFormattingCheckBox setState:[prefs boolForKey:CP_IgnoreFormatting]];
    [enableSmartQuotesCheckBox setState:[prefs boolForKey:CP_EnableSmartQuotes]];
    [openNewDoc setState:[prefs boolForKey:CP_OpenNewDoc]];
    [saveBackupCheckBox setState:[prefs boolForKey:CP_SaveBackup]];
    [saveBackupInterval setIntValue:[prefs integerForKey:CP_SaveBackupInterval]];
    
    // The font display
    
    [richTextFontNameField setStringValue:[NSString stringWithFormat:fontText, [rtfFont displayName], [rtfFont pointSize]]];
    [plainTextFontNameField setStringValue:[NSString stringWithFormat:fontText, [textFont displayName], [textFont pointSize]]];
    
    // Just in case the OS doesn't support Word...
    
    [[formatCheckboxes cellWithTag:DOCFORMAT] setEnabled:supportsWordFormat];
    
    // Set the default cell for documat format (switch doesn't work here, because we don't have integers)
    
    if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_CPDFormat])
    {
        cell = CPDFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_RTFFormat])
    {
        cell = RTFFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_RTFDFormat])
    {
        cell = RTFDFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_TextFormat])
    {
        cell = TXTFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_WordFormat] && supportsWordFormat)
    {
        cell = DOCFORMAT;
    }
    
    [formatCheckboxes selectCellWithTag:cell];  // Actually select the checkbox
}

/**************************/
/* Toggle the preferences */
/**************************/

/***** Toggle ruler visibility *****/

- (IBAction)changeShowRuler:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:CP_ShowRuler];
}

/***** Spell check as you type? *****/

- (IBAction)changeContinuousSpellCheck:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:CP_SpellChecking];
}

/***** Show the toolbar? *****/

- (IBAction)changeShowToolbar:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:CP_ShowToolbar];
}

/***** Ignore formatting commands? *****/

- (IBAction)changeIgnoreFormatting:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:CP_IgnoreFormatting];
}

/***** Enable “smart quotes?” *****/

- (IBAction)changeEnableSmartQuotes:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:CP_EnableSmartQuotes];
}

/***** Save a backup file? *****/

- (IBAction)changeSaveBackup:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:CP_SaveBackup];
    
    // Enable/disable the text field
    
    [saveBackupInterval setEnabled:[sender state]];
}

/***** Set the document background color *****/

- (IBAction)changeBackgroundColor:(id)sender
{
    // Since XML property lists don't know how to store color objects, we must encode the color object
    
    NSColor *color = [sender color];  // Get what the color chosen it
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject:color];  // Now encode it
    
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:CP_BackgroundColor];
}

/***** Set the default text color *****/

- (IBAction)changeTextColor:(id)sender
{
    NSColor *color = [sender color];
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject:color];
    
    [[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:CP_TextColor];
}

/***** Set if we should open a new document on startup *****/

- (IBAction)changeNewEmptyDoc:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:[sender state] forKey:CP_OpenNewDoc];
}

/***** Change the rich text/CPD default font *****/

- (IBAction)changeRTFFont:(id)sender
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    
    [[self window] makeFirstResponder:[self window]];  // Make sure the font panel ONLY applies to US
    [fontManager setSelectedFont:[NSFont userFontOfSize:0.0] isMultiple:NO];
    [fontManager orderFrontFontPanel:self];  // Show the font panel
    
    changingRTFFont = YES;  // We need to know if this is the RTF font or not
}

/***** Change the plain text font *****/

- (IBAction)changeTextFont:(id)sender
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    
    [[self window] makeFirstResponder:[self window]];  // Make sure the font panel ONLY applies to US
    [fontManager setSelectedFont:[NSFont userFixedPitchFontOfSize:0.0] isMultiple:NO];
    [fontManager orderFrontFontPanel:self];  // Show the font panel
    
    changingRTFFont = NO;  // We need to know if this is the RTF font or not
}

/***** Get the font changes *****/

/*
 * This is implemented by the font manager's delegate.  Previously,
 * we set ourselves as the delegate.  So, when the font changes, the
 * delegate's changeFont: method is called.
 */

- (void)changeFont:(id)sender 
{
    NSFont *oldFont, *newFont;
    
    // Get the fonts
    
    oldFont = (changingRTFFont) ? [NSFont userFontOfSize:0.0] : [NSFont userFixedPitchFontOfSize:0.0];
    newFont = [sender convertFont:oldFont];  // Convert the font to an NSFont -- just to make sure
    
    // Set the RTF font
    
    if (changingRTFFont)
    {
        [NSFont setUserFont:newFont];
        [richTextFontNameField setStringValue:[NSString stringWithFormat:fontText, [newFont displayName], [newFont pointSize]]];
    }
    
    // Otherwise, set the plain text font
    
    else
    {
        [NSFont setUserFixedPitchFont:newFont];
        [plainTextFontNameField setStringValue:[NSString stringWithFormat:fontText, [newFont displayName], [newFont pointSize]]];
    }
}

/***** Change the default document format *****/

- (IBAction)changeFormat:(id)sender
{
    int choice = [[sender selectedCell] tag];  // Get the selected radio button
    
    // Find out which format was selected
    
    switch (choice)
    {
        case CPDFORMAT:
            [[NSUserDefaults standardUserDefaults] setObject:CP_CPDFormat forKey:CP_NewDocFormat];
            break;
            
        case RTFFORMAT:
            [[NSUserDefaults standardUserDefaults] setObject:CP_RTFFormat forKey:CP_NewDocFormat];
            break;
            
        case RTFDFORMAT:
            [[NSUserDefaults standardUserDefaults] setObject:CP_RTFDFormat forKey:CP_NewDocFormat];
            break;
            
        case TXTFORMAT:
            [[NSUserDefaults standardUserDefaults] setObject:CP_TextFormat forKey:CP_NewDocFormat];
            break;
            
        // We disabled the checkbox if the OS is not Panther
            
        case DOCFORMAT:
            [[NSUserDefaults standardUserDefaults] setObject:CP_WordFormat forKey:CP_NewDocFormat];
            break;
    }
}

/***** Change how often we should save a backup *****/

- (IBAction)changeBackupInterval:(id)sender
{
    if ([sender isEnabled])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:CP_SaveBackupInterval];
        
        // Notify InterfaceController that the backup interval changed
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"BackupIntervalDidChange" object:nil]];
    }
}

/***** Same as above, except this is for when the text field loses focus *****/

- (void)textDidChange:(NSNotification *)notification
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CP_SaveBackup] && [saveBackupInterval isEnabled])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:[saveBackupInterval intValue] forKey:CP_SaveBackupInterval];
        
        // Notify InterfaceController that the backup interval changed
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"BackupIntervalDidChange" object:nil]];
    }
}

/***** Same as above, except this is for when the prefs panel loses focus *****/

- (void)windowDidResignKey:(NSNotification *)notification
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CP_SaveBackup] && [saveBackupInterval isEnabled])
    {
        [[NSUserDefaults standardUserDefaults] setInteger:[saveBackupInterval intValue] forKey:CP_SaveBackupInterval];
        
        // Notify InterfaceController that the backup interval changed
        
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"BackupIntervalDidChange" object:nil]];
    }
}

/***** Revert to the default settings *****/

- (IBAction)revertToOriginal:(id)sender
{
    SEL selector = @selector(sheetDidEnd:returnCode:contextInfo:);  // The sheet handler
    
    // Run an alert sheet to see if they really want to revert to defaults
    
    NSBeginAlertSheet(L_RESET_PREFS_SHEET_TITLE, L_RESET_BUTTON, L_CANCEL_BUTTON, nil, [self window], self, nil, selector, nil, L_RESET_PREFS_SHEET_DESCRIPTION, nil);
}

/***** Handle post-sheet stuff *****/

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)result contextInfo:(void *)contextInfo
{
    if (result == NSAlertDefaultReturn)
    {
        [self resetPreferences];  // They clicked OK, so go ahead and reset the preferences
    }
    
    [self showWindow:nil];  // Make sure the window is still visible
}

/***** Apply settings to all open documents *****/

/*
 * This is much faster -- and much more reliable --
 * than the notification system, which we used to use.
 */

- (IBAction)applyToAll:(id)sender
{
    SEL selector = @selector(applySheetDidEnd:returnCode:contextInfo:);  // The sheet handler
    
    // Run an alert sheet to see if they really want to apply to all
    
    NSBeginAlertSheet(L_APPLY_TO_ALL_SHEET_TITLE, L_APPLY_TO_ALL_BUTTON, L_CANCEL_BUTTON, nil, [self window], self, nil, selector, nil, L_APPLY_TO_ALL_SHEET_DESCRIPTION, nil);
}

- (void)applySheetDidEnd:(NSWindow *)sheet returnCode:(int)result contextInfo:(void *)contextInfo
{
    if (result == NSAlertDefaultReturn)
    {
        // Run through all the documents and apply changes
        
        NSEnumerator *documentList = [[[NSDocumentController sharedDocumentController] documents] objectEnumerator];
        MyDocument *document;
        NSTextView *textView;
        
        while (document = [documentList nextObject])
        {
            textView = [document textView];
            
            // Set the background color
            [textView setBackgroundColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:CP_BackgroundColor]]];
            
            // Set the ruler's visibility
            [textView setRulerVisible:[[NSUserDefaults standardUserDefaults] boolForKey:CP_ShowRuler]];
            
            // Set continuous spell checking enabled or not
            [textView setContinuousSpellCheckingEnabled:[[NSUserDefaults standardUserDefaults] boolForKey:CP_SpellChecking]];
            
            // Set toolbar's visibility
            [[[textView window] toolbar] setVisible:[[NSUserDefaults standardUserDefaults] boolForKey:CP_ShowToolbar]];
            
            // And update the text view
            [document updateView];
        }
    }
    
    [self showWindow:nil];  // Make sure the window is still visible
}

/***** Remove the changed preferences *****/

- (void)resetPreferences
{
    NSData *colorAsData, *textColorAsData;
    NSFont *rtfFont, *textFont;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    int cell = 0;
    
    /*
     * The user gave us the go ahead to erase all of the preference settings.
     * This just involves deleting the stuff that changed so it will revert
     * to the factory defaults.
     */
    
    [prefs removeObjectForKey:CP_ShowRuler];
    [prefs removeObjectForKey:CP_SpellChecking];
    [prefs removeObjectForKey:CP_BackgroundColor];
    [prefs removeObjectForKey:CP_TextColor];
    [prefs removeObjectForKey:CP_ShowToolbar];
    [prefs removeObjectForKey:CP_IgnoreFormatting];
    [prefs removeObjectForKey:CP_EnableSmartQuotes];
    [prefs removeObjectForKey:CP_OpenNewDoc];
    [prefs removeObjectForKey:CP_NewDocFormat];
    [prefs removeObjectForKey:CP_SaveBackup];
    [prefs removeObjectForKey:CP_SaveBackupInterval];
    [NSFont setUserFont:[NSFont fontWithName:CP_RTFFont size:12.0]];
    [NSFont setUserFixedPitchFont:[NSFont fontWithName:CP_TextFont size:10.0]];
    
    // Extract some preferences that aren't regular booleans or strings
    
    colorAsData = [prefs objectForKey:CP_BackgroundColor];
    textColorAsData = [prefs objectForKey:CP_TextColor];
    rtfFont = [[NSFontManager sharedFontManager] convertFont:[NSFont userFontOfSize:0.0]];
    textFont = [[NSFontManager sharedFontManager] convertFont:[NSFont userFixedPitchFontOfSize:0.0]];
    
    // Now update the preference panel to reflect their new settings
    
    [colorWell setColor:[NSUnarchiver unarchiveObjectWithData:colorAsData]];
    [textColorWell setColor:[NSUnarchiver unarchiveObjectWithData:textColorAsData]];
    [showRulerCheckBox setState:[prefs boolForKey:CP_ShowRuler]];
    [continuousSpellCheck setState:[prefs boolForKey:CP_SpellChecking]];
    [showToolbarCheckBox setState:[prefs boolForKey:CP_ShowToolbar]];
    [ignoreFormattingCheckBox setState:[prefs boolForKey:CP_IgnoreFormatting]];
    [enableSmartQuotesCheckBox setState:[prefs boolForKey:CP_EnableSmartQuotes]];
    
    [openNewDoc setState:[prefs boolForKey:CP_OpenNewDoc]];
    [saveBackupCheckBox setState:[prefs boolForKey:CP_SaveBackup]];
    [saveBackupInterval setIntValue:[prefs integerForKey:CP_SaveBackupInterval]];
    
    // Update the fonts
    
    [richTextFontNameField setStringValue:[NSString stringWithFormat:fontText, [rtfFont displayName], [rtfFont pointSize]]];
    [plainTextFontNameField setStringValue:[NSString stringWithFormat:fontText, [textFont displayName], [textFont pointSize]]];
    
    // Set the format checkboxes
    
    if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_CPDFormat])
    {
        cell = CPDFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_RTFFormat])
    {
        cell = RTFFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_RTFDFormat])
    {
        cell = RTFDFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_TextFormat])
    {
        cell = TXTFORMAT;
    }
    
    else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_WordFormat])
    {
        cell = DOCFORMAT;
    }
    
    [formatCheckboxes selectCellWithTag:cell];
}

@end