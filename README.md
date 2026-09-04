# US Sector Dashboard

美股 Sector Allocation / Research Dashboard 的本地项目版。

## 本地启动

1. 双击 `open_dashboard_app.bat`
2. 浏览器打开 `http://127.0.0.1:8766/dashboard`
3. 页面顶部 Macro tab 的「データ更新」按钮会按顺序刷新 Macro、Technical、Breadth、Fear & Greed，并重新生成 preview

## 直接在 Chrome / 公司电脑打开

- 本机看最新版：双击 `open_dashboard_app.bat`，不要下载 HTML。
- 公司电脑看本地文件版：双击 `download_dashboard_from_github.bat`。它会从 GitHub 下载最新 `public/index.html`，保存到 `Documents\US_Sector_Dashboard\index.html`，然后自动用 Chrome 或默认浏览器打开。
- 如果只是想直接看网页，也可以打开 `https://01015-joshua.github.io/us-sector-dashboard/`。
- GitHub 仓库里的 `public/index.html` 文件页面不是最终网页，点 raw/html 文件时浏览器可能会变成下载；公司电脑建议使用 `download_dashboard_from_github.bat`。

## 私有数据

不要上传到 GitHub：

- `private_data/`：Bloomberg Excel、API key、手工下载的授权数据
- `outputs/`：生成后的 HTML，可能包含 Bloomberg / FactSet 派生数据
- `logs/`：本地运行日志

当前 Market 的 Forward EPS / Forward P/E / price 仍使用 Bloomberg export。以后切 Bloomberg API 时，优先替换 `engine/build_nonmacro_fixed.py` 里的 Market data provider，不改页面结构。

## Bloomberg Excel

默认读取：

`private_data/BDwithBBG_260903.xlsx`

也可以用环境变量指定：

`DASHBOARD_BLOOMBERG_XLSX=C:\path\to\BDwithBBG_260903.xlsx`

## GitHub 上传建议

只提交代码和说明，不提交私有数据与生成结果。第一次在新电脑运行前，把 Bloomberg 文件放到 `private_data/`，然后双击启动并更新。
