
import SwiftUI

extension ButtonStyle where Self == PrimaryButtonStyle {
    public static var primary: Self { Self() }
}

public struct PrimaryButtonStyle: ButtonStyle {
    
    private func background(role: ButtonRole?) -> Color {
        switch role {
        case .some(.cancel): return .gray
        case .some(.destructive): return .red
        case .some: return .orange
        case .none: return .orange
        }
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.callout)
            .bold()
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .background(
                background(role: configuration.role),
                in: RoundedRectangle(cornerRadius: 7))
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
