# 🔒 Self-Hosted VPN Analysis Project
[Demo of VPN](https://youtu.be/xHemKKHjR0s?si=WPD2a_4SGnNQTny4)

## 📋 Overview

A comprehensive analysis comparing commercial VPN services (NordVPN) against a self-hosted OpenVPN solution. The project investigates network performance, security implications, and potential information leakage across different VPN protocols.

## 🎯 Project Goals

- **🚀 Performance Analysis**: Compare NordVPN (WireGuard) vs self-hosted OpenVPN
- **🔐 Security Assessment**: Analyze traffic for information leakage and encryption effectiveness
- **💰 Cost-Benefit Analysis**: Evaluate commercial vs self-hosted VPN trade-offs
- **📊 Traffic Analysis**: Use Wireshark and custom tools for packet analysis

## ⚙️ Technical Implementation

### 🛡️ VPN Solutions Tested
- **🏢 Commercial VPN**: NordVPN (WireGuard protocol)
- **🏠 Self-Hosted VPN**: OpenVPN server on AWS EC2

### 🏗️ Infrastructure
- **☁️ Cloud Platform**: AWS EC2 (Ubuntu VM)
- **🔗 VPN Protocol**: OpenVPN Access Server
- **🔧 Analysis Tools**: Wireshark, tcpdump, custom Python/Bash scripts

## 📈 Key Findings

### ⚡ Performance
- Self-hosted VPN showed slower speeds due to VM limitations
- NordVPN demonstrated faster packet transfer rates with WireGuard
- Both solutions effectively encrypted traffic

### 🔒 Security
- OpenVPN and WireGuard both provide strong encryption
- Minimal information leakage detected
- Self-hosted VPN offers greater security control

### 💡 Resources
- Self-hosted requires technical expertise for setup/maintenance
- Commercial VPNs provide better infrastructure for high traffic
- Self-hosted has ongoing VM rental costs

## 📁 Project Structure

```
myvpn/
├── 📊 analysis/           # Network analysis results
│   ├── 🔐 encryption/     # Encryption comparisons
│   ├── ⚡ speed/         # Speed test results
│   └── 🌐 traceroute/    # Network path analysis
├── 📸 screenshots/       # Setup screenshots
├── 🐚 analysis.sh        # Automated analysis script
├── 🐍 networkCapture.py  # Python packet capture
└── 📄 deliverable.md     # Project documentation
```

## 🚀 Usage

```bash
# Basic network capture
./analysis.sh -i tun0 -d 60

# Custom analysis
./analysis.sh -i eth0 -d 300 -f "port 443" -v

# Python packet capture
python3 networkCapture.py -f "host 54.93.220.40" -t 60
```

## 👨‍💻 Author

**👤 Koffison Voumadi** - Technical implementation and research

---

🔬 This project demonstrates practical VPN technology analysis, providing insights into commercial vs self-hosted VPN solutions for network security and privacy.
