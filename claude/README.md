# Claude Code - מדריך מלא בעברית

<div dir="rtl" align="right">

## מה זה Claude Code?

**Claude Code** הוא כלי CLI רשמי של Anthropic שמאפשר לך לעבוד עם Claude ישירות מהטרמינל. הוא מספק סשן אינטראקטיבי עם AI שיכול לקרוא, לכתוב ולערוך קבצים, להריץ פקודות, לעבוד עם Git, לנהל שרתי MCP ועוד.

בקצרה: **Claude Code הופך את הטרמינל שלך לעוזר AI חכם לפיתוח תוכנה.**

---

## תוכן עניינים

- [שימוש בסיסי](#שימוש-בסיסי)
- [מצבי הרצה](#מצבי-הרצה)
- [אפשרויות סשן](#אפשרויות-סשן)
- [מודלים ורמות מאמץ](#מודלים-ורמות-מאמץ)
- [MCP - שרתי Model Context Protocol](#mcp---שרתי-model-context-protocol)
- [Auth - ניהול אימות](#auth---ניהול-אימות)
- [Auto Mode - מצב אוטומטי](#auto-mode---מצב-אוטומטי)
- [Agents - סוכנים מותאמים](#agents---סוכנים-מותאמים)
- [Plugins - תוספים](#plugins---תוספים)
- [כלים ותבניות פלט](#כלים-ותבניות-פלט)
- [הרשאות ואבטחה](#הרשאות-ואבטחה)
- [Worktree - עבודה מבודדת עם Git](#worktree---עבודה-מבודדת-עם-git)
- [פקודות ניהול](#פקודות-ניהול)
- [אפשרויות מתקדמות](#אפשרויות-מתקדמות)
- [דוגמאות שימוש](#דוגמאות-שימוש)

---

## שימוש בסיסי

### הפעלת סשן אינטראקטיבי
```bash
claude
```
פותח סשן אינטראקטיבי שבו אתה יכול לשוחח עם Claude, לבקש ממנו לערוך קוד, לחפש בקבצים, להריץ פקודות ועוד.

### שליחת prompt ישירות
```bash
claude "תסביר לי מה עושה הפונקציה הזו"
```

### מצב הדפסה (לא אינטראקטיבי)
```bash
claude -p "תסכם לי את הקובץ main.py"
```
מדפיס את התשובה ויוצא - שימושי לצינורות (pipes) ולסקריפטים.

---

## מצבי הרצה

### סשן אינטראקטיבי (ברירת מחדל)
```bash
claude
```
נכנס לצ'אט אינטראקטיבי עם Claude.

### מצב Print (`-p` / `--print`)
```bash
claude -p "מה עושה הקוד הזה?"
```
מחזיר תשובה ויוצא. שימושי לשילוב בסקריפטים:
```bash
cat error.log | claude -p "תנתח את השגיאה הזו"
```

### המשך סשן קיים (`-c` / `--continue`)
```bash
claude -c
```
ממשיך את השיחה האחרונה בתיקייה הנוכחית.

### חזרה לסשן לפי ID (`-r` / `--resume`)
```bash
# פותח בורר אינטראקטיבי
claude -r

# לפי מזהה סשן ספציפי
claude -r <session-id>

# חיפוש סשן לפי מילת מפתח
claude -r "refactor"
```

### חזרה לסשן מ-PR
```bash
# לפי מספר PR
claude --from-pr 123

# לפי URL
claude --from-pr https://github.com/user/repo/pull/123
```

### Fork של סשן
```bash
claude --resume <session-id> --fork-session
```
ממשיך שיחה אבל יוצר סשן חדש (לא משנה את המקורי).

---

## אפשרויות סשן

### שם לסשן
```bash
claude -n "רפקטור מודול Auth"
```
מגדיר שם תצוגה לסשן - מופיע ב-`/resume` ובכותרת הטרמינל.

### מזהה סשן ספציפי
```bash
claude --session-id <uuid>
```

### ללא שמירת סשן
```bash
claude -p --no-session-persistence "שאלה חד-פעמית"
```
הסשן לא יישמר לדיסק ולא ניתן יהיה לחזור אליו.

---

## מודלים ורמות מאמץ

### בחירת מודל
```bash
# לפי כינוי
claude --model sonnet
claude --model opus

# לפי שם מלא
claude --model claude-sonnet-4-6
```

### מודל גיבוי (fallback)
```bash
claude -p --fallback-model claude-haiku-4-5-20251001 "שאלה מהירה"
```
אם המודל הראשי עמוס, עובר אוטומטית למודל הגיבוי (עובד רק עם `--print`).

### רמת מאמץ
```bash
claude --effort low "שאלה פשוטה"
claude --effort high "משימה מורכבת"
claude --effort max "ניתוח מעמיק"
```
רמות: `low`, `medium`, `high`, `max`

---

## MCP - שרתי Model Context Protocol

MCP מאפשר ל-Claude להתחבר לשרתים חיצוניים שמספקים כלים ומשאבים נוספים.

### הוספת שרת MCP

```bash
# שרת HTTP
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# שרת HTTP עם headers
claude mcp add --transport http corridor https://app.corridor.dev/api/mcp \
  --header "Authorization: Bearer TOKEN"

# שרת stdio עם משתני סביבה
claude mcp add -e API_KEY=xxx my-server -- npx my-mcp-server

# שרת stdio עם פרמטרים
claude mcp add my-server -- my-command --some-flag arg1
```

### הוספת שרת כ-JSON
```bash
claude mcp add-json my-server '{"command":"npx","args":["my-mcp-server"]}'
```

### ייבוא מ-Claude Desktop
```bash
claude mcp add-from-claude-desktop
```
מייבא שרתי MCP מהגדרות Claude Desktop (Mac ו-WSL בלבד).

### הצגת שרתים מוגדרים
```bash
claude mcp list
```

### פרטים על שרת
```bash
claude mcp get <name>
```

### הסרת שרת
```bash
claude mcp remove <name>
```

### איפוס אישורי פרויקט
```bash
claude mcp reset-project-choices
```
מאפס את כל השרתים שאושרו/נדחו מ-`.mcp.json` בפרויקט הנוכחי.

### הפעלת שרת MCP של Claude Code
```bash
claude mcp serve
```
מפעיל את Claude Code עצמו כשרת MCP (לחיבור מכלים אחרים).

### טעינת קונפיגורציה חיצונית
```bash
# קובץ JSON
claude --mcp-config mcp-servers.json

# רק שרתים מהקונפיגורציה (מתעלם מכל השאר)
claude --strict-mcp-config --mcp-config my-servers.json
```

---

## Auth - ניהול אימות

### התחברות
```bash
claude auth login
```
כניסה לחשבון Anthropic.

### התנתקות
```bash
claude auth logout
```

### בדיקת סטטוס
```bash
claude auth status
```

### הגדרת טוקן קבוע
```bash
claude setup-token
```
מגדיר טוקן אימות ארוך-טווח (דורש מנוי Claude).

---

## Auto Mode - מצב אוטומטי

מצב אוטומטי מאפשר ל-Claude לבצע פעולות ללא אישור ידני, בהתבסס על כללים שמוגדרים מראש.

### הצגת קונפיגורציה
```bash
claude auto-mode config
```
מציג את ההגדרות הנוכחיות (שלך + ברירות מחדל).

### הצגת ברירות מחדל
```bash
claude auto-mode defaults
```
מציג את כללי ברירת המחדל (environment, allow, deny).

### ביקורת על כללים מותאמים
```bash
claude auto-mode critique
```
מקבל פידבק מ-AI על הכללים שהגדרת.

### הפעלת מצב הרשאות
```bash
# מצב ברירת מחדל - מבקש אישור לפעולות רגישות
claude --permission-mode default

# מאשר עריכות אוטומטית
claude --permission-mode acceptEdits

# עוקף את כל בדיקות ההרשאות (רק לסנדבוקס!)
claude --permission-mode bypassPermissions

# מצב תכנון בלבד (ללא שינויים)
claude --permission-mode plan

# מצב אוטומטי מלא
claude --permission-mode auto
```

---

## Agents - סוכנים מותאמים

### הגדרת סוכנים בשורת הפקודה
```bash
claude --agents '{"reviewer": {"description": "בודק קוד", "prompt": "אתה בודק קוד מקצועי"}}'
```

### בחירת סוכן לסשן
```bash
claude --agent reviewer
```

### הצגת סוכנים מוגדרים
```bash
claude agents
```

---

## Plugins - תוספים

### ניהול תוספים
```bash
claude plugin
```

### טעינת תוספים מתיקייה
```bash
claude --plugin-dir /path/to/plugins
```

---

## כלים ותבניות פלט

### הגבלת כלים זמינים
```bash
# רק Bash ו-Read
claude --tools "Bash,Read"

# כיבוי כל הכלים
claude --tools ""

# כל הכלים (ברירת מחדל)
claude --tools "default"
```

### כלים מותרים/חסומים
```bash
# לאפשר רק פקודות git ב-Bash
claude --allowedTools "Bash(git:*) Edit"

# לחסום כלים ספציפיים
claude --disallowedTools "Bash(rm:*)"
```

### פורמט פלט (עם `--print`)
```bash
# טקסט רגיל (ברירת מחדל)
claude -p --output-format text "שאלה"

# JSON (תוצאה אחת)
claude -p --output-format json "שאלה"

# Stream JSON (זרימה בזמן אמת)
claude -p --output-format stream-json "שאלה"
```

### פורמט קלט
```bash
# טקסט (ברירת מחדל)
claude -p --input-format text "שאלה"

# Stream JSON (קלט זורם)
claude -p --input-format stream-json
```

### פלט מובנה (JSON Schema)
```bash
claude -p --json-schema '{"type":"object","properties":{"name":{"type":"string"}},"required":["name"]}' "מה השם שלך?"
```

### כלול הודעות חלקיות (streaming)
```bash
claude -p --output-format stream-json --include-partial-messages "שאלה"
```

---

## הרשאות ואבטחה

### מצבי הרשאות

| מצב | תיאור |
|------|--------|
| `default` | מבקש אישור לפעולות רגישות |
| `acceptEdits` | מאשר עריכות קבצים אוטומטית |
| `plan` | מצב תכנון - קורא בלבד, ללא שינויים |
| `auto` | מצב אוטומטי מלא עם כללים |
| `dontAsk` | לא שואל שאלות |
| `bypassPermissions` | עוקף הכל (רק לסנדבוקס מבודד!) |

### דילוג על הרשאות (זהירות!)
```bash
# מאפשר את האופציה (לא מפעיל אוטומטית)
claude --allow-dangerously-skip-permissions

# עוקף את כל ההרשאות (רק לסנדבוקסים ללא אינטרנט!)
claude --dangerously-skip-permissions
```

### הגבלת תקציב
```bash
claude -p --max-budget-usd 5.00 "משימה גדולה"
```
מגביל את הסכום המקסימלי שיוצא על קריאות API (עובד רק עם `--print`).

---

## Worktree - עבודה מבודדת עם Git

### יצירת worktree חדש
```bash
# שם אוטומטי
claude -w

# שם מותאם
claude -w "feature-auth"
```
יוצר git worktree חדש ועובד בו בסשן מבודד.

### עם tmux
```bash
claude -w --tmux
```
פותח את ה-worktree בסשן tmux נפרד.

---

## פקודות ניהול

### בדיקת בריאות
```bash
claude doctor
```
בודק את מצב ה-auto-updater, שרתי MCP ובריאות כללית.

### עדכון
```bash
claude update
```
בודק עדכונים ומתקין אם זמין.

### התקנת גרסה
```bash
# גרסה יציבה
claude install stable

# גרסה אחרונה
claude install latest

# גרסה ספציפית
claude install 1.2.3
```

### גרסה
```bash
claude -v
```

---

## אפשרויות מתקדמות

### System Prompt מותאם
```bash
# החלפת ה-system prompt
claude --system-prompt "אתה מומחה אבטחה"

# הוספה ל-system prompt הקיים
claude --append-system-prompt "תמיד תענה בעברית"
```

### תיקיות נוספות
```bash
claude --add-dir /path/to/other/project
```
מוסיף תיקיות נוספות שהכלים יכולים לגשת אליהן.

### מצב Bare (מינימלי)
```bash
claude --bare
```
מצב מינימלי: מדלג על hooks, LSP, סנכרון תוספים, זיכרון אוטומטי, גילוי CLAUDE.md ועוד. שימושי לסקריפטים ואוטומציה.

### Debug
```bash
# מצב debug מלא
claude -d

# לפי קטגוריה
claude -d "api,hooks"

# כתיבה לקובץ
claude --debug-file /tmp/claude-debug.log
```

### Beta headers
```bash
claude --betas "feature-x feature-y"
```

### כיבוי Slash Commands
```bash
claude --disable-slash-commands
```

### Chrome Integration
```bash
# הפעלה
claude --chrome

# כיבוי
claude --no-chrome
```

### הגדרות נוספות
```bash
# טעינת הגדרות מקובץ
claude --settings /path/to/settings.json

# בחירת מקורות הגדרות
claude --setting-sources "user,project"
```

### קבצים חיצוניים
```bash
claude --file file_abc:doc.txt --file file_def:img.png
```
הורדת קבצים בהתחלת הסשן.

### Verbose
```bash
claude --verbose
```

---

## דוגמאות שימוש מלאות

### תרחיש 1: עבודה יומית על פרויקט
```bash
# פתיחת סשן עם שם
claude -n "פיצ'ר התחברות חדש"

# המשך עבודה מאוחר יותר
claude -c

# חיפוש סשן ישן
claude -r "התחברות"
```

### תרחיש 2: ניתוח קוד בסקריפט
```bash
# ניתוח שגיאה מלוג
cat error.log | claude -p "מה הבעיה כאן?"

# סיכום שינויים ב-PR
git diff main | claude -p "סכם את השינויים"

# בדיקת קוד עם תקציב מוגבל
claude -p --max-budget-usd 1.00 "בדוק את הקוד ב-src/ לבעיות אבטחה"
```

### תרחיש 3: עבודה עם MCP
```bash
# הוספת שרת Sentry
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# הוספת שרת מקומי
claude mcp add my-tools -- npx my-mcp-tools

# הפעלה עם שרתים מותאמים בלבד
claude --strict-mcp-config --mcp-config my-servers.json
```

### תרחיש 4: עבודה מבודדת על פיצ'ר
```bash
# יצירת worktree חדש עם tmux
claude -w "new-feature" --tmux

# עבודה עם מודל ספציפי ורמת מאמץ גבוהה
claude --model opus --effort max
```

### תרחיש 5: אוטומציה מלאה
```bash
# מצב אוטומטי עם fallback
claude -p --permission-mode auto \
  --fallback-model claude-haiku-4-5-20251001 \
  --max-budget-usd 10.00 \
  "רפקטר את כל הקבצים בתיקיית src/ לשימוש ב-async/await"
```

### תרחיש 6: פלט מובנה
```bash
claude -p --output-format json \
  --json-schema '{"type":"object","properties":{"bugs":{"type":"array","items":{"type":"string"}}},"required":["bugs"]}' \
  "מצא באגים בקובץ main.py"
```

---

## סיכום פקודות מהיר

| פקודה | תיאור |
|--------|--------|
| `claude` | סשן אינטראקטיבי |
| `claude -p "..."` | הדפסה ויציאה |
| `claude -c` | המשך סשן אחרון |
| `claude -r` | חזרה לסשן |
| `claude -w` | עבודה ב-worktree |
| `claude -n "שם"` | סשן עם שם |
| `claude --model opus` | בחירת מודל |
| `claude --effort high` | רמת מאמץ |
| `claude auth login` | התחברות |
| `claude mcp list` | שרתי MCP |
| `claude doctor` | בדיקת בריאות |
| `claude update` | עדכון |

---

## קישורים שימושיים

- [תיעוד Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [GitHub - Claude Code](https://github.com/anthropics/claude-code)

---

> **Claude Code** - העוזר החכם שלך בטרמינל לפיתוח תוכנה.

</div>
