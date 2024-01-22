//
//  SentenceSimilarity.swift
//

import Foundation

struct SentenceSimilarityInput: Codable {
	let sourceSentence: String
	let sentences: [String]
}

extension HfInference {
	/**
	 * Calculate the semantic similarity between one text and a list of other sentences by comparing their embeddings.
	 */
	public func sentenceSimilarity(
		sourceSentence: String,
		sentences: [String],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> [Float] {
		return try await execute(
			model: model,
			taskHint: .sentenceSimilarity,
			body: SentenceSimilarityInput(
				sourceSentence: sourceSentence,
				sentences: sentences
			),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
