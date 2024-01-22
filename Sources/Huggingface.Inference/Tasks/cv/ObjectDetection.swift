//
//  ObjectDetection.swift
//

import Foundation

public struct ObjectDetectionBoxOutput: Codable {
	public let xmin: Int
	public let xmax: Int
	public let ymin: Int
	public let ymax: Int
}

public struct ObjectDetectionOutput: Codable {
	public let label: String
	public let score: Float
	public let box: ObjectDetectionBoxOutput
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
