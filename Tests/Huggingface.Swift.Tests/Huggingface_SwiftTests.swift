import XCTest
@testable import Huggingface_Inference

final class HuggingfaceTests: XCTestCase {
	private let encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		return encoder
	}()
	private let logLevel: LogLevel = .debug
	
	func testConversational() async throws {
		let expected = ConversationalOutput(
			generatedText: "It's the best movie ever.",
			conversation: .init(
				pastUserInputs: ["Which movie is the best ?", "Can you explain why ?"],
				generatedResponses: ["It is Die Hard for sure.", "It\'s the best movie ever."]
			)
		)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.conversational(
			text: "Can you explain why ?",
			pastUserInputs: ["Which movie is the best ?"],
			generatedResponses: ["It is Die Hard for sure."],
			model: "microsoft/DialoGPT-large"
		)
		XCTAssertEqual("It's the best movie ever.", actual.generatedText)
	}
	
	func testFillMask() async throws {
		let metadata = HuggingfaceModelsMetdata.make(
			fillMask: .init(
				models: [.init(
					description: "",
					id: "distilbert-base-uncased"
				)],
				id: "distilbert-base-uncased"
			)
		)
		let expected = [FillMaskOutput(
			sequence: "The answer to the universe is zero",
			score: 0.9,
			token: 3,
			tokenStr: "zero"
		)]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(metadata),
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.fillMask(
			inputs: ["The answer to the universe is [MASK]."]
		)
		XCTAssertEqual(1, actual.count)
		XCTAssertEqual("The answer to the universe is zero", actual[0].sequence)
	}
	
	func testQuestionAnswering() async throws {
		let metadata = HuggingfaceModelsMetdata.make(
			questionAnswering: .init(
				models: [.init(
					description: "",
					id: "deepset/roberta-base-squad2"
				)],
				id: "deepset/roberta-base-squad2"
			)
		)
		let expected = QuestionAnsweringOutput(
			answer: "Clara",
			end: 16,
			score: 0.9331286,
			start: 11
		)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(metadata),
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.questionAnswering(
			question: "What is my name?",
			context: "My name is Clara and I live in Berkeley."
		)
		XCTAssertEqual("Clara", actual.answer)
	}
	
	func testSentenceSimilarity() async throws {
		let expected: [Float] = [0.7639649, 0.9666221, 0.3147716]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.sentenceSimilarity(
			sourceSentence: "That is a happy person",
			sentences: [
				"That is a happy dog",
				"That is a very happy person",
				"Today is a sunny day"
			],
			model: "sentence-transformers/all-mpnet-base-v2"
		)
		XCTAssertEqual(3, actual.count)
		XCTAssertEqual(0.7639649, actual[0])
	}
	
	func testSummarization() async throws {
		let expected: [SummarizationOutput] = [SummarizationOutput(
			summaryText: "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building. Its base is square, measuring 125 metres (410 ft) on each side. During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world."
		)]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.summarization(
			inputs: "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris. Its base is square, measuring 125 metres (410 ft) on each side. During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, a title it held for 41 years until the Chrysler Building in New York City was finished in 1930. It was the first structure to reach a height of 300 metres. Due to the addition of a broadcasting aerial at the top of the tower in 1957, it is now taller than the Chrysler Building by 5.2 metres (17 ft). Excluding transmitters, the Eiffel Tower is the second tallest free-standing structure in France after the Millau Viaduct.",
			model: "sentence-transformers/all-mpnet-base-v2"
		)
		XCTAssertEqual(1, actual.count)
		XCTAssertEqual(expected.first!.summaryText, actual[0].summaryText)
	}
	
	func testTableQuestionAnswering() async throws {
		let expected = TableQuestionAnsweringOutput(
			aggregator: "AVERAGE",
			answer: "AVERAGE > 36542",
			cells: ["36542"],
			coordinates: [[0, 1]]
		)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.tableQuestionAnswering(
			query: "How many stars does the transformers repository have?",
			table: [
				"Repository": ["Transformers","Datasets","Tokenizers"],
				"Stars": ["36542","4512","3934"],
				"Contributors": ["651","77","34"],
				"Programming language": ["Python","Python","Rust, Python and NodeJS"]
			],
			model: "google/tapas-base-finetuned-wtq"
		)
		XCTAssertEqual(expected.answer, actual.answer)
	}
	
	func testTextClassification() async throws {
		let expected = [[
			TextClassificationOutput(label: "POSITIVE", score: 0.9998738765716553),
			TextClassificationOutput(label: "NEGATIVE", score: 0.00012611268903128803)
		]]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.textClassification(
			inputs: ["I like you. I love you"],
			model: "distilbert-base-uncased-finetuned-sst-2-english"
		)
		
		XCTAssertEqual(expected[0][0].label, actual[0][0].label)
		XCTAssertEqual(expected[0][1].label, actual[0][1].label)
	}
	
	func testTranslation() async throws {
		let expected = [TranslationOutput(
			translationText: "My name is Wolfgang and I live in Berlin."
		)]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.translation(
			inputs: ["Меня зовут Вольфганг и я живу в Берлине"],
			model: "Helsinki-NLP/opus-mt-ru-en"
		)
		
		XCTAssertEqual(expected[0].translationText, actual[0].translationText)
	}
	
	func testZeroShotClassification() async throws {
		let expected = [ZeroShotClassificationOutput(
			labels: ["refund","faq","legal"],
			scores: [0.8772604465484619,0.10223047435283661,0.020509060472249985],
			sequence: "Hi, I recently bought a device from your company but it is not working as advertised and I would like to get reimbursed"
		)]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.zeroShotClassification(
			inputs: ["Hi, I recently bought a device from your company but it is not working as advertised and I would like to get reimbursed"],
			candidateLabels: ["refund", "legal", "faq"],
			model: "Helsinki-NLP/opus-mt-ru-en"
		)
		
		XCTAssertEqual(expected[0].sequence, actual[0].sequence)
	}
	
	func testTokenClassification() async throws {
		let expected = [[TokenClassificationOutput(
			entityGroup: "PER",
			score: 0.9971321,
			word: "Sarah Jessica Parker",
			start: 11,
			end: 31
		)]]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.tokenClassification(
			inputs: ["My name is Sarah Jessica Parker but you can call me Jessica"],
			model: "dslim/bert-base-NER"
		)
		
		XCTAssertEqual(expected[0][0].entityGroup, actual[0][0].entityGroup)
		XCTAssertEqual(expected[0][0].word, actual[0][0].word)
	}
	
	func testTextGeneration() async throws {
		let expected = [TextGenerationOutput(
			generatedText: "The answer to the universe is simply not found in any one form or other! For more info in"
		)]
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.textGeneration(
			inputs: "The answer to the universe is",
			model: "bigscience/bloom-560m"
		)
		
		XCTAssertEqual(expected[0].generatedText, actual[0].generatedText)
	}
	
	func testTextToImage() async throws {
//		let sessionConfig = URLSessionConfiguration.default
//		sessionConfig.timeoutIntervalForRequest = 230.0
//		sessionConfig.timeoutIntervalForResource = 260.0
//		let session = URLSession(configuration: sessionConfig)
//		
//		let hf = HfInference(
//			session: session,
//			logLevel: logLevel
//		)
//		let actual = try await hf.textToImage(
//			inputs: "1boy, male focus, green hair, sweater, looking at viewer, upper body, beanie, outdoors, night, turtleneck, masterpiece, best quality",
//			negativePrompt: "blurry",
//			model: "cagliostrolab/animagine-xl-3.0"
//		)
//		try actual.write(to: URL(filePath: "/tmp/output_image.jpg"))
//		print(actual)
		let expected = Data([0xFF, 0xAA] as [UInt8])
		let hf = HfInference(
			fetch: TestFetch(result: [
				expected,
			]),
			logLevel: logLevel
		)
		let actual = try await hf.textToImage(
			inputs: "1boy, male focus, green hair, sweater, looking at viewer, upper body, beanie, outdoors, night, turtleneck, masterpiece, best quality",
			negativePrompt: "blurry",
			model: "cagliostrolab/animagine-xl-3.0"
		)
		
		XCTAssertEqual(expected, actual)
	}
	
	func testImageClassification() async throws {
		let expected = [
			ImageClassificationOutput(label: "Indian elephant, Elephas maximus", score: 0.6747689843177795),
			ImageClassificationOutput(label: "African elephant, Loxodonta africana", score: 0.2764124870300293),
			ImageClassificationOutput(label: "tusker", score: 0.03826090693473816),
			ImageClassificationOutput(label: "hippopotamus, hippo, river horse, Hippopotamus amphibius", score: 0.0018638580804690719),
			ImageClassificationOutput(label: "ice bear, polar bear, Ursus Maritimus, Thalarctos maritimus", score: 0.0006085152854211628)
		]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "elephants", withExtension: "png")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.imageClassification(
			data,
			model: "google/vit-base-patch16-224"
		)
		XCTAssertEqual(expected.count, actual.count)
		XCTAssertEqual(expected[0].label, actual[0].label)
		XCTAssertEqual(expected[1].label, actual[1].label)
		XCTAssertEqual(expected[2].label, actual[2].label)
		XCTAssertEqual(expected[3].label, actual[3].label)
		XCTAssertEqual(expected[4].label, actual[4].label)
	}
	
	func testImageToText() async throws {
		let expected = [
			ImageToTextOutput(generatedText: "a large elephant standing next to a pond ")
		]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "elephants", withExtension: "png")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.imageToText(
			data,
			model: "nlpconnect/vit-gpt2-image-captioning"
		)
		XCTAssertEqual(expected.count, actual.count)
		XCTAssertEqual(expected[0].generatedText, actual[0].generatedText)
	}
	
	func testImageSegmentation() async throws {
		let expected = [
			ImageSegmentationOutput(label: "wall", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "sky", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "tree", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "person", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "earth", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "plant", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "water", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "rock", mask: "BASE64ENCODED_MASK", score: 1.0),
			ImageSegmentationOutput(label: "animal", mask: "BASE64ENCODED_MASK", score: 1.0),
		]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "elephants", withExtension: "png")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.imageSegmentation(
			data,
			model: "openmmlab/upernet-convnext-small"
		)
		XCTAssertEqual(expected.count, actual.count)
		XCTAssertEqual(expected[0].label, actual[0].label)
		XCTAssertEqual(expected[1].label, actual[1].label)
		XCTAssertEqual(expected[2].label, actual[2].label)
		XCTAssertEqual(expected[3].label, actual[3].label)
		XCTAssertEqual(expected[4].label, actual[4].label)
		XCTAssertEqual(expected[5].label, actual[5].label)
		XCTAssertEqual(expected[6].label, actual[6].label)
		XCTAssertEqual(expected[7].label, actual[7].label)
		XCTAssertEqual(expected[8].label, actual[8].label)
	}
	
	func testObjectDetection() async throws {
		let expected = [
			ObjectDetectionOutput(label: "elephant", score: 0.998604953289032, bod: .init(xmin: 287, xmax: 421, ymin: 243, ymax: 363)),
			ObjectDetectionOutput(label: "elephant", score: 0.9994575381278992, bod: .init(xmin: 395, xmax: 555, ymin: 227, ymax: 363)),
		]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "elephants", withExtension: "png")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.objectDetection(
			data,
			model: "facebook/detr-resnet-50"
		)
		XCTAssertEqual(expected.count, actual.count)
		XCTAssertEqual(expected[0].label, actual[0].label)
		XCTAssertEqual(expected[1].label, actual[1].label)
	}
	
	func testImageToImage() async throws {
//		let data = try Data(contentsOf: Bundle.module.url(forResource: "elephants", withExtension: "png")!)
//		let sessionConfig = URLSessionConfiguration.default
//		sessionConfig.timeoutIntervalForRequest = 230.0
//		sessionConfig.timeoutIntervalForResource = 260.0
//		let session = URLSession(configuration: sessionConfig)
//		
//		let hf = HfInference(
//			session: session,
//			logLevel: logLevel
//		)
//		let actual = try await hf.imageToImage(
//			data,
//			model: "lambdalabs/sd-image-variations-diffusers"
//		)
//		let filename = UUID().uuidString
//		try actual.write(to: URL(filePath: "/tmp/\(filename).jpg"))
		let expected = Data([0xFF, 0xAA] as [UInt8])
		let data = Data([0xFE, 0xBA] as [UInt8])
		let hf = HfInference(
			fetch: TestFetch(result: [
				expected,
			]),
			logLevel: logLevel
		)
		let actual = try await hf.imageToImage(
			data,
			model: "lambdalabs/sd-image-variations-diffusers"
		)
		
		XCTAssertEqual(expected, actual)
	}
	
	func testZeroShotImageClassification() async throws {
		let expected = [
			ZeroShotImageClassificationOutput(label: "elephant", score: 0.9938836097717285),
			ZeroShotImageClassificationOutput(label: "dinosaur", score: 0.006074416451156139),
			ZeroShotImageClassificationOutput(label: "dog", score: 4.2110172216780484e-05),
		]
		
		let data = Data([0xFE, 0xBA] as [UInt8])
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.zeroShotImageClassification(
			data,
			candidateLabels: ["elephant", "dog", "dinosaur"],
			model: "openai/clip-vit-base-patch16"
		)
		XCTAssertEqual(expected.count, actual.count)
		XCTAssertEqual(expected[0].label, actual[0].label)
		XCTAssertEqual(expected[1].label, actual[1].label)
		XCTAssertEqual(expected[2].label, actual[2].label)
	}
		
	func xtestTabularData() async throws {
		let sessionConfig = URLSessionConfiguration.default
		sessionConfig.timeoutIntervalForRequest = 230.0
		sessionConfig.timeoutIntervalForResource = 260.0
		let session = URLSession(configuration: sessionConfig)
		
		let hf = HfInference(
			session: session,
			logLevel: logLevel
		)
//		let actual = try await hf.tabularClassification(
//			data: [
//				"fixed_acidity": ["7.4", "7.8", "10.3"],
//				"volatile_acidity": ["0.7", "0.88", "0.32"],
//				"citric_acid": ["0", "0", "0.45"],
//				"residual_sugar": ["1.9", "2.6", "6.4"],
//				"chlorides": ["0.076", "0.098", "0.073"],
//				"free_sulfur_dioxide": ["11", "25", "5"],
//				"total_sulfur_dioxide": ["34", "67", "13"],
//				"density": ["0.9978", "0.9968", "0.9976"],
//				"pH": ["3.51", "3.2", "3.23"],
//				"sulphates": ["0.56", "0.68", "0.82"],
//				"alcohol": ["9.4", "9.8", "12.6"]
//			],
//			model: "julien-c/wine-quality",
//			options: .init(waitForModel: true)
//		)
		
		let actual = try await hf.tabularRegression(
			data: [
				"Height": ["11.52", "12.48", "12.3778"],
				"Length1": ["23.2", "24", "23.9"],
				"Length2": ["25.4", "26.3", "26.5"],
				"Length3": ["30", "31.2", "31.1"],
				"Species": ["Bream", "Bream", "Bream"],
				"Width": ["4.02", "4.3056", "4.6961"]
			]
		)
		print(actual)
	}
	
	func testAudioClassification() async throws {
		let expected = [
			AudioClassificationOutput(label: "unknown", score: 0.9970651268959045),
			AudioClassificationOutput(label: "down", score: 0.0013692846987396479),
			AudioClassificationOutput(label: "stop", score: 0.0006748316227458417),
			AudioClassificationOutput(label: "left", score: 0.00027229153783991933),
			AudioClassificationOutput(label: "off", score: 0.00025018496671691537),
		]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "sample1", withExtension: "flac")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.audioClassification(
			data,
			model: "speechbrain/google_speech_command_xvector"
		)
		XCTAssertEqual(expected.count, actual.count)
		XCTAssertEqual(expected[0].label, actual[0].label)
		XCTAssertEqual(expected[1].label, actual[1].label)
		XCTAssertEqual(expected[2].label, actual[2].label)
		XCTAssertEqual(expected[3].label, actual[3].label)
		XCTAssertEqual(expected[4].label, actual[4].label)
	}
	
	func testAutomaticSpeechRecognition() async throws {
		let expected = AutomaticSpeechRecognitionOutput(text: "GOING ALONG SLUSHY COUNTRY ROADS AND SPEAKING TO DAMP AUDIENCES IN DRAUGHTY SCHOOLROOMS DAY AFTER DAY FOR A FORTNIGHT HE'LL HAVE TO PUT IN AN APPEARANCE AT SOME PLACE OF WORSHIP ON SUNDAY MORNING AND HE CAN COME TO US IMMEDIATELY AFTERWARDS")
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "sample1", withExtension: "flac")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.automaticSpeechRecognition(
			data,
			model: "facebook/wav2vec2-large-960h-lv60-self"
		)
		XCTAssertEqual(expected.text, actual.text)
	}
	
	func testTextToSpeech() async throws {
//		let sessionConfig = URLSessionConfiguration.default
//		sessionConfig.timeoutIntervalForRequest = 230.0
//		sessionConfig.timeoutIntervalForResource = 260.0
//		let session = URLSession(configuration: sessionConfig)
//
//		let hf = HfInference(
//			session: session,
//			logLevel: logLevel
//		)
//		let actual = try await hf.textToSpeech(
//			inputs: "Hello World!",
//			model: "facebook/fastspeech2-en-ljspeech"
//		)
//		let filename = UUID().uuidString
//		try actual.write(to: URL(filePath: "/tmp/\(filename)"))
		let expected = Data([0xFF, 0xAA] as [UInt8])
		let hf = HfInference(
			fetch: TestFetch(result: [
				expected,
			]),
			logLevel: logLevel
		)
		let actual = try await hf.textToSpeech(
			inputs: "Hello World!",
			model: "facebook/fastspeech2-en-ljspeech"
		)
		
		XCTAssertEqual(expected, actual)
	}
	
	func testAudioToAudio() async throws {
		let expected = [AudioToAudioOutput(
			label: "label_0",
			blob: "BASE64ENCODED_AUDIO",
			contentType: "audio/flac"
		)]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "sample1", withExtension: "flac")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.audioToAudio(
			data,
			model: "speechbrain/sepformer-wham"
		)
		XCTAssertEqual(expected[0].label, actual[0].label)
	}

	func testVisualQuestionAnswering() async throws {
		let expected = [
			VisualQuestionAnsweringOutput(answer: "2", score: 0.8440957069396973),
			VisualQuestionAnsweringOutput(answer: "3", score: 0.331712931394577),
			VisualQuestionAnsweringOutput(answer: "1", score: 0.05015309900045395),
			VisualQuestionAnsweringOutput(answer: "4", score: 0.03215616196393967),
			VisualQuestionAnsweringOutput(answer: "0", score: 0.006209534592926502),
		]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "elephants", withExtension: "png")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.visualQuestionAnswering(
			image: data,
			question: "How many animals are in this image?",
			model: "dandelin/vilt-b32-finetuned-vqa"
		)
		XCTAssertEqual(expected[0].answer, actual[0].answer)
		XCTAssertEqual(expected[1].answer, actual[1].answer)
		XCTAssertEqual(expected[2].answer, actual[2].answer)
		XCTAssertEqual(expected[3].answer, actual[3].answer)
		XCTAssertEqual(expected[4].answer, actual[4].answer)
	}
	
	func testDocumentQuestionAnswering() async throws {
		let expected = [
			DocumentQuestionAnsweringOutput(answer: "$154.06", start: 75, end: 75, score: 0.5467308163642883),
		]
		
		let data = try Data(contentsOf: Bundle.module.url(forResource: "invoice", withExtension: "png")!)
		let hf = HfInference(
			fetch: TestFetch(result: [
				try! encoder.encode(expected),
			]),
			logLevel: logLevel
		)
		let actual = try await hf.documentQuestionAnswering(
			image: data,
			question: "What is the invoice total amount?",
			model: "impira/layoutlm-document-qa"
		)
		XCTAssertEqual(expected[0].answer, actual[0].answer)
	}
}
