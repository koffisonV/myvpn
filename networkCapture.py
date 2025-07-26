#!/usr/bin/env python3
import logging
import argparse
from scapy.all import sniff

def packet_handler(pkt):
    logging.info(pkt.summary())

def main():
    p = argparse.ArgumentParser()
    p.add_argument("-f", "--filter", default="host 54.93.220.40")
    p.add_argument("-i", "--iface", default=None)
    p.add_argument("-c", "--count", type=int, default=0,
                   help="0 means infinite")
    p.add_argument("-t", "--timeout", type=int, default=None,
                   help="seconds before stop")
    p.add_argument("-w", "--write", help="write to pcap file")
    args = p.parse_args()

    logging.basicConfig(level=logging.INFO,
                        format="%(asctime)s %(levelname)s:%(message)s")
    sniff(filter=args.filter,
          iface=args.iface,
          prn=packet_handler,
          count=args.count or None,
          timeout=args.timeout,
          store=False,
          write=args.write)

if __name__ == "__main__":
    main()
