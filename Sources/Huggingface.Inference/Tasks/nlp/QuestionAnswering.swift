//
//  QuestionAnswering.swift
//

import Foundation

struct QuestionAnsweringInput: Codable {
	let question: String
	let context: String
}

struct QuestionAnsweringInputs: Codable {
	let inputs: QuestionAnsweringInput
}

public struct QuestionAnsweringOutput: Codable {
	let answer: String
	let end: Int
	let score: Float
	let start: Int
}

extension HfInference {
	/**
	 * Want to have a nice know-it-all bot that can answer any question?
	 */
	public func questionAnswering(
		question: String,
		context: String,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> QuestionAnsweringOutput {
		return try await execute(
			model: model,
			taskHint: .questionAnswering,
			body: QuestionAnsweringInputs(
				inputs: .init(question: question, context: context)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
