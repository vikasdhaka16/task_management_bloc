# ✅ Task Manager App

A clean and efficient task management app built with Flutter. It allows users to add, update, delete, and filter tasks, while tracking their progress in real-time across different stages: To-do, In Progress, and Completed.

---

## 🚀 Features

- 📝 Add, update, delete tasks
- 🔍 Filter tasks by status (To-do, In Progress, Completed)
- 📊 Progress tracking with visual counts
- 📦 Offline-first with Hive local storage
- 🧱 Clean architecture + BLoC + Dependency Injection

---

## 🧠 Architecture Overview

The app follows **Clean Architecture** pattern, separating concerns into:


- **Data Layer**: Local persistence via Hive
- **Domain Layer**: Business rules & task operations
- **Presentation Layer**: UI using Flutter & Bloc

---

## 🎯 State Management

We use `flutter_bloc` for predictable state management.

- `TaskBloc` handles:
  - Task creation, deletion, updates
  - Filtering logic (status-based)
  - Sync between storage and UI


---

## 💾 Local Storage

All task data is stored locally using `Hive`.

- Tasks are persisted across app restarts
- Fast performance and no need for external DB

---

