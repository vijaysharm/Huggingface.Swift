//
//  ImageClassification.swift
//

import Foundation

public struct ImageClassificationOutput: Codable {
	public let label: String
	public let score: Float
}

extension HfInference {
	/**
	 * This task reads some image input and outputs the likelihood of classes.
	 */
	public func imageClassification(
		_ data: Data,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [ImageClassificationOutput] {
		return try await execute(
			model: model,
			taskHint: .imageClassification,
			body: data,
			requestType: .data,
			responseType: .json,
			options: options
		)
	}
}
