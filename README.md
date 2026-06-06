# RemoteRecruit

Job listing & searching application built using Swift, SwiftUI and CLEAN MVVM architecture.

## Overview

RemoteRecruit is a production-quality iOS application designed to help users browse available jobs, search by title or company name, and view detailed job information. The application demonstrates modern iOS development practices with a clean, layered architecture approach.

The project showcases:

* SwiftUI
* MVVM Architecture (Clean MVVM)
* Async/Await
* Dependency Injection
* Repository Pattern
* Unit Testing
* State Management

---

# Features

### Job Listing Screen

Displays a comprehensive list of available jobs with:

* Job Title
* Company Name
* Location
* Salary Range
* Job Type

### Search Functionality

Users can search jobs by:

* Job Title
* Company Name

### Job Details Screen

Displays detailed information including:

* Complete Job Description
* Company Information
* Salary Range
* Job Location
* Job Type

### State Handling

The application handles:

* Loading State
* Empty State
* Error State
* Success State

---

# Architecture

RemoteRecruit follows a CLEAN Architecture approach combined with MVVM (Model-View-ViewModel) for the presentation layer. This layered approach ensures better separation of concerns, testability, and scalability.

## Architecture Flow

```
┌─────────────────────────────────────────┐
│           Feature Layer                 │
│      (SwiftUI Views & ViewModels)       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           Domain Layer                  │
│   (Entities & Repository Protocols)     │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│             Data Layer                  │
│ (Repository Impl, DTOs & Mappers)       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│             Core Layer                  │
│       (Networking & Utilities)          │
└─────────────────────────────────────────┘
```

### Feature Layer (Presentation)

Responsible for UI rendering, state management, and user interactions. Features are encapsulated into their own modules.

Examples:

* JobListView, JobDetailsView
* JobListViewModel, JobDetailsViewModel

### Domain Layer

Contains the core business rules and enterprise logic. It is completely independent of other layers.

Examples:

* Entities: `Job`
* Protocols: `JobRepoType`, `JobDetailRepoType`

### Data Layer

Implements the repository protocols defined in the Domain layer. It is responsible for fetching data, parsing it into DTOs (Data Transfer Objects), and mapping it to Domain Entities.

Examples:

* `JobNetworkRepo`
* `JobDTO`, `Mapper`

### Core Layer

Contains foundational infrastructure required by the application, such as network clients and utilities.

Examples:

* `ApiClient`, `RequestBuilder`, `NetworkMonitor`

### Dependency Injection

Dependencies are injected through constructors to improve testability, loose coupling, and code reusability. Factory patterns are used to construct features.

Example:

```swift
init(repository: JobRepoType) {
    self.repository = repository
}
```

---

# Project Structure

```
RemoteRecruit
│
├── App
│   └── RemoteRecruitApp.swift
│
├── Core
│   └── Networking (ApiClient, RequestBuilder, etc.)
│
├── Data
│   ├── DTO
│   ├── Mapper
│   └── Repository (JobNetworkRepo)
│
├── Domain
│   ├── Entities (Job)
│   └── Repository (JobRepoType, JobDetailRepoType)
│
├── Features
│   ├── Job Details (View, ViewModel)
│   └── JobList (View, ViewModel, Factory)
│
├── Helper & Utils (Extensions, StateMachine, Theme)
│
└── Tests
    ├── JobDTOMapperTests.swift
    ├── JobDetailsViewModelTests.swift
    ├── JobListViewModelTests.swift
    └── RemoteRecruitTests.swift
```

---

# Setup Instructions

## Prerequisites

* Xcode 26 or later
* iOS 26.0+
* Swift 6.2+

## Installation

### 1. Clone Repository

```bash
$ git clone https://github.com/PrashantKT/RemoteRecruit.git
```

### 2. Open Project

```bash
cd RemoteRecruit
open RemoteRecruit.xcodeproj
```

