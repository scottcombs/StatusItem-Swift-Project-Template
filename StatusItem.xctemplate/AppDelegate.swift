//___FILEHEADER___

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var statusItem : NSStatusItem
	var popover : NSPopover
	var eventMonitor: EventMonitor?

	override init() {

		// Hide the app icon from the dock
		NSApp.setActivationPolicy(.accessory)

		self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
		self.popover = NSPopover()
	}

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		if let button = statusItem.button {
			button.image = NSImage(named:NSImage.Name("barImage"))
			button.action = #selector(togglePopover(_:))
		}

		popover.contentViewController = ViewController.freshController()

		eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
			if let strongSelf = self, strongSelf.popover.isShown {
				strongSelf.closePopover(sender: event)
			}
		}

		self.loadDefaults(self)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
		self.saveDefaults(self)
	}

	@objc func togglePopover(_ sender: Any?) {
		if popover.isShown {
			closePopover(sender: sender)
		} else {
			showPopover(sender: sender)
		}
	}

	func showPopover(sender: Any?) {
		if let button = statusItem.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
		}

		eventMonitor?.start()
	}

	func closePopover(sender: Any?) {
		popover.performClose(sender)

		eventMonitor?.stop()
	}

	@objc @IBAction func loadDefaults(_ sender:Any?) {
		let defaults : UserDefaults = UserDefaults.standard

		// Get values
		let loadAtStartup = defaults.bool(forKey: "loadAtStartup")

		// Get the View Controller
		let viewController : ViewController = popover.contentViewController as! ViewController
		if let button = viewController.loadAtStartup {
			if loadAtStartup == true {
				button.state = .on
			}else{
				button.state = .off
			}
		}
	}

	@objc @IBAction func saveDefaults(_ sender:Any?) {
		let defaults : UserDefaults = UserDefaults.standard
		let viewController : ViewController = popover.contentViewController as! ViewController
		let loadAtStartup : Bool
		if let button = viewController.loadAtStartup {
			if button.state == .on {
				loadAtStartup = true
			}else{
				loadAtStartup = false
			}
			defaults.set(loadAtStartup, forKey: "loadAtStartup")
		}
	}

}

