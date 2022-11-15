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
        NavigationView {
            VStack(spacing: 15) {
                TextField("Title", text: $viewModel.title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.4), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
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
                
                Divider()
                
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
                
                Divider()
                    .padding(.vertical, 10)
                
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
    }
}

struct AddNewHabit_Previews: PreviewProvider {
    static var previews: some View {
        AddNewHabit()
    }
}
