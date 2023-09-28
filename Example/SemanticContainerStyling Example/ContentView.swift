
import SemanticContainerStyling
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {

            HStack {

                Container(title: "Title", subtitle: "Some subtitle") {

                    Container {
                        Rectangle().fill(.pink)
                    } category: {
                        Text("Category")
                    } title: {
                        Text("Title")
                    } rating: {
                        Text("*****")
                    } price: {
                        Text("£10.00")
                    } action: {
                        Button {} label: {
                            Image(systemName: "bag.badge.plus")
                        }
                    }
                    .containerStyle(.productCard)
                    .border(.orange)

                }
                .border(.cyan)

                Container {
                    Rectangle().fill(.blue)
                } title: {
                    Text("Title")
                } subtitle: {
                    Text("Some subtitle")
                }
                .border(.cyan)
            }

            HStack {
                Container {
                    Rectangle().fill(.blue)
                } title: {
                    Text("Title")
                } subtitle: {
                    Text("Some subtitle")
                } footer: {
                    Button("Get Started") {}
                }
                .border(.cyan)

                Container(title: "Title", subtitle: "Some subtitle") {
                    Rectangle().fill(.blue)
                } footer: {
                    Button("Get Started") {}
                }
                .border(.cyan)
            }
        }
        .containerStyle(.card)
        .padding()
    }
}
