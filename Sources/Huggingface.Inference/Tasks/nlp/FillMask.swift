//
//  FillMask.swift
//

import Foundation

struct FillMaskInput: Codable {
	let inputs: [String]
}

public struct FillMaskOutput: Codable {
	let sequence: String
	let score: Float
	let token: Int
	let tokenStr: String
}

extension HfInference {
	/**
	 * Tries to fill in a hole with a missing word (token to be precise).
	 * That’s the base task for BERT models.
	 */
	public func fillMask(
		inputs: [String],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [FillMaskOutput] {
		return try await execute(
			model: model,
			taskHint: .fillMask,
			body: FillMaskInput(inputs: inputs),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
