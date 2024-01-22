//
// Translation.swift
//

import Foundation

struct TranslationInputs: Codable {
	let inputs: [String]
}

public struct TranslationOutput: Codable {
	public let translationText: String
}

extension HfInference {
	/**
	 * This task is well known to translate text from one language to another
	 */
	public func translation(
		inputs: [String],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [TranslationOutput] {
		return try await execute(
			model: model,
			taskHint: .translation,
			body: TranslationInputs(inputs: inputs),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
