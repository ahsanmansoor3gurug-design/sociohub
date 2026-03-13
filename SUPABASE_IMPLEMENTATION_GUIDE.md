# 🚀 SocioHub - Supabase Implementation Guide

**Status**: Step-by-step guide to switch from Firebase to Supabase  
**Difficulty**: Easy ⭐⭐  
**Time Needed**: 1-2 hours  

---

## 📋 **Table of Contents**

1. [Supabase Setup](#setup)
2. [Database Creation](#database)
3. [Flutter Integration](#flutter)
4. [Authentication Setup](#auth)
5. [Duplicate Prevention](#duplicates)
6. [Deployment](#deploy)

---

## <a name="setup"></a>1. 🔧 **Supabase Setup (10 minutes)**

### Step 1: Create Supabase Account

```
1. Go to https://supabase.com
2. Click "Start your project"
3. Sign up with email or GitHub
4. Create new organization
5. Create new project
   - Name: "sociohub"
   - Database password: (strong password)
   - Region: (choose closest to your users)
6. Wait 2-3 minutes for setup
```

### Step 2: Get Your Credentials

After project creation, go to **Settings → API**

```
You'll find:
- Project URL: https://xxxxx.supabase.co
- Anon Key: eyJxxxxx...
- Service Role Key: (keep secret!)
```

**Save these for Flutter!**

---

## <a name="database"></a>2. 🗄️ **Database Creation (15 minutes)**

### Step 1: Open SQL Editor

```
In Supabase Dashboard:
1. Click "SQL Editor" (left sidebar)
2. Click "New Query"
3. Paste the SQL below
```

### Step 2: Create All Tables

```sql
-- ==================== CITIES ====================
CREATE TABLE IF NOT EXISTS cities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR NOT NULL UNIQUE,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO cities (name, latitude, longitude) VALUES
  ('Karachi', 24.8607, 67.0011),
  ('Lahore', 31.5204, 74.3587),
  ('Islamabad', 33.6844, 73.0479),
  ('Rawalpindi', 33.5731, 73.1898),
  ('Hyderabad', 25.3960, 68.4626),
  ('Faisalabad', 31.4181, 72.3110),
  ('Multan', 30.1575, 71.4267),
  ('Peshawar', 34.0151, 71.5249),
  ('Quetta', 30.1840, 67.0073),
  ('Sialkot', 32.4915, 74.5313)
ON CONFLICT DO NOTHING;

-- ==================== USERS ====================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR NOT NULL UNIQUE,  -- One email = One account (duplicate prevention!)
  name VARCHAR NOT NULL,
  role VARCHAR DEFAULT 'resident' CHECK (role IN ('resident', 'imam', 'business_owner', 'service_provider', 'admin')),
  city_id UUID REFERENCES cities(id),
  society_id UUID,
  avatar_url VARCHAR,
  email_verified BOOLEAN DEFAULT FALSE,  -- Verified after user clicks email link
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ==================== SOCIETIES ====================
CREATE TABLE IF NOT EXISTS societies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city_id UUID NOT NULL REFERENCES cities(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  area VARCHAR,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_by UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
  status VARCHAR DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  members_count INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(city_id, name)  -- PREVENTS DUPLICATES!
);

-- ==================== MASJIDS ====================
CREATE TABLE IF NOT EXISTS masjids (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  imam_id UUID REFERENCES users(id) ON DELETE SET NULL,
  name VARCHAR NOT NULL,
  area VARCHAR,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  fajr TIME,
  zuhr TIME,
  asr TIME,
  maghrib TIME,
  isha TIME,
  jummah TIME,
  phone VARCHAR,
  status VARCHAR DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ==================== RESTAURANTS ====================
CREATE TABLE IF NOT EXISTS restaurants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  owner_id UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
  name VARCHAR NOT NULL,
  category VARCHAR,
  phone VARCHAR,
  area VARCHAR,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  delivery_available BOOLEAN DEFAULT FALSE,
  image_url VARCHAR,
  status VARCHAR DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ==================== SERVICES ====================
CREATE TABLE IF NOT EXISTS services (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  provider_id UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
  service_type VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  phone VARCHAR,
  experience VARCHAR,
  status VARCHAR DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ==================== EMERGENCY CONTACTS ====================
CREATE TABLE IF NOT EXISTS emergency_contacts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  contact_type VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  phone VARCHAR NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ==================== ANNOUNCEMENTS ====================
CREATE TABLE IF NOT EXISTS announcements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  society_id UUID NOT NULL REFERENCES societies(id) ON DELETE CASCADE,
  posted_by UUID NOT NULL REFERENCES users(id) ON DELETE SET NULL,
  title VARCHAR NOT NULL,
  content TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ==================== INDEXES (Performance) ====================
CREATE INDEX IF NOT EXISTS idx_societies_city_id ON societies(city_id);
CREATE INDEX IF NOT EXISTS idx_societies_status ON societies(status);
CREATE INDEX IF NOT EXISTS idx_masjids_society_id ON masjids(society_id);
CREATE INDEX IF NOT EXISTS idx_restaurants_society_id ON restaurants(society_id);
CREATE INDEX IF NOT EXISTS idx_services_society_id ON services(society_id);
CREATE INDEX IF NOT EXISTS idx_announcements_society_id ON announcements(society_id);
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);
```

### Step 3: Run SQL

```
1. Click "Run" button (or Ctrl+Enter)
2. Wait for success message
3. Check left sidebar - you should see all tables!
```

### Step 4: Enable Row Level Security (RLS)

```
For each table, click on it and:
1. Click "Authentication" in table menu
2. Enable RLS
3. Add policies (we'll do detailed security later)
```

---

## <a name="flutter"></a>3. 📱 **Flutter Integration (20 minutes)**

### Step 1: Add Dependency

```bash
cd C:\Users\GURU GROUP\StudioProjects\sociohub
flutter pub add supabase_flutter
flutter pub get
```

### Step 2: Update pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Supabase
  supabase_flutter: ^2.0.0
  
  # State Management
  provider: ^6.0.5
  
  # Utilities
  intl: ^0.19.0
  uuid: ^4.0.0
  cupertino_icons: ^1.0.2
```

### Step 3: Initialize Supabase in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://your-project.supabase.co',  // Replace with your URL
    anonKey: 'your-anon-key',  // Replace with your key
  );
  
  runApp(const SocioHubApp());
}

class SocioHubApp extends StatelessWidget {
  const SocioHubApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SocioHub",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
```

---

## <a name="auth"></a>4. 🔐 **Authentication Setup - Email Verification (FREE!)**

### ✅ **Why Email Instead of Phone OTP?**

```
Email Verification Benefits:
✅ COMPLETELY FREE (no SMS costs!)
✅ Duplicate prevention via UNIQUE constraint
✅ Works globally
✅ Already built into Supabase
✅ Professional & trusted
✅ Can add SMS later if you want

Cost Comparison:
- Email: $0/month ✅
- Phone OTP: $25/month
- Savings: $300/year!
```

### Step 1: Enable Email Auth in Supabase

```
In Supabase Dashboard:
1. Go to "Authentication" (left sidebar)
2. Email should be enabled by default ✅
3. No additional setup needed!
4. Email verification is automatic
```

### Step 2: Create Auth Service

**File**: `lib/services/auth_service.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Sign up with email (FREE!)
  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      final AuthResponse res = await supabase.auth.signUpWithPassword(
        email: email,
        password: password,
      );
      
      // Supabase automatically sends verification email
      // User clicks link to verify → Email verified ✅
      
      // Create user profile after signup
      if (res.user != null) {
        await supabase.from('users').insert({
          'id': res.user!.id,
          'email': email,
          'name': name,
          'role': 'resident',
          'email_verified': false,  // Will be true after user verifies
        });
      }
    } on AuthException catch (e) {
      print('Auth error: ${e.message}');
      rethrow;
    }
  }

  // Sign in with email
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return res;
    } on AuthException catch (e) {
      print('Sign in error: ${e.message}');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // Check if email is verified
  bool isEmailVerified() {
    return supabase.auth.currentUser?.emailConfirmedAt != null;
  }

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    try {
      await supabase.auth.resendOtp(
        type: OtpType.signup,
        email: supabase.auth.currentUser?.email ?? '',
      );
    } on AuthException catch (e) {
      print('Resend error: ${e.message}');
      rethrow;
    }
  }
}
```

---

## <a name="duplicates"></a>5. 🚫 **Duplicate Prevention (10 minutes)**

### Create Society Service

**File**: `lib/services/society_service.dart`

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SocietyService {
  final supabase = Supabase.instance.client;

  // Add society with automatic duplicate prevention
  Future<void> addSociety({
    required String cityId,
    required String societyName,
    required String area,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await supabase.from('societies').insert({
        'city_id': cityId,
        'name': societyName,
        'area': area,
        'created_by': userId,
        'status': 'pending',
      });
      
      print('Society added successfully!');
    } on PostgrestException catch (e) {
      // Check for UNIQUE constraint violation
      if (e.code == '23505') {
        throw Exception('This society already exists in this city!');
      }
      throw Exception('Error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Get all societies in a city
  Future<List<Map<String, dynamic>>> getSocietiesByCity(String cityId) async {
    try {
      final data = await supabase
          .from('societies')
          .select()
          .eq('city_id', cityId)
          .eq('status', 'approved')
          .order('name');
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching societies: $e');
      return [];
    }
  }

  // Search societies
  Future<List<Map<String, dynamic>>> searchSocieties(
    String cityId,
    String query,
  ) async {
    try {
      final data = await supabase
          .from('societies')
          .select()
          .eq('city_id', cityId)
          .eq('status', 'approved')
          .ilike('name', '%$query%')  // Case-insensitive search
          .order('name');
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error searching societies: $e');
      return [];
    }
  }

  // Get all cities
  Future<List<Map<String, dynamic>>> getCities() async {
    try {
      final data = await supabase
          .from('cities')
          .select()
          .order('name');
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      print('Error fetching cities: $e');
      return [];
    }
  }
}
```

### Update Add Society Screen

**File**: `lib/screens/add_society_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../services/society_service.dart';

class AddSocietyScreen extends StatefulWidget {
  final String cityName;
  final String cityId;

  const AddSocietyScreen({
    required this.cityName,
    required this.cityId,
  });

  @override
  State<AddSocietyScreen> createState() => _AddSocietyScreenState();
}

class _AddSocietyScreenState extends State<AddSocietyScreen> {
  final TextEditingController societyNameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final SocietyService societyService = SocietyService();
  
  bool isLoading = false;

  void addSociety() async {
    if (formKey.currentState!.validate()) {
      String societyName = societyNameController.text.trim();
      String area = areaController.text.trim();

      setState(() => isLoading = true);

      try {
        // Email is automatically verified when user signs up
        // Database UNIQUE constraint prevents duplicates ✅
        await societyService.addSociety(
          cityId: widget.cityId,
          societyName: societyName,
          area: area,
        );

        // Success!
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Society submitted for approval!'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Society"),
        elevation: 0,
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Your Society",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Help us build the database. Your society will be reviewed and approved by admin.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 30),

              // City (Read-only)
              Text("City", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: Text(widget.cityName, style: TextStyle(fontSize: 16)),
              ),
              SizedBox(height: 20),

              // Society Name
              Text("Society Name", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: societyNameController,
                decoration: InputDecoration(
                  hintText: "Enter society name...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter society name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Area/Location
              Text("Area / Location", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              TextFormField(
                controller: areaController,
                decoration: InputDecoration(
                  hintText: "Enter area or location...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter area/location";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Info Box
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You will become the first admin of this society after approval.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addSociety,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Submit for Approval",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    societyNameController.dispose();
    areaController.dispose();
    super.dispose();
  }
}
```

---

## <a name="deploy"></a>6. 🚀 **Deployment**

### Test Locally First

```bash
# Run on web
flutter run -d chrome

# Test:
# 1. Add a society
# 2. Try to add same society again → Should show error
# 3. Try to add with different name → Should work
```

### Deploy to Production

```bash
# Build APK for Android
flutter build apk --release

# Build for App Store (iOS)
flutter build ios --release
```

---

## ✅ **Verification Checklist**

- [ ] Supabase project created
- [ ] All tables created successfully
- [ ] Cities populated with data
- [ ] Flutter dependencies added
- [ ] Supabase initialized in main.dart
- [ ] Auth service created (email-based, FREE!)
- [ ] Society service created
- [ ] Add society screen updated
- [ ] Duplicate prevention tested (UNIQUE email constraint)
- [ ] Works on web (Chrome)
- [ ] Email verification working
- [ ] Users can only have one account per email

---

## 🎯 **Common Issues & Solutions**

### Issue: "PostgrestException: UNIQUE violation on email"
```
✅ This is GOOD! It means duplicate prevention is working.
Database prevents multiple accounts with same email.
Handle this error gracefully (already done in code above).
```

### Issue: "Supabase not initialized"
```
✅ Make sure to call:
await Supabase.initialize(url, anonKey);
in main() before runApp()
```

### Issue: "Verification email not received"
```
✅ Check:
1. Check spam/junk folder
2. Verify email address is correct
3. Wait 1-2 minutes for delivery
4. Use resendVerificationEmail() if needed
```

### Issue: "CORS error"
```
✅ Go to Supabase dashboard:
Settings → API → CORS Settings
Add your domain
```

### Issue: "Table doesn't exist"
```
✅ Check:
1. You ran all SQL queries
2. Table names match exactly (case-sensitive!)
3. Refresh the Supabase dashboard
```

### Issue: "Cost concerns"
```
✅ Email auth is COMPLETELY FREE!
- No SMS costs ($0/month)
- No monthly fees
- Can add SMS later if needed
- Saves $300/year!
```
✅ Go to Supabase dashboard:
Settings → API → CORS Settings
Add your domain
```

### Issue: "Table doesn't exist"
```
✅ Check:
1. You ran all SQL queries
2. Table names match exactly (case-sensitive!)
3. Refresh the dashboard
```

---

## 📚 **Additional Resources**

- [Supabase Docs](https://supabase.com/docs)
- [Flutter Supabase Guide](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Real-time Subscriptions](https://supabase.com/docs/guides/realtime)

---

## 🎉 **Next Steps**

1. Set up Supabase project
2. Create all tables
3. Add Flutter dependencies
4. Test duplicate prevention
5. Deploy to Play Store!

**Estimated time**: 1-2 hours ⏱️

---

**Your SocioHub app will be powered by Supabase! 🚀**





