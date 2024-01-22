//
//  HuggingfaceModelsMetdata+Extensions.swift
//
//

import Foundation
@testable import Huggingface_Inference

extension HuggingfaceModelsMetdata {
	static func make(
		audioClassification: Metadata = .init(models: [], id: ""),
		audioToAudio: Metadata = .init(models: [], id: ""),
		automaticSpeechRecognition: Metadata = .init(models: [], id: ""),
		conversational: Metadata = .init(models: [], id: ""),
		depthEstimation: Metadata = .init(models: [], id: ""),
		documentQuestionAnswering: Metadata = .init(models: [], id: ""),
		featureExtraction: Metadata = .init(models: [], id: ""),
		fillMask: Metadata = .init(models: [.init(description: "", id: "distilbert-base-uncased")], id: ""),
		imageClassification: Metadata = .init(models: [], id: ""),
		imageSegmentation: Metadata = .init(models: [], id: ""),
		imageToImage: Metadata = .init(models: [], id: ""),
		imageToText: Metadata = .init(models: [], id: ""),
		maskGeneration: Metadata = .init(models: [], id: ""),
		objectDetection: Metadata = .init(models: [], id: ""),
		videoClassification: Metadata = .init(models: [], id: ""),
		questionAnswering: Metadata = .init(models: [], id: ""),
		reinforcementLearning: Metadata = .init(models: [], id: ""),
		sentenceSimilarity: Metadata = .init(models: [], id: ""),
		summarization: Metadata = .init(models: [], id: ""),
		tableQuestionAnswering: Metadata = .init(models: [], id: ""),
		tabularClassification: Metadata = .init(models: [], id: ""),
		tabularRegression: Metadata = .init(models: [], id: ""),
		textClassification: Metadata = .init(models: [], id: ""),
		textGeneration: Metadata = .init(models: [], id: ""),
		textToImage: Metadata = .init(models: [], id: ""),
		textToSpeech: Metadata = .init(models: [], id: ""),
		textToVideo: Metadata = .init(models: [], id: ""),
		tokenClassification: Metadata = .init(models: [], id: ""),
		translation: Metadata = .init(models: [], id: ""),
		unconditionalImageGeneration: Metadata = .init(models: [], id: ""),
		visualQuestionAnswering: Metadata = .init(models: [], id: ""),
		zeroShotClassification: Metadata = .init(models: [], id: ""),
		zeroShotImageClassification: Metadata = .init(models: [], id: ""),
		zeroShotObjectDetection: Metadata = .init(models: [], id: ""),
		textTo3D: Metadata = .init(models: [], id: ""),
		imageTo3D: Metadata = .init(models: [], id: "")
	) -> HuggingfaceModelsMetdata {
		HuggingfaceModelsMetdata(audioClassification: audioClassification, audioToAudio: audioClassification, automaticSpeechRecognition: automaticSpeechRecognition, conversational: conversational, depthEstimation: depthEstimation, documentQuestionAnswering: documentQuestionAnswering, featureExtraction: featureExtraction, fillMask: fillMask, imageClassification: imageClassification, imageSegmentation: imageSegmentation, imageToImage: imageToImage, imageToText: imageToText, maskGeneration: maskGeneration, objectDetection: objectDetection, videoClassification: videoClassification, questionAnswering: questionAnswering, reinforcementLearning: reinforcementLearning, sentenceSimilarity: sentenceSimilarity, summarization: summarization, tableQuestionAnswering: tableQuestionAnswering, tabularClassification: tabularClassification, tabularRegression: tabularRegression, textClassification: textClassification, textGeneration: textGeneration, textToImage: textToImage, textToSpeech: textToSpeech, textToVideo: textToVideo, tokenClassification: textClassification, translation: translation, unconditionalImageGeneration: unconditionalImageGeneration, visualQuestionAnswering: visualQuestionAnswering, zeroShotClassification: zeroShotClassification, zeroShotImageClassification: zeroShotImageClassification, zeroShotObjectDetection: zeroShotObjectDetection, textTo3D: textTo3D, imageTo3D: imageTo3D)
	}
}
