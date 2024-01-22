//
//  AudioToAudio.swift
//

import Foundation

public struct AudioToAudioOutput: Codable {
	/**
	 * The label for the audio output (model specific)
	 */
	let label: String

	/**
	 * Base64 encoded audio output.
	 */
	let blob: String

	/**
	 * Content-type for blob, e.g. audio/flac
	 */
	let contentType: String
	
	enum CodingKeys : String, CodingKey {
		case label = "label"
		case blob = "blob"
		case contentType = "content-type"
	}
}

extension HfInference {
	public func audioToAudio(
		_ data: Data,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [AudioToAudioOutput] {
		return try await execute(
			model: model,
			taskHint: .audioToAudio,
			body: data,
			requestType: .data,
			responseType: .json,
			options: options
		)
	}
}
