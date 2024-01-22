//
//  AutomaticSpeechRecognition.swift
//

import Foundation

public struct AutomaticSpeechRecognitionOutput: Codable {
	public let text: String
}

extension HfInference {
	/**
	 * This task reads some audio input and outputs the said words within the audio files.
	 */
	public func automaticSpeechRecognition(
		_ data: Data,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> AutomaticSpeechRecognitionOutput {
		return try await execute(
			model: model,
			taskHint: .automaticSpeechRecognition,
			body: data,
			requestType: .data,
			responseType: .json,
			options: options
		)
	}
}
