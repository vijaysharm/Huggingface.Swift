//
//  HfInference.swift
//
//

import Foundation

public class HfInference {
	private let accessToken: String
	private let fetch: FetchProtocol
	private let metadata: HuggingfaceModelsMetdataManager
	
	let log: LoggerProtocol
	
	public init(
		accessToken: String = "",
		fetch: FetchProtocol,
		logLevel: LogLevel = .info
	) {
		Logger.level = logLevel
		self.log = Logger.make(tag: HfInference.self)
		self.accessToken = accessToken
		self.fetch = fetch
		self.metadata = HuggingfaceModelsMetdataManager(fetch: fetch)
	}
	
	public convenience init(
		accessToken: String = "",
		session: URLSession = URLSession.shared,
		logLevel: LogLevel = .info
	) {
		self.init(
			accessToken: accessToken,
			fetch: Fetch(session: session),
			logLevel: logLevel
		)
	}
	
	// MARK: - Private Methods
	
	func execute<T: Decodable>(
		model: String?,
		taskHint: HuggingfaceModelsMetdata.CodingKeys,
		body: Codable,
		requestType: ModelContentType,
		responseType: ModelContentType,
		options: HfInferenceOptions
	) async throws -> T {
		let modelId = try await metadata.resolve(
			model: model,
			taskHint: taskHint
		)
		
		var bodyAsData: Data
		if let data = body as? Data {
			bodyAsData = data
		} else {
			let encoder = JSONEncoder()
			encoder.keyEncodingStrategy = .convertToSnakeCase
			bodyAsData = try encoder.encode(body)
			
			log.with(level: .debug) {
				if let string = String(data: bodyAsData, encoding: .utf8) {
					$0("body for \(taskHint.stringValue) -> \(string)")
				}
			}
		}
		
		let request = ModelRequest(
			task: taskHint,
			options: .init(
				accessToken: accessToken,
				model: modelId,
				url: url(model: modelId, task: nil),
				body: bodyAsData,
				requestType: requestType,
				responseType: responseType,
				useCache: options.useCache,
				waitForModel: options.waitForModel
			)
		)

		return try await run(request: request, options: options)
	}
	
	private func run<T: Decodable>(
		request: ModelRequest,
		options: HfInferenceOptions
	) async throws -> T {
		let result: Result<T, RequestError> = await request.get(using: fetch)
		switch result {
		case .failure(let error):
			switch error {
			case .modelIsCurrentlyLoading:
				if options.retryOnError && !options.waitForModel {
					return try await run(request: request, options: .init(
						retryOnError: options.retryOnError,
						useCache: options.useCache,
						waitForModel: true
					))
				} else {
					throw error
				}
			default:
				throw error
			}
		case .success(let otuput):
			return otuput
		}
	}
	
	private func url(model: String, task: String?) -> URL {
		if (model.hasPrefix("/") || model.hasPrefix("http:") || model.hasPrefix("https:")), let url = URL(string: model) {
			return url
		}
		
		let baseUrl = "https://api-inference.huggingface.co"
		if let task {
			return URL(string: "\(baseUrl)/pipeline/\(task)/\(model)")!
		}
		
		return URL(string: "\(baseUrl)/models/\(model)")!
	}
}
