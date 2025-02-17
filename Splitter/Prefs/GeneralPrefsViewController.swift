//
//  GeneralPrefsViewController.swift
//  Splitter
//
//  Created by Michael Berk on 12/13/21.
//  Copyright © 2021 Michael Berk. All rights reserved.
//

import Cocoa
import Preferences

class GeneralPrefsViewController: NSViewController, PreferencePane {
	
	@IBOutlet var menuBarSwitch: NSSwitch!
	@IBOutlet var resetWarningsButton: NSButton!
	
	@IBAction func resetWarningsClicked(_ sender: Any?) {
		for warning in Warning.allCases {
			Settings.setWarning(warning, suppresed: false)
		}
	}
	
	@IBAction func setAppMode(_ sender: NSSwitch) {
		if sender.state == .on {
			StatusBarController.setMenuBarMode(true)
			NSApp.activate(ignoringOtherApps: true)
		} else {
			StatusBarController.setMenuBarMode(false)
		}
		
	}
	@objc func popover(_ sender: Any) {
		NSApp.activate(ignoringOtherApps: true)
	}
	var preferencePaneTitle: String = "General"
	
	var preferencePaneIdentifier: Preferences.PaneIdentifier = .general
	
	override var nibName: NSNib.Name? { "GeneralPrefsViewController" }
	
	var toolbarItemIcon: NSImage {
		if #available(macOS 11.0, *), let img = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil) {
			return img
		} else {
			return NSImage(named: NSImage.preferencesGeneralName)!
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
		preferredContentSize = NSSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
		NotificationCenter.default.addObserver(forName: .menuBarModeChanged, object: nil, queue: nil, using: { _ in
			self.setMenuBarToggle()
		})
		setMenuBarToggle()
    }
	
	func setMenuBarToggle() {
		if Settings.menuBarMode {
			menuBarSwitch.state = .on
		} else {
			menuBarSwitch.state = .off
		}
	}
    
}

extension AppDelegate {
	@objc func statusAction(_ sender: Any?) {
		NSApp.activate(ignoringOtherApps: true)
	}
}
