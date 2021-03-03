//
//  LayoutStuff.swift
//  Splitter
//
//  Created by Michael Berk on 3/3/21.
//  Copyright © 2021 Michael Berk. All rights reserved.

//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cLayout = try? newJSONDecoder().decode(CLayout.self, from: jsonData)

import Foundation

// MARK: - CLayout
/// Wrapper for JSON from LiveSplit-Core JSON
struct CLayout: Codable {
	let components: [CComponent]
	let direction: String
	let timerFont, timesFont, textFont: JSONNull?
	let background: CLayoutBackground
	let thinSeparatorsColor, separatorsColor: [Double]
	let textColor: [Double]

	enum CodingKeys: String, CodingKey {
		case components, direction
		case timerFont = "timer_font"
		case timesFont = "times_font"
		case textFont = "text_font"
		case background
		case thinSeparatorsColor = "thin_separators_color"
		case separatorsColor = "separators_color"
		case textColor = "text_color"
	}
}

// MARK: - CLayoutBackground
struct CLayoutBackground: Codable {
	let plain: [Double]

	enum CodingKeys: String, CodingKey {
		case plain = "Plain"
	}
}

// MARK: - CComponent
struct CComponent: Codable {
	let title: CTitle?
	let splits: CSplits?
	let timer: CTimer?
	let keyValue: CKeyValue?

	enum CodingKeys: String, CodingKey {
		case title = "Title"
		case splits = "Splits"
		case timer = "Timer"
		case keyValue = "KeyValue"
	}
}

// MARK: - CKeyValue
struct CKeyValue: Codable {
	let background: CurrentSplitGradientClass
	let keyColor: JSONNull?
	let valueColor: [Double]
	let semanticColor, key, value: String
	let keyAbbreviations: [String]
	let displayTwoRows: Bool

	enum CodingKeys: String, CodingKey {
		case background
		case keyColor = "key_color"
		case valueColor = "value_color"
		case semanticColor = "semantic_color"
		case key, value
		case keyAbbreviations = "key_abbreviations"
		case displayTwoRows = "display_two_rows"
	}
}

// MARK: - CurrentSplitGradientClass
struct CurrentSplitGradientClass: Codable {
	let vertical: [[Double]]

	enum CodingKeys: String, CodingKey {
		case vertical = "Vertical"
	}
}

// MARK: - CSplits
struct CSplits: Codable {
	let background: CPurpleBackground
	let columnLabels: JSONNull?
	let splits: [CSplit]
	let iconChanges: [CIconChange]
	let hasIcons, showThinSeparators, showFinalSeparator, displayTwoRows: Bool
	let currentSplitGradient: CurrentSplitGradientClass

	enum CodingKeys: String, CodingKey {
		case background
		case columnLabels = "column_labels"
		case splits
		case iconChanges = "icon_changes"
		case hasIcons = "has_icons"
		case showThinSeparators = "show_thin_separators"
		case showFinalSeparator = "show_final_separator"
		case displayTwoRows = "display_two_rows"
		case currentSplitGradient = "current_split_gradient"
	}
}

// MARK: - CPurpleBackground
struct CPurpleBackground: Codable {
	let alternating: [[Double]]

	enum CodingKeys: String, CodingKey {
		case alternating = "Alternating"
	}
}

// MARK: - CIconChange
struct CIconChange: Codable {
	let segmentIndex: Int
	let icon: String

	enum CodingKeys: String, CodingKey {
		case segmentIndex = "segment_index"
		case icon
	}
}

// MARK: - CSplit
struct CSplit: Codable, Hashable {
//	static func == (lhs: CSplit, rhs: CSplit) -> Bool {
//		if lhs.name == rhs.name,
//		   lhs.columns == rhs.columns
//	}
	
	let name: String
	let columns: [Column]
	let isCurrentSplit: Bool
	let index: Double

	enum CodingKeys: String, CodingKey {
		case name, columns
		case isCurrentSplit = "is_current_split"
		case index
	}
}

// MARK: - Column
struct Column: Codable, Hashable {
	let value, semanticColor: String
	let visualColor: [Double]

	enum CodingKeys: String, CodingKey {
		case value
		case semanticColor = "semantic_color"
		case visualColor = "visual_color"
	}
}

// MARK: - CTimer
struct CTimer: Codable {
	let background, time, fraction, semanticColor: String
	let topColor: [Double]
	let bottomColor: [Double]
	let height: Int

	enum CodingKeys: String, CodingKey {
		case background, time, fraction
		case semanticColor = "semantic_color"
		case topColor = "top_color"
		case bottomColor = "bottom_color"
		case height
	}
	var timeText: String {
		return time + fraction
	}
}

// MARK: - CTitle
struct CTitle: Codable {
	let background: CurrentSplitGradientClass
	let textColor: JSONNull?
	let iconChange: String?
	let line1: [String]
	let line2: [JSONAny]
	let isCentered: Bool
	let finishedRuns: JSONNull?
	let attempts: Int

	enum CodingKeys: String, CodingKey {
		case background
		case textColor = "text_color"
		case iconChange = "icon_change"
		case line1, line2
		case isCentered = "is_centered"
		case finishedRuns = "finished_runs"
		case attempts
	}
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

	public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
		return true
	}

	public var hashValue: Int {
		return 0
	}

	public func hash(into hasher: inout Hasher) {
		// No-op
	}

	public init() {}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		if !container.decodeNil() {
			throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encodeNil()
	}
}

