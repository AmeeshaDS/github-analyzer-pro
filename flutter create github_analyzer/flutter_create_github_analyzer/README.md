# 🚀 GitAnalyzer Pro – GitHub Repository Analysis Platform

**GitAnalyzer Pro** is a full-stack application that provides deep analytical insights into GitHub repositories.
It combines a **Flutter mobile frontend** with a **FastAPI backend** to fetch, process, and visualize repository data in real time.

---

## 📌 Overview

This project is designed to help developers, students, and recruiters quickly understand a GitHub profile by analyzing repository data such as:

* Programming language distribution
* Repository popularity (stars & forks)
* Project activity insights

The system follows a **client-server architecture**, ensuring scalability and clean separation of concerns.

---

## 🧠 System Architecture

```
Flutter App (Frontend)
        ↓ HTTP Requests
FastAPI Backend (Python)
        ↓
GitHub REST API
        ↓
Processed JSON Response → UI Rendering & PDF Reports
```

---

## ✨ Features

### 🔍 Repository Analysis

* Fetch all public repositories of a GitHub user
* Extract key metrics:

  * Repository name
  * Stars ⭐
  * Forks 🍴
  * Primary language

---

### 📊 Data Visualization

* Language distribution displayed using **interactive pie charts**
* Clean and structured UI for readability

---

### 📄 PDF Report Generation

* Generate downloadable reports containing:

  * User details
  * Repository statistics
  * Language breakdown

---

### 🌓 Modern UI/UX

* Dark mode & light mode support
* Responsive layout for mobile devices

---

### ⚡ High-Performance Backend

* Built with **FastAPI** for speed and async support
* Efficient API handling using `requests`

---

## 🛠️ Tech Stack

### Frontend

* Flutter (Dart)
* HTTP package
* fl_chart (for visualization)

### Backend

* Python
* FastAPI
* Uvicorn
* Requests library

### Tools

* Git & GitHub
* VS Code

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
│   ├── pubspec.yaml
│
└── README.md
```

---

## ⚙️ Installation & Setup

### 🔹 1. Clone Repository

```
git clone https://github.com/your-username/GitAnalyzer-Pro.git
cd GitAnalyzer-Pro
```

---

### 🔹 2. Backend Setup (FastAPI)

```
cd backend
python -m venv venv
venv\Scripts\activate
pip install fastapi uvicorn requests
```

Run server:

```
uvicorn main:app --reload
```

API will run at:

```
http://127.0.0.1:8000
```

---

### 🔹 3. Frontend Setup (Flutter)

```
cd frontend
flutter pub get
flutter run
```

⚠️ For Android Emulator:

```
Use: http://10.0.2.2:8000
Instead of: http://127.0.0.1:8000
```

---

## 🔗 API Endpoints

### Get User Repositories

```
GET /user/{username}
```

#### Example:

```
/user/octocat
```

#### Response:

```json
[
  {
    "name": "repo-name",
    "stars": 120,
    "language": "Python"
  }
]
```

---

## 🚧 Future Improvements

* 🔐 GitHub OAuth authentication
* 📈 Advanced analytics (commit history, activity graphs)
* ☁️ Deployment (Docker / Cloud hosting)
* 🔎 Search and filtering options

---

## 🤝 Contribution

Contributions are welcome!

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a Pull Request

---

## 👤 Author

Developed by **AmeeSha NimsiTh**

* 🎓 Data Science Undergraduate
* 💻 Interested in Backend & Mobile Development
* 🌍 Aspiring Open Source Contributor

---

## 📜 License

This project is open-source and available under the MIT License.