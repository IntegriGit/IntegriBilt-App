from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from google.oauth2 import service_account
from googleapiclient.discovery import build
import os

app = FastAPI(title="Google Drive MCP Server")

# Load credentials from a service account JSON file
SERVICE_ACCOUNT_FILE = os.getenv("GOOGLE_SERVICE_ACCOUNT_FILE", "service_account.json")
SCOPES = ["https://www.googleapis.com/auth/drive.metadata.readonly"]

# Initialize Google Drive API client
def get_drive_service():
    try:
        credentials = service_account.Credentials.from_service_account_file(
            SERVICE_ACCOUNT_FILE, scopes=SCOPES
        )
        service = build("drive", "v3", credentials=credentials)
        return service
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error setting up Google Drive API: {str(e)}")

@app.get("/")
def read_root():
    return {"status": "Google Drive MCP Server is running."}

@app.get("/files")
def list_drive_files():
    try:
        service = get_drive_service()
        results = service.files().list(
            pageSize=10,
            fields="nextPageToken, files(id, name)"
        ).execute()
        files = results.get("files", [])
        return {"files": files}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
