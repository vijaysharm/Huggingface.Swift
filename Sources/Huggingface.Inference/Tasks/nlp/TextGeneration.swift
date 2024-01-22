//
// TextGeneration.swift
//

import Foundation

struct TextGenerationParameters: Codable {
	let topK: Int?
	let topP: Float?
	let temperature: Float
	let repetitionPenalty: Float?
	let maxNewTokens: Int?
	let maxTime: Float?
	let returnFullText: Bool
	let numReturnSequences: Int
	let doSample: Bool
	let truncate: Int?
	let stopSequences: [String]?
}

struct TextGenerationInputs: Codable {
	let inputs: String
	let parameters: TextGenerationParameters
}

public struct TextGenerationOutput: Codable {
	let generatedText: String
}

extension HfInference {
	/**
	 * Use to continue text from a prompt. This is a very generic task.
	 */
	public func textGeneration(
		inputs: String,
		topK: Int? = nil,
		topP: Float? = nil,
		temperature: Float = 1.0,
		repetitionPenalty: Float? = nil,
		maxNewTokens: Int? = nil,
		maxTime: Float? = nil,
		returnFullText: Bool = true,
		numReturnSequences: Int = 1,
		doSample: Bool = true,
		truncate: Int? = nil,
		stopSequences: [String]? = nil,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [TextGenerationOutput] {
		return try await execute(
			model: model,
			taskHint: .textGeneration,
			body: TextGenerationInputs(
				inputs: inputs,
				parameters: .init(
					topK: topK,
					topP: topP,
					temperature: temperature,
					repetitionPenalty: repetitionPenalty,
					maxNewTokens: maxNewTokens,
					maxTime: maxTime,
					returnFullText: returnFullText,
					numReturnSequences: numReturnSequences,
					doSample: doSample,
					truncate: truncate,
					stopSequences: stopSequences
				)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
	
	public func textGenerationStream(
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [String] {
		fatalError()
//		return try await execute(
//			model: model,
//			taskHint: .translation,
//			body: TranslationInputs(inputs: inputs),
//			type: .json,
//			options: options
//		)
	}
}
