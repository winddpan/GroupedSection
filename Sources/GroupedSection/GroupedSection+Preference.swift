import Foundation
import SwiftUI

public struct GroupedSectionRowPreference {
    public var iconFont: Font
    public var titleFont: Font
    public var rowSeparatorTint: Color?
    public var rowSeparatorVisibility: Visibility
    public var rowSeparatorInsets: EdgeInsets
    public var rowBackgroundColor: Color?
    public var rowInstes: EdgeInsets

    public init(
        iconFont: Font = Font.system(size: 21, weight: .regular),
        titleFont: Font = Font.system(size: 17, weight: .regular),
        rowSeparatorTint: Color? = nil,
        rowSeparatorVisibility: Visibility = .automatic,
        rowSeparatorInsets: EdgeInsets = .init(top: 0, leading: 62, bottom: 0, trailing: 0),
        rowInstes: EdgeInsets = EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20),
        rowBackgroundColor: Color? = nil
    ) {
        self.iconFont = iconFont
        self.titleFont = titleFont
        self.rowSeparatorTint = rowSeparatorTint
        self.rowSeparatorVisibility = rowSeparatorVisibility
        self.rowBackgroundColor = rowBackgroundColor
        self.rowInstes = rowInstes
        self.rowSeparatorInsets = rowSeparatorInsets
    }
}

public struct GroupedSectionPreference {
    public var sectionInsets: EdgeInsets
    public var sectionRadius: CGFloat
    public var sectionBorderWidth: CGFloat
    public var sectionBorderColor: Color?
    public var sectionSpacing: CGFloat

    public init(
        sectionInsets: EdgeInsets = EdgeInsets(top: 0, leading: 19, bottom: 0, trailing: 19),
        sectionRadius: CGFloat = 10,
        sectionBorderWidth: CGFloat = 1,
        sectionBorderColor: Color? = nil,
        sectionSpacing: CGFloat = 35
    ) {
        self.sectionRadius = sectionRadius
        self.sectionBorderWidth = sectionBorderWidth
        self.sectionBorderColor = sectionBorderColor
        self.sectionSpacing = sectionSpacing
        self.sectionInsets = sectionInsets
    }
}

public extension GroupedSection {
    func groupSectionPreference(_ preference: GroupedSectionPreference) -> Self {
        var _self = self
        _self.sectionPreference = preference
        return _self
    }

    func groupSectionRowPreference(_ preference: GroupedSectionRowPreference) -> Self {
        var _self = self
        _self.rowPreference = preference
        return _self
    }
}
