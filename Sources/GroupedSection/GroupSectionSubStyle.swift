import Foundation
import SwiftUI

struct GroupSectionLabelStyle: LabelStyle {
    let rowPreference: GroupedSectionRowPreference

    init(_ rowPreference: GroupedSectionRowPreference) {
        self.rowPreference = rowPreference
    }

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .center, spacing: 0) {
            configuration.icon
                .font(rowPreference.titleFont)
                .foregroundStyle(Color.accentColor)
                .imageScale(.large)
                .frame(width: 45, alignment: .leading)

            configuration.title
                .font(rowPreference.titleFont)
                .frame(alignment: .center)
        }
    }
}

struct GroupSectionButtonStyle: ButtonStyle {
    let rowPreference: GroupedSectionRowPreference

    init(_ rowPreference: GroupedSectionRowPreference) {
        self.rowPreference = rowPreference
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.purple)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(Color.gray)
    }
}