class JSONCodingKey: CodingKey {
	let key: String

	required init?(intValue: Int) {
		return nil
	}

	required init?(stringValue: String) {
		key = stringValue
	}

	var intValue: Int? {
		return nil
	}

	var stringValue: String {
		return key
	}
}

class JSONAny: Codable {

	let value: Any

	static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
		let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
		return DecodingError.typeMismatch(JSONAny.self, context)
	}

	static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
		let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
		return EncodingError.invalidValue(value, context)
	}

	static func decode(from container: SingleValueDecodingContainer) throws -> Any {
		if let value = try? container.decode(Bool.self) {
			return value
		}
		if let value = try? container.decode(Int64.self) {
			return value
		}
		if let value = try? container.decode(Double.self) {
			return value
		}
		if let value = try? container.decode(String.self) {
			return value
		}
		if container.decodeNil() {
			return JSONNull()
		}
		throw decodingError(forCodingPath: container.codingPath)
	}

	static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
		if let value = try? container.decode(Bool.self) {
			return value
		}
		if let value = try? container.decode(Int64.self) {
			return value
		}
		if let value = try? container.decode(Double.self) {
			return value
		}
		if let value = try? container.decode(String.self) {
			return value
		}
		if let value = try? container.decodeNil() {
			if value {
				return JSONNull()
			}
		}
		if var container = try? container.nestedUnkeyedContainer() {
			return try decodeArray(from: &container)
		}
		if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
			return try decodeDictionary(from: &container)
		}
		throw decodingError(forCodingPath: container.codingPath)
	}

	static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
		if let value = try? container.decode(Bool.self, forKey: key) {
			return value
		}
		if let value = try? container.decode(Int64.self, forKey: key) {
			return value
		}
		if let value = try? container.decode(Double.self, forKey: key) {
			return value
		}
		if let value = try? container.decode(String.self, forKey: key) {
			return value
		}
		if let value = try? container.decodeNil(forKey: key) {
			if value {
				return JSONNull()
			}
		}
		if var container = try? container.nestedUnkeyedContainer(forKey: key) {
			return try decodeArray(from: &container)
		}
		if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
			return try decodeDictionary(from: &container)
		}
		throw decodingError(forCodingPath: container.codingPath)
	}

	static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
		var arr: [Any] = []
		while !container.isAtEnd {
			let value = try decode(from: &container)
			arr.append(value)
		}
		return arr
	}

	static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
		var dict = [String: Any]()
		for key in container.allKeys {
			let value = try decode(from: &container, forKey: key)
			dict[key.stringValue] = value
		}
		return dict
	}

	static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
		for value in array {
			if let value = value as? Bool {
				try container.encode(value)
			} else if let value = value as? Int64 {
				try container.encode(value)
			} else if let value = value as? Double {
				try container.encode(value)
			} else if let value = value as? String {
				try container.encode(value)
			} else if value is JSONNull {
				try container.encodeNil()
			} else if let value = value as? [Any] {
				var container = container.nestedUnkeyedContainer()
				try encode(to: &container, array: value)
			} else if let value = value as? [String: Any] {
				var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
				try encode(to: &container, dictionary: value)
			} else {
				throw encodingError(forValue: value, codingPath: container.codingPath)
			}
		}
	}

	static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
		for (key, value) in dictionary {
			let key = JSONCodingKey(stringValue: key)!
			if let value = value as? Bool {
				try container.encode(value, forKey: key)
			} else if let value = value as? Int64 {
				try container.encode(value, forKey: key)
			} else if let value = value as? Double {
				try container.encode(value, forKey: key)
			} else if let value = value as? String {
				try container.encode(value, forKey: key)
			} else if value is JSONNull {
				try container.encodeNil(forKey: key)
			} else if let value = value as? [Any] {
				var container = container.nestedUnkeyedContainer(forKey: key)
				try encode(to: &container, array: value)
			} else if let value = value as? [String: Any] {
				var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
				try encode(to: &container, dictionary: value)
			} else {
				throw encodingError(forValue: value, codingPath: container.codingPath)
			}
		}
	}

	static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
		if let value = value as? Bool {
			try container.encode(value)
		} else if let value = value as? Int64 {
			try container.encode(value)
		} else if let value = value as? Double {
			try container.encode(value)
		} else if let value = value as? String {
			try container.encode(value)
		} else if value is JSONNull {
			try container.encodeNil()
		} else {
			throw encodingError(forValue: value, codingPath: container.codingPath)
		}
	}

	public required init(from decoder: Decoder) throws {
		if var arrayContainer = try? decoder.unkeyedContainer() {
			self.value = try JSONAny.decodeArray(from: &arrayContainer)
		} else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
			self.value = try JSONAny.decodeDictionary(from: &container)
		} else {
			let container = try decoder.singleValueContainer()
			self.value = try JSONAny.decode(from: container)
		}
	}

	public func encode(to encoder: Encoder) throws {
		if let arr = self.value as? [Any] {
			var container = encoder.unkeyedContainer()
			try JSONAny.encode(to: &container, array: arr)
		} else if let dict = self.value as? [String: Any] {
			var container = encoder.container(keyedBy: JSONCodingKey.self)
			try JSONAny.encode(to: &container, dictionary: dict)
		} else {
			var container = encoder.singleValueContainer()
			try JSONAny.encode(to: &container, value: self.value)
		}
	}
}
