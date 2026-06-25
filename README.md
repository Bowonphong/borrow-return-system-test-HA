# 📦 ระบบยืม-คืนของ (Borrow & Return System)

ระบบยืม-คืนของแบบ offline/online ทำงานบนโน๊ตบุ๊คเครื่องเดียว  
รองรับ **Windows 10/11** และ **Linux (Ubuntu 20.04+)**  
พัฒนาด้วย Python + FastAPI + SQLite + Face Recognition + Home Assistant Integration

---

## 👨‍💻 ผู้จัดทำ

| ชื่อ-นามสกุล | บทบาท |
|---|---|
| **นายบวรพงศ์ นาคสุข** | ผู้พัฒนาระบบ (Developer) |

---

## 📋 รายละเอียดโปรเจค

**ระบบยืม-คืนของ** เป็นแอปพลิเคชัน Web-based ที่พัฒนาขึ้นเพื่อบริหารจัดการการยืม-คืนสิ่งของ โดยมีคุณสมบัติดังนี้:

- **จดจำใบหน้า (Face Recognition)** — ระบบสแกนใบหน้าผู้ยืมโดยอัตโนมัติผ่านกล้อง WebCam โดยใช้ไลบรารี `face_recognition` และ `OpenCV`
- **สแกนบาร์โค้ด** — รองรับการใช้งาน Barcode Scanner เพื่อลงทะเบียนและระบุสิ่งของ
- **Smart Scan** — ระบบตรวจสอบสถานะสิ่งของอัตโนมัติ (ยืม/คืน) และป้องกันการทำซ้ำ
- **ฐานข้อมูล SQLite** — จัดเก็บข้อมูลผู้ใช้, สิ่งของ, และประวัติการยืม-คืนแบบ offline
- **เชื่อมต่อ Home Assistant** — รองรับการส่งข้อมูลผ่าน REST API และ MQTT เพื่อแสดงผลบน Dashboard และ Automation
- **Web UI** — หน้าเว็บใช้งานง่าย เข้าถึงได้ผ่าน Browser ทุกอุปกรณ์ในเครือข่าย

### 🛠️ เทคโนโลยีที่ใช้

| ส่วน | เทคโนโลยี |
|------|-----------|
| Backend | Python 3.10+, FastAPI, Uvicorn |
| ฐานข้อมูล | SQLite (ผ่าน `database.py`) |
| จดจำใบหน้า | `face_recognition`, `dlib`, OpenCV |
| Frontend | HTML, CSS, JavaScript (Single Page) |
| Home Assistant | REST API, MQTT (paho-mqtt) |
| อื่นๆ | Pydantic, Numpy |

---

## 📁 โครงสร้างโฟลเดอร์

```
borrow-return-system/
├── main.py              ← FastAPI backend (entry point)
├── database.py          ← SQLite operations (CRUD ผู้ใช้, สิ่งของ, ประวัติ)
├── face_manager.py      ← Webcam + face recognition (encode/recognize)
├── ha_integration.py    ← Home Assistant (REST API / MQTT)
├── config.py            ← การตั้งค่าทั้งหมด (Camera, HA, MQTT, Server)
├── requirements.txt     ← Python dependencies
├── Dockerfile           ← สำหรับ deploy บน Docker
├── build.yaml           ← CI/CD configuration
├── run.sh               ← Shell script รันระบบ (Linux)
├── static/
│   ├── index.html       ← Web UI หน้าหลัก (ยืม-คืนของ)
│   └── admin.html       ← Web UI หน้า Admin (จัดการผู้ใช้/สิ่งของ)
└── data/                ← สร้างอัตโนมัติตอนรัน
    ├── borrow.db        ← ฐานข้อมูล SQLite
    └── faces/           ← ภาพ face encoding ของผู้ใช้ (.npy)
```

---

## ⚙️ ขั้นตอนติดตั้ง

### 1. ติดตั้ง Python 3.10+

**Windows:** ดาวน์โหลดจาก https://python.org  
**Linux:** `sudo apt install python3 python3-pip python3-venv`

### 2. สร้าง Virtual Environment

```bash
# เข้าไปใน folder
cd borrow-return-system

# สร้าง venv
python -m venv venv

# Activate
# Windows:
venv\Scripts\activate
# Linux/Mac:
source venv/bin/activate
```

### 3. ติดตั้ง face_recognition (สำคัญ — ทำก่อน pip install)

#### Windows

```bash
# ติดตั้ง CMake ก่อน
pip install cmake

# ติดตั้ง dlib (pre-built wheel สำหรับ Python 3.12 Windows)
pip install dlib-19.24.99-cp312-cp312-win_amd64.whl

# หรือดาวน์โหลด wheel จาก GitHub สำหรับ Python เวอร์ชันอื่น:
# pip install https://github.com/jloh02/dlib/releases/download/v19.22/dlib-19.22.99-cp310-cp310-win_amd64.whl

# ติดตั้ง face_recognition
pip install face_recognition
```

> **หมายเหตุ:** ในโปรเจคนี้มีไฟล์ `dlib-19.24.99-cp312-cp312-win_amd64.whl` สำหรับ Python 3.12 บน Windows อยู่แล้ว สามารถใช้ได้เลย

