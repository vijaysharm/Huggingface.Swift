//
//  TableQuestionAnswering.swift
//

import Foundation

struct TableQuestionAnsweringInput: Codable {
	let query: String
	let table: [String: [String]]
}

struct TableQuestionAnsweringInputs: Codable {
	let inputs: TableQuestionAnsweringInput
}

public struct TableQuestionAnsweringOutput: Codable {
	/**
	 * The aggregator used to get the answer
	 */
	let aggregator: String
	/**
	 * The plaintext answer
	 */
	let answer: String
	/**
	 * A list of coordinates of the cells contents
	 */
	let cells: [String]
	/**
	 * a list of coordinates of the cells referenced in the answer
	 */
	let coordinates: [[Float]]
}

extension HfInference {
	/**
	 * Don’t know SQL? Don’t want to dive into a large spreadsheet? Ask questions in plain english!
	 *
	 * TODO: microsoft/tapex-base doesn't seem to return an object that matches the output, causing a parsing error
	 */
	public func tableQuestionAnswering(
		query: String,
		table: [String: [String]],
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> TableQuestionAnsweringOutput {
		return try await execute(
			model: model,
			taskHint: .tableQuestionAnswering,
			body: TableQuestionAnsweringInputs(inputs: .init(
				query: query,
				table: table
			)),
			requestType: .json,
			responseType: .json,
			options: options
		)
	}
}
