import os
import html as h

screen_dir = 'our-flutter-project/lib/screens'
core_dir = 'our-flutter-project/lib/core'
shared_dir = 'our-flutter-project/lib/shared'
out_dir = 'current_UI'
os.makedirs(out_dir, exist_ok=True)

COLORS = {
    'primary': '#003E74',
    'surface': '#F9F9FF',
    'surfaceLowest': '#FFFFFF',
    'surfaceLow': '#F3F3F9',
    'surfaceVariant': '#E1E2E8',
    'onSurface': '#191C20',
    'onSurfaceVar': '#424750',
    'outline': '#C2C6D2',
}

TEMPLATE_TOP = """<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
<title>SSCare - {title}</title>
<style>
  * {{ margin: 0; padding: 0; box-sizing: border-box; }}
  body {{
    font-family: 'Inter', -apple-system, sans-serif;
    background: {bg};
    color: {fg};
    max-width: 430px;
    margin: 0 auto;
    min-height: 100vh;
  }}
  .header {{
    font-family: 'Plus Jakarta Sans', sans-serif;
    font-size: 20px;
    font-weight: 800;
    color: {primary};
    padding: 20px 24px 12px;
    background: {white};
  }}
  .meta {{
    padding: 12px 24px;
    font-size: 12px;
    color: {muted};
    background: {low};
    border-bottom: 1px solid {border};
  }}
  pre {{
    background: {low};
    padding: 16px;
    margin: 0;
    font-size: 11px;
    overflow-x: auto;
    white-space: pre-wrap;
    font-family: 'Cascadia Code', 'Fira Code', monospace;
    line-height: 1.6;
    color: {fg};
  }}
  .nav {{
    position: fixed;
    bottom: 0;
    left: 50%;
    transform: translateX(-50%);
    width: 100%;
    max-width: 430px;
    background: {white};
    display: flex;
    justify-content: space-around;
    padding: 10px 0 14px;
    border-top: 1px solid {border};
    font-size: 11px;
    color: {muted};
  }}
  .nav div {{ text-align: center; }}
  .nav .active {{ color: {primary}; font-weight: 700; }}
  .nav .ico {{ font-size: 20px; display: block; }}
  .spacer {{ height: 60px; }}
</style>
</head>
<body>
<div class="header">{title}</div>
<div class="meta">
  <strong>File:</strong> {filepath}<br>
  <strong>Design:</strong> Navy #003E74 + Gold #FFB870
</div>
<pre>{code}</pre>
<div class="nav">
  <div class="active"><span class="ico">🏠</span>Trang chủ</div>
  <div><span class="ico">👨‍👩‍👧</span>Quản lý con</div>
  <div><span class="ico">📚</span>Thư viện</div>
  <div><span class="ico">🔔</span>Thông báo</div>
</div>
<div class="spacer"></div>
</body>
</html>"""

def export(title, filepath, dart_code):
    html_content = TEMPLATE_TOP.format(
        title=title,
        filepath=filepath,
        code=h.escape(dart_code),
        bg=COLORS['surface'],
        fg=COLORS['onSurface'],
        primary=COLORS['primary'],
        white=COLORS['surfaceLowest'],
        low=COLORS['surfaceLow'],
        muted=COLORS['onSurfaceVar'],
        border=COLORS['surfaceVariant'],
    )
    out_name = os.path.basename(filepath).replace('.dart', '.html')
    with open(os.path.join(out_dir, out_name), 'w', encoding='utf-8') as f:
        f.write(html_content)
    print(f'  {out_name}')

# Screens
screens = {
    'Landing Screen': 'landing_screen.dart',
    'Dashboard Screen': 'dashboard_screen.dart',
    'Children Screen': 'children_screen.dart',
    'Child Detail Screen': 'child_detail_screen.dart',
    'Check-in Tab': 'checkin_tab.dart',
    'Mood Calendar Tab': 'mood_calendar_tab.dart',
    'Measurements Tab': 'measurements_tab.dart',
    'Cycle Tab': 'cycle_tab.dart',
    'Reports Tab': 'reports_tab.dart',
    'Practice Tab': 'practice_tab.dart',
    'Reminders Tab': 'reminders_tab.dart',
    'Library Screen': 'library_screen.dart',
    'Article Detail Screen': 'article_detail_screen.dart',
    'Notifications Screen': 'notifications_screen.dart',
    'Profile Screen': 'profile_screen.dart',
    'Auth Screens': 'auth_screens.dart',
}

print('Exporting screens:')
for title, fname in screens.items():
    fpath = os.path.join(screen_dir, fname)
    if os.path.exists(fpath):
        code = open(fpath, encoding='utf-8').read()
        export(title, f'lib/screens/{fname}', code)

# Core
print('Exporting core:')
for fname in ['theme.dart', 'strings.dart']:
    fpath = os.path.join(core_dir, fname)
    code = open(fpath, encoding='utf-8').read()
    export(f'Core: {fname}', f'lib/core/{fname}', code)

# Shared
print('Exporting shared:')
for fname in ['child_picker.dart']:
    fpath = os.path.join(shared_dir, fname)
    if os.path.exists(fpath):
        code = open(fpath, encoding='utf-8').read()
        export(f'Shared: {fname}', f'lib/shared/{fname}', code)

# Count
total = len(os.listdir(out_dir))
print(f'\nDone: {total} HTML files in current_UI/')
