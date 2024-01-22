//
//  ImageToImage.swift
//

import Foundation

struct ImageToImageParameters: Codable {
	/**
	 * The text prompt to guide the image generation.
	 */
	let prompt: String?
	/**
	 * strengh param only works for SD img2img and alt diffusion img2img models
	 * Conceptually, indicates how much to transform the reference `image`. Must be between 0 and 1. `image`
	 * will be used as a starting point, adding more noise to it the larger the `strength`. The number of
	 * denoising steps depends on the amount of noise initially added. When `strength` is 1, added noise will
	 * be maximum and the denoising process will run for the full number of iterations specified in
	 * `num_inference_steps`. A value of 1, therefore, essentially ignores `image`.
	 **/
	let strength: Float?
	/**
	 * An optional negative prompt for the image generation
	 */
	let negativePrompt: String?
	/**
	 * The height in pixels of the generated image
	 */
	let height: Int?
	/**
	 * The width in pixels of the generated image
	 */
	let width: Int?
	/**
	 * The number of denoising steps. More denoising steps usually lead to a higher quality image at the expense of slower inference.
	 */
	let numInferenceSteps: Int?
	/**
	 * Guidance scale: Higher guidance scale encourages to generate images that are closely linked to the text `prompt`, usually at the expense of lower image quality.
	 */
	let guidanceScale: Float?
	/**
	 * guess_mode only works for ControlNet models, defaults to False In this mode, the ControlNet encoder will try best to recognize the content of the input image even if
	 * you remove all prompts. The `guidance_scale` between 3.0 and 5.0 is recommended.
	 */
	let guessMode: Bool?
}

struct ImageToImageInputs: Codable {
	let inputs: String
	let parameters: ImageToImageParameters
}

extension HfInference {
	public func imageToImage(
		_ data: Data,
		prompt: String? = nil,
		strength: Float? = nil,
		negativePrompt: String? = nil,
		height: Int? = nil,
		width: Int? = nil,
		numInferenceSteps: Int? = nil,
		guidanceScale: Float? = nil,
		guessMode: Bool? = nil,
		model: String? = nil,
		options: HfInferenceOptions = .init()
	) async throws -> Data {
		return try await execute(
			model: model,
			taskHint: .imageToImage,
			body: ImageToImageInputs(
				inputs: data.base64EncodedString(),
				parameters: ImageToImageParameters(
					prompt: prompt,
					strength: strength,
					negativePrompt: negativePrompt,
					height: height,
					width: width,
					numInferenceSteps: numInferenceSteps,
					guidanceScale: guidanceScale,
					guessMode: guessMode
				)
			),
			requestType: .json,
			responseType: .data,
			options: options
		)
	}
}
