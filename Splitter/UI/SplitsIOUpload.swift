//
//  SplitsIOUpload.swift
//  Splitter
//
//  Created by Michael Berk on 8/16/20.
//  Copyright © 2020 Michael Berk. All rights reserved.
//

import Foundation
import SplitsIOKit

class SplitsIOUploader {
	
	var viewController: ViewController
	init(viewController: ViewController) {
		self.viewController = viewController
	}
	
	func uploadToSplitsIO() {
		if let runString = makeSplitsIOJSON(),
			SplitsIOKit.shared.hasAuth {
			let confAlert = NSAlert()
			confAlert.messageText = "Are you sure you would like to upload this run to Splits.io?"
			confAlert.addButton(withTitle: "Upload")
			confAlert.addButton(withTitle: "Cancel")
			confAlert.beginSheetModal(for: viewController.view.window!, completionHandler: { response in
				if response == .alertFirstButtonReturn {
					let loadingView = LoadingViewController()
					loadingView.loadViewFromNib()
					loadingView.labelView.stringValue = "Uploading..."
					self.viewController.presentAsSheet(loadingView)
					try? SplitsIOKit.shared.uploadRunToSplitsIO(runString: runString, completion: { claimURI in
						
						self.viewController.dismiss(loadingView)
						let finishedAlert = NSAlert()
						finishedAlert.messageText = "Run has successfully been uploaded to Splits.io"
						finishedAlert.addButton(withTitle: "OK")
						finishedAlert.addButton(withTitle: "View on Splits.io")
						finishedAlert.beginSheetModal(for: self.viewController.view.window!, completionHandler: { response2 in
							if response2 == .alertSecondButtonReturn {
								print(claimURI)
								NSWorkspace.shared.open(URL(string: claimURI)!)
							}
						})
					})
				}
			})
		} else {
			if !SplitsIOKit.shared.hasAuth {
				let notLoggedInAlert = NSAlert()
				notLoggedInAlert.messageText = "Splitter is not signed in to Splits.io"
				notLoggedInAlert.informativeText = "Log in with your Splits.io account to upload"
				notLoggedInAlert.addButton(withTitle: "Log in")
				notLoggedInAlert.addButton(withTitle: "Cancel")
				notLoggedInAlert.beginSheetModal(for: viewController.view.window!, completionHandler: { response in
					if response == .alertFirstButtonReturn {
						AppDelegate.shared?.preferencesWindowController.show(preferencePane: .splitsIO)
					}
				})
			}
		}
	}
	func makeSplitsIOJSON() -> String? {
		let timer = SplitsIOTimer(shortname: "Splitter", longname: "Splitter", website: "splitter.mberk.com", version: "v\(otherConstants.version) (\(otherConstants.build))")
		let game = SplitsIORunCategory(longname: viewController.run.title, shortname: nil, links: nil)
		let cat = SplitsIORunCategory(longname: viewController.run.subtitle, shortname: nil, links: nil)
		var cs: [SplitsIOSegment] = []
		let run = viewController.run.timer.lsRun
		let len = run.len()
		for s in 0..<len {
			let segment = run.segment(s)
			let bestRT = segment.personalBestSplitTime().realTime()?.totalSeconds() ?? 0 * 1000
			let bestGT = segment.personalBestSplitTime().gameTime()?.totalSeconds() ?? 0 * 1000
			let dur = SplitsIOBestDuration(realtimeMS: Int(bestRT), gametimeMS: Int(bestGT))
			let seg = SplitsIOSegment(name: segment.name(), endedAt: dur, bestDuration: dur, isSkipped: nil, histories: nil)
			cs.append(seg)
		}
		var runners: [SplitsIOExchangeRunner] = []
		if let currentRunner = Settings.splitsIOUser {
			let r = SplitsIOExchangeRunner(links: nil, longname: currentRunner.displayName, shortname: currentRunner.name)
			runners.append(r)
		}
		let sIO = SplitsIOExchangeFormat(schemaVersion: "v1.0.1", links: nil, timer: timer, attempts: nil, game: game, category: cat, runners: runners, segments: cs, imageURL: nil)
		//TODO: See if this works without "var"
		if var jsonString = try? sIO.jsonString() {
			return jsonString.replacingOccurrences(of: "schemaVersion", with: "_schemaVersion")
		}
		return nil
	}
}
