//
//  AddNewHabit.swift
//  ManageDay
//
//  Created by Piotr Woźniak on 13/11/2022.
//

import SwiftUI

struct AddNewHabit: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var env
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
    }
}
