//
//  TextToImage.swift
//

import Foundation

struct TextToImageParameters: Codable {
	let negativePrompt: String?
	let height: Float?
	let width: Float?
	let numInferenceSteps: Int?
	let guidanceScale: Float?
}

struct TextToImageInputs: Codable {
	let inputs: String
	let parameters: TextToImageParameters
}

extension HfInference {
	/**
	 * Note that the request normally takes a long time, and
	 * its common to experience timeout. It's a good idea to
	 * set the timeout using the following:
	 *
	 * let sessionConfig = URLSessionConfiguration.default
	 * sessionConfig.timeoutIntervalForRequest = 230.0
	 * sessionConfig.timeoutIntervalForResource = 260.0
	 * let session = URLSession(configuration: sessionConfig)
	 *
	 * Output is image data normally in jpeg format
	 */
	public func textToImage(
		inputs: String,
		negativePrompt: String? = nil,
		width: Float? = nil,
		height: Float? = nil,
		numInferenceSteps: Int? = nil,
		guidanceScale: Float? = nil,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> Data {
		return try await execute(
			model: model,
			taskHint: .textToImage,
			body: TextToImageInputs(
				inputs: inputs,
				parameters: .init(
					negativePrompt: negativePrompt,
					height: height,
					width: width,
					numInferenceSteps: numInferenceSteps,
					guidanceScale: guidanceScale
				)
			),
			requestType: .json,
			responseType: .data,
			options: options
		)
	}
}
