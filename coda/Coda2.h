/*
 * Coda2.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class Coda2Application, Coda2Document, Coda2Window, Coda2Tab, Coda2Split, Coda2Site, Coda2FileBrowser, Coda2SkipRule, Coda2BrowserItem, Coda2SelectedBrowserItem;

enum Coda2SaveOptions {
	Coda2SaveOptionsYes = 'yes ' /* Save the file. */,
	Coda2SaveOptionsNo = 'no  ' /* Do not save the file. */,
	Coda2SaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum Coda2SaveOptions Coda2SaveOptions;

enum Coda2PrintingErrorHandling {
	Coda2PrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	Coda2PrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum Coda2PrintingErrorHandling Coda2PrintingErrorHandling;

enum Coda2SaveableFileFormat {
	Coda2SaveableFileFormatText = 'txt ' /* Text Document Format */
};
typedef enum Coda2SaveableFileFormat Coda2SaveableFileFormat;

enum Coda2Connectprotocol {
	Coda2ConnectprotocolFTP = 'FTP ' /* FTP Protocol */,
	Coda2ConnectprotocolFTPImplicitSSL = 'FSSL' /* FTP with implicit SLL */,
	Coda2ConnectprotocolFTPTLSSSL = 'FTPS' /* FTP with TLS/SSL */,
	Coda2ConnectprotocolS3 = 'S3  ' /* Amazon S3 */,
	Coda2ConnectprotocolSFTP = 'SFTP' /* SFTP */,
	Coda2ConnectprotocolWebDAV = 'WDAV' /* WebDAV */,
	Coda2ConnectprotocolWebDAVHTTPS = 'SDAV' /* WebDAV with HTTPS */
};
typedef enum Coda2Connectprotocol Coda2Connectprotocol;

enum Coda2Resumetype {
	Coda2ResumetypeAsk = 'aTRN' /* Ask how to proceed if a duplicate file exists. */,
	Coda2ResumetypeOverwrite = 'oTRN' /* Overwrite a duplicate file. */,
	Coda2ResumetypeResume = 'rTRN' /* Try and continue transferring a duplicate file. */,
	Coda2ResumetypeSkip = 'sTRN' /* Skip a duplicate file. */
};
typedef enum Coda2Resumetype Coda2Resumetype;

enum Coda2Itemtype {
	Coda2ItemtypeFolderItem = 'FKfo' /* Browser item folders. */,
	Coda2ItemtypeFileItem = 'FKfi' /* Browser item files. */,
	Coda2ItemtypeAliasItem = 'FKal' /* Browser item aliases. */,
	Coda2ItemtypeSmartFolderItem = 'FKsm' /* Browser item smart folders. */
};
typedef enum Coda2Itemtype Coda2Itemtype;



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface Coda2Application : SBApplication

- (SBElementArray *) documents;
- (SBElementArray *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the active application?
@property (copy, readonly) NSString *version;  // The version number of the application.

- (id) open:(id)x;  // Open a document.
- (void) print:(id)x withProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) quitSaving:(Coda2SaveOptions)saving;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify that an object exists.

@end

// A document.
@interface Coda2Document : SBObject

@property (copy, readonly) NSString *name;  // Its name.
@property (readonly) BOOL modified;  // Has it been modified since the last save?
@property (copy, readonly) NSURL *file;  // Its location on disk, if it has one.

- (void) closeSaving:(Coda2SaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(Coda2SaveableFileFormat)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end

// A window.
@interface Coda2Window : SBObject

@property (copy, readonly) NSString *name;  // The title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Does the window have a close button?
@property (readonly) BOOL miniaturizable;  // Does the window have a minimize button?
@property BOOL miniaturized;  // Is the window minimized right now?
@property (readonly) BOOL resizable;  // Can the window be resized?
@property BOOL visible;  // Is the window visible right now?
@property (readonly) BOOL zoomable;  // Does the window have a zoom button?
@property BOOL zoomed;  // Is the window zoomed right now?
@property (copy, readonly) Coda2Document *document;  // The document whose contents are displayed in the window.

- (void) closeSaving:(Coda2SaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(Coda2SaveableFileFormat)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.
- (BOOL) connectTo:(Coda2Site *)to toAddress:(NSString *)toAddress asUser:(NSString *)asUser usingPort:(NSInteger)usingPort withInitialPath:(NSString *)withInitialPath withPassword:(NSString *)withPassword withProtocol:(Coda2Connectprotocol)withProtocol;  // Connect to a site or a specified server.
- (void) disconnect;  // Disconnect a site.
- (BOOL) publish;  // Upload locally changed files from the current site to their corresponding location on the server.

@end



/*
 * Coda Suite
 */

@interface Coda2Application (CodaSuite)

- (SBElementArray *) sites;
- (SBElementArray *) skipRules;

@property BOOL suppressErrors;  // Do not show error dialogs during AppleScript execution (on by default).

@end

@interface Coda2Window (CodaSuite)

- (SBElementArray *) tabs;
@end
