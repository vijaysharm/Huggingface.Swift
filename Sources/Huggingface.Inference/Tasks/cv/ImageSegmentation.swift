//
//  ImageSegmentation.swift
//

import Foundation

public struct ImageSegmentationOutput: Codable {
	let label: String
	let mask: String
	let score: Float
}

extension HfInference {
	/**
	 * This task reads some image input and outputs the likelihood of classes & bounding boxes of detected objects.
	 */
	public func imageSegmentation(
		_ data: Data,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [ImageSegmentationOutput] {
		return try await execute(
			model: model,
			taskHint: .imageSegmentation,
			body: data,
			requestType: .data,
			responseType: .json,
			options: options
		)
	}
}
