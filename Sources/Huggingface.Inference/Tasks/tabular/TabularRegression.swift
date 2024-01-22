//
//  TabularRegression.swift
//

import Foundation

struct TabularRegressionData: Codable {
	let data: [String: [String]]
}

struct TabularRegressionInputs: Codable {
	let inputs: TabularClassificationData
}

extension HfInference {
	public func tabularRegression(
		data: [String: [String]],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [String] {
		log.w("TODO: This model did not work while testing")
		return try await execute(
			model: model,
			taskHint: .tabularRegression,
			body: TabularClassificationInputs(
				inputs: .init(data: data)
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
