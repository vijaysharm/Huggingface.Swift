//
//  ZeroShotImageClassification.swift
//

import Foundation

struct ZeroShotImageClassificationParameters: Codable {
	let candidateLabels: [String]
}

struct ZeroShotImageClassificationInputs: Codable {
	let inputs: String
	let parameters: ZeroShotImageClassificationParameters
}

public struct ZeroShotImageClassificationOutput: Codable {
	public let label: String
	public let score: Float
}

extension HfInference {
	public func zeroShotImageClassification(
		_ data: Data,
		candidateLabels: [String],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [ZeroShotImageClassificationOutput] {
		return try await execute(
			model: model,
			taskHint: .zeroShotImageClassification,
			body: ZeroShotImageClassificationInputs(
				inputs: data.base64EncodedString(),
				parameters: .init(candidateLabels: candidateLabels)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
