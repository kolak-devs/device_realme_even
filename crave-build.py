#!/usr/bin/env python3
# ─────────────────────────────────────────────────────────────────────────────
#   ██████ ██████   █████  ██    ██ ███████     ██      █████  ██    ██ ███  
#  ██      ██   ██ ██   ██ ██    ██ ██          ██     ██   ██ ██    ██ ████ 
#  ██      ██████  ███████ ██    ██ █████       ██     ███████ ██    ██ ██ ██
#  ██      ██   ██ ██   ██  ██  ██  ██          ██     ██   ██ ██    ██ ██  █
#   ██████ ██   ██ ██   ██   ████   ███████     ███████ ██  ██  ██████  ██   
#
#   CRAVE BUILD LAUNCHER  •  v2.0  •  by Badmaneers
# ─────────────────────────────────────────────────────────────────────────────

import os
import sys
import subprocess
import textwrap
import shutil
from pathlib import Path
from datetime import datetime

# Script lives at <source>/device/<oem>/<device>/crave_launcher.py
# So the AOSP source root is 3 levels up.
SCRIPT_DIR  = Path(__file__).resolve().parent
SOURCE_ROOT = SCRIPT_DIR.parents[2]   # .../device/oem/device  →  3 up = source root

# ── ANSI Palette ──────────────────────────────────────────────────────────────
class C:
    RESET   = "\033[0m"
    BOLD    = "\033[1m"
    DIM     = "\033[2m"
    ITAL    = "\033[3m"

    BLACK   = "\033[30m"
    RED     = "\033[91m"
    GREEN   = "\033[92m"
    YELLOW  = "\033[93m"
    BLUE    = "\033[94m"
    MAGENTA = "\033[95m"
    CYAN    = "\033[96m"
    WHITE   = "\033[97m"
    GRAY    = "\033[90m"

    BG_BLACK  = "\033[40m"
    BG_BLUE   = "\033[44m"
    BG_CYAN   = "\033[46m"

    @staticmethod
    def hex(r, g, b):
        return f"\033[38;2;{r};{g};{b}m"

# Accent colours used throughout
ACCENT  = C.hex(99, 179, 237)   # soft sky blue
ACCENT2 = C.hex(154, 230, 180)  # mint green
GOLD    = C.hex(246, 173, 85)   # warm amber
ROSE    = C.hex(252, 129, 129)  # soft red
MUTED   = C.hex(160, 174, 192)  # cool grey

# ── Helpers ───────────────────────────────────────────────────────────────────
def term_width():
    return shutil.get_terminal_size((80, 24)).columns

def hr(char="─", color=MUTED):
    print(f"{color}{char * term_width()}{C.RESET}")

def banner():
    w = term_width()
    lines = [
        "",
        f"{ACCENT}{C.BOLD}  ██████╗██████╗  █████╗ ██╗   ██╗███████╗{C.RESET}",
        f"{ACCENT}{C.BOLD}  ██╔════╝██╔══██╗██╔══██╗██║   ██║██╔════╝{C.RESET}",
        f"{ACCENT}{C.BOLD}  ██║     ██████╔╝███████║██║   ██║█████╗  {C.RESET}",
        f"{ACCENT}{C.BOLD}  ██║     ██╔══██╗██╔══██║╚██╗ ██╔╝██╔══╝  {C.RESET}",
        f"{ACCENT}{C.BOLD}  ╚██████╗██║  ██║██║  ██║ ╚████╔╝ ███████╗{C.RESET}",
        f"{ACCENT}{C.BOLD}   ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝{C.RESET}",
        f"{GOLD}{C.BOLD}          B U I L D   L A U N C H E R{C.RESET}",
        f"{MUTED}          v2.0  •  by Badmaneers  •  {datetime.now().strftime('%Y-%m-%d')}{C.RESET}",
        "",
    ]
    hr("═", ACCENT)
    for l in lines:
        print(l)
    hr("═", ACCENT)
    print()

def section(title):
    print()
    print(f"{ACCENT2}{C.BOLD}  ┌─  {title}  {C.RESET}")
    print(f"{ACCENT2}  └{'─' * (len(title) + 4)}{C.RESET}")