### 3. Build and Run

```bash
Cmd + B  (Build)
Cmd + R  (Run)
```

---

# Running Unit Tests

Tests cover:

* Job fetching and parsing
* Search filtering logic
* ViewModel state management
* Repository layer functionality
* Service layer operations
* Error handling scenarios

### Execute Tests

```bash
Cmd + U  (Run Tests)
```

Or from terminal:

```bash
xcodebuild test -scheme RemoteRecruit
```

---

# Assumptions Made

### Data Source

The application connects to a remote REST API to fetch real-time job listings. The network layer is built using Swift's async/await concurrency model.

**Features:**
* Robust networking with `ApiClient`
* DTO mapping to domain models
* Real-time search support
* Pagination/Offset handling implemented via `PagingInfo`

### Search Behavior

Search is performed remotely using the REST API endpoint.

**Supported fields:**
* Job Title
* Company Name

**Search characteristics:**
* Case-insensitive matching via API
* Real-time backend filtering

### Pagination

Pagination is not implemented for the current version due to small mock dataset.

**For production systems, recommended:**
* Server-side pagination
* Infinite scrolling
* Load more functionality

### Authentication

No authentication is implemented as it was not part of initial requirements.

### Offline Support

Offline storage is not implemented in the current version.

**Potential production enhancements:**
* Core Data
* SwiftData
* Local caching strategy

### Images

Company logos are not included in the current version.

**Production enhancements:**
* AsyncImage
* Kingfisher for image caching
* SDWebImage integration

---

# Testing Strategy

Unit tests focus on business logic rather than UI components.

## Covered Areas

* **Repository Layer** - Data source abstraction and switching
* **Service Layer** - Data fetching and error handling
* **ViewModels** - State management and business logic
* **Search Logic** - Filtering and search accuracy

## Mock Objects

Mock implementations isolate dependencies for pure unit testing:

```swift
class MockJobRepository: JobRepositoryProtocol {
    // Mock implementation for testing
}
```

## Target Coverage

* 70%+ business logic coverage
* 80%+ critical path coverage
* All ViewModels covered

---

# Future Improvements

* ✅ REST API Integration
* ✅ Pagination & Infinite Scrolling
* ✅ SwiftData/Core Data for persistence
* ✅ Pull to Refresh
* ✅ Favorites/Bookmarks feature
* ✅ Advanced Filters
* ✅ Company Logos with caching
* ✅ Snapshot Testing
* ✅ CI/CD Pipeline (GitHub Actions)
* ✅ Firebase Analytics
* ✅ Firebase Crashlytics
* ✅ Push Notifications
* ✅ User Authentication
* ✅ Dark Mode Support

---

# Technologies Used

* **Language:** Swift 5.9+
* **UI Framework:** SwiftUI
* **Architecture:** CLEAN MVVM
* **Concurrency:** Async/Await
* **Testing:** XCTest
* **Design Pattern:** Dependency Injection, Repository Pattern
* **Minimum iOS:** iOS 16.0+

---

# Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

# Code Standards

* Follow Swift style guidelines
* Write unit tests for new features
* Maintain 70%+ code coverage
* Use meaningful variable and function names
* Document complex logic with comments
* Keep ViewModels lightweight
* Prefer protocols for abstraction

---

# Troubleshooting

### Build Failures

* Ensure Xcode 15+ is installed
* Clean build folder: `Cmd + Shift + K`
* Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/*`

### Tests Not Running

* Ensure all test files are added to the test target
* Check scheme settings: Product → Scheme → Edit Scheme

### JSON File Not Found

* Verify `jobs.json` is in `Resources` folder
* Check if file is added to target in Build Phases

---

# License

This project is licensed under the MIT License - see the LICENSE file for details.

---

# Author

Prashant KT
iOS Developer

**Repository:** [PrashantKT/RemoteRecruit](https://github.com/PrashantKT/RemoteRecruit)
