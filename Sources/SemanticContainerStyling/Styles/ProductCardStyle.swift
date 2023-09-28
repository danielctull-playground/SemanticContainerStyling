
import SwiftUI

extension Container {

    public init<Category: View, Title: View, Price: View, Rating: View, Action: View>(
        @ViewBuilder image: () -> Header,
        @ViewBuilder category: () -> Category,
        @ViewBuilder title: () -> Title,
        @ViewBuilder rating: () -> Rating,
        @ViewBuilder price: () -> Price,
        @ViewBuilder action: () -> Action
    ) where Content == Information<Category, Title, Price, Rating, Action>, Footer == EmptyView {
        self.init {
            Information(
                category: category,
                title: title,
                price: price,
                rating: rating,
                action: action)
        } header: {
            image()
        } footer: {
            EmptyView()
        }
    }
}

// MARK: - Card Container Style

extension ContainerStyle where Self == ProductCardContainerStyle {
    public static var productCard: Self { Self() }
}

public struct ProductCardContainerStyle: ContainerStyle {

    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 4) {
            configuration.header
            configuration.content
                .padding(8)
            configuration.footer
        }
        .informationStyle(ProductCardInformationStyle())
        .buttonStyle(ProductCardButtonStyle())
    }
}

private struct ProductCardButtonStyle: ButtonStyle {

    private func background(isPressed: Bool) -> Color {
        switch isPressed {
        case true: return .gray
        case false: return .black
        }
    }


    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.callout)
            .bold()
            .foregroundColor(.white)
            .padding(8)
            .background(
                background(isPressed: configuration.isPressed),
                in: Circle()
            )
    }
}

private struct ProductCardInformationStyle: InformationStyle {

    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            configuration.category
                .font(.callout)
                .bold()

            configuration.title
                .font(.callout)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    configuration.rating
                    configuration.price
                        .font(.callout)
                        .bold()
                }
                Spacer(minLength: 4)
                configuration.action
            }
        }
    }
}
