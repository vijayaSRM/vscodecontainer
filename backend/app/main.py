from typing import Union
from fastapi import FastAPI
from fastapi.responses import JSONResponse
import mangum
import uvicorn
from typing import Union

app = FastAPI()

@app.get("/")
def read_root():
   return {"Welcome to": "My first FastAPI depolyment using Docker image"}

@app.get("/{text}")
def read_item(text: str):
   return JSONResponse({"result": text})

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
   return JSONResponse({"item_id": item_id, "q": q})

#if __name__ == "__main__":
#   uvicorn.run(app, host="0.0.0.0", port=8000)