
import SwiftUI

// Perhaps this could be composed of smaller views?
// For example, Category/Title is a Detail view really.
public struct Information<Category: View, Title: View, Price: View, Rating: View, Action: View>: View {

    @Environment(\.informationStyle) private var style

    private let category: Category
    private let title: Title
    private let price: Price
    private let rating: Rating
    private let action: Action

    public init(
        @ViewBuilder category: () -> Category,
        @ViewBuilder title: () -> Title,
        @ViewBuilder price: () -> Price,
        @ViewBuilder rating: () -> Rating,
        @ViewBuilder action: () -> Action
    ) {
        self.category = category()
        self.title = title()
        self.price = price()
        self.rating = rating()
        self.action = action()
    }

    public var body: some View {
        let configuration = InformationConfiguration(
            category: category,
            title: title,
            price: price,
            rating: rating,
            action: action)
        AnyView(style.resolve(configuration: configuration))
    }
}

// MARK: - Plain Style

extension InformationStyle where Self == PlainInformationStyle {

    public static var plain: Self { PlainInformationStyle() }
}

public struct PlainInformationStyle: InformationStyle {

    public func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.category
            configuration.title
            configuration.price
            configuration.rating
            configuration.action
        }
    }
}

// MARK: - Style

public protocol InformationStyle: DynamicProperty {

    typealias Configuration = InformationConfiguration
    associatedtype Body: View

    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

extension View {

    public func informationStyle(_ style: some InformationStyle) -> some View {
        environment(\.informationStyle, style)
    }
}

extension Scene {

    public func informationStyle(_ style: some InformationStyle) -> some Scene {
        environment(\.informationStyle, style)
    }
}

// MARK: Configuration

public struct InformationConfiguration {

    public struct Category: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }

    public struct Title: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }

    public struct Price: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }

    public struct Rating: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }

    public struct Action: View {
        fileprivate let base: AnyView
        public var body: some View { base }
    }

    public let category: Category
    public let title: Title
    public let price: Price
    public let rating: Rating
    public let action: Action

    fileprivate init(
        category: some View,
        title: some View,
        price: some View,
        rating: some View,
        action: some View
    ) {
        self.category = Category(base: AnyView(category))
        self.title = Title(base: AnyView(title))
        self.price = Price(base: AnyView(price))
        self.rating = Rating(base: AnyView(rating))
        self.action = Action(base: AnyView(action))
    }
}

// MARK: Environment

private struct InformationStyleKey: EnvironmentKey {
    static var defaultValue: any InformationStyle = .plain
}

extension EnvironmentValues {

    fileprivate var informationStyle: any InformationStyle {
        get { self[InformationStyleKey.self] }
        set { self[InformationStyleKey.self] = newValue }
    }
}

// MARK: Resolution

extension InformationStyle {

    fileprivate func resolve(configuration: Configuration) -> some View {
        ResolvedInformationStyle(style: self, configuration: configuration)
    }
}

private struct ResolvedInformationStyle<Style: InformationStyle>: View {

    let style: Style
    let configuration: Style.Configuration

    var body: some View {
        style.makeBody(configuration: configuration)
    }
}
