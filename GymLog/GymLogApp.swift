import SwiftUI

@main
struct GymLogApp: App {
    @StateObject private var store = WorkoutStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let targetSets: Int
    let targetReps: String
    let suggestedWeight: Double
    let restSeconds: Int
}

struct WorkoutDay: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let exercises: [Exercise]
}

struct SetLog: Identifiable {
    let id = UUID()
    let exerciseName: String
    let setNumber: Int
    var reps: Int
    var weight: Double
    var isComplete: Bool
}

struct WorkoutRecord: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let workoutName: String
    let completedSets: Int
    let volume: Double
}

final class WorkoutStore: ObservableObject {
    @Published var plans = SampleData.plans
    @Published var records: [WorkoutRecord] {
        didSet { persistRecords() }
    }

    init() {
        let key = "workoutRecords"
        if let data = UserDefaults.standard.data(forKey: key),
           let savedRecords = try? JSONDecoder().decode([WorkoutRecord].self, from: data) {
            records = savedRecords
        } else {
            records = SampleData.records
        }
    }

    func save(workout: WorkoutDay, logs: [SetLog]) {
        let completed = logs.filter(\.isComplete)
        guard !completed.isEmpty else { return }
        let volume = completed.reduce(0) { $0 + Double($1.reps) * $1.weight }
        records.insert(WorkoutRecord(date: .now, workoutName: workout.title, completedSets: completed.count, volume: volume), at: 0)
    }

    private func persistRecords() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: "workoutRecords")
    }
}

enum SampleData {
    static let plans: [WorkoutDay] = [
        WorkoutDay(title: "Push", subtitle: "Ngực • Vai • Tay sau", exercises: [
            Exercise(name: "Bench Press", targetSets: 4, targetReps: "8–10", suggestedWeight: 50, restSeconds: 120),
            Exercise(name: "Incline Dumbbell Press", targetSets: 3, targetReps: "10–12", suggestedWeight: 20, restSeconds: 90),
            Exercise(name: "Shoulder Press", targetSets: 3, targetReps: "8–10", suggestedWeight: 30, restSeconds: 90),
            Exercise(name: "Tricep Pushdown", targetSets: 3, targetReps: "12–15", suggestedWeight: 25, restSeconds: 60)
        ]),
        WorkoutDay(title: "Pull", subtitle: "Lưng • Tay trước", exercises: [
            Exercise(name: "Lat Pulldown", targetSets: 4, targetReps: "8–12", suggestedWeight: 45, restSeconds: 90),
            Exercise(name: "Seated Cable Row", targetSets: 3, targetReps: "10–12", suggestedWeight: 40, restSeconds: 90),
            Exercise(name: "Dumbbell Curl", targetSets: 3, targetReps: "10–12", suggestedWeight: 12, restSeconds: 60)
        ]),
        WorkoutDay(title: "Legs", subtitle: "Chân • Mông • Bắp chân", exercises: [
            Exercise(name: "Barbell Squat", targetSets: 4, targetReps: "6–8", suggestedWeight: 60, restSeconds: 150),
            Exercise(name: "Romanian Deadlift", targetSets: 3, targetReps: "8–10", suggestedWeight: 50, restSeconds: 120),
            Exercise(name: "Leg Press", targetSets: 3, targetReps: "10–12", suggestedWeight: 120, restSeconds: 90)
        ])
    ]

    static let records = [
        WorkoutRecord(date: .now.addingTimeInterval(-172_800), workoutName: "Push", completedSets: 13, volume: 4_860),
        WorkoutRecord(date: .now.addingTimeInterval(-432_000), workoutName: "Legs", completedSets: 10, volume: 7_240)
    ]
}
