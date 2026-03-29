import os
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
import requests
from dotenv import load_dotenv

# .env file එකකින් Token එක load කරගැනීමට (Security සඳහා)
load_dotenv()

app = FastAPI()

# Flutter App එකට connect වීමට CORS settings
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- CONFIGURATION ---
# GitHub Personal Access Token එක .env file එකක හෝ environment variable එකක තියෙන්න ඕනේ.
# GitHub -> Settings -> Developer Settings -> Personal access tokens -> Tokens (classic) -> Generate new token
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")

if not GITHUB_TOKEN:
    print("⚠️ WARNING: GITHUB_TOKEN not found. API rate limits will be very low.")

HEADERS = {
    "Accept": "application/vnd.github.v3+json",
}
if GITHUB_TOKEN:
    HEADERS["Authorization"] = f"token {GITHUB_TOKEN}"


# --- HELPERS ---
def fetch_github_data(url):
    try:
        response = requests.get(url, headers=HEADERS)
        if response.status_code == 200:
            return response.json()
        elif response.status_code == 404:
            raise HTTPException(status_code=404, detail="Repository not found")
        elif response.status_code == 403:
            raise HTTPException(status_code=403, detail="GitHub API rate limit exceeded")
        else:
            raise HTTPException(status_code=response.status_code, detail="Error fetching data")
    except requests.exceptions.RequestException as e:
        raise HTTPException(status_code=500, detail=str(e))

# --- ENDPOINTS ---
@app.get("/analyze")
def analyze_repository(owner: str = Query(...), repo_name: str = Query(...)):
    if not owner or not repo_name:
        raise HTTPException(status_code=400, detail="Owner and Repo Name are required")

    base_url = f"https://api.github.com/repos/{owner}/{repo_name}"
    
    # 1. Fetch Repository General Info (Stars, Forks, Issues)
    repo_info = fetch_github_data(base_url)
    
    # 2. Fetch Languages Data
    languages_url = f"{base_url}/languages"
    languages_raw = fetch_github_data(languages_url)
    
    # 3. Fetch Contributors (Get top 5)
    contributors_url = f"{base_url}/contributors?per_page=5"
    contributors_raw = fetch_github_data(contributors_url)

    # 4. Process Data
    total_bytes = sum(languages_raw.values())
    processed_languages = {}
    if total_bytes > 0:
        processed_languages = {
            lang: {
                "Bytes": bytes_count,
                "Percentage": round((bytes_count / total_bytes) * 100, 1)
            }
            for lang, bytes_count in languages_raw.items()
        }

    contributors = [
        {"login": c["login"], "avatar_url": c["avatar_url"], "contributions": c["contributions"]}
        for c in contributors_raw
    ]

    # Structure Final Response
    return {
        "repo_info": {
            "name": repo_info["name"],
            "owner": repo_info["owner"]["login"],
            "description": repo_info.get("description", "No description"),
            "stars": repo_info["stargazers_count"],
            "forks": repo_info["forks_count"],
            "open_issues": repo_info["open_issues_count"],
            "url": repo_info["html_url"],
            "created_at": repo_info["created_at"]
        },
        "languages": processed_languages,
        "contributors": contributors
    }

# Terminal එකේ run කරන්න:
# uvicorn main:app --host 0.0.0.0 --port 8000 --reload