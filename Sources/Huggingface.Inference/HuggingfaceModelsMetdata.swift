//
//  Types.swift
//

import Foundation

struct HuggingfaceModelsMetdata: Codable {
	let audioClassification: Metadata
	let audioToAudio: Metadata
	let automaticSpeechRecognition: Metadata
	let conversational: Metadata
	let depthEstimation: Metadata
	let documentQuestionAnswering: Metadata
	let featureExtraction: Metadata
	let fillMask: Metadata
	let imageClassification: Metadata
	let imageSegmentation: Metadata
	let imageToImage, imageToText, maskGeneration, objectDetection: Metadata
	let videoClassification, questionAnswering, reinforcementLearning, sentenceSimilarity: Metadata
	let summarization, tableQuestionAnswering, tabularClassification, tabularRegression: Metadata
	let textClassification, textGeneration, textToImage, textToSpeech: Metadata
	let textToVideo, tokenClassification, translation, unconditionalImageGeneration: Metadata
	let visualQuestionAnswering, zeroShotClassification, zeroShotImageClassification, zeroShotObjectDetection: Metadata
	let textTo3D, imageTo3D: Metadata

	enum CodingKeys: String, CodingKey {
		case audioClassification = "audio-classification"
		case audioToAudio = "audio-to-audio"
		case automaticSpeechRecognition = "automatic-speech-recognition"
		case conversational
		case depthEstimation = "depth-estimation"
		case documentQuestionAnswering = "document-question-answering"
		case featureExtraction = "feature-extraction"
		case fillMask = "fill-mask"
		case imageClassification = "image-classification"
		case imageSegmentation = "image-segmentation"
		case imageToImage = "image-to-image"
		case imageToText = "image-to-text"
		case maskGeneration = "mask-generation"
		case objectDetection = "object-detection"
		case videoClassification = "video-classification"
		case questionAnswering = "question-answering"
		case reinforcementLearning = "reinforcement-learning"
		case sentenceSimilarity = "sentence-similarity"
		case summarization
		case tableQuestionAnswering = "table-question-answering"
		case tabularClassification = "tabular-classification"
		case tabularRegression = "tabular-regression"
		case textClassification = "text-classification"
		case textGeneration = "text-generation"
		case textToImage = "text-to-image"
		case textToSpeech = "text-to-speech"
		case textToVideo = "text-to-video"
		case tokenClassification = "token-classification"
		case translation
		case unconditionalImageGeneration = "unconditional-image-generation"
		case visualQuestionAnswering = "visual-question-answering"
		case zeroShotClassification = "zero-shot-classification"
		case zeroShotImageClassification = "zero-shot-image-classification"
		case zeroShotObjectDetection = "zero-shot-object-detection"
		case textTo3D = "text-to-3d"
		case imageTo3D = "image-to-3d"
	}
}

// MARK: - Dataset
struct Model: Codable {
	let description, id: String
}

struct Metadata: Codable {
	// datasets
	// demo
	// metrics
	let models: [Model]
	// spaces
	// summary
	// widgetModels
	// youtubeId
	let id: String
	// label
	// libraries
}

class HuggingfaceModelsMetdataManager {
	private var metadata: HuggingfaceModelsMetdata? = nil
	private let fetch: FetchProtocol
	
	init(fetch: FetchProtocol) {
		self.fetch = fetch
	}
	
	func resolve(
		model: String?,
		taskHint: HuggingfaceModelsMetdata.CodingKeys
	) async throws -> String {
		if let model = model {
			return model
		}

		if metadata == nil {
			metadata = try await fetchMetadata(using: fetch)
		}
		
		let models = try self.model(type: taskHint)
		return models.first!.id
	}
	
	private func model(type: HuggingfaceModelsMetdata.CodingKeys) throws -> [Model] {
		guard let metadata = metadata else {
			fatalError("The models metadata should be loaded")
		}
		
		switch type {
		case .audioClassification:
			return metadata.audioClassification.models
		case .audioToAudio:
			return metadata.audioToAudio.models
		case .automaticSpeechRecognition:
			return metadata.automaticSpeechRecognition.models
		case .conversational:
			return metadata.conversational.models
		case .depthEstimation:
			return metadata.depthEstimation.models
		case .documentQuestionAnswering:
			return metadata.documentQuestionAnswering.models
		case .featureExtraction:
			return metadata.featureExtraction.models
		case .fillMask:
			return metadata.fillMask.models
		case .imageClassification:
			return metadata.imageClassification.models
		case .imageSegmentation:
			return metadata.imageSegmentation.models
		case .imageToImage:
			return metadata.imageToImage.models
		case .imageToText:
			return metadata.imageToText.models
		case .maskGeneration:
			return metadata.maskGeneration.models
		case .objectDetection:
			return metadata.objectDetection.models
		case .videoClassification:
			return metadata.videoClassification.models
		case .questionAnswering:
			return metadata.questionAnswering.models
		case .reinforcementLearning:
			return metadata.reinforcementLearning.models
		case .sentenceSimilarity:
			return metadata.sentenceSimilarity.models
		case .summarization:
			return metadata.summarization.models
		case .tableQuestionAnswering:
			return metadata.tableQuestionAnswering.models
		case .tabularClassification:
			return metadata.tabularClassification.models
		case .tabularRegression:
			return metadata.tabularRegression.models
		case .textClassification:
			return metadata.textClassification.models
		case .textGeneration:
			return metadata.textGeneration.models
		case .textToImage:
			return metadata.textToImage.models
		case .textToSpeech:
			return metadata.textToSpeech.models
		case .textToVideo:
			return metadata.textToVideo.models
		case .tokenClassification:
			return metadata.tokenClassification.models
		case .translation:
			return metadata.translation.models
		case .unconditionalImageGeneration:
			return metadata.unconditionalImageGeneration.models
		case .visualQuestionAnswering:
			return metadata.visualQuestionAnswering.models
		case .zeroShotClassification:
			return metadata.zeroShotClassification.models
		case .zeroShotImageClassification:
			return metadata.zeroShotImageClassification.models
		case .zeroShotObjectDetection:
			return metadata.zeroShotObjectDetection.models
		case .textTo3D:
			return metadata.textTo3D.models
		case .imageTo3D:
			return metadata.imageTo3D.models
		}
	}
	
	private func fetchMetadata(using fetch: FetchProtocol) async throws -> HuggingfaceModelsMetdata {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let parser = JsonDataParser(decoder: decoder)
		
		let client = RequestManager(fetch: fetch, parser: parser)
		let metadata = ModelMetadataRequest()
		let result = await metadata.fetch(client: client)
		switch result {
		case .failure(let error):
			throw error
		case .success(let model):
			return model
		}
	}
}
