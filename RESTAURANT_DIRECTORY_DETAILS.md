# 🍽️ Restaurant Directory Implementation Details

This document provides a detailed breakdown of the "Restaurant Directory" feature implemented for MPCHS B-17.

---

## 1. Data Structure (`lib/models/restaurant_model.dart`)
We created a dedicated model to manage restaurant information professionally.

| Field | Type | Description |
| :--- | :--- | :--- |
| `id` | String | Unique identifier from Supabase. |
| `name` | String | Name of the restaurant (e.g., Savour Foods). |
| `cuisine` | String | Category (Fast Food, Desi, Bakery, Chinese). |
| `phoneNumber`| String | Contact for delivery/orders. |
| `address` | String | Location inside B-17 (e.g., Block C). |
| `rating` | double | User rating (e.g., 4.5). |

---

## 2. Local Database Integration (`lib/services/local_db_service.dart`)
To ensure the directory works **without internet**, we updated the SQLite database to version **3**.

### **New Table: `restaurants`**
```sql
CREATE TABLE restaurants(
  id TEXT PRIMARY KEY,
  society_id TEXT NOT NULL,
  name TEXT NOT NULL,
  cuisine TEXT NOT NULL,
  phone_number TEXT NOT NULL,
  address TEXT NOT NULL,
  rating REAL NOT NULL
)
```
*   **Sync Logic**: Data is fetched from the cloud and saved locally.
*   **Offline Access**: If offline, the app queries this table directly.

---

## 3. UI Implementation (`lib/screens/restaurant_directory_screen.dart`)
A high-performance screen designed for local community use.

### **Key Features**
*   **MPCHS B-17 Local Data**: Pre-seeded with local favorites:
    *   **Savour Foods** (Block C)
    *   **Cheezious** (Block B)
    *   **Tehzeeb Bakery** (Block A)
*   **Filtering**: A horizontal "ChoiceChip" list allows users to quickly filter by cuisine type.
*   **One-Tap Call**: Clicking the delivery icon triggers the phone's dialer using `url_launcher`.
*   **Ads**: A `BannerAdWidget()` is placed at the bottom to generate revenue while users browse.

---

## 4. Home Screen Integration
The **"🍽️ Restaurants"** card on the `HomeScreen` is now functional.
*   **Navigation**: Uses `Navigator.push` to open the directory.
*   **Context Aware**: Passes the `societyId` ("s1" for B-17) to ensure only relevant restaurants are shown.

---

## 📋 Review Checklist for Restaurant Feature
- [ ] **Database Version**: Ensure you performed a "Cold Restart" to trigger the SQLite v3 update.
- [ ] **Call Permission**: Ensure `android.permission.CALL_PHONE` is in `AndroidManifest.xml`.
- [ ] **Banner Ad**: Verify that the test banner appears at the bottom of the list.
- [ ] **Filtering**: Tap on 'Fast Food' to ensure only pizza/burger spots are visible.

---
**Implementation Completed: March 15, 2026**
