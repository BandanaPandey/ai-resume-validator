# 🚀 AI-Powered ATS (Applicant Tracking System)

An intelligent **ATS platform** that analyzes resumes against job descriptions using **AI + semantic matching + scoring**, and ranks candidates with actionable insights.

---

# ✨ Features

## 🔐 Authentication

* JWT-based **Signup / Login**
* User-specific data isolation
* Secure API access

---

## 🧠 AI Skill Analysis

* Resume & Job skill extraction (AI + dictionary)
* Semantic skill matching using embeddings
* Skill normalization & deduplication

---

## 📊 Advanced Scoring System

### 1. Basic Match Score

* % of matched skills

### 2. Weighted Score

* Job-specific skill importance

### 3. Smart Score (Final Score)

Combines:

* Skill match weight
* Skill proficiency
* Experience detection
* Keyword relevance
* Impact words
* Penalties for:

  * Missing critical skills
  * Weak proficiency

---

## 🎯 Skill Intelligence

* 🔥 **Critical Missing Skills**
* ⚠️ **Weak Skills (low proficiency)**
* 🧠 **AI-based Skill Proficiency Detection**
* 📈 Job-specific skill weighting

---

## 🏆 Candidate Ranking

* ATS-style ranking system
* Smart scoring-based sorting
* Rank assignment (1, 2, 3…)

---

## 🤖 AI Features

* AI-generated candidate comparison
* AI recruiter summary in email reports
* Context-aware hiring recommendations

---

## 📄 Reports & Sharing

* Download **PDF reports**
* Email:

  * Top candidates
  * Selected candidates
* AI summary included in email body

---

## 🖥️ Frontend (React)

* Job input + multiple candidates
* Resume upload (PDF supported)
* Candidate cards with:

  * Score
  * Decision (Hire / Reject)
* Ranking table with:

  * Select candidates
  * Select All (Top 10)
  * Bulk actions:

    * Download
    * Email
* Candidate comparison view

---

# 🏗️ Architecture

```text
Frontend (React)
   ↓
Rails API (JWT Auth)
   ↓
AI + Services Layer
   ↓
PostgreSQL + pgvector
```

---

# 🧩 Core Components

## Backend (Rails)

### Services

* `SkillExtractionService`
* `SemanticSkillMatcher`
* `VectorSearchService`
* `SkillProficiencyService`
* `JobSkillWeighter`
* `SmartScoreService`
* `CandidateRanker`
* `CandidateSummaryService`

### Models

* `User`
* `Job`
* `Candidate`
* `Skill` (with embeddings)

---

## Frontend (React)

### Pages

* `Login`
* `Signup`
* `Dashboard`
* `JobRankingPage`

### Components

* `JobForm`
* `RankingTable`
* `CandidateCard`
* `CandidateComparison`

---

# 🔐 Authentication Flow

```text
Signup/Login → JWT Token → Stored in localStorage
→ Sent via Authorization header
→ Backend validates user
```

---

# 🔄 User Flow

```text
Login → Dashboard
→ Enter Job Description
→ Add Candidates (text or PDF)
→ Analyze
→ View Rankings
→ Select Candidates
→ Download / Email Reports
```

---

# 🧠 Smart Scoring Logic

```text
Final Score =
  Weighted Skill Score
+ Proficiency Bonus
+ Experience Score
+ Keyword Match Score
+ Impact Score
- Penalties (Critical Missing + Weak Skills)
```

---

# 📦 API Endpoints

## Auth

* `POST /api/signup`
* `POST /api/login`

## Jobs

* `POST /api/jobs`
* `GET /api/jobs`

## Reports

* `POST /api/reports/email`
* `POST /api/reports/download`

---

# 🛠️ Setup Instructions

## Backend

```bash
bundle install
rails db:create db:migrate
rails server
```

## Frontend

```bash
npm install
npm start
```

---

# 🧪 Key Technologies

* Ruby on Rails
* React.js
* PostgreSQL + pgvector
* JWT Authentication
* LLM Integration (OpenAI / Ollama)

---

# 🔥 Highlights

* Production-style ATS system
* AI-powered decision making
* Recruiter-friendly workflows
* Modular, scalable architecture

---

# 🚀 Future Improvements

* OAuth (Google / LinkedIn)
* Role-based access (Admin / Recruiter)
* Job history & analytics
* Bias detection
* Real-time collaboration

---

# 👩‍💻 Author Notes

This project evolved into a **full ATS system** with:

* AI-driven matching
* Recruiter workflows
* Secure multi-user support
* Smart scoring engine

Use this as:

* A learning project
* A production base
* A SaaS ATS foundation

---

# ⭐ Final Thought

This is not just a resume matcher —
it’s a **decision-making engine for hiring**.
