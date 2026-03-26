# OpenClaw - מדריך קונפיגורציה מלא ומפורט בעברית

<div dir="rtl" align="right">

## מה מכיל המדריך הזה?

מדריך זה מסביר **לעומק** כל אפשרות שקיימת בקונפיגורציה של OpenClaw. כשאתה מריץ `openclaw configure` אתה עובר תהליך אינטראקטיבי שמגדיר את כל המערכת. כאן תמצא הסבר מפורט על כל חלק, מה הוא עושה, למה הוא חשוב, ודוגמאות מלאות.

> לתיעוד פקודות בסיסי ראה: [openclaw/README.md](openclaw/README.md) | [claude/README.md](claude/README.md)

---

## תוכן עניינים

- [מבנה קובץ הקונפיגורציה](#מבנה-קובץ-הקונפיגורציה)
- [MODEL - מודל ה-AI](#model---מודל-ה-ai)
- [GATEWAY - השער הראשי](#gateway---השער-הראשי)
- [AUTH - אימות והרשאות](#auth---אימות-והרשאות)
- [CHANNELS - ערוצי תקשורת](#channels---ערוצי-תקשורת)
- [WORKSPACE - סביבת העבודה](#workspace---סביבת-העבודה)
- [WEB - חיפוש ואחזור מהרשת](#web---חיפוש-ואחזור-מהרשת)
- [SKILLS - כישורים וכלים](#skills---כישורים-וכלים)
- [HEALTH - בריאות המערכת](#health---בריאות-המערכת)
- [AGENTS - ניהול סוכנים](#agents---ניהול-סוכנים)
- [TOOLS - הגדרות כלים](#tools---הגדרות-כלים)
- [COMMANDS - הגדרות פקודות](#commands---הגדרות-פקודות)
- [MEMORY - זיכרון סמנטי](#memory---זיכרון-סמנטי)
- [SANDBOX - בידוד קונטיינרים](#sandbox---בידוד-קונטיינרים)
- [SECURITY - אבטחה](#security---אבטחה)
- [CRON - תזמון משימות](#cron---תזמון-משימות)
- [PLUGINS - תוספים](#plugins---תוספים)
- [WEBHOOKS - התראות חיצוניות](#webhooks---התראות-חיצוניות)
- [DNS ו-TAILSCALE - גילוי ברשת רחבה](#dns-ו-tailscale---גילוי-ברשת-רחבה)
- [BACKUP - גיבוי](#backup---גיבוי)

---

## מבנה קובץ הקונפיגורציה

קובץ הקונפיגורציה של OpenClaw נמצא ב:
```
~/.openclaw/openclaw.json
```

אפשר לגשת אליו ישירות או דרך פקודות:
```bash
# הצגת נתיב הקובץ
openclaw config file

# קריאת ערך ספציפי
openclaw config get gateway.mode

# הגדרת ערך
openclaw config set gateway.port 19001

# מחיקת ערך
openclaw config unset gateway.auth.password

# בדיקת תקינות
openclaw config validate
```

### מבנה הקובץ המלא
```json
{
  "meta": { ... },
  "wizard": { ... },
  "auth": { ... },
  "agents": { ... },
  "tools": { ... },
  "commands": { ... },
  "gateway": { ... }
}
```

---

## MODEL - מודל ה-AI

### מה זה?

המודל הוא ה"מוח" של הסוכן. זה מודל ה-AI שמעבד את ההודעות שלך, מבין הקשר, מנתח מידע, ומחזיר תשובות. בחירת המודל היא אחת ההחלטות הכי חשובות בקונפיגורציה כי היא משפיעה ישירות על:

- **איכות התשובות** - מודלים גדולים יותר (כמו Opus) נותנים תשובות מעמיקות ומדויקות יותר
- **מהירות התגובה** - מודלים קטנים (כמו Haiku/Sonnet) מגיבים מהר יותר
- **עלות** - כל קריאה למודל עולה כסף, מודלים גדולים יקרים יותר
- **יכולות** - חלק מהמודלים תומכים בתמונות, חלק לא

### מודלים זמינים

| מודל | סוג קלט | חלון הקשר | תיאור |
|-------|----------|------------|--------|
| `anthropic/claude-sonnet-4-6` | טקסט + תמונה | 977K tokens | מודל מאוזן - איכות גבוהה במהירות טובה. **מומלץ לשימוש יומי** |
| `anthropic/claude-opus-4-6` | טקסט + תמונה | 977K tokens | המודל החזק ביותר - לניתוח מורכב, קוד, ומשימות קריטיות |

### מה זה "חלון הקשר" (Context Window)?

חלון ההקשר הוא כמות ה"טקסט" שהמודל יכול "לזכור" בשיחה אחת. 977K tokens זה בערך 700,000 מילים - מספיק לנתח ספרים שלמים או בסיסי קוד גדולים בשיחה אחת.

### מה זה Tokens?

טוקנים הם יחידות הטקסט שהמודל מעבד. בערך:
- מילה באנגלית = 1-2 טוקנים
- מילה בעברית = 2-4 טוקנים
- שורת קוד = 5-15 טוקנים

### קונפיגורציה במערכת

ההגדרה נמצאת ב-`agents.defaults.model`:
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-sonnet-4-6",
        "fallbacks": [
          "anthropic/claude-opus-4-6"
        ]
      },
      "models": {
        "anthropic/claude-opus-4-6": {},
        "anthropic/claude-sonnet-4-6": {}
      }
    }
  }
}
```

### הסבר על כל שדה

- **`primary`** - המודל הראשי שישמש כברירת מחדל. כל הודעה שנשלחת לסוכן תעבד קודם כל על ידי המודל הזה.
- **`fallbacks`** - רשימת מודלים חלופיים. אם המודל הראשי לא זמין (עמוס, שגיאה, timeout), המערכת תנסה אוטומטית את המודל הבא ברשימה. זה מבטיח שהמערכת תמיד תענה.
- **`models`** - הגדרות ספציפיות לכל מודל (למשל טמפרטורה, max tokens). אובייקט ריק `{}` אומר "השתמש בברירות מחדל".

### פקודות ניהול מודלים

```bash
# הצגת כל המודלים המוגדרים
openclaw models list

# הצגת סטטוס מלא (כולל auth ו-fallbacks)
openclaw models status

# שינוי מודל ברירת מחדל
openclaw models set
# → תפריט אינטראקטיבי לבחירת מודל

# שינוי מודל דרך config ישירות
openclaw config set agents.defaults.model.primary "anthropic/claude-opus-4-6"
```

### כינויים (Aliases)

כינויים מאפשרים לך להשתמש בשמות קצרים במקום שמות מודלים מלאים:
```bash
# הצגת כינויים קיימים
openclaw models aliases list
# opus   -> anthropic/claude-opus-4-6
# sonnet -> anthropic/claude-sonnet-4-6

# הוספת כינוי חדש
openclaw models aliases add fast anthropic/claude-sonnet-4-6

# שימוש בכינוי
openclaw agent --model opus --message "נתח את הקוד"
```

### Fallbacks - מודלים חלופיים

Fallbacks הם "רשת ביטחון". אם המודל הראשי נופל, המערכת עוברת אוטומטית לחלופי:
```bash
# הצגת fallbacks
openclaw models fallbacks

# דוגמה לקונפיגורציה מתקדמת:
{
  "model": {
    "primary": "anthropic/claude-sonnet-4-6",
    "fallbacks": [
      "anthropic/claude-opus-4-6",
      "openrouter/google/gemini-2.5-pro"
    ]
  }
}
```
במקרה הזה: קודם ינסה Sonnet, אם נכשל ינסה Opus, ואם גם זה נכשל ינסה Gemini דרך OpenRouter.

### מודל לתמונות

אפשר להגדיר מודל נפרד ליצירת תמונות:
```bash
openclaw models set-image
openclaw models image-fallbacks
```

### דוגמאות קונפיגורציה

**קונפיגורציה חסכונית (לשימוש אישי קל):**
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-sonnet-4-6",
        "fallbacks": []
      }
    }
  }
}
```

**קונפיגורציה מקצועית (אמינות מקסימלית):**
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-opus-4-6",
        "fallbacks": [
          "anthropic/claude-sonnet-4-6"
        ]
      }
    }
  }
}
```

**קונפיגורציה עם OpenRouter (גישה למודלים נוספים):**
```bash
# סריקת מודלים חינמיים ב-OpenRouter
openclaw models scan
```

---

## GATEWAY - השער הראשי

### מה זה?

ה-Gateway הוא **השרת המרכזי** של OpenClaw. הוא פועל ברקע ומנהל את כל התקשורת:

- מקבל הודעות מערוצי תקשורת (WhatsApp, Telegram, Discord...)
- מעביר אותן לסוכן AI לעיבוד
- שולח את התשובות חזרה לערוץ המתאים
- מנהל סשנים, זיכרון, cron jobs, ועוד

בלי ה-Gateway, OpenClaw לא יכולה לקבל ולשלוח הודעות אוטומטית.

### מצבי פעולה

**`local`** - ה-Gateway רץ על המכונה שלך. זה המצב הנפוץ ביותר.
```json
{
  "gateway": {
    "mode": "local"
  }
}
```

**`remote`** - ה-Gateway רץ על שרת אחר. אתה רק מתחבר אליו מרחוק.

### קונפיגורציה מלאה

```json
{
  "gateway": {
    "mode": "local",
    "port": 18789,
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "your-secret-token-here"
    }
  }
}
```

### הסבר על כל שדה

#### `mode` - מצב פעולה
| ערך | תיאור |
|------|--------|
| `local` | ה-Gateway רץ על המכונה הזו. OpenClaw מנהלת אותו ישירות |
| `remote` | ה-Gateway רץ במקום אחר. אתה מתחבר אליו דרך WebSocket |

#### `port` - פורט
הפורט שעליו ה-Gateway מקשיב. ברירת מחדל: **18789**.
במצב dev: **19001**.

```bash
# שינוי פורט
openclaw config set gateway.port 19001

# הפעלה עם פורט מותאם
openclaw gateway run --port 20000
```

#### `bind` - מצב חיבור

מגדיר מאיפה אפשר להתחבר ל-Gateway:

| ערך | תיאור | מתי להשתמש |
|------|--------|------------|
| `loopback` | רק מהמכונה המקומית (127.0.0.1) | **הכי בטוח** - לשימוש אישי על הלפטופ |
| `lan` | מכל מכונה ברשת המקומית (0.0.0.0) | כשיש מכשירים אחרים ברשת שצריכים גישה (למשל טלפון) |
| `tailnet` | דרך רשת Tailscale בלבד | גישה מאובטחת מכל מקום בעולם דרך VPN |
| `auto` | המערכת בוחרת אוטומטית | כשאתה לא בטוח מה לבחור |
| `custom` | כתובת IP ספציפית | תרחישים מתקדמים |

```bash
# דוגמה: פתיחה לרשת מקומית
openclaw gateway run --bind lan

# דוגמה: חשיפה דרך Tailscale
openclaw gateway run --bind tailnet --tailscale serve
```

#### `auth` - אימות

מגדיר איך מכשירים/משתמשים מתחברים ל-Gateway:

| מצב | תיאור | רמת אבטחה |
|------|--------|------------|
| `none` | ללא אימות - כל אחד יכול להתחבר | נמוכה מאוד - רק לפיתוח מקומי! |
| `token` | נדרש טוקן סודי בחיבור | **מומלץ** - טוב לשימוש יומי |
| `password` | נדרשת סיסמה | טוב - כשיש כמה משתמשים |
| `trusted-proxy` | סומך על proxy חיצוני (כמו nginx) | מתקדם - לסביבות production |

```json
// אימות עם טוקן (מומלץ):
{
  "gateway": {
    "auth": {
      "mode": "token",
      "token": "YOUR_TOKEN_HERE"
    }
  }
}

// אימות עם סיסמה:
{
  "gateway": {
    "auth": {
      "mode": "password",
      "password": "my-secure-password"
    }
  }
}
```

### התקנת Gateway כשירות מערכת

כשמתקינים את ה-Gateway כשירות, הוא מתחיל אוטומטית עם המחשב:

```bash
# התקנה כשירות systemd (Linux)
openclaw gateway install

# הפעלה/עצירה
openclaw gateway start
openclaw gateway stop
openclaw gateway restart

# בדיקת סטטוס
openclaw gateway status

# הסרה
openclaw gateway uninstall
```

### Tailscale Integration

Tailscale מאפשר גישה מאובטחת ל-Gateway מכל מקום:

```bash
# חשיפה ברשת Tailscale הפנימית
openclaw gateway run --tailscale serve

# חשיפה לאינטרנט (דרך Tailscale Funnel)
openclaw gateway run --tailscale funnel

# איפוס הגדרות Tailscale ביציאה
openclaw gateway run --tailscale serve --tailscale-reset-on-exit
```

### גילוי Gateways ברשת

```bash
# גילוי gateways מקומיים ורחוקים
openclaw gateway discover

# בדיקת נגישות מלאה
openclaw gateway probe
```

### עלויות שימוש

```bash
# סיכום עלויות מסשנים
openclaw gateway usage-cost
```

---

## AUTH - אימות והרשאות

### מה זה?

מערכת ה-Auth מנהלת את ה"מפתחות" שלך - הם מאפשרים ל-OpenClaw לגשת לשירותי AI (Anthropic, OpenAI, Google...) ולערוצי תקשורת.

### מבנה ב-Config

```json
{
  "auth": {
    "profiles": {
      "anthropic:default": {
        "provider": "anthropic",
        "mode": "api_key"
      }
    }
  }
}
```

### סוגי אימות

| סוג | תיאור | מתי להשתמש |
|------|--------|------------|
| `api_key` | מפתח API ישיר | הכי פשוט - מפתח מ-Anthropic Console |
| `oauth` | אימות OAuth2 | לשירותים שדורשים הרשאות מתקדמות |
| `token` | טוקן גישה | לבוטים (Discord, Telegram...) |

### ניהול Auth

```bash
# ניהול פרופילי אימות למודלים
openclaw models auth

# הגדרה אינטראקטיבית
openclaw configure --section model

# בדיקת סטטוס auth
openclaw models status
```

### Auth Store

המפתחות נשמרים בקובץ מאובטח:
```
~/.openclaw/agents/main/agent/auth-profiles.json
```

אפשר גם להשתמש במשתני סביבה:
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
export OPENAI_API_KEY="sk-..."
export GEMINI_API_KEY="..."
```

### דוגמה - הגדרת Anthropic API Key

```bash
# דרך configure
openclaw configure --section model

# דרך משתנה סביבה
export ANTHROPIC_API_KEY="sk-ant-api03-xxxxxxxxxxxxxxxxxxxxx"

# דרך config ישירות (מתקדם)
openclaw config set auth.profiles.anthropic:default.provider anthropic
```

---

## CHANNELS - ערוצי תקשורת

### מה זה?

ערוצים הם הדרך שבה OpenClaw מתקשרת עם העולם החיצון. כל ערוץ הוא פלטפורמת הודעות שהסוכן יכול לקרוא ממנה ולכתוב אליה.

### ערוצים נתמכים

| ערוץ | תיאור | סוג חיבור |
|-------|--------|-----------|
| **WhatsApp** | הודעות WhatsApp דרך WhatsApp Web | QR code scan |
| **Telegram** | בוט Telegram | Bot token מ-@BotFather |
| **Discord** | בוט Discord | Bot token מ-Discord Developer Portal |
| **Slack** | בוט Slack | OAuth / Bot token |
| **Signal** | הודעות Signal | Signal CLI |
| **iMessage** | הודעות iMessage (macOS בלבד) | BlueBubbles / ישיר |
| **IRC** | ערוצי IRC | חיבור ישיר |
| **Google Chat** | Google Workspace Chat | Service account |
| **LINE** | הודעות LINE | Channel token |

### קונפיגורציה

הגדרת ערוץ בקובץ config:
```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "123456:ABC-DEF..."
    },
    "discord": {
      "enabled": true,
      "token": "MTIzNDU2Nzg5..."
    }
  }
}
```

### הגדרת WhatsApp (הכי נפוץ)

WhatsApp עובד דרך WhatsApp Web - סורקים QR code והמערכת מחוברת:

```bash
# חיבור ראשוני
openclaw channels login --channel whatsapp

# בדיקת סטטוס
openclaw channels status --probe

# צפייה בלוגים
openclaw channels logs
```

**חשוב:** WhatsApp Web דורש שהטלפון יהיה מחובר לאינטרנט. אם הטלפון מתנתק, גם ה-WhatsApp Web מתנתק.

### הגדרת Telegram

```bash
# 1. צור בוט ב-@BotFather בטלגרם
# 2. קבל את ה-token
# 3. הוסף את הערוץ:
openclaw channels add --channel telegram --token "123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"

# 4. בדוק שעובד:
openclaw channels status
```

### הגדרת Discord

```bash
# 1. צור אפליקציה ב-Discord Developer Portal
# 2. צור בוט וקבל token
# 3. הוסף:
openclaw channels add --channel discord --token "MTIzNDU2Nzg5MDEyMzQ1Njc4OQ.Gxxxxx.xxxxxxxxx"

# 4. הזמן את הבוט לשרת שלך דרך OAuth2 URL
```

### יכולות לפי ערוץ

```bash
# הצגת מה כל ערוץ יכול לעשות
openclaw channels capabilities
```

כל ערוץ תומך ביכולות שונות:
- **טקסט** - כל הערוצים
- **תמונות/מדיה** - רוב הערוצים
- **סקרים** - Discord, Telegram
- **תגובות (reactions)** - Discord, Slack, Telegram
- **threads** - Discord, Slack
- **קול** - Discord

### זיהוי אנשי קשר

```bash
# חיפוש מזהה של משתמש/קבוצה
openclaw directory

# המרת שם לID
openclaw channels resolve
```

---

## WORKSPACE - סביבת העבודה

### מה זה?

ה-Workspace הוא התיקייה שבה הסוכן שומר את כל הקבצים שלו - הערות, זיכרון, סקריפטים, קבצים זמניים. זו "הבית" של הסוכן.

### מיקום ברירת מחדל
```
~/.openclaw/workspace
```

### קונפיגורציה
```json
{
  "agents": {
    "defaults": {
      "workspace": "/home/user/.openclaw/workspace"
    }
  }
}
```

### למה זה חשוב?

- הסוכן שומר פה קבצים שהוא יוצר (דוחות, סקריפטים...)
- ה-Workspace מכיל את קבצי הזיכרון של הסוכן
- Skills מותקנים ומורצים מתוך ה-Workspace
- כל סוכן יכול לקבל Workspace נפרד (בידוד)

### שינוי Workspace

```bash
# דרך configure
openclaw configure --section workspace

# דרך config
openclaw config set agents.defaults.workspace "/path/to/my/workspace"
```

---

## WEB - חיפוש ואחזור מהרשת

### מה זה?

הגדרות ה-Web קובעות אם ואיך הסוכן יכול לחפש מידע באינטרנט ולגשת לדפי אינטרנט.

### קונפיגורציה

```json
{
  "tools": {
    "web": {
      "search": {
        "enabled": true,
        "provider": "gemini"
      },
      "fetch": {
        "enabled": false
      }
    }
  }
}
```

### הסבר על כל שדה

#### `search` - חיפוש באינטרנט

| שדה | תיאור |
|------|--------|
| `enabled` | `true` = הסוכן יכול לחפש באינטרנט. `false` = לא |
| `provider` | ספק החיפוש: `gemini`, `google`, `brave`, `searxng` |

**דוגמה:** כשהסוכן צריך לענות על שאלה שדורשת מידע עדכני (כמו "מה מזג האוויר?" או "מה הגרסה האחרונה של Node?"), הוא מחפש באינטרנט.

#### `fetch` - אחזור דפי אינטרנט

| שדה | תיאור |
|------|--------|
| `enabled` | `true` = הסוכן יכול לגשת לURLs ספציפיים. `false` = לא |

**דוגמה:** כשאתה שולח לסוכן לינק ואומר "תסכם את הדף הזה", הוא משתמש ב-fetch כדי להוריד את התוכן.

### דוגמאות קונפיגורציה

**הכל מופעל (מומלץ):**
```json
{
  "tools": {
    "web": {
      "search": { "enabled": true, "provider": "gemini" },
      "fetch": { "enabled": true }
    }
  }
}
```

**ללא אינטרנט (מצב מבודד):**
```json
{
  "tools": {
    "web": {
      "search": { "enabled": false },
      "fetch": { "enabled": false }
    }
  }
}
```

---

## SKILLS - כישורים וכלים

### מה זה?

Skills הם "כישורים" מוכנים מראש שמרחיבים את היכולות של הסוכן. כל Skill מוסיף יכולת ספציפית - כמו שליטה ב-Spotify, ניהול Apple Notes, שליחת מיילים, ועוד.

### סוגי Skills

Skills מגיעים ממקורות שונים:

| מקור | תיאור |
|-------|--------|
| `openclaw-bundled` | מגיעים מובנים עם OpenClaw |
| `clawhub` | מותקנים מ-ClawHub (חנות Skills) |
| `custom` | Skills שיצרת בעצמך |

### Skills מובנים (דוגמאות)

| Skill | תיאור | סטטוס |
|--------|--------|--------|
| `coding-agent` | הפעלת Codex/Claude Code לכתיבת קוד | מוכן |
| `github` | עבודה עם GitHub - PRs, Issues, CI | מוכן |
| `gh-issues` | אוטומציה של GitHub Issues ו-PRs | מוכן |
| `weather` | מזג אוויר מ-wttr.in | מוכן |
| `tmux` | שליטה בסשנים של tmux | מוכן |
| `healthcheck` | בדיקות אבטחה על המכונה | מוכן |
| `discord` | ניהול Discord | דורש הגדרה |
| `slack` | ניהול Slack | דורש הגדרה |
| `telegram` | (דרך message tool) | דורש הגדרה |
| `spotify-player` | שליטה ב-Spotify | דורש הגדרה |
| `1password` | ניהול סודות ב-1Password | דורש הגדרה |
| `apple-notes` | ניהול Apple Notes | דורש הגדרה |
| `notion` | עבודה עם Notion | דורש הגדרה |
| `obsidian` | עבודה עם Obsidian vaults | דורש הגדרה |
| `himalaya` | ניהול אימיילים (IMAP/SMTP) | דורש הגדרה |
| `nano-pdf` | עריכת PDF | דורש הגדרה |
| `trello` | ניהול Trello boards | דורש הגדרה |
| `gog` | Google Workspace (Gmail, Calendar, Drive) | דורש הגדרה |
| `xurl` | X (Twitter) API | דורש הגדרה |

### ניהול Skills

```bash
# הצגת כל ה-Skills וסטטוס שלהם
openclaw skills list

# בדיקה מה מוכן ומה חסר
openclaw skills check

# מידע מפורט על skill ספציפי
openclaw skills info coding-agent

# חיפוש skills ב-ClawHub
openclaw skills search "email"

# התקנת skill מ-ClawHub
openclaw skills install my-custom-skill

# עדכון skills מותקנים
openclaw skills update
```

### יצירת Skill מותאם

```bash
# יצירת skill חדש
openclaw skills create  # (דרך skill-creator)
```

---

## HEALTH - בריאות המערכת

### מה זה?

פקודת `doctor` בודקת את כל המערכת ומדווחת על בעיות:

```bash
openclaw doctor
```

### מה נבדק?

| בדיקה | תיאור |
|--------|--------|
| **State integrity** | תקינות קבצי ההגדרות והמצב |
| **Gateway runtime** | גרסת Node.js, תלויות |
| **Gateway service** | האם השירות מותקן ורץ |
| **Security** | בעיות אבטחה בקונפיגורציה |
| **Skills status** | כמה skills מוכנים |
| **Plugins** | תוספים טעונים/מושבתים/שגויים |
| **Memory search** | מצב מערכת הזיכרון הסמנטי |
| **Systemd/launchd** | הגדרות שירות מערכת |

### תיקון אוטומטי

```bash
# תיקון בעיות שזוהו
openclaw doctor --fix
```

---

## AGENTS - ניהול סוכנים

### מה זה?

OpenClaw יכולה להריץ **כמה סוכנים** במקביל, כל אחד עם הגדרות, מודל, workspace, והרשאות משלו. זה שימושי כשרוצים סוכן אחד לקוד, אחד לתמיכה, אחד ל-DevOps...

### מבנה ב-Config

```json
{
  "agents": {
    "defaults": {
      "model": { ... },
      "workspace": "~/.openclaw/workspace"
    }
  }
}
```

### ניהול סוכנים

```bash
# הצגת סוכנים מוגדרים
openclaw agents

# הוספת סוכן חדש
openclaw agents add ops --model anthropic/claude-opus-4-6

# שימוש בסוכן ספציפי
openclaw agent --agent ops --message "בדוק את הלוגים"
```

### כל סוכן מקבל:

- **שם ייחודי** - לזיהוי
- **מודל משלו** - יכול להיות שונה מברירת המחדל
- **Workspace נפרד** - תיקייה מבודדת
- **Auth נפרד** - מפתחות API משלו
- **Routing** - לאיזה ערוצים/אנשים הוא מגיב

---

## TOOLS - הגדרות כלים

### מה זה?

החלק `tools` בקונפיגורציה קובע אילו כלים חיצוניים הסוכן יכול להשתמש בהם.

### קונפיגורציה נוכחית

```json
{
  "tools": {
    "web": {
      "search": { "enabled": true, "provider": "gemini" },
      "fetch": { "enabled": false }
    }
  }
}
```

ראה פרק [WEB](#web---חיפוש-ואחזור-מהרשת) להסבר מלא.

---

## COMMANDS - הגדרות פקודות

### מה זה?

החלק `commands` קובע איך OpenClaw מתנהגת בנוגע לפקודות פנימיות:

```json
{
  "commands": {
    "native": "auto",
    "nativeSkills": "auto",
    "restart": true,
    "ownerDisplay": "raw"
  }
}
```

### הסבר על כל שדה

| שדה | תיאור | ערכים |
|------|--------|--------|
| `native` | שימוש בפקודות native (מקומפלות) - מהירות יותר | `auto`, `always`, `never` |
| `nativeSkills` | שימוש ב-skills כ-native | `auto`, `always`, `never` |
| `restart` | האם לאפשר restart אוטומטי של ה-gateway | `true`, `false` |
| `ownerDisplay` | איך להציג את שם הבעלים של הודעות | `raw` (כמו שזה), `friendly` (ידידותי) |

---

## MEMORY - זיכרון סמנטי

### מה זה?

מערכת הזיכרון מאפשרת לסוכן **לזכור דברים בין שיחות**. הסוכן שומר הערות, העדפות, ומידע חשוב, ואחר כך יכול לחפש בהם סמנטית (לפי משמעות, לא רק מילות מפתח).

### איך זה עובד?

1. הסוכן שומר "זיכרונות" כקבצי markdown
2. המערכת יוצרת embeddings (ייצוגים מתמטיים) של כל זיכרון
3. כשהסוכן צריך מידע, הוא מחפש סמנטית בזיכרונות

### דרישות

מערכת הזיכרון דורשת **embedding provider** - שירות שהופך טקסט לוקטורים:

| ספק | דרישה |
|------|--------|
| OpenAI | `OPENAI_API_KEY` |
| Google | `GEMINI_API_KEY` |
| Voyage | `VOYAGE_API_KEY` |
| Mistral | `MISTRAL_API_KEY` |
| Local | מודל מקומי |

### קונפיגורציה

```bash
# הפעלה/כיבוי
openclaw config set agents.defaults.memorySearch.enabled true

# בדיקת סטטוס
openclaw memory status --deep

# אינדוקס מחדש
openclaw memory index --force

# חיפוש בזיכרון
openclaw memory search "פגישת צוות שבוע שעבר"
```

### כיבוי זיכרון
```bash
openclaw config set agents.defaults.memorySearch.enabled false
```

---

## SANDBOX - בידוד קונטיינרים

### מה זה?

Sandbox מריץ את הסוכן בתוך **קונטיינר Docker מבודד**. זה מגן על המחשב שלך - הסוכן יכול להריץ קוד, להתקין חבילות, ולעשות דברים "מסוכנים" בלי לפגוע במערכת.

### למה זה חשוב?

- הסוכן מריץ קוד שהוא כותב - מה אם יש באג?
- הסוכן מתקין חבילות - מה אם משהו נשבר?
- הסוכן ניגש לקבצים - מה אם הוא מוחק משהו בטעות?

ה-Sandbox מבודד את כל זה בתוך קונטיינר שאפשר למחוק ולשחזר.

### ניהול

```bash
# הצגת קונטיינרים
openclaw sandbox list

# יצירה מחדש (אחרי שינוי הגדרות)
openclaw sandbox recreate --all

# הסבר על מדיניות הבידוד
openclaw sandbox explain
```

---

## SECURITY - אבטחה

### מה זה?

כלי אבטחה שבודקים את הקונפיגורציה שלך ומזהים בעיות פוטנציאליות.

### ביקורת אבטחה

```bash
# ביקורת בסיסית
openclaw security audit

# ביקורת מעמיקה (כולל בדיקות Gateway חי)
openclaw security audit --deep

# תיקון אוטומטי של בעיות
openclaw security audit --fix

# פלט JSON
openclaw security audit --json
```

### מה נבדק?

- הרשאות קבצים (config, secrets, tokens)
- מצב אימות Gateway (האם פתוח ללא סיסמה?)
- חשיפת ערוצים
- מצב bind (האם פתוח לרשת?)
- סודות בקבצי קונפיגורציה

---

## CRON - תזמון משימות

### מה זה?

מנגנון לתזמון משימות שחוזרות על עצמן. הסוכן מריץ פעולות לפי לוח זמנים שאתה מגדיר - בדיוק כמו crontab של Linux אבל לסוכן AI.

### דוגמאות שימוש

- "כל בוקר ב-8:00 תשלח לי סיכום של GitHub Issues פתוחים"
- "כל שעה תבדוק את הלוגים ותתריע אם יש שגיאות"
- "כל יום ראשון תצור דוח שבועי ותשלח לקבוצה ב-Discord"

### ניהול

```bash
# הוספת משימה
openclaw cron add

# הצגת כל המשימות
openclaw cron list

# סטטוס המתזמן
openclaw cron status

# הרצה ידנית (לבדיקה)
openclaw cron run <job-id>

# עריכה
openclaw cron edit <job-id>

# הפעלה/כיבוי
openclaw cron enable <job-id>
openclaw cron disable <job-id>

# מחיקה
openclaw cron rm <job-id>

# היסטוריית הרצות
openclaw cron runs
```

---

## PLUGINS - תוספים

### מה זה?

Plugins הם הרחבות שמוסיפות יכולות חדשות ל-OpenClaw. בניגוד ל-Skills (שהם "מתכונים" לסוכן), Plugins הם **קוד** שרץ בתוך ה-Gateway עצמו.

### ניהול

```bash
# הצגת תוספים
openclaw plugins list

# התקנה
openclaw plugins install <source>

# הפעלה/כיבוי
openclaw plugins enable <name>
openclaw plugins disable <name>

# בדיקת בעיות
openclaw plugins doctor

# פרטים
openclaw plugins inspect <name>

# עדכון
openclaw plugins update

# Marketplace
openclaw plugins marketplace
```

---

## WEBHOOKS - התראות חיצוניות

### מה זה?

Webhooks מאפשרים לשירותים חיצוניים לשלוח אירועים ל-OpenClaw. למשל, Gmail יכול להתריע על מיילים חדשים.

```bash
# הגדרת webhook ל-Gmail
openclaw webhooks gmail
```

---

## DNS ו-TAILSCALE - גילוי ברשת רחבה

### מה זה?

כלים שמאפשרים למצוא ולהתחבר ל-Gateways ברשתות שונות:

```bash
# גילוי DNS
openclaw dns

# Tailscale Integration
openclaw gateway run --tailscale serve    # חשיפה פנימית
openclaw gateway run --tailscale funnel   # חשיפה לאינטרנט
```

### מתי להשתמש?

- כשה-Gateway רץ על שרת (VPS) ואתה מתחבר מהלפטופ
- כשרוצים גישה מהטלפון ל-Gateway בבית
- כשיש כמה Gateways ברשת וצריך למצוא אותם

---

## BACKUP - גיבוי

### מה זה?

יצירה ואימות של גיבויים מקומיים למצב OpenClaw (קונפיגורציה, סשנים, זיכרון, secrets).

```bash
openclaw backup
```

**תמיד כדאי לגבות** לפני:
- עדכון גרסה
- שינוי קונפיגורציה משמעותי
- reset של המערכת

---

## טבלת סיכום - כל הסקשנים ב-configure

| סקשן | פקודה | תיאור |
|--------|--------|--------|
| **model** | `openclaw configure --section model` | בחירת מודל AI, fallbacks, credentials |
| **gateway** | `openclaw configure --section gateway` | הגדרת Gateway - פורט, bind, אימות |
| **channels** | `openclaw configure --section channels` | הוספת ערוצי תקשורת |
| **workspace** | `openclaw configure --section workspace` | הגדרת תיקיית העבודה |
| **web** | `openclaw configure --section web` | חיפוש אינטרנט ו-fetch |
| **skills** | `openclaw configure --section skills` | ניהול כישורים |
| **health** | `openclaw configure --section health` | הגדרות בדיקות בריאות |
| **daemon** | `openclaw configure --section daemon` | הגדרות שירות רקע |

### הרצת configure מלא:
```bash
openclaw configure
```

### הרצת סקשן ספציפי:
```bash
openclaw configure --section model
openclaw configure --section gateway
openclaw configure --section channels
```

---

> **OpenClaw** - הופכת את הטרמינל שלך למרכז שליטה חכם. הגדר, חבר, ותן לסוכן לעבוד בשבילך.

</div>
