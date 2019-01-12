//___FILEHEADER___

import Cocoa
import ServiceManagement

class ViewController: NSViewController {
	@IBOutlet var loadAtStartup: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		NSApp.sendAction(#selector(AppDelegate.loadDefaults(_:)), to: nil, from: self)
    }

	@IBAction func loadAtStartup(_ sender: Any?) {
		let appBundleIdentifier : String = "[--Bundle Identifier For Launcher App--]"
		let defaults = UserDefaults.standard;

		if let button : NSButton = sender as? NSButton {
			// Good
			if button.state == .on {
				SMLoginItemSetEnabled(appBundleIdentifier as CFString, true)
				defaults.set(true, forKey: "loadAtStartup")
			}else{
				SMLoginItemSetEnabled(appBundleIdentifier as CFString, false)
				defaults.set(false, forKey: "loadAtStartup")
			}
		}
	}
}

extension ViewController {
	// MARK: Storyboard instantiation
	static func freshController() -> ViewController {
		//1.
		let storyboard = NSStoryboard(name: "Main", bundle: nil)

		//2.
		let identifier = NSStoryboard.SceneIdentifier("ViewController")

		//3.
		guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
			fatalError("Why can't I find ViewController? - Check Main.storyboard")
		}
		return viewcontroller
	}
}
