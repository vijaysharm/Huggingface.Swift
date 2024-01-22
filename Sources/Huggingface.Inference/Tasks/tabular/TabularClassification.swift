//
//  TabularClassification.swift
//

import Foundation

struct TabularClassificationData: Codable {
	let data: [String: [String]]
}

struct TabularClassificationInputs: Codable {
	let inputs: TabularClassificationData
}

extension HfInference {
	public func tabularClassification(
		data: [String: [String]],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [String] {
		log.w("TODO: This model did not work while testing")
		return try await execute(
			model: model,
			taskHint: .tabularClassification,
			body: TabularClassificationInputs(
				inputs: .init(data: data)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