def info(msg):
    print(f"  {ACCENT}ℹ{C.RESET}  {MUTED}{msg}{C.RESET}")

def success(msg):
    print(f"  {ACCENT2}✔{C.RESET}  {C.WHITE}{msg}{C.RESET}")

def warn(msg):
    print(f"  {GOLD}⚠{C.RESET}  {GOLD}{msg}{C.RESET}")

def error(msg):
    print(f"  {ROSE}✖{C.RESET}  {ROSE}{msg}{C.RESET}")

def label(key, value, key_color=GOLD, val_color=C.WHITE):
    print(f"  {key_color}{C.BOLD}{key:<24}{C.RESET}{val_color}{value}{C.RESET}")

def prompt(question, default=None, required=True):
    """Styled single-line prompt."""
    dflt = f"{MUTED} [{default}]{C.RESET}" if default else ""
    hint = f"{ROSE} *{C.RESET}" if required and not default else ""
    print(f"\n  {ACCENT}▸{C.RESET} {C.WHITE}{C.BOLD}{question}{C.RESET}{dflt}{hint}")
    try:
        val = input(f"  {MUTED}❯{C.RESET} ").strip()
    except (KeyboardInterrupt, EOFError):
        print()
        abort()
    if not val and default:
        return default
    if not val and required:
        error("This field is required.")
        return prompt(question, default, required)
    return val

def choose(question, options, default=None):
    """
    Numbered menu picker.
    options: list of (key, display_label) tuples  — or plain strings.
    Returns the chosen key/string.
    """
    print(f"\n  {ACCENT}▸{C.RESET} {C.WHITE}{C.BOLD}{question}{C.RESET}")
    print()
    for i, opt in enumerate(options, 1):
        key   = opt[0] if isinstance(opt, tuple) else opt
        label_str = opt[1] if isinstance(opt, tuple) else opt
        marker = f"{ACCENT2}{C.BOLD}  [{i:>2}]{C.RESET}"
        print(f"{marker}  {label_str}")

    default_hint = f"  {MUTED}(default: {default}){C.RESET}" if default else ""
    print(f"\n  {MUTED}Enter number{default_hint}:{C.RESET}")
    try:
        raw = input(f"  {MUTED}❯{C.RESET} ").strip()
    except (KeyboardInterrupt, EOFError):
        print()
        abort()

    if not raw and default:
        raw = str(default)
    try:
        idx = int(raw) - 1
        if 0 <= idx < len(options):
            return options[idx][0] if isinstance(options[idx], tuple) else options[idx]
    except ValueError:
        pass
    error("Invalid selection. Try again.")
    return choose(question, options, default)

def confirm(question, default="y"):
    yn = f"{ACCENT2}Y{C.RESET}/{MUTED}n{C.RESET}" if default == "y" else f"{MUTED}y{C.RESET}/{ACCENT2}N{C.RESET}"
    print(f"\n  {ACCENT}▸{C.RESET} {C.WHITE}{C.BOLD}{question}{C.RESET} {yn} ", end="")
    try:
        val = input().strip().lower()
    except (KeyboardInterrupt, EOFError):
        print()
        abort()
    if not val:
        val = default
    return val in ("y", "yes")

def abort():
    print()
    warn("Session cancelled by user.")
    sys.exit(0)

# ── Data ──────────────────────────────────────────────────────────────────────
# Default local manifest repo — used to pre-fill the prompt, never hardcoded
# into the final command. Override per-run when prompted in STEP 3.
DEFAULT_LOCAL_MANIFEST_URL = "https://github.com/kolak-devs/even-manifests.git"

