//
//  SettingsView.swift
//  task4_draft
//
//  Created by R S on 02.08.2021.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("saving") private var saving = true
    var body: some View {
        Toggle("Разрешать сохранять персонажей", isOn: $saving).frame(width: 300).onChange(of: saving) { value in
            if value == false { StorageManager.shared.deleteAllItems()}
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
