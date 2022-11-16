//
//  AddNewHabit.swift
//  ManageDay
//
//  Created by Piotr Woźniak on 13/11/2022.
//

import SwiftUI

struct AddNewHabit: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.self) var env
    
    var body: some View {
        NavigationView {
            insideView
                .animation(.easeInOut, value: viewModel.isRemainderOn)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(viewModel.editHabit != nil ? "Edit Habit" : "Add Habit")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            env.dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                        .tint(.primary)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if viewModel.deleteHabit(context: env.managedObjectContext) {
                                env.dismiss()
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        .opacity(viewModel.editHabit != nil ? 1 : 0)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            Task {
                                if await viewModel.addHabit(context: env.managedObjectContext) {
                                    env.dismiss()
                                }
                            }
                        }
                        .tint(.primary)
                        .disabled(!viewModel.doneStatus())
                        .opacity(viewModel.doneStatus() ? 1 : 0.6)
                    }
                }
        }
        .overlay {
            if viewModel.showTimePicker {
                ZStack {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.showTimePicker.toggle()
                        }
                    
                    DatePicker.init("", selection: $viewModel.remainderDate, displayedComponents: [.hourAndMinute])
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("TFBG"))
                        }
                        .padding()
                }
            }
        }
    }
    var insideView: some View {
        VStack(spacing: 15) {
            titleView
            chooseColor
            Divider()
            daysFrequency
            Divider()
                .padding(.vertical, 10)
            notificationToggle
            notificationTimeAndMessage
        }
    }
    @ViewBuilder var titleView: some View {
        TextField("Title", text: $viewModel.title)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
    var chooseColor: some View {
        HStack(spacing: 0) {
            ForEach(1...7, id: \.self) { index in
                let color = "Card-\(index)"
                Circle()
                    .fill(Color(color))
                    .frame(width: 30, height: 30)
                    .overlay(content: {
                        if color == viewModel.habitColor {
                            Image(systemName: "checkmark")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                    })
                    .onTapGesture {
                        withAnimation {
                            viewModel.habitColor = color
                        }
                    }
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 15)
    }
    var daysFrequency: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Frequency")
                .font(.callout.bold())
            let weekDays = Calendar.current.weekdaySymbols
            HStack(spacing: 10) {
                ForEach(weekDays, id: \.self) { day in
                    let index = viewModel.weekDays.firstIndex { value in
                        return value == day
                    } ?? -1
                    
                    Text(day.prefix(2))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundColor(index != -1 ? .white : .primary)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(index != -1 ? Color(viewModel.habitColor) : Color("TFBG").opacity(0.4))
                        }
                        .onTapGesture {
                            withAnimation {
                                if index != -1 {
                                    viewModel.weekDays.remove(at: index)
                                } else {
                                    viewModel.weekDays.append(day)
                                }
                            }
                        }
                }
            }
            .padding(.top, 15)
        }
    }
    var notificationToggle: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Remainder")
                    .fontWeight(.semibold)
                
                Text("Just notification")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle(isOn: $viewModel.isRemainderOn) {}
                .labelsHidden()
        }
        .opacity(viewModel.notificationAccess ? 1 : 0)
    }
    var notificationTimeAndMessage: some View {
        HStack(spacing: 12) {
            Label {
                Text(viewModel.remainderDate.formatted(date: .omitted, time: .shortened))
            } icon: {
                Image(systemName: "clock")
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
            .onTapGesture {
                withAnimation {
                    viewModel.showTimePicker.toggle()
                }
            }
            
            TextField("Reminder text", text: $viewModel.remainderText)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .frame(height: viewModel.isRemainderOn ? nil : 0)
        .opacity(viewModel.isRemainderOn ? 1 : 0)
        .opacity(viewModel.notificationAccess ? 1 : 0)
    }
}

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
    }
}