SOURCES = [
    # (crave_id, display_name, url, default_branch, crave_listed)
    # crave_listed=True  → source is officially on crave; repo init is skipped
    # crave_listed=False → unlisted/custom ROM; repo init is required
    ("35",  "AOSP",          "https://android.googlesource.com/platform/manifest",               "android-14.0.0_r1", True),
    ("72",  "LOS 21",        "https://github.com/LineageOS/android.git",                         "lineage-21",        True),
    ("93",  "LOS 22.1",      "https://github.com/accupara/los22.git",                            "lineage-22.1",      True),
    ("36",  "LOS 20",        "https://github.com/accupara/los20.git",                            "lineage-20",        True),
    ("85",  "LOS 18.1",      "https://github.com/accupara/los18.1.git",                          "lineage-18.1",      True),
    ("81",  "LOS 16",        "https://github.com/accupara/los16.git",                            "lineage-16.0",      True),
    ("80",  "LOS CM 12.1",   "https://github.com/accupara/los-cm12.1.git",                       "cm-12.1",           True),
    ("83",  "LOS CM 14.1",   "https://github.com/accupara/los-cm14.1.git",                       "cm-14.1",           True),
    ("73",  "Arrow OS",      "https://github.com/ArrowOS/android_manifest.git",                  "arrow-13.1",        True),
    ("79",  "CipherOS",      "https://github.com/CipherOS/android_manifest.git",                 "fourteen",          True),
    ("64",  "DerpFest-AOSP", "https://github.com/DerpFest-AOSP/manifest.git",                    "14",                True),
    ("82",  "PixelOS",       "https://github.com/PixelOS-AOSP/android_manifest",                 "fourteen",          True),
    ("86",  "Rising OS",     "https://github.com/RisingOS-Revived/android.git",                  "fourteen",          True),
    ("77",  "ROM Dumper",    "https://github.com/DumprX/DumprX",                                 "main",              True),
    ("78",  "TWRP",          "https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git", "twrp-12.1", True),
    # ── Add unlisted/custom ROMs below with crave_listed=False ─────────────────
    # ("00", "crDroid 14",   "https://github.com/crdroidandroid/android.git",                    "14.0",              False),
]

BUILD_VARIANTS = [
    ("userdebug", f"{ACCENT2}userdebug{C.RESET}  {MUTED}— Recommended for development & testing{C.RESET}"),
    ("user",      f"{GOLD}user{C.RESET}       {MUTED}— Production/release build (no root){C.RESET}"),
    ("eng",       f"{ROSE}eng{C.RESET}        {MUTED}— Engineering build (full debugging){C.RESET}"),
]

BUILD_TARGETS = [
    ("bacon",           f"bacon           {MUTED}— LineageOS / most custom ROMs{C.RESET}"),
    ("otapackage",      f"otapackage       {MUTED}— AOSP / Pixel style ROMs{C.RESET}"),
    ("recoveryimage",   f"recoveryimage    {MUTED}— Recovery only (TWRP etc.){C.RESET}"),
    ("bootimage",       f"bootimage        {MUTED}— Boot image only{C.RESET}"),
    ("custom",          f"custom           {MUTED}— Enter your own target{C.RESET}"),
]

# ── Pull Commands Generator ───────────────────────────────────────────────────
def pull_commands(cfg: dict) -> str:
    """Return crave pull command(s) as a shell string, or empty string if disabled."""
    if not cfg.get("pull_artifacts"):
        return ""
    ptype = cfg.get("pull_type", "zip")
    cmds = []
    if ptype in ("zip", "both"):
        cmds.append('crave pull "out/target/product/*/*.zip"')
    if ptype in ("img", "both"):
        cmds.append('crave pull "out/target/product/*/*.img"')
    return "\n".join(cmds)

# ── Build Command Generator ───────────────────────────────────────────────────
def build_command(cfg: dict) -> str:
    src_url            = cfg["source_url"]
    src_branch         = cfg["source_branch"]
    local_manifest_url = cfg["local_manifest_url"]
    local_branch       = cfg["local_branch"]
    device             = cfg["device"]
    variant            = cfg["variant"]
    target             = cfg["build_target"]
    use_git_lfs        = cfg["git_lfs"]
    extra_flags        = cfg["extra_repo_flags"]
    src_listed         = cfg["src_listed"]   # True = officially on crave → skip repo init

    lfs_flag = " --git-lfs" if use_git_lfs else ""
    extra    = f" {extra_flags}" if extra_flags else ""

    steps = ["rm -rf .repo/local_manifests"]

    # repo init is only needed for ROMs not officially hosted on crave
    if not src_listed:
        steps.append(f"repo init -u {src_url} -b {src_branch}{lfs_flag}{extra}")

    steps += [
        f"git clone {local_manifest_url} --depth 1 -b {local_branch} .repo/local_manifests",
        f"/opt/crave/resync.sh",
        f"export BUILD_USERNAME=ismasrull",
        f"export BUILD_HOSTNAME=crave",
        f"source build/envsetup.sh",
        f"breakfast {device} {variant}",
    ]

    if cfg.get("clean_build"):
        steps.append("m clean")

    steps.append(f"mka {target}")

    inner = "; \\\n".join(f" {s}" for s in steps)
    return f'crave run --no-patch -- "\\\n{inner}"'

