import Version

public struct InfoPropertyList: Decodable {
    public let name: String
    public let identifier: String
    public let language: String
    public let platforms: [Platform]
    public let version: Version
    public let build: String
    public let executable: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        identifier = try container.decode(String.self, forKey: .identifier)
        language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        platforms = try container.decodeIfPresent([Platform].self, forKey: .platforms) ?? []
        version = try container.decodeIfPresent(Version.self, forKey: .version) ?? .zero
        build = try container.decodeIfPresent(String.self, forKey: .build) ?? ""
        executable = try container.decode(String.self, forKey: .executable)
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "CFBundleName"
        case identifier = "CFBundleIdentifier"
        case language = "CFBundleDevelopmentRegion"
        case platforms = "CFBundleSupportedPlatforms"
        case version = "CFBundleShortVersionString"
        case build = "CFBundleVersion"
        case executable = "CFBundleExecutable"
    }
}

private enum InfoPropertyListKeys: String {
    case CFBundleIdentifier
    case CFBundleVersion
    case CFBundleShortVersionString
    case CFBundleExecutable
    case CFBundleName
    case CFBundleDisplayName
    case CFBundlePackageType
    case CFBundleNumericVersion
    case CFBundleDevelopmentRegion
    case CFBundleInfoDictionaryVersion
    case CFBundleSupportedPlatforms
    
    case NSLocalNetworkUsageDescription
    case NSAppTransportSecurity
    
    case NSAccentColorName
    case NSSupportsSuddenTermination
    case NSSupportsAutomaticTermination
    
    case DTPlatformName
    case DTPlatformBuild
    case DTPlatformVersion
    case DTCompiler
    case DTXcode
    case DTXcodeBuild
    case DTSDKBuild
    case DTSDKName
    
    case BuildMachineOSBuild
    
    case UIApplicationSupportsIndirectInputEvents
    case UIRequiredDeviceCapabilities
    case UIDeviceFamily
    case UISupportedInterfaceOrientations
    case UISupportedInterfaceOrientations_ipad = "UISupportedInterfaceOrientations~ipad"
    case UILaunchScreen
    case UIApplicationSceneManifest
    
    case LSMinimumSystemVersion
    case LSApplicationCategoryType
}
