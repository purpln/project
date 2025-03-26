public enum Platform: String, Codable {
    case macOS = "MacOSX"
    case iOS = "iPhoneOS"
}

extension Platform: CustomStringConvertible {
    public var description: String {
        switch self {
        case .macOS: return "macOS"
        case .iOS: return "iOS"
        }
    }
}
