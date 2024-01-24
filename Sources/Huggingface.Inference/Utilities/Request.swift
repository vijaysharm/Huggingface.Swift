//
//  Request.swift
//
//

import Foundation

public enum RequestError: LocalizedError {
	case invalidServerResponse
	case invalidURL
	case requestFailure(response: HTTPURLResponse, data: Data)
	case unknownFailure(error: Error)
	case parseFailure(error: Error)
	case modelIsCurrentlyLoading
	case rateLimitReached
}

public protocol Request {
	var debug: Bool { get }
	func createURLRequest() throws -> URLRequest
}

struct ModelMetadataRequest: Request {
	let debug = false

	func fetch(client: RequestManager) async -> Result<HuggingfaceModelsMetdata, RequestError> {
		await client.perform(self)
	}
	
	func createURLRequest() throws -> URLRequest {
		let url = URL(string: "https://huggingface.co/api/tasks")!
		return URLRequest(url: url)
	}
}

enum ModelContentType {
	case data
	case json
}

struct ModelRequestOptions {
	let accessToken: String?
	let model: String
	let url: URL
	let body: Data
	let requestType: ModelContentType
	let responseType: ModelContentType
	let useCache: Bool
	let waitForModel: Bool
}

struct ModelRequest: Request {
	private let task: HuggingfaceModelsMetdata.CodingKeys
	private let options: ModelRequestOptions

	init(
		task: HuggingfaceModelsMetdata.CodingKeys,
		options: ModelRequestOptions
	) {
		self.task = task
		self.options = options
	}
	
	var debug: Bool {
		get {
			switch task {
			default:
				#if DEBUG
				true
				#else
				false
				#endif
			}
		}
	}
	
	func get<T: Decodable>(using fetch: FetchProtocol) async -> Result<T, RequestError> {
		let client = RequestManager(fetch: fetch, parser: responseParser)
		return await client.perform(self)
	}
	
	private var responseParser: DataParserProtocol {
		get {
			switch options.responseType {
			case .data:
				return NoOpParser()
			case .json:
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let parser = JsonDataParser(decoder: decoder)
				return parser
			}
		}
	}
	
	func createURLRequest() throws -> URLRequest {
		var urlRequest = URLRequest(
			url: options.url,
			cachePolicy: .reloadIgnoringLocalCacheData
		)
		urlRequest.httpMethod = "POST"
		
		if let token = options.accessToken, !token.isEmpty {
			urlRequest.setValue(
				"Bearer \(token)",
				forHTTPHeaderField: "Authorization"
			)
		}
		if options.requestType == .json {
			urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
		}
		urlRequest.setValue(options.useCache ? "true" : "false", forHTTPHeaderField: "X-Use-Cache")
		urlRequest.setValue(options.waitForModel ? "true" : "false", forHTTPHeaderField: "X-Wait-For-Model")
		urlRequest.httpBody = options.body
		
		return urlRequest
	}
}

