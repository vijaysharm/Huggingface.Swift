//
//  TestFetch.swift
//

import Foundation
@testable import Huggingface_Inference

class TestFetch: FetchProtocol {
	private let result: [Result<RequestResponse, RequestError>]
	var index: Int = 0
	
	init(
		result: [Result<RequestResponse, RequestError>]
	) {
		self.result = result
	}
	
	convenience init(
		result: String
	) {
		self.init(result: [.success(RequestResponse(
			data: result.data(using: .utf8)!,
			response: HTTPURLResponse())
		)])
	}
	
	convenience init(
		result: [Data]
	) {
		self.init(result: result.map {
			.success(RequestResponse(
				data: $0,
				response: HTTPURLResponse())
			)
		})
	}
	
	convenience init(
		result: [String]
	) {
		self.init(result: result.map {
			.success(RequestResponse(
				data: $0.data(using: .utf8)!,
				response: HTTPURLResponse())
			)
		})
	}
	
	convenience init(
		error: RequestError
	) {
		self.init(result: [.failure(error)])
	}

	func perform(
		_ request: Request
	) async -> Result<RequestResponse, RequestError> {
		let output = result[index]
		index += 1
		return output
	}
}
