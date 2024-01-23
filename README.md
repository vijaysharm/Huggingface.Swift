# 🤗 Hugging Face Inference API

A Swift powered wrapper for the Hugging Face Inference API. Learn more about the Inference API at [Hugging Face](https://huggingface.co/docs/api-inference/index). 

## Getting Started

### Install

#### Swift Package Manager (SPM)

```console
 * File > Swift Packages > Add Package Dependency
 * Add https://github.com/vijaysharm/Huggingface.Swift.git
```

### Initialize

```swift
import Huggingface_Inference

let hf = HfInference(accessToken: "your access token")
```

❗**Important note:** Using an access token is optional to get started, however you will be rate limited eventually. Join [Hugging Face](https://huggingface.co/join) and then visit [access tokens](https://huggingface.co/settings/tokens) to generate your access token for **free**.

Your access token should be kept private.

## Natural Language Processing

### Fill Mask

Tries to fill in a hole with a missing word (token to be precise).

```swift
try await hf.fillMask(
  inputs: "[MASK] world!",
  model: "bert-base-uncased"
)
```

### Summarization

Summarizes longer text into shorter text. Be careful, some models have a maximum length of input.

```swift
try await hf.summarization(
  inputs: "The tower is 324 metres (1,063 ft) tall, about the same height as an 81-storey building, and the tallest structure in Paris. Its base is square, measuring 125 metres (410 ft) on each side. During its construction, the Eiffel Tower surpassed the Washington Monument to become the tallest man-made structure in the world, a title it held for 41 years until the Chrysler Building in New York City was finished in 1930.",
  maxLength: 100,
  model: "facebook/bart-large-cnn"
)
```

### Question Answering

Answers questions based on the context you provide.

```swift
try await hf.questionAnswering(
  question: "What is the capital of France?",
  context: "The capital of France is Paris.",
  model: "deepset/roberta-base-squad2"
)
```

### Table Question Answering

```swift
try await hf.tableQuestionAnswering(
  query: "How many stars does the transformers repository have?",
  table: [
    Repository: ["Transformers", "Datasets", "Tokenizers"],
    Stars: ["36542", "4512", "3934"],
    Contributors: ["651", "77", "34"],
    "Programming language": ["Python", "Python", "Rust, Python and NodeJS"]
  ],
  model: "google/tapas-base-finetuned-wtq",
)
```

### Text Classification

Often used for sentiment analysis, this method will assign labels to the given text along with a probability score of that label.

```swift
try await hf.textClassification(
  inputs: ["I like you. I love you."],
  model: "distilbert-base-uncased-finetuned-sst-2-english"
)
```

### Text Generation

Generates text from an input prompt.

[Demo](https://huggingface.co/spaces/huggingfacejs/streaming-text-generation)

```swift
try await hf.textGeneration(
  inputs: "The answer to the universe is",
  model: "gpt2"
)
```

### Token Classification

Used for sentence parsing, either grammatical, or Named Entity Recognition (NER) to understand keywords contained within text.

```swift
try await hf.tokenClassification(
  inputs: ["My name is Sarah Jessica Parker but you can call me Jessica"],
  model: "dbmdz/bert-large-cased-finetuned-conll03-english"
)
```

### Translation

Converts text from one language to another.

```swift
try await hf.translation(
  inputs: ["My name is Wolfgang and I live in Berlin"]
  model: "t5-base"
)
```

### Zero-Shot Classification

Checks how well an input text fits into a set of labels you provide.

```swift
try await hf.zeroShotClassification(
  inputs: [
    "Hi, I recently bought a device from your company but it is not working as advertised and I would like to get reimbursed!"
  ],
  candidateLabels: ["refund", "legal", "faq"],
  model: "facebook/bart-large-mnli"
)
```

### Conversational

This task corresponds to any chatbot-like structure. Models tend to have shorter max_length, so please check with caution when using a given model if you need long-range dependency or not.

```swift
try await hf.conversational(
  text: "Can you explain why ?",
  pastUserInputs: ["Which movie is the best ?"],
  generatedResponses: ["It is Die Hard for sure."],
  model: "microsoft/DialoGPT-large"
)
```

### Sentence Similarity

Calculate the semantic similarity between one text and a list of other sentences.

```swift
try await hf.sentenceSimilarity(
  sourceSentence: "That is a happy person",
  sentences: [
    "That is a happy dog",
    "That is a very happy person",
    "Today is a sunny day"
  ],
  model: "sentence-transformers/paraphrase-xlm-r-multilingual-v1",
)
```

## Audio

### Automatic Speech Recognition

Transcribes speech from an audio file.

[Demo](https://huggingface.co/spaces/huggingfacejs/speech-recognition-vue)

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "audio", withExtension: "flac")!)
try await hf.automaticSpeechRecognition(
  data,
  model: "facebook/wav2vec2-large-960h-lv60-self"
)
```

### Audio Classification

Assigns labels to the given audio along with a probability score of that label.

[Demo](https://huggingface.co/spaces/huggingfacejs/audio-classification-vue)

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "audio", withExtension: "flac")!
try await hf.audioClassification(
  data,
  model: "superb/hubert-large-superb-er"  
)
```

### Text To Speech

Generates natural-sounding speech from text input.

[Interactive tutorial](https://scrimba.com/scrim/co8da4d23b49b648f77f4848a?pl=pkVnrP7uP)

```swift
try await hf.textToSpeech(
  inputs: "Hello world!",
  model: "espnet/kan-bayashi_ljspeech_vits"
)
```

### Audio To Audio

Outputs one or multiple generated audios from an input audio, commonly used for speech enhancement and source separation.

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "audio", withExtension: "flac")!)
try await hf.audioToAudio(
  data,
  model: "speechbrain/sepformer-wham"
)
```

## Computer Vision

### Image Classification

Assigns labels to a given image along with a probability score of that label.

[Demo](https://huggingface.co/spaces/huggingfacejs/image-classification-vue)

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "image", withExtension: "png")!)
try await hf.imageClassification(
  data,
  model: "google/vit-base-patch16-224"
)
```

### Object Detection

Detects objects within an image and returns labels with corresponding bounding boxes and probability scores.

[Demo](https://huggingface.co/spaces/huggingfacejs/object-detection-vue)

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "image", withExtension: "png")!)
try await hf.objectDetection(
  data,
  model: "facebook/detr-resnet-50"
)
```

### Image Segmentation

Detects segments within an image and returns labels with corresponding bounding boxes and probability scores.

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "image", withExtension: "png")!)
try await hf.imageSegmentation(
  data,
  model: "facebook/detr-resnet-50-panoptic"
)
```

