//
//  Summarization.swift
//

import Foundation

struct SummarizationParameters: Codable {
	var minLength: Int? = nil
	var maxLength: Int? = nil
	var topK: Int? = nil
	var topP: Float? = nil
	var temperature: Float = 1.0
	var repetitionPenalty: Float? = nil
	var maxTime: Float? = nil
}

struct SummarizationInput: Codable {
	let inputs: String
	let parameters: SummarizationParameters
}

public struct SummarizationOutput: Codable {
	public let summaryText: String
}

extension HfInference {
	/**
	 * This task is well known to summarize longer text into shorter text.
	 * Be careful, some models have a maximum length of input.
	 * That means that the summary cannot handle full books for instance.
	 * Be careful when choosing your model. If you want to discuss your summarization needs,
	 * please get in touch with us: api-enterprise@huggingface.co
	 */
	public func summarization(
		inputs: String,
		minLength: Int? = nil,
		maxLength: Int? = nil,
		topK: Int? = nil,
		topP: Float? = nil,
		temperature: Float = 1.0,
		repetitionPenalty: Float? = nil,
		maxTime: Float? = nil,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [SummarizationOutput] {
		return try await execute(
			model: model,
			taskHint: .summarization,
			body: SummarizationInput(
				inputs: inputs,
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
