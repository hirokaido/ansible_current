import os
import sys

# ビルド成果物が出力されるディレクトリ名
OUTPUT_DIR = "build_output"

def build_website():
    print("--- 💻 ビルド開始 ---")
    
    # 成果物ディレクトリの作成
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        print(f"ディレクトリを作成しました: {OUTPUT_DIR}")
    
    # デプロイ用HTMLコンテンツの定義
    html_content = f"""
<!DOCTYPE html>
<html>
<head>
    <title>GitHub Actions Demo</title>
</head>
<body>
    <h1>デプロイ成功！</h1>
    <p>このページはGitHub Actionsセルフホストランナーによってビルド・デプロイされました。</p>
    <p>実行コマンド: {' '.join(sys.argv)}</p>
</body>
</html>
"""
    
    # ファイルをビルドディレクトリに出力
    output_path = os.path.join(OUTPUT_DIR, "index.html")
    with open(output_path, "w") as f:
        f.write(html_content)
        
    print(f"✅ ファイル生成完了: {output_path}")
    print("--- ビルド終了 ---")

if __name__ == "__main__":
    # ワークフローからの引数 '--build' をチェック
    if "--build" in sys.argv:
        build_website()
    else:
        print("エラー: ビルド引数 '--build' が見つかりません。")
        sys.exit(1)
