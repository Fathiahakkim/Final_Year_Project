import httpx
api_url = "https://api-inference.huggingface.co/models/Anshi2003/obd-rf-model"
# let's try just a dict
payload = {"inputs": {"feature1": 1.0}} 
response = httpx.post(api_url, json=payload, timeout=30.0)
print("status", response.status_code)
print(response.text)
