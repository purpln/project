import Version

public struct BundleInfoPropertyList: Decodable {
    public let name: String
    public let identifier: String
    public let language: String
    public let platforms: [Platform]
    public let version: Version
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        identifier = try container.decode(String.self, forKey: .identifier)
        language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        platforms = try container.decodeIfPresent([Platform].self, forKey: .platforms) ?? []
        version = try container.decodeIfPresent(Version.self, forKey: .version) ?? .zero
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "CFBundleName"
        case identifier = "CFBundleIdentifier"
        case language = "CFBundleDevelopmentRegion"
        case platforms = "CFBundleSupportedPlatforms"
        case version = "MinimumOSVersion"
        case sdk = "DTSDKName"
    }
}
