# Self-Hosted VPN 

## Contributions
- **Koffison Voumadi** - Technical - Research on Technology & References

## Review

While working on the VPN and self-hosted VPN project, I encountered challenges related to installation, resource limitations, and technical proficiency. The major turning point was installing the OpenVPN protocol on a virtual machine with Vultr, which required meticulous attention due to its complexity and importance for secure network access.

The OpenVPN installation script was complicated, involving unfamiliar prompts and configurations. I considered using scripts from GitHub to automate setup but could not verify their legitimacy, risking vulnerabilities. To address this, I used a trusted Ubuntu VM with OpenVPN from the AWS Marketplace, expediting installation and ensuring integrity. This strategy helped me overcome hurdles with OpenVPN on my AWS EC2 instance.

Another challenge was resource limitations compared to larger VPN providers. Unlike NordVPN, which allows seamless switching between countries and servers, my self-hosted solution required renting additional VMs to expand regions, increasing costs and administrative overhead. My VPN operated on a small VM (free tier), limiting computing power, bandwidth, and simultaneous connections. I managed expenses by deactivating the server when not in use, as AWS charges hourly and by usage. In contrast, providers like NordVPN have robust infrastructure for high traffic without performance loss.

Building and maintaining a secure self-hosted VPN requires understanding networking protocols, security configurations, and server administration. Unlike commercial VPNs with user-friendly interfaces and delegated maintenance, self-hosted solutions demand higher technical proficiency. This barrier may deter organizations lacking expertise or resources. Maintenance includes overseeing the VM, ensuring updates, and resolving technical issues, adding administrative burden for IT teams with limited expertise.

Navigating these challenges highlighted trade-offs between self-hosted VPNs and established providers like NordVPN. Self-hosted deployments offer autonomy and control but require significant complexity and resources.

## Research on Technology

OpenVPN is open-source software providing secure VPN connections using SSL and TLS encryption. It creates a safe client-server connection for secure data transmission over the internet. Data sent between client and server is encrypted, preventing interception or unauthorized access. OpenVPN is vital for accessing sensitive data and when security risks are high.

Government agencies use VPNs for secure communication. VPNs are critical for maintaining security in daily operations. Remote access is another primary use, allowing secure connections to corporate networks from remote locations. OpenVPN also enhances privacy and anonymity online by hiding IP addresses and encrypting traffic, preventing tracking. It enables access to geo-restricted content by connecting to servers in different locations. On public Wi-Fi, OpenVPN encrypts transmissions, protecting users from hacking attempts. During the COVID-19 pandemic, VPNs were key for secure data collection and management.

Overall, OpenVPN is popular for secure, encrypted internet connections. Its open-source nature and advanced security features make it a strong choice for privacy and security.

The VPN was hosted on AWS using a virtual machine. Virtualization allows a computer to share hardware with multiple digital entities. Each virtual environment uses the host's resources (memory, CPU, storage). Virtualization enables switching between operating systems on the same server without restarting. A virtual machine is software-defined, running on a physical host with different OS and resources. Multiple VMs can run on one physical machine, increasing efficiency. Installing virtualization software lets users create multiple VMs for various uses, each with its own OS for compatibility and usage.

## Tools Used

To assess network performance, we used various tools and methodologies. Screenshots document our setup, methodologies, and comparative analysis of our self-hosted VPN versus NordVPN.

- **AWS EC2 Instance**: Our network environment was established using an Amazon EC2 Linux VM, hosting the OpenVPN Access Server throughout development and analysis.
- **SSH Client**: Connection to the server via SSH enabled installation and configuration of the access server.
- **VPN Client**: Compatible with major OS; we used macOS for testing.
- **Terminal Commands**: Used to test speed and latency.
    - `networkquality`: Measured connection speed and latency, showing slower download speeds for our self-hosted VPN due to VM limitations.
    - `traceroute`: Examined path and hops to reach servers (e.g., google.com).
- **Wireshark**: Captured network traffic while connected to our VPN. OpenVPN encrypted packets, revealing less data about transfers.
- **NordVPN Comparison**: Wireguard protocol used by NordVPN showed slightly faster packet transfer rates. Most packets were encrypted, with no other protocol visible compared to our OpenVPN server.
- **Scripts**: We used scripts to automate the analysis process, including capturing packets and analyzing network traffic.

## References

- Crist, E. F., & Keijser, J. J. (2015). *Mastering OpenVPN: master building and integrating secure private networks using OpenVPN* (1st edition). Packt Publishing.
- Iqbal, Muhammad. “(PDF) Analysis of Security Virtual Private Network (VPN) Using Openvpn.” International Journal of Cyber Security, 2019, [ResearchGate](https://www.researchgate.net/publication/333198144_Analysis_of_Security_Virtual_Private_Network_VPN_Using_OpenVPN).
- The amazon AWS cloud VPN. OpenVPN. (2023, April 25). [OpenVPN](https://openvpn.net/amazon-cloud/)
- What Is Virtualization? - Cloud Computing Virtualization Explained - AWS, [AWS](https://aws.amazon.com/what-is/virtualization/). Accessed 15 May 2024.
- Zhengchun Zhou and Tongcheng Huang 2021 J. Phys.: Conf. Ser. 1865 042015