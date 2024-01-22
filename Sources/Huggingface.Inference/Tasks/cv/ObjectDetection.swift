//
//  ObjectDetection.swift
//

import Foundation

public struct ObjectDetectionBoxOutput: Codable {
	let xmin: Int
	let xmax: Int
	let ymin: Int
	let ymax: Int
}

public struct ObjectDetectionOutput: Codable {
	let label: String
	let score: Float
	let bod: ObjectDetectionBoxOutput
}

extension HfInference {
	/**
	 * This task reads some image input and outputs the likelihood of classes & bounding boxes of detected objects.
	 */
	public func objectDetection(
		_ data: Data,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [ObjectDetectionOutput] {
		return try await execute(
			model: model,
			taskHint: .objectDetection,
			body: data,
			requestType: .data,
			responseType: .json,
			options: options
		)
	}
}
