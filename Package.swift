// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Huggingface.Swift",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
	],
	products: [
		.library(
			name: "Huggingface.Swift",
			targets: ["Huggingface.Inference"]),
	],
	targets: [
		.target(
			name: "Huggingface.Inference"
		),
		.testTarget(
			name: "Huggingface.Swift.Tests",
			dependencies: [
				"Huggingface.Inference"
			],
			resources: [
				.copy("assets/elephants.png"),
				.copy("assets/sample1.flac"),
				.copy("assets/invoice.png")
			]
		),
	]
)