### Image To Text

Outputs text from a given image, commonly used for captioning or optical character recognition.

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "image", withExtension: "png")!)
try await hf.imageToText(
  data,
  model: "nlpconnect/vit-gpt2-image-captioning"
)
```

### Text To Image

Creates an image from a text prompt.

[Demo](https://huggingface.co/spaces/huggingfacejs/image-to-text)

```swift
try await hf.textToImage(
  inputs: "award winning high resolution photo of a giant tortoise/((ladybird)) hybrid, [trending on artstation]",
  negativePrompt: "blurry",
  model: "stabilityai/stable-diffusion-2"
)
```

### Image To Image

Image-to-image is the task of transforming a source image to match the characteristics of a target image or a target image domain.

[Interactive tutorial](https://scrimba.com/scrim/co4834bf9a91cc81cfab07969?pl=pkVnrP7uP)

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "image", withExtension: "png")!)
try await hf.imageToImage(
  data,
  prompt: "elmo's lecture",
  model: "lllyasviel/sd-controlnet-depth",
)
```

### Zero Shot Image Classification

Checks how well an input image fits into a set of labels you provide.

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "image", withExtension: "png")!)
try await hf.zeroShotImageClassification(
  data,  
  candidateLabels: ["cat", "dog"],
  model: "openai/clip-vit-large-patch14-336"
)
```

## Multimodal

### Feature Extraction

This task reads some text and outputs raw float values, that are usually consumed as part of a semantic database/semantic search.

```swift
try await hf.featureExtraction(
  inputs: ["That is a happy person"],
  model: "sentence-transformers/distilbert-base-nli-mean-tokens"
)
```

### Visual Question Answering

Visual Question Answering is the task of answering open-ended questions based on an image. They output natural language responses to natural language questions.

[Demo](https://huggingface.co/spaces/huggingfacejs/doc-vis-qa)

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "elephants", withExtension: "png")!)
try await hf.visualQuestionAnswering(
  image: data,
  question: "How many animals are in this image?",
  model: "dandelin/vilt-b32-finetuned-vqa"
)
```

### Document Question Answering

Document question answering models take a (document, question) pair as input and return an answer in natural language.

[Demo](https://huggingface.co/spaces/huggingfacejs/doc-vis-qa)

```swift
let data = try Data(contentsOf: Bundle.module.url(forResource: "document", withExtension: "png")!)
try await hf.documentQuestionAnswering(
	image: data,
	question: "What is the invoice total amount?",
	model: "impira/layoutlm-document-qa"
)
```

## Tabular

### Tabular Regression

Tabular regression is the task of predicting a numerical value given a set of attributes.

TODO

## Custom Calls

For models with custom parameters / outputs.

TODO

## Running tests

```console

```

## Finding appropriate models

We have an informative documentation project called [Tasks](https://huggingface.co/tasks) to list available models for each task and explain how each task works in detail.

It also contains demos, example outputs, and other resources should you want to dig deeper into the ML side of things.

