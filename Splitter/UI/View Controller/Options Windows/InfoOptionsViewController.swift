//
//  InfoOptionsViewController.swift
//  Splitter
//
//  Created by Michael Berk on 3/3/20.
//  Copyright © 2020 Michael Berk. All rights reserved.
//

import Cocoa



class InfoOptionsViewController: NSViewController, NSPopoverDelegate, advancedTabDelegate, NSTextFieldDelegate {

	var run: SplitterRun!
	var delegate: ViewController?
	@IBOutlet weak var runTitleField: NSTextField!
	@IBOutlet weak var categoryField: NSTextField!
	@IBOutlet weak var attemptField: NSTextField!
	@IBOutlet weak var platformField: NSTextField!
	@IBOutlet weak var versionField: NSTextField!
	@IBOutlet weak var regionField: NSTextField!
	
	@IBOutlet weak var startTimeLabel: NSTextField!
	@IBOutlet weak var endTimeLabel: NSTextField!
	
	@IBOutlet weak var iconWell: MetadataImage!
	
	@IBOutlet weak var offsetField: NSTextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		getDataFromRun()
		
		iconWell.allowsUpdate = false
		iconWell.image = run.gameIcon
		iconWell.allowsUpdate = true
		
		attemptField.formatter = OnlyIntegerValueFormatter()
		
		runTitleField.delegate = self
		categoryField.delegate = self
		attemptField.delegate = self
		platformField.delegate = self
		versionField.delegate = self
		regionField.delegate = self
		
		NotificationCenter.default.addObserver(forName: .runEdited, object: nil, queue: nil, using: { _ in
			self.getDataFromRun()
		})
		NotificationCenter.default.addObserver(forName: .gameIconEdited, object: nil, queue: nil, using: { notification in
			
		})
		
		
    }
	
	@IBAction func offsetTextFieldEdited(_ sender: Any?) {
		run.offset = Double(offsetField.stringValue) ?? 0
		run.updateLayoutState()
		let offset = run.offset
		offsetField.stringValue = "\(offset)"
		delegate?.updateTimer()
	}
	
	@IBOutlet weak var startEndDateFormatter: DateFormatter!
	
	func popoverShouldDetach(_ popover: NSPopover) -> Bool {
		let realAppearance = view.effectiveAppearance.name
		popover.appearance = NSAppearance(named: realAppearance)
		return true
	}
	
	func setupDelegate() {
		
	}
	func controlTextDidEndEditing(_ obj: Notification) {
		updateRun()
	}
	
	///Loads the popover with data from the main window
	func getDataFromRun() {
		//If the user types a title on the view controller, then shows the info panel (without pressing enter on the TF first), delegate is nil
		if let delegate = self.delegate {
			iconWell.run = delegate.run
			runTitleField.stringValue = run.title
			categoryField.stringValue = run.subtitle
			attemptField.stringValue = "\(delegate.run.attempts)"
			platformField.stringValue = run.platform
			versionField.stringValue = run.gameVersion
			regionField.stringValue = run.region
			
			if let st = delegate.startTime {
				let sDate = startEndDateFormatter.string(from: st)
				
				startTimeLabel.stringValue = sDate
			}
			if let et = delegate.endTime {
				let eDate = startEndDateFormatter.string(from: et)
				endTimeLabel.stringValue = eDate
			}
		}
	}
	
	///Sends data from the popover to the main window
	func updateRun() {
		run.title = runTitleField.stringValue
		run.subtitle = categoryField.stringValue
		run.attempts = Int(attemptField.stringValue) ?? 0
		run.platform = platformField.stringValue
		run.gameVersion = versionField.stringValue
		run.region = regionField.stringValue
	}
	
}

class OnlyIntegerValueFormatter: NumberFormatter {

	override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

		if partialString.isEmpty {
			return true
		}

		return Int(partialString) != nil
	}
}
