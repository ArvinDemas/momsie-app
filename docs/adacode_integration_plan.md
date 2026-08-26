# 🧠 Brainstorming: Integrasi adaCODE AI untuk Chatbot Momsie

## 📊 Kondisi Saat Ini

| Aspek | Detail |
|-------|--------|
| **Endpoint Lama** | `generativelanguage.googleapis.com/.../gemini-flash-latest:generateContent` |
| **Format Request** | Gemini-specific (`contents`, `parts`) |
| **Format Response** | Gemini-specific (`candidates[0].content.parts[0].text`) |
| **API Key Storage** | SharedPreferences (`gemini_api_key`) |
| **Fallback** | Sudah ada `.getEducativeFallbackResponse()` |

---

## 🎯 Target Integrasi

### Opsi A: Hybrid Fallback (Rekomendasi)
- **Utama**: Gemini (jika user punya key)
- **Fallback otomatis**: adaCODE (jika Gemini fail/403)
- **Keuntungan**: Tidak perlu ubah setting user, tetap backward compatible

### Opsi B: Dual Provider Toggle
- User pilih provider di Settings: Gemini / adaCODE
- **Keuntungan**: User punya kontrol penuh
- **Kekurangan**: Membutuhkan UI settings tambahan

### Opsi C: adaCODE Only (Pindah Total)
- Hapus semua kode Gemini
- Ganti endpoint ke adaCODE
- **Keuntungan**: Simpel, hemat token
- **Kekurangan**: Breaking change untuk user lama

---

## 🔧 Implementasi Teknikal (Opsi A - Hybrid)

### 1. Konstanta Baru di `ai_chat_controller.dart`

```dart
// Gemini (existing)
static const String _geminiEndpoint = 
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent';

// adaCODE (NEW - OpenAI-compatible)
static const String _adacodeEndpoint = 'https://adacode.ai/v1/chat/completions';
static const String _adacodeModel = 'adacode-2-0-pro';
static const String _adacodeApiKeyPref = 'adacode_api_key';
```

### 2. Mapping Format Request

| Gemini | adaCODE (OpenAI) |
|--------|------------------|
| `contents: [{role, parts: [{text}]}]` | `messages: [{role, content}]` |
| System prompt di `contents[0]` | System prompt di `messages[0]` dengan role='system' |

**Mapping Sistem:**
```dart
// Convert Gemini format → OpenAI format
List<Map<String, dynamic>> toOpenAIMessages() {
  return [
    {'role': 'system', 'content': _systemPrompt},
    ...messages.take(15).map((m) => {'role': m.role, 'content': m.text}),
  ];
}
```

### 3. Mapping Format Response

**Gemini Response:**
```json
{
  "candidates": [{
    "content": {"parts": [{"text": "..."}]}
  }]
}
```

**adaCODE Response (OpenAI format):**
```json
{
  "choices": [{
    "message": {"content": "..."}
  }]
}
```

**Unified Parser:**
```dart
String parseResponse(http.Response response, String provider) {
  final data = jsonDecode(response.body);
  
  if (provider == 'gemini') {
    final candidates = data['candidates'] as List?;
    return candidates?[0]['content']['parts'][0]['text'] ?? '';
  } else {
    // adaCODE / OpenAI format
    final choices = data['choices'] as List?;
    return choices?[0]['message']['content'] ?? '';
  }
}
```

### 4. Flow Logic SendMessage

```
1. Get active API key (Gemini first, then adaCODE)
2. Try Gemini endpoint
   ├─ Success (200) → Return response
   └─ Fail (403/401/error)
       └─ Try adaCODE endpoint
           ├─ Success (200) → Return response
           └─ Fail → Use fallback educative response
```

### 5. Settings UI Update

Tambahkan di `user_bantuan_page.dart`:
```dart
// Existing: Gemini API Key Section
 ListTile(
   title: Text('API Key Gemini'),
   subtitle: Obx(() => Text(controller.apiKeyPreview.value)),
   trailing: IconButton(
     icon: Icon(Icons.edit),
     onPressed: () => _showApiKeyDialog(context, 'gemini'),
   ),
 )

// NEW: adaCODE API Key Section
ListTile(
  title: Text('API Key adaCODE'),
  subtitle: Obx(() => Text(controller.adacodeApiKeyPreview.value)),
  trailing: IconButton(
    icon: Icon(Icons.edit),
    onPressed: () => _showApiKeyDialog(context, 'adacode'),
  ),
)
```

---

## 📋 Checklist Implementasi

### Phase 1: Core Controller (`ai_chat_controller.dart`)
- [ ] Tambah konstanta adaCODE
- [ ] Tambah method `_tryAdacode()`
- [ ] Update `sendMessage()` dengan fallback logic
- [ ] Buat unified response parser
- [ ] Tambah storage key adaCODE

### Phase 2: Settings UI
- [ ] Update `user_bantuan_controller.dart` (tambah state adaCODE)
- [ ] Update `user_bantuan_page.dart` (tambah input field)
- [ ] Tambah method save/remove adaCODE key

### Phase 3: Testing
- [ ] Test Gemini only (existing flow)
- [ ] Test adaCODE only (new flow)
- [ ] Test fallback (Gemini fail → adaCODE success)
- [ ] Test dual fail (both fail → educational fallback)

---

## 💡 Pertimbangan Tambahan

### 1. Rate Limiting & Retry
- Gemini: Sudah ada retry 3x dengan delay
- adaCODE: Tambah retry logic yang sama

### 2. System Prompt Compatibility
- System prompt saat ini written untuk Gemini
- Perlu test apakah adaCODE interpretasinya sama
- mungkin perlu adjust sedikit wording

### 3. Token Usage
- adaCODE model `adacode-2-0-pro` lebih hemat token
- Estimate: ~30% lebih murah dibanding Gemini Flash
- Cocok untuk daily active users banyak

### 4. Fallback Trigger Conditions
- HTTP 401/403 (invalid/expired key)
- HTTP 429 (rate limit)
- Network timeout
- Malformed response

---

## 🚀 Estimasi Waktu

| Phase | Estimasi |
|-------|----------|
| Phase 1: Controller | 30-45 menit |
| Phase 2: Settings UI | 20-30 menit |
| Phase 3: Testing | 15-20 menit |
| **Total** | **~1-1.5 jam** |

---

*Brainstorming dibuat: 2025-08-15*
*Status: Ready untuk implementasi*
