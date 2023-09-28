
import SwiftUI

public struct Container<Content: View, Header: View, Footer: View>: View {
    
    @Environment(\.containerStyle) private var style
    
    private let content: Content
    private let header: Header
    private let footer: Footer
    
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder header: () -> Header,
        @ViewBuilder footer: () -> Footer
    ) {
        self.content = content()
        self.header = header()
        self.footer = footer()
    }
    
    public var body: some View {
        let configuration = ContainerConfiguration(
            content: content,
            header: header,
            footer: footer)
        AnyView(style.resolve(configuration: configuration))
    }
}

// MARK: - Plain Style

extension ContainerStyle where Self == PlainContainerStyle {
    
    public static var plain: Self { PlainContainerStyle() }
}

public struct PlainContainerStyle: ContainerStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.header
            configuration.content
            configuration.footer
        }
    }
}

// MARK: - Style

public protocol ContainerStyle: DynamicProperty {
    
    typealias Configuration = ContainerConfiguration
    associatedtype Body: View
    
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

extension View {
    
    public func containerStyle(_ style: some ContainerStyle) -> some View {
        environment(\.containerStyle, style)
    }
}

extension Scene {
    
    public func containerStyle(_ style: some ContainerStyle) -> some Scene {
        environment(\.containerStyle, style)
    }
}

// MARK: Configuration

public struct ContainerConfiguration {
    
    public struct Content: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }
    
    public struct Header: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }
    
    public struct Footer: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }
    
    public let content: Content
    public let header: Header
    public let footer: Footer
    
    fileprivate init(
        content: some View,
        header: some View,
        footer: some View
    ) {
        self.content = Content(base: AnyView(content))
        self.header = Header(base: AnyView(header))
        self.footer = Footer(base: AnyView(footer))
    }
}

// MARK: Environment

private struct ContainerStyleKey: EnvironmentKey {
    static var defaultValue: any ContainerStyle = .plain
}

extension EnvironmentValues {
    
    fileprivate var containerStyle: any ContainerStyle {
        get { self[ContainerStyleKey.self] }
        set { self[ContainerStyleKey.self] = newValue }
    }
}

// MARK: Resolution

extension ContainerStyle {
    
    fileprivate func resolve(configuration: Configuration) -> some View {
        ResolvedContainerStyle(style: self, configuration: configuration)
    }
}

private struct ResolvedContainerStyle<Style: ContainerStyle>: View {
    
    let style: Style
    let configuration: Style.Configuration
    
    var body: some View {
        style.makeBody(configuration: configuration)
    }
}
