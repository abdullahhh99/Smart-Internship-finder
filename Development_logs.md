# Development Logs - InternSeek (Smart Internship Finder)

## Project Overview
InternSeek is a mobile application built to bridge the gap between academic credentials and industry requirements for fresh software engineering graduates. It addresses the "Cold Start" issue in recruitment by automating the matching process between student resumes and entry-level internship postings.

## Core Architecture: Two-Stage Ranking Pipeline
To ensure optimal performance, low latency, and token efficiency, the matching logic utilizes a hybrid approach:
1.  **Stage 1 (Local Filter):** A local Jaccard Similarity algorithm runs within the Flutter client. It compares parsed resume skills against Firebase job postings to instantly filter out irrelevant roles, producing a shortlist of 15-20 highly relevant jobs.
2.  **Stage 2 (Deep Semantic Ranker):** The shortlist and the parsed CV data are sent to the Gemini API. The LLM acts as the final decision-maker, evaluating deep semantic context to output the absolute Top 6 internship recommendations along with a concise Gap Analysis (Match Reason) for each.

## Technology Stack
* **Frontend:** Flutter (Dart) - Material Design 3
* **Backend:** Google Firebase (Authentication, Firestore NoSQL Database, Cloud Storage)
* **Intelligence Layer:** Google Gemini API
* **State Management:** Provider (Planned)

---

## Phase 1: Foundation & Frontend UI/UX
**Status:** In Progress

### Objectives
* Initialize standard Flutter project structure.
* Implement Firebase Authentication (OAuth / Email+Password).
* Design and build the primary UI screens (Authentication, Student Dashboard, Resume Upload UI, Job Feed).
* Establish state management baseline.

### Log Entries

* **[Date: TBD] - Project Initialization**
    * Initialized `Development_logs.md` to track architectural decisions and progress.
    * Finalized the Two-Stage Ranking Pipeline architecture to balance local computation with LLM API usage.
    * Development environment configured: VS Code + LDPlayer9 Android Emulator.

---
## Upcoming Tasks (Next Action Items)
- [ ] Run `flutter create internseek`
- [ ] Set up folder architecture (e.g., `/lib/screens`, `/lib/services`, `/lib/models`, `/lib/providers`).
- [ ] Connect the Flutter project to a new Firebase instance.
- [ ] Add base dependencies to `pubspec.yaml` (firebase_core, firebase_auth, cloud_firestore, provider).