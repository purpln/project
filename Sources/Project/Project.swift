import class Foundation.PropertyListDecoder
import struct Foundation.Data
import LibC

public struct Project {
    public let name: String
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
#elseif os(iOS)
            let contents = try getDirectoryContents(path)
                .filter({ $0.name.hasSuffix(".bundle") })
            return contents.map({ "\(path)/\($0.name)" }).map(Bundle.init)
#endif
        }
    }
    
    public var resources: [String] {
        get throws {
#if os(macOS) || targetEnvironment(macCatalyst)
            let path = path + "/Resources"
            return try getDirectoryContents(path)
                .map({ "\(path)/\($0.name)" })
#elseif os(iOS)
            let list: Set<String> = [
                "Info.plist", "Frameworks", "embedded.mobileprovision", "PkgInfo",
                "_CodeSignature", "__preview.dylib", name, "\(name).debug.dylib"
            ]
            return try getDirectoryContents(path)
                .filter({ !list.contains($0.name) }).map({ "\(path)/\($0.name)" })
#endif
        }
    }
}

public extension Project {
    static var current: Project {
        get throws {
            var components = try getExecutablePath().split(separator: "/")
            let name = components.removeLast()
#if os(macOS) || targetEnvironment(macCatalyst)
            components.removeLast()
#endif
            let path = "/" + components.joined(separator: "/")
            return Project(name: String(name), path: path)
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
        
        public var resources: [String] {
            get throws {
#if os(macOS) || targetEnvironment(macCatalyst)
                let path = path + "/Resources"
                return try getDirectoryContents(path)
                    .map({ "\(path)/\($0.name)" })
#elseif os(iOS)
                try getDirectoryContents(path)
                    .filter({ $0.name != "Info.plist" }).map({ "\(path)/\($0.name)" })
#endif
            }
        }
    }
}
