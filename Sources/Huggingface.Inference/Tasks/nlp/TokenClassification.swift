//
// TokenClassification.swift
//

import Foundation

public enum TokenClassificationAggregationStrategy: String, Codable {
	case none
	case simple
	case first
	case average
	case max
}

struct TokenClassificationParameters: Codable {
	let aggregationStrategy: TokenClassificationAggregationStrategy
}

struct TokenClassificationInputs: Codable {
	let inputs: [String]
	let parameters: TokenClassificationParameters
}

public struct TokenClassificationOutput: Codable {
	let entityGroup: String
	let score: Float
	let word: String
	let start: Int
	let end: Int
}

extension HfInference {
	/**
	 * Usually used for sentence parsing, either grammatical, or Named Entity Recognition (NER) to understand keywords contained within text.
	 */
	public func tokenClassification(
		inputs: [String],
		aggregationStrategy: TokenClassificationAggregationStrategy = .simple,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [[TokenClassificationOutput]] {
		return try await execute(
			model: model,
			taskHint: .tokenClassification,
			body: TokenClassificationInputs(
				inputs: inputs,
				parameters: .init(
					aggregationStrategy: aggregationStrategy
				)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
