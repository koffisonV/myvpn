#!/usr/bin/env bash
set -euo pipefail

# default parameters
IFACE="tun0"
DURATION=60 # seconds
OUTDIR="./net_analysis"
PCAP_FILE="capture_$(date +%Y%m%d_%H%M%S).pcap"
LOG_FILE="analysis.log"
FILTER="" # tcpdump filter
MAX_ENDPOINTS=50
VERBOSE=false

usage() {
  cat <<EOF
Usage: $0 [-i interface] [-d duration] [-o outdir] [-f filter] [-n max_endpoints] [-v] [-h]
  -i IFACE        network interface (default: tun0)
  -d DURATION     capture duration in seconds (default: 60)
  -o OUTDIR       output directory (default: ./net_analysis)
  -f FILTER       tcpdump filter expression (e.g., "port 80")
  -n MAX_ENDPOINTS maximum endpoints to show (default: 50)
  -v              verbose output
  -h              show this help message

Examples:
  $0 -i eth0 -d 120 -f "port 443"
  $0 -i wlan0 -d 300 -o /tmp/capture -v
EOF
  exit 1
}

log_msg() {
  local msg="[$(date +'%Y-%m-%d %H:%M:%S')] $1"
  echo "$msg" | tee -a "$LOG_FILE"
}

verbose_log() {
  if [[ "$VERBOSE" == true ]]; then
    log_msg "$1"
  fi
}

# parse args
while getopts "i:d:o:f:n:vh" opt; do
  case $opt in
    i) IFACE="$OPTARG" ;;
    d) DURATION="$OPTARG" ;;
    o) OUTDIR="$OPTARG" ;;
    f) FILTER="$OPTARG" ;;
    n) MAX_ENDPOINTS="$OPTARG" ;;
    v) VERBOSE=true ;;
    h) usage ;;
    *) usage ;;
  esac
done

# validate numeric inputs
if ! [[ "$DURATION" =~ ^[0-9]+$ ]] || [[ "$DURATION" -le 0 ]]; then
  echo "Error: Duration must be a positive integer" >&2
  exit 1
fi

if ! [[ "$MAX_ENDPOINTS" =~ ^[0-9]+$ ]] || [[ "$MAX_ENDPOINTS" -le 0 ]]; then
  echo "Error: Max endpoints must be a positive integer" >&2
  exit 1
fi

# check if running as root (required for packet capture)
if [[ $EUID -ne 0 ]] && [[ ! -r /dev/bpf* ]] 2>/dev/null; then
  echo "Warning: Packet capture may require root privileges" >&2
fi

# ensure required tools exist
for cmd in tcpdump tshark timeout; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: '$cmd' not found. Please install it and retry." >&2
    echo "  Ubuntu/Debian: sudo apt-get install $cmd" >&2
    echo "  CentOS/RHEL: sudo yum install $cmd" >&2
    exit 1
  fi
done

# check if interface exists
if ! ip link show "$IFACE" >/dev/null 2>&1; then
  echo "Error: Network interface '$IFACE' not found" >&2
  echo "Available interfaces:" >&2
  ip link show | grep -E '^[0-9]+:' | cut -d: -f2 | sed 's/^ */  /' >&2
  exit 1
fi

# prepare output directory
if ! mkdir -p "$OUTDIR"; then
  echo "Error: Cannot create output directory '$OUTDIR'" >&2
  exit 1
fi

cd "$OUTDIR"

# initialize log file
: > "$LOG_FILE"
log_msg "Network Analysis Started"
log_msg "Interface: $IFACE"
log_msg "Duration: ${DURATION}s"
log_msg "Output Directory: $(pwd)"
[[ -n "$FILTER" ]] && log_msg "Filter: $FILTER"

# build tcpdump command
TCPDUMP_CMD="tcpdump -i $IFACE -w $PCAP_FILE"
[[ -n "$FILTER" ]] && TCPDUMP_CMD="$TCPDUMP_CMD $FILTER"

