//___FILEHEADER___

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		let pathComponents = (Bundle.main.bundlePath as NSString).pathComponents

		let	pathSlice = pathComponents.prefix(pathComponents.count - 4)
		let path = NSString.path(withComponents: Array(pathSlice) ) as String
		NSWorkspace.shared.launchApplication(path)
		NSApp.terminate(self)

	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}

