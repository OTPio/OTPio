// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2b2b2b"></span>
  /// Alpha: 100% <br/> (0x2b2b2bff)
  internal static let nightlightBlack = ColorName(rgbaValue: 0x2b2b2bff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#262626"></span>
  /// Alpha: 100% <br/> (0x262626ff)
  internal static let nightlightBlackDark = ColorName(rgbaValue: 0x262626ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#3599db"></span>
  /// Alpha: 100% <br/> (0x3599dbff)
  internal static let nightlightBlue = ColorName(rgbaValue: 0x3599dbff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#95a5a6"></span>
  /// Alpha: 100% <br/> (0x95a5a6ff)
  internal static let nightlightGray = ColorName(rgbaValue: 0x95a5a6ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#7e8b8c"></span>
  /// Alpha: 100% <br/> (0x7e8b8cff)
  internal static let nightlightGrayDark = ColorName(rgbaValue: 0x7e8b8cff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f2f2f2"></span>
  /// Alpha: 100% <br/> (0xf2f2f2ff)
  internal static let nightlightWhite = ColorName(rgbaValue: 0xf2f2f2ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bdc3c7"></span>
  /// Alpha: 100% <br/> (0xbdc3c7ff)
  internal static let nightlightWhiteDark = ColorName(rgbaValue: 0xbdc3c7ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#839496"></span>
  /// Alpha: 100% <br/> (0x839496ff)
  internal static let solarizedBase0 = ColorName(rgbaValue: 0x839496ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#657b83"></span>
  /// Alpha: 100% <br/> (0x657b83ff)
  internal static let solarizedBase00 = ColorName(rgbaValue: 0x657b83ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#586e75"></span>
  /// Alpha: 100% <br/> (0x586e75ff)
  internal static let solarizedBase01 = ColorName(rgbaValue: 0x586e75ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#073642"></span>
  /// Alpha: 100% <br/> (0x073642ff)
  internal static let solarizedBase02 = ColorName(rgbaValue: 0x073642ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#002b36"></span>
  /// Alpha: 100% <br/> (0x002b36ff)
  internal static let solarizedBase03 = ColorName(rgbaValue: 0x002b36ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#93a1a1"></span>
  /// Alpha: 100% <br/> (0x93a1a1ff)
  internal static let solarizedBase1 = ColorName(rgbaValue: 0x93a1a1ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#eee8d5"></span>
  /// Alpha: 100% <br/> (0xeee8d5ff)
  internal static let solarizedBase2 = ColorName(rgbaValue: 0xeee8d5ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fdf6e3"></span>
  /// Alpha: 100% <br/> (0xfdf6e3ff)
  internal static let solarizedBase3 = ColorName(rgbaValue: 0xfdf6e3ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#268bd2"></span>
  /// Alpha: 100% <br/> (0x268bd2ff)
  internal static let solarizedBlue = ColorName(rgbaValue: 0x268bd2ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2aa198"></span>
  /// Alpha: 100% <br/> (0x2aa198ff)
  internal static let solarizedCyan = ColorName(rgbaValue: 0x2aa198ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#859900"></span>
  /// Alpha: 100% <br/> (0x859900ff)
  internal static let solarizedGreen = ColorName(rgbaValue: 0x859900ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d33682"></span>
  /// Alpha: 100% <br/> (0xd33682ff)
  internal static let solarizedMagenta = ColorName(rgbaValue: 0xd33682ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cb4b16"></span>
  /// Alpha: 100% <br/> (0xcb4b16ff)
  internal static let solarizedOrange = ColorName(rgbaValue: 0xcb4b16ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dc322f"></span>
  /// Alpha: 100% <br/> (0xdc322fff)
  internal static let solarizedRed = ColorName(rgbaValue: 0xdc322fff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#6c71c4"></span>
  /// Alpha: 100% <br/> (0x6c71c4ff)
  internal static let solarizedViolet = ColorName(rgbaValue: 0x6c71c4ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b58900"></span>
  /// Alpha: 100% <br/> (0xb58900ff)
  internal static let solarizedYellow = ColorName(rgbaValue: 0xb58900ff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
