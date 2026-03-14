# 📦 SQLITE IMPLEMENTATION PLAN - OFFLINE CAPABILITIES

**Status**: Planning  
**Objective**: Enable offline access to society data and cached community information.

---

## 🏗️ **Core Concept**
SocioHub will use **SQLite** as a local "Cache" layer. 
1. **Online**: Fetch from Supabase -> Save copy to SQLite.
2. **Offline**: Load instantly from SQLite.

---

## 🛠️ **Dependencies**
Add these to `pubspec.yaml`:
```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

---

## 📂 **Database Schema**

### **1. Table: `cities`**
| Column | Type | Description |
|--------|------|-------------|
| id | TEXT (PK) | Supabase ID |
| name | TEXT | City Name |

### **2. Table: `societies`**
| Column | Type | Description |
|--------|------|-------------|
| id | TEXT (PK) | Supabase ID |
| city_id | TEXT | FK to cities |
| name | TEXT | Society Name |
| area | TEXT | Area Name |

### **3. Table: `cache_metadata`**
Used to track when data was last updated.
| Column | Type | Description |
|--------|------|-------------|
| key | TEXT (PK) | e.g., 'societies_list' |
| last_updated | INTEGER | Timestamp |

---

## 🚀 **Step-by-Step Implementation**

### **Phase 1: Database Helper (Setup)**
Create `lib/services/local_db_service.dart`.
- Initialize database file.
- Define `onCreate` tables.
- Version control for schema changes.

### **Phase 2: Data Persistence**
Update `SupabaseService` to sync data.
```dart
// logic flow
final onlineData = await fetchFromSupabase();
await LocalDB.save(onlineData);
return onlineData;
```

### **Phase 3: Offline Loading**
Update Screens (`CityScreen`, `SocietyScreen`) to handle errors.
```dart
try {
  return await fetchOnline();
} catch (e) {
  return await fetchFromLocalSQLite(); // Fallback
}
```

---

## 📋 **Files to be Created/Modified**

| File | Action | Purpose |
|------|--------|---------|
| `pubspec.yaml` | Edit | Add `sqflite` and `path` |
| `lib/services/local_db_service.dart` | **Create** | Main SQLite management |
| `lib/services/supabase_service.dart` | Edit | Add logic to sync online data to local |
| `lib/main.dart` | Edit | Initialize Local DB on startup |

---

## ✅ **Benefits for SocioHub**
1. **No Internet? No Problem**: Users can see Masjid timings and contact numbers without data.
2. **Speed**: Apps feel faster because cached data loads in milliseconds.
3. **Data Savings**: Doesn't re-download the same city list every time.

---

## ⚠️ **Next Step**
1. Run `flutter pub get` after adding dependencies.
2. I will provide the `LocalDbService` code once you're ready to start coding.
