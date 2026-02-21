#!/usr/bin/env python3
# 将除 AgentSkillsManager 外的所有公开 GitHub 仓库设为私有
# 由 set-repos-private.sh 调用，需环境变量 GITHUB_TOKEN

import os
import sys
import json
import time
import urllib.request
import urllib.error

TOKEN = os.environ.get("GITHUB_TOKEN")
KEEP_PUBLIC = "wallwallwallwall/AgentSkillsManager"

def main():
    if not TOKEN:
        print("请设置环境变量 GITHUB_TOKEN", file=sys.stderr)
        sys.exit(1)

    req = urllib.request.Request(
        "https://api.github.com/user/repos?per_page=100&type=all",
        headers={"Authorization": f"token {TOKEN}", "Accept": "application/vnd.github+json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            repos = json.load(r)
    except Exception as e:
        print(f"获取仓库列表失败: {e}", file=sys.stderr)
        sys.exit(1)

    if not repos:
        print("未获取到仓库，请检查 GITHUB_TOKEN 是否有效")
        sys.exit(1)

    for repo in repos:
        full_name = repo["full_name"]
        if full_name == KEEP_PUBLIC:
            print(f"[跳过] {full_name} （保持公开）")
            continue
        if repo.get("private"):
            print(f"[跳过] {full_name} （已是私有）")
            continue

        ok, err = set_private(full_name)
        if ok:
            print(f"设为私有: {full_name} ... OK")
        else:
            print(f"设为私有: {full_name} ... 失败 {err}")

    print("完成。")

def set_private(full_name):
    patch = urllib.request.Request(
        f"https://api.github.com/repos/{full_name}",
        data=b'{"private":true}',
        method="PATCH",
        headers={
            "Authorization": f"token {TOKEN}",
            "Accept": "application/vnd.github+json",
            "Content-Type": "application/json",
        },
    )
    for attempt in range(2):
        try:
            with urllib.request.urlopen(patch, timeout=15) as r:
                return True, None
        except urllib.error.HTTPError as e:
            body = e.read().decode()
            try:
                data = json.loads(body)
                msg = data.get("message", body)
                if data.get("errors"):
                    msg = msg + " " + str(data["errors"])
            except Exception:
                msg = body
            return False, f"HTTP {e.code} {msg}"
        except OSError as e:
            if attempt == 0:
                time.sleep(2)
                continue
            return False, str(e)
    return False, "未知错误"

if __name__ == "__main__":
    main()