# ── Summary Box ───────────────────────────────────────────────────────────────
def print_summary(cfg: dict):
    section("BUILD CONFIGURATION SUMMARY")
    print()
    label("Device Codename",   cfg["device"])
    label("Build Variant",     cfg["variant"])
    label("Build Target",      cfg["build_target"])
    label("Base Source",       f"{cfg['source_name']}  (id: {cfg['source_id']})")
    label("Source URL",        cfg["source_url"])
    label("Source Branch",     cfg["source_branch"])
    label("Local Manifest URL",cfg["local_manifest_url"])
    label("Local Branch",      cfg["local_branch"])
    label("Clean Build",       "Yes" if cfg.get("clean_build") else "No")
    listed_str = f"{ACCENT2}Skipped{C.RESET} {MUTED}(officially listed on crave){C.RESET}" if cfg["src_listed"] else f"{GOLD}Included{C.RESET} {MUTED}(unlisted ROM — repo init required){C.RESET}"
    label("repo init",          listed_str)
    label("Git LFS",           "Yes" if cfg["git_lfs"] else "No")
    if cfg["extra_repo_flags"]:
        label("Extra Repo Flags",  cfg["extra_repo_flags"])
    if cfg["pull_artifacts"]:
        pull_map = {"zip": ".zip files", "img": ".img files", "both": ".zip + .img files"}
        label("Pull Artifacts",    f"{ACCENT2}{pull_map[cfg['pull_type']]}{C.RESET} {MUTED}(crave pull after build){C.RESET}")
    else:
        label("Pull Artifacts",    f"{MUTED}Disabled{C.RESET}")
    print()

def print_command(cmd: str, pull_cmd: str = ""):
    section("GENERATED CRAVE COMMAND")
    print()
    hr("─", MUTED)
    for line in cmd.split("\n"):
        print(f"  {ACCENT2}{line}{C.RESET}")
    hr("─", MUTED)
    if pull_cmd:
        print()
        print(f"  {GOLD}{C.BOLD}  ↓  Post-build pull  (runs after crave finishes){C.RESET}")
        print()
        for line in pull_cmd.split("\n"):
            print(f"  {GOLD}{line}{C.RESET}")
        hr("─", MUTED)
    print()

