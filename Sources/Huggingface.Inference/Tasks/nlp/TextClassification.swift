//
// TextClassification.swift
//

import Foundation

struct TextClassificationInputs: Codable {
	let inputs: [String]
}

public struct TextClassificationOutput: Codable {
	let label: String
	let score: Float
}

extension HfInference {
	/**
	 * Usually used for sentiment-analysis this will output the likelihood of classes of an input.
	 */
	public func textClassification(
		inputs: [String],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [[TextClassificationOutput]] {
		return try await execute(
			model: model,
			taskHint: .textClassification,
			body: TextClassificationInputs(inputs: inputs),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
