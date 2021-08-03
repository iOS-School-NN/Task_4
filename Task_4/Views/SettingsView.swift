//
//  SettingsView.swift
//  task4_draft
//
//  Created by R S on 02.08.2021.
//

import SwiftUI

struct SettingsView: View {
    @State private var savings = false
    var body: some View {
        Toggle("Разрешать сохранять персонажей", isOn: $savings).frame(width: 300)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
