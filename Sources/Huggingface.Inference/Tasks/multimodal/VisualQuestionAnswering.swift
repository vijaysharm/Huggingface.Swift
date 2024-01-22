//
//  VisualQuestionAnswering.swift
//

import Foundation

struct VisualQuestionAnsweringInputs: Codable {
	let image: String
	let question: String
}

public struct VisualQuestionAnsweringOutput: Codable {
	/**
	 * A string that’s the answer to a visual question.
	 */
	public let answer: String
	/**
	 * Answer correctness score.
	 */
	public let score: Float
}

extension HfInference {
	public func visualQuestionAnswering(
		image: Data,
		question: String,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [VisualQuestionAnsweringOutput] {
		return try await execute(
			model: model,
			taskHint: .visualQuestionAnswering,
			body: VisualQuestionAnsweringInputs(
				image: image.base64EncodedString(),
				question: question
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
