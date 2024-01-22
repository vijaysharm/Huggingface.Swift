//
//  Conversational.swift
//

import Foundation

struct ConversationalInput: Codable {
	let pastUserInputs: [String]?
	let generatedResponses: [String]?
	let text: String
}

struct ConversationalParameters: Codable {
	var minLength: Int? = nil
	var maxLength: Int? = nil
	var topK: Int? = nil
	var topP: Float? = nil
	var temperature: Float = 1.0
	var repetitionPenalty: Float? = nil
	var maxTime: Float? = nil
}

struct ConversationalInputs: Codable {
	let inputs: ConversationalInput
	let parameters: ConversationalParameters
}

public struct ConversationOutput: Codable {
	let pastUserInputs: [String]
	let generatedResponses: [String]
}

public struct ConversationalOutput: Codable {
	let generatedText: String
	let conversation: ConversationOutput
}

extension HfInference {
	/**
	 * This task corresponds to any chatbot like structure. Models tend to have shorter max_length, so please check with caution when using a given model if you need long range dependency or not.
	 */
	public func conversational(
		text: String,
		pastUserInputs: [String]? = nil,
		generatedResponses: [String]? = nil,
		minLength: Int? = nil,
		maxLength: Int? = nil,
		topK: Int? = nil,
		topP: Float? = nil,
		temperature: Float = 1.0,
		repetitionPenalty: Float? = nil,
		maxTime: Float? = nil,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> ConversationalOutput {
		return try await execute(
			model: model,
			taskHint: .conversational,
			body: ConversationalInputs(
				inputs: .init(
					pastUserInputs: pastUserInputs,
					generatedResponses: generatedResponses,
					text: text
				),
				parameters: .init(
					minLength: minLength,
					maxLength: maxLength,
					topK: topK,
					topP: topP,
					temperature: temperature,
					repetitionPenalty: repetitionPenalty,
					maxTime: maxTime
				)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
