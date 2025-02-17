//
//  SplitterTableView.swift
//  Splitter
//
//  Created by Michael Berk on 4/5/20.
//  Copyright © 2020 Michael Berk. All rights reserved.
//

import Cocoa

class SplitterTableView: NSTableView {
	var viewController: ViewController!
	
	override func adjustScroll(_ newVisible: NSRect) -> NSRect {
		var adjRect = newVisible
		let headerHeight = self.headerView?.frame.height ?? 0
		var h = adjRect.origin.y
		let amount: CGFloat = 31
		if (h+headerHeight).truncatingRemainder(dividingBy: amount) != 0 {
			let mul = CGFloat(Int((h) / amount))
			let lower = abs(mul * amount)
			let higher = abs(mul + 1) * amount
			if lower < higher {
				//Make sure that it's not possible for the top of the view to be "stuck" under the header
				if h < 0 && lower == 0 && headerView != nil {
					h = -1 * headerHeight
				} else {
					h = lower
				}
			} else {
				h = higher
			}
		}
		adjRect.origin.y = h
		return super.adjustScroll(adjRect)
	}
	
	
    override func draw(_ dirtyRect: NSRect) {}
	
	
	/// Sets the background color for the view under the scroll bar
	/// - Parameter cornerColor: Background color for the view under the scroll bar
	func setCornerColor(cornerColor: NSColor) {
		let vSize = self.headerView?.frame.size.height ?? 0
		let hSize = self.enclosingScrollView!.verticalScroller!.frame.size.height
		let cRect = NSRect(x: 0, y: 0, width: hSize, height: vSize)
		
		let cornerV = NSView(frame: cRect)
		cornerV.wantsLayer = true
		cornerV.layer?.backgroundColor = cornerColor.cgColor
		
		enclosingScrollView?.verticalScroller?.wantsLayer = true
		enclosingScrollView?.verticalScroller?.layer?.isOpaque = false
		enclosingScrollView?.horizontalScroller?.wantsLayer = false
		enclosingScrollView?.horizontalScroller?.layer?.isOpaque = false
		if let hScroller = enclosingScrollView?.horizontalScroller as? SplitterScroller, let vScroller = enclosingScrollView?.verticalScroller as? SplitterScroller {
			hScroller.layer?.backgroundColor = .clear
			vScroller.layer?.backgroundColor = .clear
			hScroller.bgColor = cornerColor
			vScroller.bgColor = cornerColor
		}
		
		self.cornerView = cornerV
		
		(enclosingScrollView as? SplitsComponent)?.tableBGColor = cornerColor
	}
	
	/// Sets the background color of the table header to the specified color
	///
	/// In addition to setting the backrgound and text for the header, it also makes the header opaque.
	/// - Parameters:
	///   - textColor: Color for the header's text
	///   - bgColor: Background color for the header
	func setHeaderColor(textColor: NSColor, bgColor: NSColor) {
		if self.headerView != nil {
			for c in self.tableColumns {
				if !c.isHidden {
					let headerStr = c.headerCell.stringValue
					let head = SplitterTableHeaderCell(textCell: headerStr)
					head.drawsBackground = true
					head.backgroundColor = .clear
					head.backgroundStyle = .raised
					head.tintColor = viewController.run.tableColor
					head.textColor = textColor
					head.attributedStringValue = NSAttributedString(string: headerStr, attributes: [.foregroundColor: textColor])
					c.headerCell = head
				}
			}
		}
	}
    
	//Overriding keyDown so that typing a letter for a hotkey doesn't select that segment
	override func keyDown(with event: NSEvent) {
		superview?.keyDown(with: event)
	}
	
	///An `IndexSet` with the index for every column in the table
	var allColumnIndexes: IndexSet {
		var cols: [Int] = []
		for i in 0...tableColumns.count {
			cols.append(i)
		}
		return IndexSet(cols)
	}
	
}

class SplitterTableHeader: NSTableHeaderView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
	
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
	}

    override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)
		
	}
}


///The header cell for the Splitter Table View.
///
///Automatically draws the background with the current `backgroundColor` of the `SplitterTableHeaderCell`
class SplitterTableHeaderCell: NSTableHeaderCell {
	
	var tintColor: NSColor? = .controlBackgroundColor
	
	required init(coder: NSCoder) {
		super.init(coder: coder)
	}

    override init(textCell: String) {
        super.init(textCell: textCell)
    }
	
	func colorfulDraw(withFrame cellFrame: NSRect, in controlView: NSView, systemEffect: NSColor.SystemEffect) {
		if let tintColor = self.tintColor {
			let alpha = tintColor.alphaComponent * 0.6
			tintColor.withAlphaComponent(alpha).withSystemEffect(systemEffect).set()
			var fillStyle: NSCompositingOperation
			if controlView.effectiveAppearance.name.rawValue.contains("Dark") {
				fillStyle = .softLight
			} else {
				fillStyle = .hardLight
			}
			if alpha == 0 {
				fillStyle = .clear
			}
			cellFrame.fill(using: fillStyle)
		}
		
		//Several calculations used to draw the border and text
		let offset = floor((cellFrame.height - (font!.ascender - font!.descender))/2)// - 3
		let topOffset = cellFrame.maxY - offset
		
		//Draw the border
		let fromPoint = NSPoint(x: cellFrame.maxX + 1.5, y: offset)
		let toPoint = NSPoint(x: cellFrame.maxX + 1.5, y: topOffset)
		let sep = NSColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
		sep.setStroke()
		let path = NSBezierPath.init()
		path.lineWidth = 0
		path.move(to: fromPoint)
		path.line(to: toPoint)
		path.stroke()
		
		//Without this custom inset, the header text will appear at the top of the cell, instead of the center.
		let inset = cellFrame.insetBy(dx: 5, dy: offset)
		drawInterior(withFrame: inset, in: controlView)
	}

    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
		colorfulDraw(withFrame: cellFrame, in: controlView, systemEffect: .none)
    }
	
	override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
		colorfulDraw(withFrame: cellFrame, in: controlView, systemEffect: .pressed)
	}
	
	//Used to fix crash - Apple's reccomended approach
	override func copy(with zone: NSZone? = nil) -> Any {
		let stashedTintColor = tintColor
		tintColor = nil
		let copy = super.copy(with: zone)
		tintColor = stashedTintColor
		(copy as? SplitterTableHeaderCell)?.tintColor = stashedTintColor
		return copy
	}
}
