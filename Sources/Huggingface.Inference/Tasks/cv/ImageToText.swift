//
//  ImageToText.swift
//

import Foundation

public struct ImageToTextOutput: Codable {
	public let generatedText: String
}

extension HfInference {
	public func imageToText(
		_ data: Data,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [ImageToTextOutput] {
		return try await execute(
			model: model,
			taskHint: .imageToText,
			body: data,
			requestType: .data,
			responseType: .json,
			options: options
		)
	}
}
