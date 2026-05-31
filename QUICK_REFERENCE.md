# Quick Reference Guide

## 🎯 Key Files & Their Purpose

### **Core Application**

- `lib/main.dart` - Entry point with role-based routing
- `lib/app_state.dart` - Global state management with all business logic

### **Authentication**

- `lib/screens/login_screen.dart` - Login with role selection buttons
  - Quick login for Admin (admin@gmail.com)
  - Quick login for Vendor (vendor@gmail.com)
  - Quick login for Customer (customer@gmail.com)

### **Dashboards** (Role-Specific)

- `lib/screens/admin_dashboard_screen.dart` - Admin control panel
  - 6 tabs: Products, Orders, Payments, Users, Reports, Settings
  - 25+ admin features
- `lib/screens/seller_dashboard_screen.dart` - Vendor management
  - Product management with approval workflow
  - Inventory & order management
  - Earnings & payouts
- `lib/screens/customer_dashboard_screen.dart` - Customer account
  - 4 tabs: Orders, Addresses, Payments, Profile
  - Order tracking, address management, payment history

### **Data Models**

**Core Models (Existing)**

- `lib/models/user.dart` - User with roles (admin, seller, customer)
- `lib/models/product.dart` - Product details
- `lib/models/order.dart` - Orders with seller support (enhanced)
- `lib/models/coupon.dart` - Promotions & discounts
- `lib/models/review.dart` - Product reviews

**New Models (Created)**

- `lib/models/category.dart` - Category management
- `lib/models/payment.dart` - Payments with 5 methods
- `lib/models/address.dart` - Multiple address support
- `lib/models/seller_product.dart` - Seller products with approval
- `lib/models/seller_stats.dart` - Seller analytics
- `lib/models/seller_payout.dart` - Seller withdrawals
- `lib/models/return.dart` - Return/refund requests
- `lib/models/withdrawal.dart` - Withdrawal management

---

## 🔑 Quick Navigation

### **To Add a New Admin Feature:**

1. Edit `lib/screens/admin_dashboard_screen.dart`
2. Add method `_buildNewFeature()`
3. Call it from appropriate tab builder
4. Update AppState if needed

### **To Add Customer Functionality:**

1. Edit `lib/screens/customer_dashboard_screen.dart`
2. Add to appropriate section
3. Update AppState with new getters/setters
4. Add corresponding model if needed

### **To Create New Models:**

1. Create file: `lib/models/new_model.dart`
2. Define class with properties
3. Add copyWith() for immutability
4. Import in AppState
5. Add getter/setter methods

### **To Modify Authentication:**

1. Edit `lib/screens/login_screen.dart`
2. Update role creation logic
3. Test with all three accounts

---

## 📊 Data Flow

```
Login Screen
    ↓ (Select Role)
AppState.login(User)
    ↓ (Update _currentUser)
MainApp checks user.role
    ↓
Route to Dashboard
├─ AdminDashboardScreen (if admin)
├─ SellerDashboardScreen (if seller)
└─ CustomerDashboardScreen (if customer)
```

---

## 🔐 Default Test Accounts

```
Role: Admin
Email: admin@gmail.com
Features: System management, approvals, analytics

Role: Vendor
Email: vendor@gmail.com
Features: Product & order management, earnings

Role: Customer
Email: customer@gmail.com
Features: Shopping, orders, addresses, payments
```

---

## 🛠️ Common Tasks

### **View All Orders (Admin)**

```dart
var orders = widget.appState.userOrders;
```

### **Get Seller Stats**

```dart
var stats = widget.appState.sellerStats;
```

### **Add Address (Customer)**

```dart
widget.appState.addAddress(address);
```

### **Approve Product (Admin)**

```dart
widget.appState.approveSellerProduct(productId);
```

### **Add Payment (System)**

```dart
widget.appState.addPayment(payment);
```

---

## 📱 UI Components Used

- `BottomNavigationBar` - Tab navigation
- `TabBar` + `TabBarView` - Tab content
- `Container` + `BoxDecoration` - Cards
- `ListTile` - List items
- `ElevatedButton` / `OutlinedButton` - Actions
- `Badge` - Notification counts
- `AlertDialog` - Forms & dialogs
- `FilterChip` - Status filtering
- `CircleAvatar` - User icons

---

## 🎨 Color Scheme

- **Primary**: `Colors.deepOrange`
- **Success**: `Colors.green`
- **Warning**: `Colors.orange`
- **Error**: `Colors.red`
- **Info**: `Colors.blue`
- **Background**: `Colors.white`
- **Border**: `Colors.grey[300]`

---

## 📝 Naming Conventions

- **Screens**: `XxxScreen` (e.g., `AdminDashboardScreen`)
- **Models**: `Xxx` (e.g., `SellerProduct`)
- **Methods**: `camelCase` (e.g., `addAddress`)
- **Private**: `_camelCase` (e.g., `_buildOrdersList`)
- **Constants**: `UPPER_CASE` (e.g., `_defaultEmails`)

---

## ✅ Build & Run

```bash
# Clean build
flutter clean
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

---

## 🐛 Debugging Tips

1. **Check Role**: Print `widget.appState.currentUser?.role`
2. **View State**: Print `widget.appState.userOrders` or similar
3. **Navigation**: Verify dashboard appears for correct role
4. **Data**: Add prints in AppState methods
5. **UI**: Use Flutter Inspector to inspect widget tree

---

## 📚 Documentation Files

- `IMPLEMENTATION_GUIDE.md` - Detailed feature breakdown
- `IMPLEMENTATION_SUMMARY.md` - Overview & completion status
- `QUICK_REFERENCE.md` - This file
- Code comments - In-line documentation

---

## 🚀 Deployment Checklist

- [ ] All models created and tested
- [ ] Dashboards compile without errors
- [ ] Login redirects to correct dashboard
- [ ] Role-based access working
- [ ] No console errors
- [ ] UI responsive on mobile/tablet
- [ ] All buttons functional
- [ ] Navigation working smoothly

---

## 🎓 Learning Path

1. Start with `lib/main.dart` to understand routing
2. Review `lib/app_state.dart` for state management
3. Study `lib/screens/login_screen.dart` for authentication
4. Explore dashboard screens (admin, seller, customer)
5. Check models in `lib/models/` for data structure
6. Review documentation files for detailed info

---

Generated: 2024
Status: ✅ Complete & Ready
