//
//  DataParser.swift
//

import Foundation

protocol DataParserProtocol {
	func parse<T: Decodable>(data: Data) throws -> T
}

class JsonDataParser: DataParserProtocol {
	private var jsonDecoder: JSONDecoder

	init(decoder: JSONDecoder) {
		self.jsonDecoder = decoder
	}

	func parse<T: Decodable>(data: Data) throws -> T {
		return try jsonDecoder.decode(T.self, from: data)
	}
}

class NoOpParser: DataParserProtocol {
	func parse<T: Decodable>(data: Data) throws -> T {
		return data as! T
	}
}