# ── Main Flow ─────────────────────────────────────────────────────────────────
def main():
    os.system("clear")
    banner()

    info("This launcher builds a crave run command using your local manifest repo.")
    info(f"Default local manifest  →  {ACCENT}{DEFAULT_LOCAL_MANIFEST_URL}{C.RESET}  {MUTED}(override below){C.RESET}")
    print()

    # ── 1. Device ──────────────────────────────────────────────────────────────
    section("STEP 1  —  DEVICE")
    device = prompt("Enter your device codename", default="even", required=True)
    device = device.lower().replace(" ", "_")

    # ── 2. Base Source ─────────────────────────────────────────────────────────
    section("STEP 2  —  AOSP BASE SOURCE")

    source_opts = [
        (s[0], f"{GOLD}[{s[0]:>2}]{C.RESET} {C.WHITE}{C.BOLD}{s[1]:<16}{C.RESET} {MUTED}{s[2]}{C.RESET}")
        for s in SOURCES
    ]
    # Append the custom source option at the end
    source_opts.append((
        "custom",
        f"{ROSE}[  ]{C.RESET} {C.WHITE}{C.BOLD}{'Custom / Unlisted':<16}{C.RESET} {MUTED}Enter your own manifest URL{C.RESET}"
    ))
    chosen_id = choose("Select the AOSP base source for your build", source_opts, default="1")

    if chosen_id == "custom":
        section("STEP 2a  —  CUSTOM SOURCE DETAILS")
        warn("This ROM is not officially listed on crave — repo init will be included.")
        src_url    = prompt("Manifest repo URL", required=True)
        src_branch = prompt("Branch / tag", required=True)
        src_name   = prompt("Short name for this ROM  (e.g. crDroid 14)", default="Custom ROM", required=True)
        src_id     = "custom"
        src_listed = False          # always needs repo init
        success(f"Custom source  →  {src_name}  |  {src_url}  [{src_branch}]")
    else:
        source_entry = next(s for s in SOURCES if s[0] == chosen_id)
        src_id, src_name, src_url, src_default_branch, src_listed = source_entry
        success(f"Selected  →  {src_name}  |  {src_url}")
        src_branch = prompt(
            f"Branch for {src_name}",
            default=src_default_branch,
            required=True,
        )

    # ── 3. Local Manifest ──────────────────────────────────────────────────────
    section("STEP 3  —  LOCAL MANIFEST")
    local_manifest_url = prompt(
        "Local manifest repo URL",
        default=DEFAULT_LOCAL_MANIFEST_URL,
        required=True,
    )
    local_branch = prompt(
        "Branch in local manifest repo to use",
        default="lineage-23.2",
        required=True,
    )

    # ── 4. Build Variant ───────────────────────────────────────────────────────
    section("STEP 4  —  BUILD VARIANT")
    variant = choose("Select build variant", BUILD_VARIANTS, default="1")
    success(f"Variant  →  {variant}")

    # ── 5. Build Target ────────────────────────────────────────────────────────
    section("STEP 5  —  BUILD TARGET")
    build_target_key = choose("Select build target", BUILD_TARGETS, default="1")
    if build_target_key == "custom":
        build_target = prompt("Enter your custom make target", required=True)
    else:
        build_target = build_target_key
    success(f"Target  →  {build_target}")

    # ── 6. Advanced Options ────────────────────────────────────────────────────
    section("STEP 6  —  ADVANCED OPTIONS")
    clean_build = confirm("Perform a clean build (m clean)?", default="n")
    use_git_lfs = confirm("Enable --git-lfs for repo init?", default="n")
    extra_flags = prompt(
        "Extra flags for repo init  (leave blank to skip)",
        default="",
        required=False,
    )

    # ── 7. Pull Artifacts ─────────────────────────────────────────────────────
    section("STEP 7  —  PULL BUILD ARTIFACTS")
    info("After a successful build, crave pull fetches the output files to this devspace.")
    pull_artifacts = confirm("Pull build artifacts to devspace after build?", default="y")
    if pull_artifacts:
        pull_opts = [
            ("zip",      f"📦  {ACCENT2}.zip only{C.RESET}          {MUTED}crave pull out/target/product/*/*.zip{C.RESET}"),
            ("img",      f"💿  {GOLD}.img only{C.RESET}          {MUTED}crave pull out/target/product/*/*.img{C.RESET}"),
            ("both",     f"🗂   {ACCENT}Both .zip and .img{C.RESET} {MUTED}pull all build outputs{C.RESET}"),
        ]
        pull_type = choose("What to pull?", pull_opts, default="1")
    else:
        pull_type = None

    # ── Build config dict ──────────────────────────────────────────────────────
    cfg = {
        "device":         device,
        "source_id":      src_id,
        "source_name":    src_name,
        "source_url":     src_url,
        "source_branch":  src_branch,
        "local_manifest_url": local_manifest_url,
        "local_branch":   local_branch,
        "variant":        variant,
        "build_target":   build_target,
        "clean_build":    clean_build,
        "git_lfs":        use_git_lfs,
        "extra_repo_flags": extra_flags,
        "src_listed":     src_listed,
        "pull_artifacts": pull_artifacts,
        "pull_type":      pull_type,
    }

    # ── Summary & Command ──────────────────────────────────────────────────────
    os.system("clear")
    banner()
    print_summary(cfg)
    cmd = build_command(cfg)
    pull_cmd = pull_commands(cfg)
    print_command(cmd, pull_cmd)

    # ── Actions ────────────────────────────────────────────────────────────────
    section("ACTIONS")
    action_opts = [
        ("run",    f"🚀  {ACCENT2}Run the command now{C.RESET}              {MUTED}(executes crave run){C.RESET}"),
        ("copy",   f"📋  {GOLD}Copy to clipboard{C.RESET}                {MUTED}(xclip / xsel / pbcopy){C.RESET}"),
        ("save",   f"💾  {ACCENT}Save to file{C.RESET}                     {MUTED}(./crave_build.sh){C.RESET}"),
        ("print",  f"🖨  {MUTED}Just print — exit after{C.RESET}"),
    ]
    action = choose("What do you want to do?", action_opts, default="1")

    print()

    if action == "run":
        warn("About to execute the crave command. Make sure you are inside a crave devspace!")
        info(f"Working directory  \u2192  {ACCENT}{SOURCE_ROOT}{C.RESET}")
        if pull_cmd:
            info(f"After the build, these pull commands will run automatically:")
            for pc in pull_cmd.split("\n"):
                print(f"    {GOLD}{pc}{C.RESET}")
        if confirm("Confirm execution?", default="y"):
            hr("\u2500", MUTED)
            print(f"\n  {ACCENT2}{C.BOLD}Launching crave run from source root \u2026{C.RESET}\n")
            os.chdir(SOURCE_ROOT)
            ret = os.system(cmd)
            if pull_cmd:
                print()
                if ret == 0:
                    print(f"  {ACCENT2}{C.BOLD}Build finished — pulling artifacts \u2026{C.RESET}\n")
                    for pc in pull_cmd.split("\n"):
                        info(f"Running:  {GOLD}{pc}{C.RESET}")
                        os.system(pc)
                else:
                    warn("Build exited with a non-zero status — skipping artifact pull.")
                    warn("Check build logs before pulling manually.")
        else:
            warn("Execution cancelled.")
    elif action == "copy":
        full_clip = cmd + ("\n\n# Pull artifacts\n" + pull_cmd if pull_cmd else "")
        copied = False
        for tool in ("xclip -selection clipboard", "xsel --clipboard --input", "pbcopy"):
            try:
                subprocess.run(
                    tool.split(),
                    input=full_clip.encode(),
                    check=True,
                    stderr=subprocess.DEVNULL,
                )
                success(f"Copied to clipboard using  {tool.split()[0]}")
                if pull_cmd:
                    info("Clipboard includes the post-build crave pull commands.")
                copied = True
                break
            except (FileNotFoundError, subprocess.CalledProcessError):
                continue
        if not copied:
            error("No clipboard tool found (xclip/xsel/pbcopy). Command printed above.")

    elif action == "save":
        out_file = SOURCE_ROOT / "crave_build.sh"
        shebang  = "#!/usr/bin/env bash\n# Generated by Crave Build Launcher\n# " + datetime.now().isoformat() + "\n\n"
        script_body = shebang + cmd + "\n"
        if pull_cmd:
            script_body += (
                "\n# ── Pull artifacts after successful build ──────────────\n"
                "if [ $? -eq 0 ]; then\n"
                + "".join(f"  {pc}\n" for pc in pull_cmd.split("\n"))
                + "else\n"
                "  echo \"Build failed — skipping artifact pull.\"\n"
                "fi\n"
            )
        with open(out_file, "w") as f:
            f.write(script_body)
        os.chmod(out_file, 0o755)
        success(f"Saved to  {out_file}  (chmod +x applied)")
        if pull_cmd:
            info(f"Script includes post-build {GOLD}crave pull{C.RESET} on success.")
        info(f"Run it with:  {ACCENT}bash {out_file}{C.RESET}")

    elif action == "print":
        success("Command printed above. Exiting.")

    # ── Footer ─────────────────────────────────────────────────────────────────
    print()
    hr("═", ACCENT)
    print(f"  {MUTED}Crave Build Launcher  •  Happy building, {device}! 🔨{C.RESET}")
    hr("═", ACCENT)
    print()

# ── Entry ──────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print()
        warn("Interrupted. Goodbye.")
        sys.exit(0)
