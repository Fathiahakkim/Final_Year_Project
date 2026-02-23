import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

np.random.seed(42)

SAMPLES_PER_CLASS = 1300

CLASSES = [
    "NORMAL",
    "ENGINE",
    "ENGINE_COOLING",
    "FUEL_SYSTEM",
    "FUEL_PROPULSION",
    "GASOLINE",
    "DIESEL",
    "HYBRID_PROPULSION",
    "ELECTRICAL_SYSTEM",
    "POWER_TRAIN",
    "SERVICE_BRAKES",
    "TRACTION_CONTROL",
    "ESC",
    "VEHICLE_SPEED_CONTROL",
    "STEERING"
]

# ----------------------------
# Healthy Baseline Generator
# ----------------------------

def generate_baseline():
    rpm = np.random.normal(1500, 300)
    throttle = np.random.uniform(20, 50)
    engine_load = 0.6 * throttle + np.random.normal(0, 5)  # correlated
    coolant = np.random.normal(95, 4)
    speed = np.random.normal(60, 20)
    fuel_trim = np.random.normal(0, 4)
    o2_var = np.random.uniform(0.08, 0.18)
    battery = np.random.normal(14.0, 0.3)
    rpm_std = np.random.normal(90, 40)
    coolant_max = coolant + np.random.uniform(2, 6)

    return {
        "rpm_mean": rpm,
        "rpm_std": rpm_std,
        "coolant_mean": coolant,
        "coolant_max": coolant_max,
        "speed_mean": speed,
        "throttle_mean": throttle,
        "engine_load_mean": engine_load,
        "fuel_trim_mean": fuel_trim,
        "o2_var": o2_var,
        "battery_voltage_mean": battery
    }

# ----------------------------
# Fault Injection
# ----------------------------

def inject_fault(features, label):

    f = features.copy()

    if label == "ENGINE":
        f["rpm_std"] += np.random.normal(150, 60)
        f["fuel_trim_mean"] += np.random.normal(10, 5)

    elif label == "ENGINE_COOLING":
        f["coolant_mean"] += np.random.normal(15, 5)
        f["coolant_max"] = f["coolant_mean"] + np.random.uniform(5, 12)

    elif label == "FUEL_SYSTEM":
        f["fuel_trim_mean"] += np.random.normal(18, 6)
        f["o2_var"] += np.random.normal(0.15, 0.05)

    elif label == "ELECTRICAL_SYSTEM":
        f["battery_voltage_mean"] -= np.random.normal(2.0, 0.5)
        f["rpm_std"] += np.random.normal(40, 20)

    elif label == "POWER_TRAIN":
        f["rpm_mean"] += np.random.normal(1200, 400)
        f["engine_load_mean"] += np.random.normal(25, 8)

    elif label == "TRACTION_CONTROL":
        f["rpm_std"] += np.random.normal(120, 50)

    elif label == "ESC":
        f["rpm_std"] += np.random.normal(100, 40)

    elif label == "VEHICLE_SPEED_CONTROL":
        f["speed_mean"] += np.random.normal(60, 15)

    elif label == "STEERING":
        f["engine_load_mean"] += np.random.normal(15, 5)

    elif label == "GASOLINE":
        f["fuel_trim_mean"] += np.random.normal(8, 4)

    elif label == "DIESEL":
        f["engine_load_mean"] += np.random.normal(20, 6)

    elif label == "HYBRID_PROPULSION":
        f["rpm_mean"] -= np.random.normal(300, 150)

    elif label == "FUEL_PROPULSION":
        f["fuel_trim_mean"] += np.random.normal(12, 5)

    return f

# ----------------------------
# Noise Injection
# ----------------------------

def add_sensor_noise(features):
    noisy = {}
    for k, v in features.items():
        noise = np.random.normal(0, abs(v) * 0.02)  # 2% noise
        noisy[k] = v + noise
    return noisy

# ----------------------------
# Dataset Creation
# ----------------------------

data = []

for label in CLASSES:
    for _ in range(SAMPLES_PER_CLASS):
        base = generate_baseline()

        if label != "NORMAL":
            base = inject_fault(base, label)

        base = add_sensor_noise(base)
        base["label"] = label
        data.append(base)

df = pd.DataFrame(data)

# ----------------------------
# Train/Val/Test Split
# ----------------------------

train_df, temp_df = train_test_split(df, test_size=0.3, stratify=df["label"])
val_df, test_df = train_test_split(temp_df, test_size=0.5, stratify=temp_df["label"])

train_df.to_csv("obd_train.csv", index=False)
val_df.to_csv("obd_val.csv", index=False)
test_df.to_csv("obd_test.csv", index=False)

print("Train:", train_df.shape)
print("Val:", val_df.shape)
print("Test:", test_df.shape)