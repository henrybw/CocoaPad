/*
 ---------------------------------------------------------------------------
 CocoaPad -- InterfaceController.h
 By Henry Weiss
 ---------------------------------------------------------------------------
 This is the header file that initializes all the variables, functions, and
 stuff for the InterfaceController class.  See "InterfaceController.m" for
 info on the InterfaceController class.
 
 */

#import <Foundation/Foundation.h>
@class PreferenceController;  // This way, Xcode doesn't have to parse more files

/****************************/
/* Declare global variables */
/****************************/

/*
 * These are the keys used in the preference file
 *
 * The "CP_" prefix means CocoaPad, just like the
 * "NS" Cocoa prefix stands for NeXTSTEP.
 */

extern NSString *CP_ShowRuler;
extern NSString *CP_SpellChecking;
extern NSString *CP_ShowToolbar;
extern NSString *CP_IgnoreFormatting;
extern NSString *CP_EnableSmartQuotes;
extern NSString *CP_BackgroundColor;
extern NSString *CP_TextColor;
extern NSString *CP_OpenNewDoc;
extern NSString *CP_NewDocFormat;
extern NSString *CP_SaveBackup;
extern NSString *CP_SaveBackupInterval;

// These are the keys used for custom toolbar items.

extern NSString *CP_ToolbarIdentifier;
extern NSString *CP_BoldToolbarItemIdentifier;
extern NSString *CP_ItalicToolbarItemIdentifier;
extern NSString *CP_UnderlineToolbarItemIdentifier;
extern NSString *CP_NewDocToolbarItemIdentifier;
extern NSString *CP_SaveToolbarItemIdentifier;
extern NSString *CP_SaveAsToolbarItemIdentifier;
extern NSString *CP_OpenToolbarItemIdentifier;
extern NSString *CP_PrefsToolbarItemIdentifier;
extern NSString *CP_FindToolbarItemIdentifier;
extern NSString *CP_FindNextToolbarItemIdentifier;
extern NSString *CP_BackgroundColorToolbarItemIdentifier;
extern NSString *CP_BiggerToolbarItemIdentifier;
extern NSString *CP_SmallerToolbarItemIdentifier;
extern NSString *CP_UppercaseToolbarItemIdentifier;
extern NSString *CP_LowercaseToolbarItemIdentifier;
extern NSString *CP_CapitalizeToolbarItemIdentifier;
extern NSString *CP_ConvertToCPDToolbarItemIdentifier;
extern NSString *CP_ConvertToRTFToolbarItemIdentifier;
extern NSString *CP_ConvertToRTFDToolbarItemIdentifier;
extern NSString *CP_ConvertToTXTToolbarItemIdentifier;
extern NSString *CP_ConvertToDocToolbarItemIdentifier;

// Document formats defined in Info.plist

extern NSString *CP_CPDocument;
extern NSString *CP_RTFDocument;
extern NSString *CP_RTFDDocument;
extern NSString *CP_TextDocument;
extern NSString *CP_WordDocument;

// Document formats used in the preference file

extern NSString *CP_DefaultFormat;
extern NSString *CP_CPDFormat;
extern NSString *CP_RTFFormat;
extern NSString *CP_RTFDFormat;
extern NSString *CP_WordFormat;
extern NSString *CP_TextFormat;

// Default fonts

extern NSString *CP_RTFFont;
extern NSString *CP_TextFont;


/**********************************/
/* Instance variables and Methods */
/**********************************/

@interface InterfaceController : NSObject
{
    PreferenceController *preferenceController;  // For the instance of PreferenceController
    IBOutlet NSPanel *window;
    BOOL flag;
    
    NSTimer *backupTimer;  // The timer that will save a backup file at specified intervals
}

- (IBAction)showPreferencePanel:(id)sender;  // This will show the pref panel
- (IBAction)showAboutPanel:(id)sender;
- (void)createNewBackupTimer:(NSNotification *)notification;

// These will trigger MyDocument's utility methods

- (IBAction)uppercase:(id)sender;
- (IBAction)lowercase:(id)sender;
- (IBAction)capitalize:(id)sender;
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)wordCount:(id)sender;
- (IBAction)makeCPD:(id)sender;
- (IBAction)makeRichText:(id)sender;
- (IBAction)makeRTFD:(id)sender;
- (IBAction)makeDocFormat:(id)sender;
- (IBAction)makePlainText:(id)sender;

@end