//
// FeatureExtraction.swift
//

import Foundation

struct FeatureExtractionInputs: Codable {
	let inputs: [String]
}

extension HfInference {
	/**
	 * This task reads some text and outputs raw float values, that are usually consumed as part of a semantic database/semantic search.
	 */
	public func featureExtraction(
		inputs: [String],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [[[[Float]]]] {
		return try await execute(
			model: model,
			taskHint: .featureExtraction,
			body: FeatureExtractionInputs(inputs: inputs),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
