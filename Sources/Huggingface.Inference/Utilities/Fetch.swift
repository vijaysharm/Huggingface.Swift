//
//  Fetch.swift
//

import Foundation

public protocol FetchProtocol {
	func perform(
		_ request: Request
	) async -> Result<RequestResponse, RequestError>
}

public struct RequestResponse {
	let data: Data
	let response: HTTPURLResponse
}

class Fetch: FetchProtocol {
	private let session: URLSession

	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
	
	func perform(_ request: Request) async -> Result<RequestResponse, RequestError> {
		do {
			let r = try request.createURLRequest()
			let (data, response) = try await session.data(for: r)
			
			guard let response = response as? HTTPURLResponse else {
				return .failure(.invalidServerResponse)
			}
			
			return .success(RequestResponse(
				data: data,
				response: response
			))
		} catch RequestError.invalidURL {
			return .failure(.invalidURL)
		} catch {
			return .failure(.unknownFailure(error: error))
		}
	}
}
