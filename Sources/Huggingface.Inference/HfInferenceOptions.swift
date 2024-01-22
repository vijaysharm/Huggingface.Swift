//
//  HfInferenceOptions.swift
//

import Foundation

public struct HfInferenceOptions: Codable {
	/**
	 * (Default: true) Boolean. If a request 503s and wait_for_model is set to false, the request will be retried with the same parameters but with wait_for_model set to true.
	 */
	let retryOnError: Bool
	/**
	 * (Default: true). Boolean. There is a cache layer on the inference API to speedup requests we have already seen. Most models can use those results as is as models are deterministic (meaning the results will be the same anyway). However if you use a non deterministic model, you can set this parameter to prevent the caching mechanism from being used resulting in a real new query.
	 */
	let useCache: Bool

	/**
	 * (Default: false) Boolean. If the model is not ready, wait for it instead of receiving 503. It limits the number of requests required to get your inference done. It is advised to only set this flag to true after receiving a 503 error as it will limit hanging in your application to known places.
	 */
	let waitForModel: Bool
	
	public init(
		retryOnError: Bool = true,
		useCache: Bool = true,
		waitForModel: Bool = false
	) {
		self.retryOnError = retryOnError
		self.useCache = useCache
		self.waitForModel = waitForModel
	}
}
