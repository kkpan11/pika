import Defaults
import SwiftUI

struct NavigationMenu: View {
    @Default(.colorFormat) var colorFormat

    // These are a hack to trigger a redraw on OSX 11.0 - otherwise the
    // button displays wtih 50% opacity until you interract with it. If
    // anyone knows of a better way to do this, let me know.
    @State var once: Bool = false
    @State var showMenu: Bool = true

    @ViewBuilder
    func getMenu() -> some View {
        let icon = "gearshape"

        if #available(OSX 11.0, *) {
            if showMenu {
                Menu {
                    NavigationMenuItems()
                } label: {
                    IconImage(name: icon)
                }
                .menuStyle(BorderlessButtonMenuStyle(showsMenuIndicator: true))
                .onAppear {
                    if !once {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.showMenu.toggle()
                        }
                        self.showMenu.toggle()
                    }
                    once = true
                }
            }
        } else {
            MenuButton(label: HStack { Spacer(); IconImage(name: icon) }, content: {
                NavigationMenuItems()
            })
                .menuButtonStyle(BorderlessPullDownMenuButtonStyle())
                .padding(EdgeInsets(top: 40, leading: 5, bottom: 0, trailing: 20))
                .edgesIgnoringSafeArea(.all)
                .fixedSize()
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            Picker(NSLocalizedString("preferences.format.title", comment: "Color Format"), selection: $colorFormat) {
                ForEach(ColorFormat.allCases, id: \.self) { value in
                    Text(value.rawValue)
                }
            }
            .modify {
                if #available(OSX 11.0, *) {
                    $0.offset(y: 1.0)
                } else {
                    $0.offset(x: 6.0, y: -18.0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()

            getMenu()
                .frame(alignment: .leading)
                .modify {
                    if #available(OSX 11.0, *) {
                        $0
                            .padding(.trailing, 10.0)
                            .padding(.leading, 5.0)
                    } else {
                        $0
                    }
                }
                .fixedSize()
        }
    }
}

struct ToolbarButtons_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenu()
    }
}