verbose_log "Starting packet capture..."

# Capture packets with error handling
if ! timeout "${DURATION}s" $TCPDUMP_CMD 2>>"$LOG_FILE"; then
  if [[ $? -eq 124 ]]; then
    log_msg "Capture completed (timeout reached)"
  else
    log_msg "Capture failed - check permissions and interface"
    exit 1
  fi
else
  log_msg "Capture completed successfully"
fi

# check if capture file was created and has content
if [[ ! -f "$PCAP_FILE" ]]; then
  log_msg "Error: Capture file not created"
  exit 1
fi

PCAP_SIZE=$(stat -f%z "$PCAP_FILE" 2>/dev/null || stat -c%s "$PCAP_FILE" 2>/dev/null || echo "0")
if [[ "$PCAP_SIZE" -eq 0 ]]; then
  log_msg "Warning: Capture file is empty - no packets captured"
  exit 0
fi

log_msg "Captured file size: $(numfmt --to=iec "$PCAP_SIZE")"

# generate analysis reports
verbose_log "Generating analysis reports..."

log_msg "Generating IP conversations..."
if ! tshark -r "$PCAP_FILE" -q -z conv,ip > conv_ip.txt 2>>"$LOG_FILE"; then
  log_msg "Warning: Failed to generate IP conversations"
fi

log_msg "Generating TCP conversations..."
if ! tshark -r "$PCAP_FILE" -q -z conv,tcp > conv_tcp.txt 2>>"$LOG_FILE"; then
  log_msg "Warning: Failed to generate TCP conversations"
fi

log_msg "Generating UDP conversations..."
if ! tshark -r "$PCAP_FILE" -q -z conv,udp > conv_udp.txt 2>>"$LOG_FILE"; then
  log_msg "Warning: Failed to generate UDP conversations"
fi

log_msg "Generating protocol hierarchy..."
if ! tshark -r "$PCAP_FILE" -q -z prot,colinfo > protocol_hierarchy.txt 2>>"$LOG_FILE"; then
  log_msg "Warning: Failed to generate protocol hierarchy"
fi

log_msg "Listing top $MAX_ENDPOINTS endpoints..."
if ! tshark -r "$PCAP_FILE" -q -z endpoints,ip | head -n "$MAX_ENDPOINTS" > top_endpoints.txt 2>>"$LOG_FILE"; then
  log_msg "Warning: Failed to generate top endpoints"
fi

# generate packet count summary
PACKET_COUNT=$(tshark -r "$PCAP_FILE" -q -z io,stat,0 2>/dev/null | grep -o 'Frames:[[:space:]]*[0-9]*' | grep -o '[0-9]*' || echo "unknown")
log_msg "Total packets captured: $PACKET_COUNT"

# create summary report
cat > summary_report.txt <<EOF
Network Analysis Summary
========================
Date: $(date)
Interface: $IFACE
Duration: ${DURATION}s
Filter: ${FILTER:-"none"}
Capture File: $PCAP_FILE
File Size: $(numfmt --to=iec "$PCAP_SIZE")
Total Packets: $PACKET_COUNT

Generated Files:
- $PCAP_FILE (raw packet capture)
- conv_ip.txt (IP conversations)
- conv_tcp.txt (TCP conversations) 
- conv_udp.txt (UDP conversations)
- protocol_hierarchy.txt (protocol breakdown)
- top_endpoints.txt (top $MAX_ENDPOINTS endpoints)
- $LOG_FILE (analysis log)
EOF

log_msg "Analysis complete. Files generated:"
ls -la *.txt *.pcap 2>/dev/null | sed 's/^/  /' | tee -a "$LOG_FILE" || log_msg "No output files found"

log_msg "Summary report saved to: summary_report.txt"
verbose_log "Use 'wireshark $PCAP_FILE' for detailed analysis"