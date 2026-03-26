# OpenClaw - מדריך מלא בעברית

<div dir="rtl" align="right">

## מה זה OpenClaw?

**OpenClaw** היא פלטפורמת AI חכמה שמאפשרת לך להריץ סוכנים (Agents) אוטומטיים, לנהל ערוצי תקשורת (WhatsApp, Telegram, Discord ועוד), לשלוח הודעות, לתזמן משימות, ולנהל הכל דרך ממשק CLI או Gateway מבוסס WebSocket.

בקצרה: **OpenClaw הופכת את הטרמינל שלך למרכז שליטה חכם לאוטומציה ותקשורת.**

---

## תוכן עניינים

- [התקנה והגדרה ראשונית](#התקנה-והגדרה-ראשונית)
- [Gateway - השער הראשי](#gateway---השער-הראשי)
- [Agent - הסוכן החכם](#agent---הסוכן-החכם)
- [Channels - ערוצי תקשורת](#channels---ערוצי-תקשורת)
- [Message - שליחת וניהול הודעות](#message---שליחת-וניהול-הודעות)
- [Models - ניהול מודלים](#models---ניהול-מודלים)
- [Skills - כישורים](#skills---כישורים)
- [Plugins - תוספים](#plugins---תוספים)
- [Cron - תזמון משימות](#cron---תזמון-משימות)
- [Memory - זיכרון](#memory---זיכרון)
- [Sandbox - בידוד וסנדבוקס](#sandbox---בידוד-וסנדבוקס)
- [כלים נוספים](#כלים-נוספים)
- [אפשרויות גלובליות](#אפשרויות-גלובליות)
- [דוגמאות שימוש](#דוגמאות-שימוש)

---

## התקנה והגדרה ראשונית

### הגדרה אינטראקטיבית
```bash
openclaw configure
```
מפעיל תהליך הגדרה אינטראקטיבי שמוביל אותך דרך הגדרת credentials, ערוצים, gateway והגדרות ברירת מחדל לסוכנים.

### הגדרה מהירה
```bash
openclaw setup
```
אתחול קונפיגורציה מקומית ו-workspace לסוכן.

### Onboarding מלא
```bash
openclaw onboard
```
תהליך onboarding אינטראקטיבי ל-gateway, workspace וכישורים.

### בדיקת בריאות המערכת
```bash
openclaw doctor
```
מריץ בדיקות בריאות ותיקונים מהירים ל-gateway ולערוצים. אם משהו לא עובד - זו הפקודה הראשונה שכדאי להריץ.

---

## Gateway - השער הראשי

ה-Gateway הוא הלב של OpenClaw - שרת WebSocket שמנהל את כל התקשורת בין הסוכנים, הערוצים והמשתמשים.

### פקודות עיקריות

| פקודה | תיאור |
|--------|--------|
| `openclaw gateway run` | הפעלת ה-gateway בחזית (foreground) |
| `openclaw gateway start` | הפעלת ה-gateway כשירות רקע |
| `openclaw gateway stop` | עצירת השירות |
| `openclaw gateway restart` | הפעלה מחדש |
| `openclaw gateway status` | בדיקת סטטוס + נגישות |
| `openclaw gateway install` | התקנת ה-gateway כשירות מערכת (systemd/launchd) |
| `openclaw gateway uninstall` | הסרת השירות |
| `openclaw gateway discover` | גילוי gateways ברשת המקומית |
| `openclaw gateway health` | בדיקת בריאות |
| `openclaw gateway usage-cost` | סיכום עלויות שימוש |

### אפשרויות חשובות

- **`--port <port>`** - פורט ל-WebSocket
- **`--bind <mode>`** - מצב חיבור: `loopback` (מקומי), `lan` (רשת מקומית), `tailnet`, `auto`, `custom`
- **`--auth <mode>`** - מצב אימות: `none`, `token`, `password`, `trusted-proxy`
- **`--force`** - הריגת תהליך קיים על הפורט לפני הפעלה
- **`--tailscale <mode>`** - חשיפה דרך Tailscale: `off`, `serve`, `funnel`
- **`--verbose`** - לוגים מפורטים

### דוגמאות
```bash
# הפעלת gateway על פורט מותאם
openclaw gateway --port 18789

# הפעלת gateway במצב פיתוח (סביבה מבודדת)
openclaw --dev gateway

# הפעלה עם אימות טוקן
openclaw gateway run --auth token --token MY_SECRET_TOKEN
```

---

## Agent - הסוכן החכם

הסוכן הוא ה-AI שמריץ משימות עבורך. אתה שולח לו הודעה והוא מבצע פעולות, מחזיר תשובות, ויכול אפילו לשלוח את התשובה ישירות לערוץ תקשורת.

### פקודות עיקריות
```bash
# שליחת הודעה לסוכן בסשן חדש
openclaw agent --to +972501234567 --message "תן לי סיכום יומי"

# שימוש בסוכן ספציפי
openclaw agent --agent ops --message "סכם את הלוגים"

# עם רמת חשיבה (thinking) מוגדרת
openclaw agent --session-id 1234 --message "סכם תיבת דואר" --thinking medium

# שליחת התשובה ישירות לערוץ
openclaw agent --to +972501234567 --message "דוח מצב" --deliver

# העברת תשובה לערוץ אחר
openclaw agent --agent ops --message "צור דוח" --deliver --reply-channel slack --reply-to "#reports"
```

### אפשרויות

| אפשרות | תיאור |
|---------|--------|
| `--to <number>` | מספר טלפון של הנמען (E.164) |
| `--message <text>` | תוכן ההודעה לסוכן |
| `--agent <id>` | בחירת סוכן ספציפי |
| `--deliver` | שליחת התשובה חזרה לערוץ |
| `--thinking <level>` | רמת חשיבה: `off`, `minimal`, `low`, `medium`, `high`, `xhigh` |
| `--channel <channel>` | ערוץ משלוח: `telegram`, `whatsapp`, `discord`, `slack` ועוד |
| `--local` | הרצה מקומית (דורש מפתחות API במכונה) |
| `--json` | פלט בפורמט JSON |
| `--timeout <seconds>` | זמן מקסימלי (ברירת מחדל: 600 שניות) |

### ניהול סוכנים מרובים
```bash
openclaw agents          # ניהול סוכנים מבודדים (workspaces, auth, routing)
```

---

## Channels - ערוצי תקשורת

OpenClaw תומכת במגוון רחב של ערוצי תקשורת:

**WhatsApp** | **Telegram** | **Discord** | **Slack** | **Signal** | **iMessage** | **IRC** | **Google Chat** | **LINE**

### פקודות עיקריות

```bash
# הצגת כל הערוצים המוגדרים
openclaw channels list

# בדיקת סטטוס ערוצים
openclaw channels status --probe

# חיבור חשבון WhatsApp
openclaw channels login --channel whatsapp

# הוספת ערוץ Telegram
openclaw channels add --channel telegram --token <TOKEN>

# הסרת ערוץ
openclaw channels remove

# התנתקות
openclaw channels logout

# הצגת יכולות של ערוץ
openclaw channels capabilities

# צפייה בלוגים של ערוצים
openclaw channels logs
```

---

## Message - שליחת וניהול הודעות

מערכת הודעות עשירה שתומכת בשליחה, קריאה, עריכה, מחיקה, סקרים, תגובות ועוד.

### שליחת הודעות
```bash
# שליחת הודעת טקסט
openclaw message send --target +972501234567 --message "שלום!"

# שליחת הודעה עם מדיה
openclaw message send --target +972501234567 --message "תראה תמונה" --media photo.jpg

# שידור לכמה נמענים
openclaw message broadcast --targets "+972501234567,+972509876543" --message "עדכון חשוב"
```

### קריאת הודעות
```bash
openclaw message read --target +972501234567
```

### פעולות נוספות

| פקודה | תיאור |
|--------|--------|
| `message edit` | עריכת הודעה |
| `message delete` | מחיקת הודעה |
| `message pin` / `unpin` | הצמדה/ביטול הצמדה |
| `message pins` | הצגת הודעות מוצמדות |
| `message react` | הוספת/הסרת תגובה (אימוג'י) |
| `message reactions` | הצגת תגובות על הודעה |
| `message search` | חיפוש הודעות (Discord) |
| `message poll` | יצירת סקר |
| `message thread` | פעולות על threads |
| `message ban` | חסימת משתמש |
| `message kick` | הסרת משתמש |
| `message timeout` | השתקת משתמש זמנית |
| `message role` | ניהול תפקידים |
| `message permissions` | הצגת הרשאות ערוץ |
| `message voice` | פעולות קוליות |
| `message sticker` | פעולות סטיקרים |
| `message emoji` | פעולות אימוג'ים |

### דוגמה - יצירת סקר ב-Discord
```bash
openclaw message poll \
  --channel discord \
  --target channel:123 \
  --poll-question "מה להזמין?" \
  --poll-option "פיצה" \
  --poll-option "סושי"
```

### דוגמה - תגובה על הודעה
```bash
openclaw message react --channel discord --target 123 --message-id 456 --emoji "✅"
```

---

## Models - ניהול מודלים

ניהול מודלי AI שה-Agent משתמש בהם.

### פקודות עיקריות

```bash
# הצגת מודלים מוגדרים
openclaw models list

# הצגת סטטוס מודלים
openclaw models status

# הגדרת מודל ברירת מחדל
openclaw models set

# הגדרת מודל לתמונות
openclaw models set-image

# סריקת מודלים חינמיים ב-OpenRouter
openclaw models scan
```

### ניהול מתקדם

| פקודה | תיאור |
|--------|--------|
| `models aliases` | ניהול כינויים למודלים |
| `models auth` | ניהול פרופילי אימות למודלים |
| `models fallbacks` | ניהול רשימת fallback (מודלים חלופיים) |
| `models image-fallbacks` | ניהול fallback למודלי תמונה |

---

## Skills - כישורים

כישורים הם יכולות מוכנות מראש שהסוכן יכול להשתמש בהן.

```bash
# הצגת כל הכישורים הזמינים
openclaw skills list

# בדיקת כישורים מוכנים vs חסרים
openclaw skills check

# מידע מפורט על כישור
openclaw skills info <skill-name>

# התקנת כישור מ-ClawHub
openclaw skills install <skill-name>

# עדכון כישורים מותקנים
openclaw skills update

# חיפוש כישורים ב-ClawHub
openclaw skills search <query>
```

---

## Plugins - תוספים

מערכת תוספים להרחבת היכולות של OpenClaw.

```bash
# הצגת תוספים מותקנים
openclaw plugins list

# התקנת תוסף (מנתיב, npm, ClawHub או marketplace)
openclaw plugins install <source>

# הסרת תוסף
openclaw plugins uninstall <plugin>

# הפעלת/כיבוי תוסף
openclaw plugins enable <plugin>
openclaw plugins disable <plugin>

# בדיקת בעיות בטעינת תוספים
openclaw plugins doctor

# פרטים על תוסף
openclaw plugins inspect <plugin>

# עדכון תוספים
openclaw plugins update

# צפייה ב-marketplace
openclaw plugins marketplace
```

---

## Cron - תזמון משימות

תזמון משימות חוזרות דרך ה-Gateway.

```bash
# הצגת כל המשימות המתוזמנות
openclaw cron list

# הוספת משימה חדשה
openclaw cron add

# הרצה ידנית (לבדיקה)
openclaw cron run <job-id>

# עריכת משימה
openclaw cron edit <job-id>

# הפעלה/כיבוי משימה
openclaw cron enable <job-id>
openclaw cron disable <job-id>

# מחיקת משימה
openclaw cron rm <job-id>

# היסטוריית הרצות
openclaw cron runs

# סטטוס מתזמן
openclaw cron status
```

---

## Memory - זיכרון

מערכת זיכרון שמאפשרת לסוכן לזכור מידע בין שיחות.

```bash
# בדיקת סטטוס מערכת הזיכרון
openclaw memory status

# בדיקה מעמיקה (כולל embedding provider)
openclaw memory status --deep

# חיפוש בזיכרון
openclaw memory search "פגישות צוות"

# חיפוש עם הגבלת תוצאות
openclaw memory search --query "deployment" --max-results 20

# אינדוקס מחדש של קבצי זיכרון
openclaw memory index --force

# פלט JSON (טוב לסקריפטים)
openclaw memory status --json
```

---

## Sandbox - בידוד וסנדבוקס

ניהול קונטיינרים לבידוד סוכנים (מבוסס Docker).

```bash
# הצגת כל הקונטיינרים
openclaw sandbox list

# הצגת קונטיינרי דפדפן בלבד
openclaw sandbox list --browser

# יצירה מחדש של כל הקונטיינרים
openclaw sandbox recreate --all

# יצירה מחדש לסשן ספציפי
openclaw sandbox recreate --session main

# יצירה מחדש לסוכן ספציפי
openclaw sandbox recreate --agent mybot

# הסבר על מדיניות sandbox
openclaw sandbox explain
```

---

## כלים נוספים

### Browser - ניהול דפדפן
```bash
openclaw browser          # ניהול דפדפן ייעודי (Chrome/Chromium)
```

### DNS - גילוי ברשת רחבה
```bash
openclaw dns              # כלי DNS לגילוי דרך Tailscale + CoreDNS
```

### Devices - ניהול מכשירים
```bash
openclaw devices          # צימוד מכשירים + ניהול טוקנים
```

### Directory - ספריית אנשי קשר
```bash
openclaw directory        # חיפוש אנשי קשר וקבוצות בערוצים שונים
```

### Backup - גיבוי
```bash
openclaw backup           # יצירת ואימות גיבויים מקומיים
```

### Security - אבטחה
```bash
openclaw security         # כלי אבטחה וביקורת קונפיגורציה מקומית
```

### Sessions - סשנים
```bash
openclaw sessions         # הצגת שיחות שמורות
```

### Webhooks
```bash
openclaw webhooks         # כלי webhook ואינטגרציות
```

### Hooks - הוקים פנימיים
```bash
openclaw hooks            # ניהול הוקים פנימיים של סוכנים
```

### ACP - Agent Control Protocol
```bash
openclaw acp              # כלי פרוטוקול בקרת סוכנים
```

### Nodes - ניהול צמתים
```bash
openclaw node             # הרצת שירות node host ללא ממשק גרפי
openclaw nodes            # ניהול צימוד צמתים ופקודות
```

### Approvals - אישורים
```bash
openclaw approvals        # ניהול אישורי הרצה (gateway או node host)
```

### Secrets - סודות
```bash
openclaw secrets          # טעינה מחדש של secrets בזמן ריצה
```

### Dashboard
```bash
openclaw dashboard        # פתיחת ממשק ניהול ויזואלי (Control UI)
```

### TUI - ממשק טרמינל
```bash
openclaw tui              # פתיחת ממשק טרמינל מתקדם מחובר ל-Gateway
```

### Logs
```bash
openclaw logs             # מעקב אחר לוגים של ה-gateway
```

### QR Code
```bash
openclaw qr               # יצירת קוד QR לצימוד עם iOS
```

---

## אפשרויות גלובליות

אפשרויות שזמינות בכל פקודה:

| אפשרות | תיאור |
|---------|--------|
| `--container <name>` | הרצת CLI בתוך קונטיינר Docker/Podman |
| `--dev` | מצב פיתוח - מבודד מתחת ל-`~/.openclaw-dev` |
| `--profile <name>` | שימוש בפרופיל מותאם (מבודד state ו-config) |
| `--log-level <level>` | רמת לוגים: `silent`, `fatal`, `error`, `warn`, `info`, `debug`, `trace` |
| `--no-color` | כיבוי צבעים |
| `-V, --version` | הצגת גרסה |
| `-h, --help` | הצגת עזרה |

---

## דוגמאות שימוש מלאות

### תרחיש 1: הקמת מערכת מאפס
```bash
# 1. הגדרה ראשונית
openclaw configure

# 2. הפעלת ה-gateway
openclaw gateway run

# 3. חיבור WhatsApp
openclaw channels login --channel whatsapp

# 4. בדיקה שהכל עובד
openclaw doctor
```

### תרחיש 2: בוט שמגיב אוטומטית
```bash
# הגדרת סוכן עם משימה מתוזמנת
openclaw cron add  # הגדרת cron job שמריץ את הסוכן כל שעה

# בדיקת היסטוריית הרצות
openclaw cron runs
```

### תרחיש 3: שליחת עדכונים לכמה ערוצים
```bash
# שליחת הודעה ב-WhatsApp
openclaw message send --target +972501234567 --message "עדכון: הגרסה החדשה עלתה!"

# שליחת הודעה ב-Telegram
openclaw message send --channel telegram --target @mychat --message "עדכון: הגרסה החדשה עלתה!"

# שליחת הודעה ב-Discord
openclaw message send --channel discord --target channel:123456 --message "עדכון: הגרסה החדשה עלתה!"
```

### תרחיש 4: מצב פיתוח מבודד
```bash
# הפעלת gateway במצב dev (לא משפיע על הסביבה הראשית)
openclaw --dev gateway

# הרצת סוכן מקומי (ללא gateway)
openclaw agent --local --message "בדיקה מקומית"
```

---

## קישורים שימושיים

- [תיעוד רשמי](https://docs.openclaw.ai/cli)
- **גרסה נוכחית:** 2026.3.24

---

> **OpenClaw** - הופכת את הטרמינל שלך למרכז שליטה חכם לאוטומציה ותקשורת.

</div>
