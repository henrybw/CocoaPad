/*
 ---------------------------------------------------------------------------
 CocoaPad -- PreferenceController.h
 By Henry Weiss
 ---------------------------------------------------------------------------
 This is the header file that initializes all the variables, functions, and
 stuff for the PreferenceControllclass.  See "PreferenceController.m" for
 info on the PreferenceController class.
 
 */

#import <AppKit/AppKit.h>

/**********************************/
/* Instance variables and Methods */
/**********************************/

@interface PreferenceController : NSWindowController
{
    IBOutlet NSButton *showRulerCheckBox;  // The "Is ruler visible?" flag
    IBOutlet NSButton *continuousSpellCheck;  // The "Check spelling as you type?" flag
    IBOutlet NSButton *showToolbarCheckBox;  // The "Show Toolbar?" flag
    IBOutlet NSButton *ignoreFormattingCheckBox;  // The "Ignore Formatting?" flag
    IBOutlet NSButton *enableSmartQuotesCheckBox;  // The "Enable Smart Quotes?" flag
    IBOutlet NSButton *saveBackupCheckBox;  // The "Save Backup?" flag
    IBOutlet NSColorWell *colorWell;  // Document's background color
    IBOutlet NSColorWell *textColorWell;  // Font's color
    IBOutlet NSButton *openNewDoc;  // The "Open a new document on launch?" flag
    IBOutlet NSButton *revertButton;  // Revert to original button
    IBOutlet NSMatrix *formatCheckboxes;  // Outlet for the new doc format radio buttons
    IBOutlet NSTextField *saveBackupInterval;  // How often we should save the backup
    
    // Font stuff

    IBOutlet NSTextField *richTextFontNameField;  // Text field that shows the RTF font name
    IBOutlet NSTextField *plainTextFontNameField;  // Text field that shows the plain text font name
    NSString *fontText;  // The font display's formatted string
    BOOL changingRTFFont;  // Flag for what font we're changing
}
- (IBAction)changeShowRuler:(id)sender;  // Toggle the ruler flag
- (IBAction)changeContinuousSpellCheck:(id)sender;  // Toggle the spell-check flag
- (IBAction)changeShowToolbar:(id)sender;  // Toggle the show toolbar flag
- (IBAction)changeIgnoreFormatting:(id)sender;  // Toggle the ignore formatting flag
- (IBAction)changeEnableSmartQuotes:(id)sender;  // Toggle the enable smart quotes flag
- (IBAction)changeSaveBackup:(id)sender;  // Toggle the save backup flag
- (IBAction)changeBackgroundColor:(id)sender;  // Change the background color
- (IBAction)changeTextColor:(id)sender;  // Change the text color
- (IBAction)changeNewEmptyDoc:(id)sender;  // Toggle the new doc on startup flag
- (IBAction)changeRTFFont:(id)sender;  // Change the RTF font
- (IBAction)changeTextFont:(id)sender;  // Change the plain text font
- (void)changeFont:(id)sender;  // Change the font settings (NSFontManager delegate implementation)
- (IBAction)changeFormat:(id)sender;  // Change the new doc format
- (IBAction)changeBackupInterval:(id)sender;  // Change how frequently a backup is saved
- (IBAction)applyToAll:(id)sender;  // Apply changes to all documents
- (IBAction)revertToOriginal:(id)sender;  // Show some sheets to confirm reset decision
- (void)resetPreferences;  // Revert to original settings

@end