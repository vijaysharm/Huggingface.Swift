//
//  Logger.swift
//

import Foundation

public protocol LoggerProtocol {
	func i(_ message: String)
	func e(_ message: String)
	func e(_ message: String, _ error: Error?)
	func d(_ message: String)
	func w(_ message: String)
	func with(level: LogLevel, _ callback: @escaping ((String) -> Void) -> Void)
}

public enum LogLevel: Int {
	case error = 0
	case warning = 1
	case info = 2
	case debug = 3
	
	var label: String {
		get {
			switch self {
			case .debug:
				"DEBUG"
			case .error:
				"ERROR"
			case .info:
				"INFO"
			case .warning:
				"WARN"
			}
		}
	}
}

private class TaggerLogger: LoggerProtocol {
	private let tag: String
	private let logger: Logger
	private let level: LogLevel
	
	init(
		tag: String,
		logger: Logger,
		level: LogLevel
	) {
		self.tag = tag
		self.logger = logger
		self.level = level
	}
	
	func i(_ message: String) {
		if level.rawValue >= LogLevel.info.rawValue {
			logger.i(tag, message: message)
		}
	}
	
	func e(_ message: String) {
		self.e(message, nil)
	}
	
	func e(_ message: String, _ error: Error?) {
		if level.rawValue >= LogLevel.error.rawValue {
			logger.e(tag, message: message, error: error)
		}
	}
	
	func d(_ message: String) {
		if level.rawValue >= LogLevel.debug.rawValue {
			logger.d(tag, message: message)
		}
	}
	
	func w(_ message: String) {
		if level.rawValue >= LogLevel.warning.rawValue {
			logger.w(tag, message: message)
		}
	}
	
	func with(level: LogLevel, _ callback: @escaping ((String) -> Void) -> Void) {
		if self.level.rawValue >= level.rawValue {
			callback { [self] message in
				switch level {
				case .debug:
					self.d(message)
				case .error:
					self.e(message)
				case .info:
					self.i(message)
				case .warning:
					self.w(message)
				}
			}
		}
	}
}

class Logger {
	public static var level: LogLevel = .info
	public static func make(tag: Any) -> LoggerProtocol {
		return TaggerLogger(
			tag: String(describing: tag),
			logger: Logger.shared,
			level: Logger.level
		)
	}
	
	struct LogLine {
		let tag: String
		let message: String
		let level: LogLevel
		let timestamp: Date = Date()
	}
	
	fileprivate static let shared = Logger()
	private var lines: [LogLine] = []
	
	fileprivate func i(_ tag: String, message: String) {
		append(line: LogLine(tag: tag, message: message, level: .info))
	}
	
	fileprivate func d(_ tag: String, message: String) {
		append(line: LogLine(tag: tag, message: message, level: .debug))
	}
	
	fileprivate func e(_ tag: String, message: String, error: Error? = nil) {
		append(line: LogLine(tag: tag, message: message, level: .error))
		if let error = error {
			append(line: LogLine(tag: tag, message: "\(error)", level: .error))
		}
	}
	
	fileprivate func w(_ tag: String, message: String) {
		append(line: LogLine(tag: tag, message: message, level: .warning))
	}
	
	private func append(line: LogLine) {
//		lines.append(line)
		print("[\(line.level.label)]: \(line.message)")
	}
}
