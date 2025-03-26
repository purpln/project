import class Foundation.PropertyListDecoder
import struct Foundation.Data
import LibC

public struct Project {
    public let path: String
    
    public var info: InfoPropertyList {
        get throws {
            let bytes = try read(path: path + "/Info.plist")
            return try PropertyListDecoder().decode(InfoPropertyList.self, from: Data(bytes))
        }
    }
    
    public var bundles: [Bundle] {
        get throws {
#if os(macOS) || targetEnvironment(macCatalyst)
            let path = path + "/Resources"
            let contents = try getDirectoryContents(path)
                .filter({ $0.name.hasSuffix(".bundle") })
            return contents.map({ "\(path)/\($0.name)/Contents" }).map(Bundle.init)
#else
            let contents = try getDirectoryContents(path)
                .filter({ $0.name.hasSuffix(".bundle") })
            return contents.map({ "\(path)/\($0.name)" }).map(Bundle.init)
#endif
        }
    }
}

public extension Project {
    static var current: Project {
        get throws {
            var components = try getExecutablePath().split(separator: "/")
#if os(macOS) || targetEnvironment(macCatalyst)
            components.removeLast(1)
#endif
            components.removeLast(1)
            let path = "/" + components.joined(separator: "/")
            return Project(path: path)
        }
    }
}

public extension Project {
    struct Bundle {
        public let path: String
        
        public var info: BundleInfoPropertyList {
            get throws {
                let bytes = try read(path: path + "/Info.plist")
                return try PropertyListDecoder().decode(BundleInfoPropertyList.self, from: Data(bytes))
            }
        }
        
        public var contents: [String] {
            get throws {
#if os(macOS) || targetEnvironment(macCatalyst)
                let path = path + "/Resources"
                return try getDirectoryContents(path)
                    .map({ "\(path)/\($0.name)" })
#else
                try getDirectoryContents(path)
                    .filter({ $0.name != "Info.plist" }).map({ "\(path)/\($0.name)" })
#endif
            }
        }
    }
}
