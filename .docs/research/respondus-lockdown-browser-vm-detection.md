# Respondus LockDown Browser VM Detection Research

## Executive Summary

Respondus LockDown Browser **actively detects and blocks virtual machine execution** to maintain exam academic integrity. There are no official approved exceptions for running it in virtualized environments, though some specific workarounds and false positive mitigations exist. The software has **no native Linux support** and no plans for Linux compatibility.

---

## Official VM Detection Policy

### What Respondus States

According to official Respondus documentation:

> To maintain the academic integrity of an exam, students are not permitted to run LockDown Browser when a virtual machine is detected on the system.

### Virtualization Types Blocked

The following virtualization environments are explicitly blocked:

- **VM host applications**: VMware, VirtualBox, Parallels Desktop, Virtual PC, Hyper-V
- **Thin apps**: VMware ThinApp, Microsoft App-V
- **Windows emulators**: Wine (Linux), CodeWeavers CrossOver
- **Other virtualization**: Virtual Hard Drives (vHDs), Virtual Displays, Virtual Desktops

**Source**: [Respondus Support - VM Detection Warning](https://support.respondus.com/hc/en-us/articles/4409604116123-I-receive-a-warning-The-browser-cant-be-used-in-virtual-machine-software-such-as-Virtual-PC-VMWare-and-Parallels)

---

## What Happens When a VM is Detected

### User Experience

When LockDown Browser detects a virtual machine:

1. A popup error message appears stating "A VM has been detected"
2. The browser forcibly shuts down
3. The student is logged out of the exam
4. No exam data is saved (exam is aborted)

### Error Prevention

Students cannot proceed with the exam while virtualization is detected. The browser will not launch or will immediately terminate upon detection.

**Source**: [Texas A&M University - VM Has Been Detected](https://service.tamu.edu/TDClient/36/Portal/KB/ArticleDet?ID=637)

---

## Legitimate/Approved Workarounds

### Limited Exception: Respondus 4 Campus-Wide (Older Version)

There is **one documented exception** to the VM detection policy, but it applies only to **Respondus 4** (the predecessor to LockDown Browser), not LockDown Browser itself:

- Respondus 4 Campus-Wide can run in virtual machines under specific conditions:
  - Full versions of Windows 10, 8.1, or earlier
  - VMware (Mac and Windows)
  - Parallels Desktop (Mac)
  - Oracle VirtualBox (Mac and Windows)
  - **Requirement**: VM must run in "Single Window" or "Full Screen" mode only
  - **Prohibited**: Shared desktop modes like VMware Unity and Parallels Coherence

**Important**: This exception does NOT apply to LockDown Browser (the current product).

**Source**: [Respondus Support - Campus-wide in Virtual Environment](https://support.respondus.com/hc/en-us/articles/4409604151195-Respondus-4-Campus-wide-in-a-virtual-environment-on-Mac-and-Windows)

### False Positive Mitigation (Not Virtualization Support)

If LockDown Browser incorrectly detects a VM on native hardware, these troubleshooting steps may help:

#### 1. Disable Antivirus Software
Antivirus programs often use sandboxing/mini VMs for malware detection, triggering false positives:

- **Affected programs**: McAfee, Norton, Avast, AVG
- **Solution**: Temporarily disable antivirus before taking the exam
- **Alternative**: Scan with Malwarebytes instead (doesn't trigger false positives)

#### 2. Remove Leftover VM Drivers
Previous VM installations may leave virtualization device drivers:

- Open Windows Device Manager
- Look for devices labeled "Virtual" under:
  - Display adapters
  - Network adapters
  - System devices
- Uninstall any virtual drivers found
- Allow Windows to restore default drivers

#### 3. Firewall Configuration
Ensure Respondus LockDown Browser has firewall permissions:

- Open Windows Defender Firewall settings
- Select "Allow an app or feature through Windows Defender Firewall"
- Find Respondus LockDown Browser
- Check boxes for both **Public** and **Private** networks

**Source**: [TAMU Troubleshooting Guide](https://service.tamu.edu/TDClient/36/Portal/KB/ArticleDet?ID=637)

---

## Linux Support

### Official Status: Not Supported

Respondus LockDown Browser **does not support Linux** at all. The supported operating systems are:

- **Windows**: Versions 11 and 10 (x86 64-bit, ARM 64-bit with x86 emulation)
- **macOS**: Versions 11.0 through 15.0+
- **ChromeOS**: Long Term Support (LTS) channel minimum
- **iPad**: iOS 11.0+ (iPad only, not iPhone)

**There are no plans for Linux support** according to official documentation.

**Source**: [Respondus KnowledgeOwl - System Requirements](https://respondus.knowledgeowl.com/home/lockdown-browser-computer-requirements)

### Linux Workarounds (Unsupported)

#### Wine Compatibility Layer

Community members have documented a Wine-based workaround, but Respondus explicitly states this is **unsupported**:

**Requirements**:
- Wine (Windows compatibility layer)
- winetricks
- gnutls library
- Run: `winetricks msftedit allfonts`

**Critical Caveats**:
- Success "varies from version to version"
- Reliability is not guaranteed
- **Must obtain professor permission before using on actual exams**
- Not officially supported by Respondus
- LockDown Browser will still attempt to detect virtualization (Wine creates a pseudo-VM environment)

**Source**: [Virginia Tech LUUG - Respondus LockDown Browser Wiki](https://vtluug.org/wiki/Respondus_LockDown_Browser)

#### QEMU VM Bypass (Theoretical)

Some users have theoretically suggested using QEMU with `kvm=off` flag to hide VM signatures, but this remains untested and unconfirmed.

---

## System Requirements

### Hardware Requirements

| Requirement | Windows | Mac |
|-------------|---------|-----|
| Minimum RAM | 2 GB | 2 GB |
| With Webcam | 4 GB | 4 GB |
| Disk Space | 300 MB | 400 MB |
| Processor | x86 64-bit, ARM 64-bit (x86 emulation) | Intel/Apple Silicon |

### Software Requirements

- Windows 11 or 10 only (not Windows 10S, not from Windows App Store)
- macOS 11.0 through 15.0+
- ChromeOS via LTS channel
- iPad (iOS 11.0+) only

**Source**: [Respondus Support - System Requirements](https://support.respondus.com/hc/en-us/articles/4409607170459-What-are-the-computer-requirements-for-installations-of-Respondus-LockDown-Browser)

---

## Detection Technology

### How VM Detection Works

Respondus LockDown Browser inspects system hardware signatures and installed drivers to identify virtualization:

- Detects VM hardware signatures (CPUID, motherboard identifiers)
- Checks for installed VM drivers (VirtualBox, VMware, Parallels, Hyper-V)
- Scans Windows Device Manager for virtual devices
- Monitors for hypervisor-specific system calls

### Detection Difficulty

- **VirtualBox, VMware, Parallels**: Easily detected; detection signature commonly updated
- **Hyper-V (Windows Sandbox)**: Harder to detect due to Microsoft's investment in enterprise VM hardening
- **Wine**: Detected as emulation environment
- **QEMU**: Theoretically bypassable with CPU spoofing, but untested against current versions

### Bypass Attempts and Responses

Community developers have created tools (GitHub projects like "lockdown-browser" and "unlockdown-browser") that attempt to run LockDown Browser in Windows Sandbox by hiding VM signatures. However:

- Respondus regularly releases updates that detect and block these tools
- Using bypass tools during exams violates academic integrity policies
- Consequences can include failing grades, disciplinary action, or expulsion

**Source**: Community research and GitHub project status

---

## Alternatives for Linux Users

For Linux users who need proctored exam software, these alternatives exist (compatibility varies):

### General Alternatives Used by Universities

- **Honorlock**: Lightweight browser plugin integration
- **Proctorio**: Browser extension-based proctoring
- **ProctorU**: Vendor-based proctoring service
- **Proctor Track**: For high-stakes assessments
- **PSI**: Secure testing alternative
- **ProctorFree Secure Browser**: Emerging alternative

### Linux-Specific Notes

- **SkyPrep** is identified as the most popular Linux-compatible proctoring alternative
- However, **most institutional exams require the specific software (Respondus) chosen by their instructors**
- Students must contact their instructor or institution to request alternative proctoring software if running Linux

**Source**: [Rutgers IDT - Alternatives to Respondus](https://idt.camden.rutgers.edu/alternatives-to-respondus-lockdown-browser-monitor/), [Gartner Peer Insights - Alternatives](https://www.gartner.com/reviews/market/remote-proctoring-services-for-higher-education/vendor/respondus/product/lockdown-browser/alternatives)

---

## Key Findings Summary

| Question | Answer |
|----------|--------|
| Does LockDown Browser detect VMs? | **Yes, actively and by design** |
| Can you run it in a VM? | **No, it will block execution** |
| Are there approved VM exceptions? | **No** (Respondus 4 has limited support, not LockDown Browser) |
| Can you use Wine/emulation? | **Unsupported; may work but not guaranteed** |
| Linux support? | **No native support, no planned support** |
| What happens if VM detected? | **Browser terminates; exam aborted** |
| Can it be bypassed? | **Community tools exist but Respondus patches them regularly** |
| Academic integrity consequences of bypass? | **Failing grade, disciplinary action, potential expulsion** |

---

## Official Support Resources

- [Respondus Support Center](https://support.respondus.com/hc/en-us/)
- [VM Detection Warning - Official Article](https://support.respondus.com/hc/en-us/articles/4409604116123-I-receive-a-warning-The-browser-cant-be-used-in-virtual-machine-software-such-as-Virtual-PC-VMWare-and-Parallels)
- [System Requirements](https://support.respondus.com/hc/en-us/articles/4409607170459-What-are-the-computer-requirements-for-installations-of-Respondus-LockDown-Browser)
- [Respondus KnowledgeOwl Base](https://respondus.knowledgeowl.com/)

---

## References

1. [Respondus Support - VM Detection Warning](https://support.respondus.com/hc/en-us/articles/4409604116123-I-receive-a-warning-The-browser-cant-be-used-in-virtual-machine-software-such-as-Virtual-PC-VMWare-and-Parallels)
2. [Respondus Support - System Requirements](https://support.respondus.com/hc/en-us/articles/4409607170459-What-are-the-computer-requirements-for-installations-of-Respondus-LockDown-Browser)
3. [Respondus Support - Respondus 4 in Virtual Environment](https://support.respondus.com/hc/en-us/articles/4409604151195-Respondus-4-Campus-wide-in-a-virtual-environment-on-Mac-and-Windows)
4. [Respondus KnowledgeOwl - System Requirements](https://respondus.knowledgeowl.com/home/lockdown-browser-computer-requirements)
5. [Texas A&M - VM Detection Troubleshooting](https://service.tamu.edu/TDClient/36/Portal/KB/ArticleDet?ID=637)
6. [Virginia Tech LUUG - Respondus LockDown Browser Wiki](https://vtluug.org/wiki/Respondus_LockDown_Browser)
7. [GitHub - lockdown-browser (Windows Sandbox Bypass)](https://github.com/gucci-on-fleek/lockdown-browser)
8. [GitHub - unlockdown-browser (Windows Sandbox Bypass)](https://github.com/thepro1000/unlockdown-browser)
9. [Rutgers IDT - Alternatives to Respondus](https://idt.camden.rutgers.edu/alternatives-to-respondus-lockdown-browser-monitor/)
10. [Gartner - LockDown Browser Alternatives](https://www.gartner.com/reviews/market/remote-proctoring-services-for-higher-education/vendor/respondus/product/lockdown-browser/alternatives)
11. [G2 - LockDown Browser Alternatives](https://www.g2.com/products/lockdown-browser/competitors/alternatives)

---

**Research Date**: January 27, 2025
**Last Updated**: January 27, 2025
