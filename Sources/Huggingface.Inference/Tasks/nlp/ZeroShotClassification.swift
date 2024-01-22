//
// ZeroShotClassification.swift
//

import Foundation

struct ZeroShotClassificationParameters: Codable {
	let candidateLabels: [String]
	var multiLabel: Bool? = false
}

struct ZeroShotClassificationInputs: Codable {
	let inputs: [String]
	let parameters: ZeroShotClassificationParameters
}

public struct ZeroShotClassificationOutput: Codable {
	let labels: [String]
	let scores: [Float]
	let sequence: String
}

extension HfInference {
	/**
	 * This task is super useful to try out classification with zero code, you simply pass a sentence/paragraph and the possible labels for that sentence, and you get a result.
	 */
	public func zeroShotClassification(
		inputs: [String],
		candidateLabels: [String],
		multiLabel: Bool = false,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [ZeroShotClassificationOutput] {
		return try await execute(
			model: model,
			taskHint: .zeroShotClassification,
			body: ZeroShotClassificationInputs(
				inputs: inputs,
				parameters: .init(
					candidateLabels: candidateLabels,
					multiLabel: multiLabel
				)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
