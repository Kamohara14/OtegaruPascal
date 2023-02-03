//
//  OtegaruPascalView.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2022/10/07.
//

import SwiftUI

struct OtegaruPascalView: View {
    var body: some View {
        NavigationView {
            VStack {
                
                // FooterView()
                MainView()
                
            } // VS
        } // Navi
    }
}

struct OtegaruPascalView_Previews: PreviewProvider {
    static var previews: some View {
        OtegaruPascalView()
    }
}

// MARK: - FooterView
struct FooterView: View {
    var body: some View {
        Color("TabViewBackground")
        TabView {
            
        }
    } // body
}
