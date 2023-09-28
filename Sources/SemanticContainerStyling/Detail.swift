
import SwiftUI

public struct Detail<Title: View, Subtitle: View>: View {
    
    @Environment(\.detailStyle) private var style
    
    private let title: Title
    private let subtitle: Subtitle
    
    public init(
        @ViewBuilder title: () -> Title,
        @ViewBuilder subtitle: () -> Subtitle
    ) {
        self.title = title()
        self.subtitle = subtitle()
    }
    
    public var body: some View {
        let configuration = DetailConfiguration(
            title: title,
            subtitle: subtitle)
        AnyView(style.resolve(configuration: configuration))
    }
}

// MARK: - Plain Style

extension DetailStyle where Self == PlainDetailStyle {
    
    public static var plain: Self { PlainDetailStyle() }
}

public struct PlainDetailStyle: DetailStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.title
            configuration.subtitle
        }
    }
}

// MARK: - Style

public protocol DetailStyle: DynamicProperty {
    
    typealias Configuration = DetailConfiguration
    associatedtype Body: View
    
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

extension View {
    
    public func detailStyle(_ style: some DetailStyle) -> some View {
        environment(\.detailStyle, style)
    }
}

extension Scene {
    
    public func detailStyle(_ style: some DetailStyle) -> some Scene {
        environment(\.detailStyle, style)
    }
}

// MARK: Configuration

public struct DetailConfiguration {
    
    public struct Title: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }
    
    public struct Subtitle: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }
    
    public let title: Title
    public let subtitle: Subtitle
    
    fileprivate init(
        title: some View,
        subtitle: some View
    ) {
        self.title = Title(base: AnyView(title))
        self.subtitle = Subtitle(base: AnyView(subtitle))
    }
}

// MARK: Environment

private struct DetailStyleKey: EnvironmentKey {
    static var defaultValue: any DetailStyle = .plain
}

extension EnvironmentValues {
    
    fileprivate var detailStyle: any DetailStyle {
        get { self[DetailStyleKey.self] }
        set { self[DetailStyleKey.self] = newValue }
    }
}

// MARK: Resolution

extension DetailStyle {
    
    fileprivate func resolve(configuration: Configuration) -> some View {
        ResolvedDetailStyle(style: self, configuration: configuration)
    }
}

private struct ResolvedDetailStyle<Style: DetailStyle>: View {
    
    let style: Style
    let configuration: Style.Configuration
    
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}
