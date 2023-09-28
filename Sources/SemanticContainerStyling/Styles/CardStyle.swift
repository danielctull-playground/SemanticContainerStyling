
import SwiftUI

extension Container {

    public init<Title: View, Subtitle: View>(
        @ViewBuilder content: () -> Content,
        @ViewBuilder title: () -> Title,
        @ViewBuilder subtitle: () -> Subtitle,
        @ViewBuilder footer: () -> Footer
    ) where Header == Detail<Title, Subtitle> {
        self.init {
            content()
        } header: {
            Detail {
                title()
            } subtitle: {
                subtitle()
            }
        } footer: {
            footer()
        }
    }

    public init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) where Header == Detail<Text, Text> {
        self.init {
            content()
        } title: {
            Text(title)
        } subtitle: {
            Text(subtitle)
        } footer: {
            footer()
        }
    }

    public init<Title: View, Subtitle: View>(
        @ViewBuilder content: () -> Content,
        @ViewBuilder title: () -> Title,
        @ViewBuilder subtitle: () -> Subtitle
    ) where Header == Detail<Title, Subtitle>, Footer == EmptyView {
        self.init {
            content()
        } header: {
            Detail {
                title()
            } subtitle: {
                subtitle()
            }
        } footer: {
            EmptyView()
        }
    }

    public init(
        title: LocalizedStringKey,
        subtitle: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) where Header == Detail<Text, Text>, Footer == EmptyView {
        self.init {
            content()
        } title: {
            Text(title)
        } subtitle: {
            Text(subtitle)
        } footer: {
            EmptyView()
        }
    }
}

// MARK: - Card Container Style

extension ContainerStyle where Self == CardContainerStyle {
    public static var card: Self { Self() }
}

public struct CardContainerStyle: ContainerStyle {

    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 20) {
            configuration.header
                .font(.title)
            configuration.content
                .font(.body)
            configuration.footer
        }
        .padding(20)
        .detailStyle(CardDetailStyle())
        .buttonStyle(.primary)
    }
}

private struct CardDetailStyle: DetailStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                configuration.title
                    .font(.title)
                configuration.subtitle
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}
