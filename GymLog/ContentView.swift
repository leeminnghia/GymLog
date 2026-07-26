import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Hôm nay", systemImage: "figure.strengthtraining.traditional") }
            PlansView()
                .tabItem { Label("Lịch tập", systemImage: "calendar") }
            ProgressView()
                .tabItem { Label("Tiến độ", systemImage: "chart.line.uptrend.xyaxis") }
        }
        .tint(.orange)
    }
}

struct TodayView: View {
    @EnvironmentObject private var store: WorkoutStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Sẵn sàng chinh phục buổi tập hôm nay?")
                        .font(.title3.bold())
                    NavigationLink {
                        WorkoutSessionView(workout: store.plans[0])
                    } label: {
                        Label("Bắt đầu Push", systemImage: "play.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.orange.opacity(0.16))
                }

                Section("Buổi gần đây") {
                    ForEach(store.records.prefix(3)) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.workoutName).font(.headline)
                            Text("\(record.completedSets) sets • \(Int(record.volume).formatted()) kg tổng khối lượng")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("GymLog")
        }
    }
}

struct PlansView: View {
    @EnvironmentObject private var store: WorkoutStore

    var body: some View {
        NavigationStack {
            List(store.plans) { workout in
                NavigationLink {
                    PlanDetailView(workout: workout)
                } label: {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(workout.title).font(.headline)
                        Text(workout.subtitle).foregroundStyle(.secondary)
                        Text("\(workout.exercises.count) bài tập").font(.caption).foregroundStyle(.orange)
                    }
                }
            }
            .navigationTitle("Lịch tập")
        }
    }
}

struct PlanDetailView: View {
    let workout: WorkoutDay

    var body: some View {
        List {
            Section(workout.subtitle) {
                ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(index + 1). \(exercise.name)").font(.headline)
                        Text("\(exercise.targetSets) sets × \(exercise.targetReps) reps • \(exercise.suggestedWeight.formatted()) kg")
                            .foregroundStyle(.secondary)
                        Text("Nghỉ \(exercise.restSeconds) giây").font(.caption).foregroundStyle(.orange)
                    }
                }
            }
            Section {
                NavigationLink("Bắt đầu buổi tập") { WorkoutSessionView(workout: workout) }
            }
        }
        .navigationTitle(workout.title)
    }
}

struct ProgressView: View {
    @EnvironmentObject private var store: WorkoutStore

    var body: some View {
        NavigationStack {
            List {
                let totalVolume = store.records.reduce(0) { $0 + $1.volume }
                Section("Tổng quan") {
                    LabeledContent("Số buổi đã lưu", value: "\(store.records.count)")
                    LabeledContent("Tổng khối lượng", value: "\(Int(totalVolume).formatted()) kg")
                }
                Section("Lịch sử") {
                    ForEach(store.records) { record in
                        LabeledContent(record.workoutName, value: "\(record.completedSets) sets")
                    }
                }
            }
            .navigationTitle("Tiến độ")
        }
    }
}
