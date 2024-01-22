//
//  TextToSpeech.swift
//

import Foundation

struct TextToSpeechInputs: Codable {
	let inputs: String
}

extension HfInference {
	public func textToSpeech(
		inputs: String,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> Data {
		return try await execute(
			model: model,
			taskHint: .textToSpeech,
			body: TextToSpeechInputs(
				inputs: inputs
			),
			requestType: .json,
			responseType: .data,
			options: options
		)
	}
}
