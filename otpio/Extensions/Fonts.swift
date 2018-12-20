// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  internal typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum FontAwesome5Brands {
    internal static let regular = FontConvertible(name: "FontAwesome5BrandsRegular", family: "Font Awesome 5 Brands", path: "fa-brands-400.ttf")
    internal static let all: [FontConvertible] = [regular]
  }
  internal enum FontAwesome5Pro {
    internal static let light = FontConvertible(name: "FontAwesome5ProLight", family: "Font Awesome 5 Pro", path: "fa-light-300.ttf")
    internal static let regular = FontConvertible(name: "FontAwesome5ProRegular", family: "Font Awesome 5 Pro", path: "fa-regular-400.ttf")
    internal static let solid = FontConvertible(name: "FontAwesome5ProSolid", family: "Font Awesome 5 Pro", path: "fa-solid-900.ttf")
    internal static let all: [FontConvertible] = [light, regular, solid]
  }
  internal enum SourceCodeVariable {
    internal static let black = FontConvertible(name: "SourceCodeRoman-Black", family: "Source Code Variable", path: "SourceCodeVariable-Roman.ttf")
    internal static let bold = FontConvertible(name: "SourceCodeRoman-Bold", family: "Source Code Variable", path: "SourceCodeVariable-Roman.ttf")
    internal static let extraLight = FontConvertible(name: "SourceCodeRoman-ExtraLight", family: "Source Code Variable", path: "SourceCodeVariable-Roman.ttf")
    internal static let light = FontConvertible(name: "SourceCodeRoman-Light", family: "Source Code Variable", path: "SourceCodeVariable-Roman.ttf")
    internal static let medium = FontConvertible(name: "SourceCodeRoman-Medium", family: "Source Code Variable", path: "SourceCodeVariable-Roman.ttf")
    internal static let semibold = FontConvertible(name: "SourceCodeRoman-Semibold", family: "Source Code Variable", path: "SourceCodeVariable-Roman.ttf")
    internal static let regular = FontConvertible(name: "SourceCodeVariable-Roman", family: "Source Code Variable", path: "SourceCodeVariable-Roman.ttf")
    internal static let all: [FontConvertible] = [black, bold, extraLight, light, medium, semibold, regular]
  }
  internal static let allCustomFonts: [FontConvertible] = [FontAwesome5Brands.all, FontAwesome5Pro.all, SourceCodeVariable.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font! {
    return Font(font: self, size: size)
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundle = Bundle(for: BundleToken.self)
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init!(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

private final class BundleToken {}
