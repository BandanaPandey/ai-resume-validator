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


# 🧱 SYSTEM DESIGN DIAGRAM
                    ┌──────────────────────┐
                    │      Frontend        │
                    │      (React)         │
                    │  - Login/Signup      │
                    │  - ATS UI            │
                    └─────────┬────────────┘
                              │ HTTPS (JWT)
                              ▼
                    ┌──────────────────────┐
                    │   Rails API Backend  │
                    │  (Authentication)    │
                    │                      │
                    │ Controllers          │
                    │ - AuthController     │
                    │ - JobsController     │
                    │ - ReportsController  │
                    └─────────┬────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼

┌──────────────────┐  ┌──────────────────┐  ┌────────────────────┐
│  AI Layer        │  │  Business Logic  │  │  File Processing   │
│ - LLM Provider   │  │ - SkillGap       │  │ - PDF Parser       │
│ - Embeddings     │  │ - Ranker         │  │ - Resume Extract   │
│ - AI Summary     │  │ - Smart Score    │  │                    │
└────────┬─────────┘  └────────┬─────────┘  └────────┬───────────┘
         │                      │                      │
         └──────────────┬───────┴──────────────┬───────┘
                        ▼                      ▼

                ┌──────────────────────────────┐
                │     PostgreSQL + pgvector   │
                │ - Users                     │
                │ - Jobs                      │
                │ - Candidates                │
                │ - Skills (embeddings)       │
                └──────────────────────────────┘

---

# 🔹 Request Flow (Important)
1. User logs in → JWT issued
2. User submits job + resumes
3. Backend:
   → Extract skills (AI + dictionary)
   → Generate embeddings
   → Semantic matching (pgvector)
   → Compute scores
   → Rank candidates
4. Response → React UI
5. Optional:
   → Generate PDF
   → Send Email (with AI summary)


---

# 🔹 Key Components
* Backend
* Auth (JWT)
* Skill extraction + semantic matching
* Smart scoring engine
* Candidate ranking
* PDF + Email service
* Database
* PostgreSQL + pgvector (vector search)
* AI Layer
* LLM (OpenAI / Ollama)
* Embeddings

---

# ☁️ DEPLOYMENT GUIDE
# 🚀 OPTION 1: AWS (Production-Grade)

## 🧱 Architecture (AWS)
* React → S3 + CloudFront
* Rails API → EC2 / ECS
* Postgres → RDS
* Files → S3
* Background Jobs → Sidekiq + Redis (ElastiCache)

## 🔹 Step-by-Step

## 1️⃣ Frontend Deployment (S3 + CloudFront)
npm run build

✅ Fast global delivery

## 2️⃣ Backend Deployment (Rails)
*Option A: EC2 (Simple)
*Launch: Amazon EC2
* sudo apt install ruby nodejs nginx
* git clone your-repo
* bundle install
* rails db:migrate

Run:

puma -C config/puma.rb

Use NGINX as reverse proxy

Option B: ECS (Scalable)
* Use Docker
* Deploy via: Amazon ECS

## 3️⃣ Database (RDS)
Create:
* Amazon RDS
* PostgreSQL + pgvector enabled

## 4️⃣ File Storage (PDF resumes)
Store in: Amazon S3

## 5️⃣ Background Jobs

Use:

* Sidekiq
* Amazon ElastiCache

## 6️⃣ Environment Variables

Use:

* RAILS_ENV=production
* DATABASE_URL=...
* JWT_SECRET=...
* OPENAI_API_KEY=...

##💡 AWS COST OPTIMIZED SETUP
* EC2 (t3.micro)
* RDS (db.t3.micro)
* S3 (cheap storage)
* CloudFront (optional)


# 🚀 OPTION 2: DIGITALOCEAN (SIMPLER + CHEAPER)

## 🧱 Architecture
* React → App Platform / Static Hosting
* Rails → Droplet
* Postgres → Managed DB

## 🔹 Step-by-Step

## 1️⃣ Create Droplet
* DigitalOcean Droplet
* Ubuntu + 2GB RAM recommended

## 2️⃣ Setup Backend
* sudo apt update
* sudo apt install ruby-full nodejs nginx git
* git clone your-repo
* bundle install
* rails db:migrate

Run:

RAILS_ENV=production rails s -b 0.0.0.0

## 3️⃣ Setup PostgreSQL

Use:

* DigitalOcean Managed PostgreSQL

* Enable pgvector:

* CREATE EXTENSION vector;

## 4️⃣ Frontend Deployment

* Option A: DigitalOcean App Platform

* Option B: NGINX static hosting

 ## 5️⃣ NGINX Setup
server {
  location / {
    root /var/www/react-build;
  }

  location /api {
    proxy_pass http://localhost:3000;
  }
}
