import SwiftUI

struct WorkoutSessionView: View {
    @EnvironmentObject private var store: WorkoutStore
    @Environment(\.dismiss) private var dismiss
    let workout: WorkoutDay
    @State private var logs: [SetLog]
    @State private var showSaved = false

    init(workout: WorkoutDay) {
        self.workout = workout
        _logs = State(initialValue: workout.exercises.flatMap { exercise in
            (1...exercise.targetSets).map {
                SetLog(exerciseName: exercise.name, setNumber: $0, reps: Int(String(exercise.targetReps.prefix { $0.isNumber })) ?? 10, weight: exercise.suggestedWeight, isComplete: false)
            }
        })
    }

    var body: some View {
        List {
            ForEach(workout.exercises) { exercise in
                Section(exercise.name) {
                    ForEach(logs.indices.filter { logs[$0].exerciseName == exercise.name }, id: \.self) { index in
                        HStack {
                            Button {
                                logs[index].isComplete.toggle()
                            } label: {
                                Image(systemName: logs[index].isComplete ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(logs[index].isComplete ? .green : .secondary)
                            }
                            Text("Set \(logs[index].setNumber)")
                            Spacer()
                            TextField("Rep", value: $logs[index].reps, format: .number)
                                .keyboardType(.numberPad).multilineTextAlignment(.trailing).frame(width: 42)
                            Text("×")
                            TextField("Kg", value: $logs[index].weight, format: .number)
                                .keyboardType(.decimalPad).multilineTextAlignment(.trailing).frame(width: 50)
                            Text("kg").foregroundStyle(.secondary)
                        }
                    }
                    Text("Nghỉ đề xuất: \(exercise.restSeconds) giây")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(workout.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Hoàn thành") {
                    store.save(workout: workout, logs: logs)
                    showSaved = true
                }
                .disabled(!logs.contains(where: \.isComplete))
            }
        }
        .alert("Đã lưu buổi tập", isPresented: $showSaved) {
            Button("Xong") { dismiss() }
        } message: {
            Text("Tiến độ của bạn đã được cập nhật.")
        }
    }
}
