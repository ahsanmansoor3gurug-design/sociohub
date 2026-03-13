# 🌍 SocioHub - Connect Your Community

A Flutter-based mobile application that helps residents connect with their local community, find services, and stay informed about local events and announcements.

## 📱 Features (MVP)

- **City Selection** - Select your city from a list of major Pakistani cities
- **Society Management** - Browse and add residential societies
- **Duplicate Prevention** - Smart duplicate detection with suggestions
- **Masjid Timings** - View prayer times and mosque information
- **Restaurants Directory** - Find restaurants in your society
- **Community Services** - Directory of local service providers
- **Emergency Contacts** - Quick access to important numbers
- **Admin Approval System** - Community-driven content with admin moderation

## 🚀 Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/
│   ├── splash_screen.dart            # Welcome screen
│   ├── city_screen.dart              # City selection
│   ├── society_screen.dart           # Society listing and search
│   ├── home_screen.dart              # Main dashboard
│   └── add_society_screen.dart       # Add new society form
├── models/
│   ├── city_model.dart               # City data model
│   └── society_model.dart            # Society data model
└── utils/
    └── constants.dart                # App constants
```

## 🔧 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio with Flutter plugin
- Supabase Account (FREE!)

### Installation

1. **Clone or navigate to project**
   ```bash
   cd sociohub
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create account at supabase.com
   - Create new project
   - Copy Project URL and API Key
   - Follow SUPABASE_IMPLEMENTATION_GUIDE.md

4. **Run the app**
   ```bash
   flutter run -d chrome
   ```

### First Run
The app will show:
1. Splash Screen (3 seconds)
2. Login/Signup Screen (email)
3. City Selection Screen
4. Society List Screen
5. Community Dashboard

## 📊 Data Structure (Supabase PostgreSQL)

## 📊 Data Structure (Supabase PostgreSQL)

### Tables

#### cities
```sql
CREATE TABLE cities (
  id UUID PRIMARY KEY,
  name VARCHAR NOT NULL UNIQUE,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP
);
```

#### users
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR NOT NULL UNIQUE,  -- One email = One account
  name VARCHAR NOT NULL,
  role VARCHAR DEFAULT 'resident',
  city_id UUID REFERENCES cities(id),
  email_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP
);
```

#### societies
```sql
CREATE TABLE societies (
  id UUID PRIMARY KEY,
  city_id UUID NOT NULL REFERENCES cities(id),
  name VARCHAR NOT NULL,
  area VARCHAR,
  created_by UUID REFERENCES users(id),
  status VARCHAR DEFAULT 'pending',
  created_at TIMESTAMP,
  UNIQUE(city_id, name)  -- Prevents duplicate societies!
);
```

#### masjids
```sql
CREATE TABLE masjids (
  id UUID PRIMARY KEY,
  society_id UUID NOT NULL REFERENCES societies(id),
  imam_id UUID REFERENCES users(id),
  name VARCHAR NOT NULL,
  fajr TIME, zuhr TIME, asr TIME, maghrib TIME, isha TIME,
  status VARCHAR DEFAULT 'pending',
  created_at TIMESTAMP
);
```

#### restaurants
```sql
CREATE TABLE restaurants (
  id UUID PRIMARY KEY,
  society_id UUID NOT NULL REFERENCES societies(id),
  owner_id UUID REFERENCES users(id),
  name VARCHAR NOT NULL,
  category VARCHAR,
  delivery_available BOOLEAN,
  status VARCHAR DEFAULT 'pending',
  created_at TIMESTAMP
);
```

#### services
```sql
CREATE TABLE services (
  id UUID PRIMARY KEY,
  society_id UUID NOT NULL REFERENCES societies(id),
  provider_id UUID REFERENCES users(id),
  service_type VARCHAR,
  name VARCHAR NOT NULL,
  status VARCHAR DEFAULT 'pending',
  created_at TIMESTAMP
);
```

## 🔐 Authentication (Email Verification)

### How It Works
1. **User Signup** - Email + Password
   ```dart
   await supabase.auth.signUpWithPassword(
     email: 'user@gmail.com',
     password: 'password',
   );
   ```

2. **Automatic Verification Email** - Supabase sends email
   ```
   Click link → Email verified
   Cost: $0 ✅
   ```

3. **Account Ready** - User can login
   ```dart
   await supabase.auth.signInWithPassword(
     email: 'user@gmail.com',
     password: 'password',
   );
   ```

### Duplicate Prevention
- Email is UNIQUE in users table
- One email = One account (enforced by database)
- Cannot create multiple accounts with same email
- Same applies to societies within a city
- UNIQUE(city_id, name) prevents duplicate societies

## 💰 Cost Structure

| Component | Cost | Notes |
|-----------|------|-------|
| **Supabase Database** | $0-25/mo | Free tier for MVP |
| **Email Auth** | $0/mo | Built-in, completely free |
| **Email Sending** | $0/mo | Automatic via Supabase |
| **Total MVP Cost** | **$0/month** | ✅ Completely FREE |
  "cityId": "karachi",
  "societyName": "DHA Phase 6",
  "area": "Defence",
  "createdBy": "user123",
  "status": "approved",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

#### masjids
```json
{
  "masjidId": "masjid_1",
  "societyId": "dha_phase6",
  "imamId": "imam_1",
  "masjidName": "Al-Noor Masjid",
  "fajr": "05:30",
  "zuhr": "12:30",
  "asr": "15:45",
  "maghrib": "18:15",
  "isha": "19:45",
  "status": "approved"
}
```

## 🎯 User Roles

- **Resident** - Can view and search communities
- **Imam** - Can manage masjid information
- **Restaurant Owner** - Can add/manage restaurants
- **Service Provider** - Can register services
- **Admin** - Can approve/reject user submissions

## 🔐 Duplicate Prevention Strategy

### Option 1: Exact Name Match
- Checks if society name already exists in the city
- Simple and fast
- Prevents obvious duplicates

### Option 2: Similar Name Suggestion
- Shows suggestions while user types
- Similar to Google Maps
- Helps users find existing entries

## 🔄 User Flow

```
App Launch
    ↓
Splash Screen (3s)
    ↓
Select City
    ↓
Search/Browse Societies
    ↓
Add New Society (if needed)
    ↓
View Community Dashboard
    ├── Masjid Timings
    ├── Restaurants
    ├── Services
    └── Emergency Contacts
```

## 💰 Cost Estimation

| Users | Monthly Cost |
|-------|-------------|
| 0-1K | $0-10 |
| 10K | $20-70 |
| 100K | $100-400 |

*Costs are approximate and based on Firebase pricing*

## 🔄 Next Steps

1. **Firebase Integration**
   - Set up Firebase project
   - Configure Authentication
   - Create Firestore collections

2. **Real Data**
   - Replace hardcoded cities/societies with Firebase data
   - Implement real-time search

3. **Additional Modules**
   - Masjid timings management
   - Restaurant directory
   - Service provider system

4. **Admin Panel**
   - Build approval system
   - User management
   - Content moderation

## 📚 Dependencies

- **Flutter** - Cross-platform mobile framework
- **Firebase** - Backend and real-time database
- **Google Maps** - Location services
- **Provider** - State management

## 🤝 Contributing

When adding features:
1. Follow the folder structure
2. Add appropriate models in `models/`
3. Create screens in `screens/`
4. Update constants in `utils/constants.dart`

## 📝 License

This project is proprietary software.

## 📞 Support

For issues or questions, contact the development team.

---

**SocioHub** - Connecting Communities, One Society at a Time 🏘️



