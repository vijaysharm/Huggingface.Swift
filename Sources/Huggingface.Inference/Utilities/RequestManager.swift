//
//  RequestManager.swift
//
//

import Foundation

class RequestManager {
	private let log = Logger.make(tag: RequestManager.self)
	private let fetch: FetchProtocol
	private let parser: DataParserProtocol
	
	init(fetch: FetchProtocol, parser: DataParserProtocol) {
		self.fetch = fetch
		self.parser = parser
	}
	
	func perform<T: Decodable>(
		_ request: Request
	) async -> Result<T, RequestError> {
		let result = await fetch.perform(request)
		
		switch result {
		case .success(let result):
			let data = result.data
			if request.debug {
				log.with(level: .debug) {
					let text = String(data: data, encoding: .utf8)
					$0("request: \(request)\nresponse \(result.response.statusCode):\n\(result.response.allHeaderFields)\n\(text ?? "Can't parse")")
				}
			}
			
			if result.response.statusCode >= 200 && result.response.statusCode < 300 {
				do {
					let decoded: T = try parser.parse(data: data)
					return .success(decoded)
				} catch {
					return .failure(.parseFailure(error: error))
				}
			} else if result.response.statusCode == 503 {
				return .failure(.modelIsCurrentlyLoading)
			} else if result.response.statusCode == 429 {
				return .failure(.rateLimitReached)
			} else {
				return .failure(.requestFailure(response: result.response, data: result.data))
			}
		case .failure(let error):
			return .failure(error)
		}
	}
}