#### Linux (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install -y build-essential cmake python3-dev
sudo apt install -y libopenblas-dev liblapack-dev libx11-dev

pip install dlib face_recognition
```

### 4. ติดตั้ง Dependencies ที่เหลือ

```bash
pip install -r requirements.txt
```

รายการ dependencies หลัก:

| Package | เวอร์ชัน | หน้าที่ |
|---------|---------|---------|
| `fastapi` | 0.111.0 | Web Framework |
| `uvicorn[standard]` | 0.30.1 | ASGI Server |
| `opencv-python` | 4.9.0.80 | จัดการภาพจากกล้อง |
| `numpy` | 1.26.4 | คำนวณ face encoding |
| `face_recognition` | 1.3.0 | จดจำใบหน้า |
| `requests` | 2.32.2 | เรียก Home Assistant REST API |
| `paho-mqtt` | 1.6.1 | เชื่อมต่อ MQTT Broker |

---

## 🔧 การตั้งค่า config.py

เปิดไฟล์ `config.py` และปรับค่าตามความต้องการ:

```python
# --- Camera ---
CAMERA_INDEX = 0                    # 0 = กล้องแรก, 1 = กล้องที่สอง
FACE_RECOGNITION_TOLERANCE = 0.55  # ค่าความเข้มงวดในการจดจำใบหน้า (0.4–0.65)
FACE_CAPTURE_ATTEMPTS = 40         # จำนวน frame ที่พยายามจับใบหน้า

# --- Paths ---
DB_PATH   = "data/borrow.db"       # ตำแหน่งฐานข้อมูล
FACES_DIR = "data/faces"           # ตำแหน่งเก็บภาพใบหน้า

# --- Web Server ---
HOST = "0.0.0.0"                   # รับการเชื่อมต่อจากทุก interface
PORT = 8000                        # พอร์ตเริ่มต้น (ระบบหาพอร์ตว่างอัตโนมัติ)
```

---

## 🏠 เชื่อมต่อ Home Assistant

### วิธีที่ 1: REST API (แนะนำ)

1. เปิด Home Assistant → โปรไฟล์ → **Long-Lived Access Tokens** → สร้าง token
2. แก้ `config.py`:

```python
HA_ENABLED = True
HA_URL     = "http://192.168.1.xxx:8123"   # IP ของ Home Assistant
HA_TOKEN   = "eyJhbGciOiJIUzI1NiIs..."    # Token ที่ได้
```

3. เพิ่ม Sensor ใน `configuration.yaml` ของ HA:

```yaml
template:
  - sensor:
      - name: "Borrow Last Action"
        unique_id: borrow_last_action
        state: "{{ states('sensor.borrow_last_action') }}"
      - name: "Borrow Total Borrowed"
        unique_id: borrow_total_borrowed
        state: "{{ states('sensor.borrow_total_borrowed') }}"
```

4. เพิ่ม Automation ตัวอย่าง:

```yaml
- alias: "แจ้งเตือนเมื่อยืมของ"
  trigger:
    - platform: event
      event_type: borrow_system_borrow
  action:
    - service: notify.notify
      data:
        message: >
          {{ trigger.event.data.user_name }} ยืม {{ trigger.event.data.item_name }}
```

### วิธีที่ 2: MQTT

1. ติดตั้ง Mosquitto broker ใน HA (Add-on Store)
2. แก้ `config.py`:

```python
MQTT_ENABLED      = True
MQTT_HOST         = "localhost"      # หรือ IP ของ Home Assistant
MQTT_PORT         = 1883
MQTT_USER         = "mqtt_user"
MQTT_PASSWORD     = "mqtt_pass"
MQTT_TOPIC_PREFIX = "borrow_system"
```

3. Topics ที่ระบบส่ง:
   - `borrow_system/borrow` — เมื่อมีการยืม
   - `borrow_system/return` — เมื่อมีการคืน
   - `borrow_system/status/total_borrowed` — จำนวนที่ยืมอยู่

4. ใน HA `configuration.yaml`:

```yaml
mqtt:
  sensor:
    - name: "Total Borrowed"
      state_topic: "borrow_system/status/total_borrowed"
      value_template: "{{ value_json.value }}"
```

---

## ▶️ วิธีรันระบบ

```bash
# Activate venv ก่อน
venv\Scripts\activate        # Windows
source venv/bin/activate     # Linux

# รันระบบ
python main.py
```

ระบบจะค้นหาพอร์ตว่างโดยอัตโนมัติ เริ่มจาก **8000**  
เปิด browser ที่ `http://localhost:8000`

---

## 📖 วิธีใช้งาน

### การยืมของ
1. ไปแท็บ **ยืมของ**
2. กด **เปิดกล้อง** เพื่อดูตัวอย่างภาพจากกล้อง
3. กด **จดจำใบหน้า** — ให้ผู้ยืมมองตรงกล้อง ระบบจะระบุชื่อผู้ยืมอัตโนมัติ
   - (หรือเลือกผู้ใช้เองจาก dropdown ถ้ายังไม่ได้ลงทะเบียนใบหน้า)
