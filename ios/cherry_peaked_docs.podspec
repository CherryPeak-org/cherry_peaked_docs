#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint cherry_peaked_docs.podspec` to validate before publishing.
#
Pod::Spec.new do |spec|
  spec.name             = "cherry_peaked_docs"
  spec.version          = "0.0.1"
  spec.summary          = "Document Scanner for Flutter Mobile"
  spec.homepage         = "https://github.com/CherryPeak-org/cherry_peaked_docs"
  spec.license          = { :type => "MIT", :file => "../LICENSE" }
  spec.author           = { "Samuel Kubinský" => "samuel.kubinsky@cherrypeak.eu" }
  spec.source           = { :git => "https://github.com/CherryPeak-org/cherry_peaked_docs.git" } # Add TAG
  spec.source_files     = "cherry_peaked_docs/Sources/cherry_peaked_docs/**/*"
  spec.platform         = :ios, "13.0"
  spec.dependency       "Flutter"

  # Flutter.framework does not contain a i386 slice.
  spec.pod_target_xcconfig = { "DEFINES_MODULE" => "YES", "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "i386" }
  spec.swift_version       = "5.0"

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # spec.resource_bundles = {"cherry_peaked_docs_privacy" => ["cherry_peaked_docs/Sources/cherry_peaked_docs/PrivacyInfo.xcprivacy"]}
end
