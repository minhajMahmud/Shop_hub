# ShopHub E-Commerce Flutter App

Complete Flutter e-commerce application converted from the React design.

## Project Structure

### Models (`lib/models/`)

- **product.dart** - Product model with all properties, discounts, and quantity management

### Data (`lib/data/`)

- **products_data.dart** - Hardcoded product list with 7 sample products across all categories

### Screens (`lib/screens/`)

- **home_screen.dart** - Main shopping screen with product grid, filtering, sorting, and category selection
- **cart_screen.dart** - Shopping cart with item management, quantity adjustment, and checkout
- **wishlist_screen.dart** - Wishlist display with quick add-to-cart functionality
- **product_detail_screen.dart** - Template for detailed product view
- **checkout_screen.dart** - Template for checkout flow

### Widgets (`lib/widgets/`)

- **product_card.dart** - Reusable product card with price, rating, and action buttons
- **category_bar.dart** - Horizontal scrollable category filter
- **hero_banner.dart** - Auto-rotating carousel banner with navigation
- **header.dart** - Top header with branding and quick action icons

### Main App (`lib/main.dart`)

- Complete Material 3 app with light/dark theme support
- Bottom navigation for Home, Cart, and Wishlist
- Badge counts for cart and wishlist items
- Full state management for cart and wishlist operations

## Features Implemented

✅ **Product Browsing**

- Grid view of products with images
- Category filtering (All, Electronics, Fashion, Home, Sports, Beauty, Toys)
- Sorting options (Featured, Price Low-High, Price High-Low, Rating, Popular)
- Search support ready
- Discount badges for sale items
- Flash sale indicators

✅ **Shopping Cart**

- Add/remove items
- Adjust quantity
- Calculate totals with free shipping
- Responsive cart with product images
- Proceed to checkout button

✅ **Wishlist**

- Toggle favorites
- View all wishlist items
- Quick add-to-cart from wishlist
- Remove from wishlist

✅ **User Experience**

- Bottom navigation bar
- Badge counts for cart and wishlist
- Toast notifications for user actions
- Dark mode support
- Material 3 design system
- Responsive layout

## Product Data

7 sample products included:

1. Premium Wireless Headphones ($89.99)
2. Ultra 4K Smart TV ($449.99)
3. Casual Cotton T-Shirt ($19.99)
4. Stainless Steel Water Bottle ($24.99)
5. Organic Face Cream ($45.99)
6. Modern LED Desk Lamp ($35.99)
7. Board Game Collection ($29.99)

## Colors & Branding

- Primary Color: Deep Orange
- Brand Name: ShopHub
- Theme: Material 3 with light/dark mode support

## How to Run

```bash
flutter pub get
flutter run
```

## Next Steps (Future Enhancements)

- [ ] Backend API integration
- [ ] User authentication (sign up, login)
- [ ] Payment gateway integration
- [ ] Order history
- [ ] Product reviews and ratings
- [ ] Real search functionality
- [ ] Advanced filtering (price range, brand, etc.)
- [ ] Product detail pages with specifications
- [ ] Checkout form and address management
- [ ] Push notifications
- [ ] User profile management
