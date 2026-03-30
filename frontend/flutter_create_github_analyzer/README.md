<div align="center">

<img src="https://img.shields.io/badge/GitAnalyzer-Pro-0d1117?style=for-the-badge&logo=github&logoColor=white" alt="GitAnalyzer Pro" height="50"/>

# GitAnalyzer Pro

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)

### AI-Powered GitHub Repository Analysis — Instantly understand any GitHub profile.

[![Live Demo](https://img.shields.io/badge/🌐%20Live%20Demo-github--analyzer--pro.web.app-4285F4?style=for-the-badge)](https://github-analyzer-pro.web.app/)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Railway](https://img.shields.io/badge/Railway-0B0D0E?style=for-the-badge&logo=railway&logoColor=white)](https://railway.app/)

</div>

---

## 📖 About

**GitAnalyzer Pro** is an AI-powered GitHub repository analysis platform that turns raw GitHub data into meaningful insights — instantly. Enter any GitHub username and get a comprehensive breakdown of their public repositories: language distribution, popularity metrics, activity trends, and a downloadable PDF report — all in one clean, modern interface.

Built with a Flutter mobile frontend and a FastAPI backend, it's designed for developers, recruiters, and students who want a smarter way to explore GitHub profiles at a glance.

---

## ✨ Features

- 🔍 **Repository Analysis** — Fetch all public repos for any GitHub user with key metrics: stars, forks, and primary language
- 📊 **Data Visualization** — Interactive pie charts showing language distribution across a profile
- 📄 **PDF Report Generation** — Export a clean, shareable report with user details and repository statistics
- 🌓 **Dark & Light Mode** — Polished UI that adapts to your system preference
- ⚡ **High-Performance Backend** — Async FastAPI backend for fast, reliable data fetching

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Frontend** | Flutter (Dart), fl_chart, HTTP package |
| **Backend** | Python, FastAPI, Uvicorn, Requests |
| **Hosting (Frontend)** | Firebase Hosting |
| **Hosting (Backend)** | Railway |
| **Data Source** | GitHub REST API |

---

## 🧠 Architecture

```
Flutter App  →  FastAPI Backend  →  GitHub REST API
     ↑               ↓
  UI Render  ←  Processed JSON + PDF Reports
```

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/GitAnalyzer-Pro.git
cd GitAnalyzer-Pro
```

### 2. Backend Setup (FastAPI + Railway)

```bash
cd backend
python -m venv venv
venv\Scripts\activate        # Windows
# source venv/bin/activate   # macOS/Linux

pip install fastapi uvicorn requests
uvicorn main:app --reload
```

API runs at: `http://127.0.0.1:8000`

### 3. Frontend Setup (Flutter + Firebase)

```bash
cd frontend
flutter pub get
flutter run
```

> ⚠️ **Android Emulator:** Use `http://10.0.2.2:8000` instead of `http://127.0.0.1:8000`

---

## 🔗 API Reference

### `GET /user/{username}`

Fetch all public repositories for a GitHub user.

**Example:**
```
GET /user/octocat
```

**Response:**
```json
[
  {
    "name": "Hello-World",
    "stars": 2500,
    "forks": 1800,
    "language": "Python"
  }
]
```

---

## 📂 Project Structure

```
GitAnalyzer-Pro/
│
├── backend/
│   ├── main.py
│   └── requirements.txt
│
├── frontend/
│   ├── lib/
│   └── pubspec.yaml
│
└── README.md
```

---

## 🔮 Roadmap

- [ ] GitHub OAuth authentication
- [ ] Commit history & activity graphs
- [ ] Advanced filtering and search
- [ ] AI-generated profile summaries
- [ ] Docker support

---

## 👤 Author

**AmeeSha NimsiTh**

🎓 Data Science Undergraduate · 💻 Backend & Mobile Developer · 🌍 Open Source Enthusiast

---

## 📜 License

This project is open-source and available under the [MIT License](LICENSE).

---

<div align="center">

⭐ If you found this useful, consider giving it a star!

</div>