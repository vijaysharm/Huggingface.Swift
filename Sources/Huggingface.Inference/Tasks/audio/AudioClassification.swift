//
//  AudioClassification.swift
//

import Foundation

public struct AudioClassificationOutput: Codable {
	/**
	 * The label for the class (model specific)
	 */
	public let label: String

	/**
	 * A float that represents how likely it is that the audio file belongs to this class.
	 */
	public let score: Float
}

extension HfInference {
	/**
	 * This task reads some audio input and outputs the likelihood of classes.
	 */
	public func audioClassification(
		_ data: Data,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [AudioClassificationOutput] {
		return try await execute(
			model: model,
			taskHint: .audioClassification,
			body: data,
			requestType: .data,
			responseType: .json,
			options: options
		)
	}
}
