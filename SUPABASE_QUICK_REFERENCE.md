# 📋 Supabase Quick Reference for SocioHub

**Quick Start Guide - 5 Minutes**

---

## 🚀 **3-Step Setup**

### Step 1: Create Supabase Project
```
1. Go to https://supabase.com
2. Sign up
3. Create new project (takes 2 min)
4. Copy URL and API key
```

### Step 2: Create Database (Copy-Paste SQL)
```sql
-- Paste this entire SQL in Supabase SQL editor and click Run

CREATE TABLE cities (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), name VARCHAR NOT NULL UNIQUE, latitude DECIMAL(10, 8), longitude DECIMAL(11, 8), created_at TIMESTAMP DEFAULT NOW());

CREATE TABLE users (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), phone VARCHAR NOT NULL UNIQUE, name VARCHAR NOT NULL, role VARCHAR DEFAULT 'resident', city_id UUID REFERENCES cities(id), society_id UUID, created_at TIMESTAMP DEFAULT NOW());

CREATE TABLE societies (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), city_id UUID NOT NULL REFERENCES cities(id) ON DELETE CASCADE, name VARCHAR NOT NULL, area VARCHAR, created_by UUID REFERENCES users(id), status VARCHAR DEFAULT 'pending', created_at TIMESTAMP DEFAULT NOW(), UNIQUE(city_id, name));

CREATE TABLE masjids (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE, imam_id UUID REFERENCES users(id), name VARCHAR NOT NULL, fajr TIME, zuhr TIME, asr TIME, maghrib TIME, isha TIME, jummah TIME, phone VARCHAR, status VARCHAR DEFAULT 'pending', created_at TIMESTAMP DEFAULT NOW());

CREATE TABLE restaurants (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE, owner_id UUID REFERENCES users(id), name VARCHAR NOT NULL, category VARCHAR, phone VARCHAR, delivery_available BOOLEAN DEFAULT FALSE, status VARCHAR DEFAULT 'pending', created_at TIMESTAMP DEFAULT NOW());

CREATE TABLE services (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE, provider_id UUID REFERENCES users(id), service_type VARCHAR, name VARCHAR NOT NULL, phone VARCHAR, status VARCHAR DEFAULT 'pending', created_at TIMESTAMP DEFAULT NOW());

CREATE TABLE emergency_contacts (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), society_id UUID REFERENCES societies(id), contact_type VARCHAR, name VARCHAR NOT NULL, phone VARCHAR NOT NULL, created_at TIMESTAMP DEFAULT NOW());

INSERT INTO cities (name, latitude, longitude) VALUES ('Karachi', 24.8607, 67.0011), ('Lahore', 31.5204, 74.3587), ('Islamabad', 33.6844, 73.0479), ('Rawalpindi', 33.5731, 73.1898), ('Hyderabad', 25.3960, 68.4626), ('Faisalabad', 31.4181, 72.3110), ('Multan', 30.1575, 71.4267), ('Peshawar', 34.0151, 71.5249), ('Quetta', 30.1840, 67.0073), ('Sialkot', 32.4915, 74.5313);
```

### Step 3: Update Flutter Code
```dart
// main.dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_ANON_KEY',
  );
  
  runApp(const SocioHubApp());
}
```

---

## 💡 **Common Supabase Queries for SocioHub**

### Get All Cities
```dart
final cities = await supabase.from('cities').select();
```

### Get Societies in a City
```dart
final societies = await supabase
    .from('societies')
    .select()
    .eq('city_id', cityId)
    .eq('status', 'approved');
```

### Search Societies
```dart
final results = await supabase
    .from('societies')
    .select()
    .eq('city_id', cityId)
    .ilike('name', '%query%');
```

### Add Society (Auto Duplicate Prevention!)
```dart
try {
  await supabase.from('societies').insert({
    'city_id': cityId,
    'name': societyName,
    'area': area,
    'created_by': userId,
    'status': 'pending'
  });
} on PostgrestException catch (e) {
  if (e.code == '23505') { // UNIQUE constraint
    print('Society already exists!');
  }
}
```

### Get Masjids in a Society
```dart
final masjids = await supabase
    .from('masjids')
    .select()
    .eq('society_id', societyId)
    .eq('status', 'approved');
```

### Real-time Listener
```dart
supabase
    .from('societies')
    .on(RealtimeListenTypes.all, (payload) {
      print('Change: ${payload.newRecord}');
    })
    .eq('city_id', cityId)
    .subscribe();
```

---

## 🔐 **Authentication**

### Sign Up with Phone
```dart
await supabase.auth.signUpWithPhone(
  phone: '+923001234567',
  password: 'temp_password',
);
```

### Verify OTP
```dart
await supabase.auth.verifyOTP(
  phone: '+923001234567',
  token: otpCode,
  type: OtpType.sms,
);
```

### Sign Out
```dart
await supabase.auth.signOut();
```

### Get Current User
```dart
final user = supabase.auth.currentUser;
```

---

## 📊 **Key Differences from Firebase**

| Operation | Firebase | Supabase |
|-----------|----------|----------|
| Duplicate Check | Manual query | Auto UNIQUE constraint |
| Search | Download all, filter in code | SQL WHERE LIKE |
| Cost | High | Low |
| Database | NoSQL | PostgreSQL |
| Relationships | Limited | Native FK |

---

## ✅ **Advantages Over Firebase for SocioHub**

✅ **Duplicate Prevention**: Database-level UNIQUE constraint  
✅ **Cost**: 10x cheaper ($25 vs $200+/month)  
✅ **Power**: Full SQL for complex queries  
✅ **Relationships**: Native foreign keys  
✅ **Control**: No vendor lock-in  
✅ **Simplicity**: Standard PostgreSQL  

---

## 🎯 **Next Steps**

1. **Create Supabase account** (5 min)
2. **Copy-paste SQL** (2 min)
3. **Update Flutter main.dart** (2 min)
4. **Test duplicate prevention** (2 min)
5. **Deploy!** 🚀

---

## 📞 **Support**

- Supabase Docs: https://supabase.com/docs
- Community: https://discord.supabase.io
- Status: https://status.supabase.io

---

**Ready to switch to Supabase? You got this! 💪**

