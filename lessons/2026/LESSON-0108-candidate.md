---
id: LESSON-0108
date: 2026-10-05
trigger: user-correction
phases: [07]
keywords: [wrong-device, android, adb, private-dns, browser, triage]
related-rules: [standards/ANTI_HALLUCINATION.md]
status: candidate
---

## What went wrong

A report that "my brave browser doesn't work anymore and can't visit any website after the changes in private dns" was investigated on the Mac for a full pass (system DNS, Brave desktop profile, headless netlog, mDNSResponder logs), and the reply concluded "Brave on this Mac is working". The user meant Brave on an Android phone that was attached over USB adb the whole time. "Private DNS" is the name of an Android setting; macOS has no setting by that name.

## Why it happened (root cause)

Triage defaulted to the machine the session runs on without first establishing which device the report concerned. The platform-specific term in the report pointed at Android, and one `adb devices -l` call would have shown the attached phone, but no step checked for other devices before committing to a multi-call local investigation.

## How to prevent it (the rule)

Before debugging a device or app problem, establish which device it is on: when the report uses a platform-specific term (Android "Private DNS", iOS "Private Relay") or names an app that exists on several platforms, run `adb devices -l` and check for other attached devices, or ask, before investigating the local machine.

## Verification

- The first diagnostic step on a browser or network complaint names the device under test and the evidence for why it is that device (for example `adb devices -l` output).
- The category that should fall toward zero: a user reply of the form "I was talking about <other device>".