4. สแกนบาร์โค้ดสิ่งของในช่อง (Scanner พิมพ์ค่าอัตโนมัติ → กด Enter)
5. กด **บันทึกการยืม**

### การคืนของ
- **ผ่านบาร์โค้ด:** สแกนบาร์โค้ดสิ่งของ → กด **คืนของ**
- **ผ่านใบหน้า:** สแกนใบหน้า → ระบบแสดงรายการที่ยืม → เลือกกด **คืน**

### Smart Scan (ยืม-คืนอัตโนมัติ)
- ระบบตรวจสอบสถานะสิ่งของอัตโนมัติ
- ถ้าสิ่งของถูกยืมอยู่แล้วจะ **คืนให้อัตโนมัติ**
- ถ้ายังไม่ได้ยืมจะ **บันทึกการยืม**
- ป้องกันการทำซ้ำหรือทำผิดโหมด

### เพิ่มผู้ใช้
1. แท็บ **ผู้ใช้** → ใส่ชื่อ → กด **เพิ่มผู้ใช้**
2. ให้ผู้ใช้มองตรงกล้อง ระบบจะจับภาพใบหน้าและสร้าง face encoding อัตโนมัติ

### เพิ่มสิ่งของ
แท็บ **สิ่งของ** → สแกนบาร์โค้ด → ใส่ชื่อ (และคำอธิบาย/จำนวนวันยืมสูงสุด) → **เพิ่มสิ่งของ**

---

## 🌐 API Endpoints

| Method | Endpoint | คำอธิบาย |
|--------|----------|----------|
| GET | `/api/status` | สถานะระบบ (จำนวนผู้ใช้, สิ่งของ, ยืมอยู่) |
| GET | `/api/users` | รายชื่อผู้ใช้ทั้งหมด |
| POST | `/api/users` | เพิ่มผู้ใช้ (พร้อมจับภาพใบหน้าผ่านกล้อง) |
| POST | `/api/users/with_image` | เพิ่มผู้ใช้พร้อม face image (base64) |
| PATCH | `/api/users/{id}` | แก้ไขข้อมูลผู้ใช้ |
| DELETE | `/api/users/{id}` | ลบผู้ใช้ |
| GET | `/api/items` | รายการสิ่งของทั้งหมด |
| POST | `/api/items` | เพิ่มสิ่งของ |
| PATCH | `/api/items/{id}` | แก้ไขข้อมูลสิ่งของ |
| DELETE | `/api/items/{id}` | ลบสิ่งของ |
| POST | `/api/borrow` | บันทึกการยืม |
| POST | `/api/return` | บันทึกการคืน |
| POST | `/api/smart_scan` | ยืม/คืนอัตโนมัติตามสถานะ |
| GET | `/api/borrowed` | รายการที่ยืมอยู่ปัจจุบัน |
| GET | `/api/history` | ประวัติการยืม-คืนทั้งหมด |
| POST | `/api/camera/recognize_frame` | จดจำใบหน้าจาก frame (base64) |

---

## 🔍 แก้ปัญหาที่พบบ่อย

| ปัญหา | วิธีแก้ |
|-------|---------|
| กล้องไม่เปิด | เปลี่ยน `CAMERA_INDEX = 1` ใน config.py |
| face_recognition ติดตั้งไม่ได้ | ดูขั้นตอน Windows/Linux ด้านบน ต้องติดตั้ง cmake และ dlib ก่อน |
| บาร์โค้ด Scanner ไม่ทำงาน | คลิก input field ก่อนสแกน (Scanner ส่งค่าเหมือน keyboard) |
| HA ไม่ตอบสนอง | ตรวจสอบ IP, port 8123, และ Token ใน config.py |
| port 8000 ถูกใช้งาน | ระบบจะหาพอร์ตว่างถัดไปอัตโนมัติ หรือแก้ `PORT = 8001` ใน config.py |
| ใบหน้าจดจำไม่ได้ | ปรับค่า `FACE_RECOGNITION_TOLERANCE` (ลดให้ต่ำลง เช่น 0.5 = เข้มงวดขึ้น) |
| `setuptools` error | ใช้ `setuptools<81` ตามที่ระบุใน requirements.txt |

---

## 🐳 รันด้วย Docker

```bash
# Build image
docker build -t borrow-system .

# Run container
docker run -p 8000:8000 --device=/dev/video0 borrow-system
```

> **หมายเหตุ:** การใช้กล้องใน Docker บน Windows อาจต้องการการตั้งค่าเพิ่มเติม

---

## 🔄 รัน Auto-start (Linux systemd)

```ini
# /etc/systemd/system/borrow-system.service
[Unit]
Description=Borrow Return System
After=network.target

[Service]
User=pi
WorkingDirectory=/home/pi/borrow-return-system
ExecStart=/home/pi/borrow-return-system/venv/bin/python main.py
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable borrow-system
sudo systemctl start borrow-system
```

---

*พัฒนาโดย **นายบวรพงศ์ นาคสุข***
