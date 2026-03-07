import httpx
api_url = "https://api-inference.huggingface.co/models/Anshi2003/obd-rf-model"
payload = {"inputs": [[0.0]*200]} # Mock input
response = httpx.post(api_url, json=payload, timeout=30.0)
print(response.status_code)
print(response.text)
