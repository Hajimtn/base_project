# Users Module

Module quản lý danh sách người dùng với API từ JSONPlaceholder.

## Cấu trúc thư mục

```
lib/features/users/
├── users_module.dart          # Export tất cả các file trong module
├── users_controller.dart      # Controller kế thừa từ BaseController
├── users_screen.dart          # Màn hình kế thừa từ BaseScreen
├── data/
│   ├── models/
│   │   └── user_model.dart    # Model dữ liệu người dùng
│   └── repositories/
│       └── users_repository.dart  # Repository xử lý API calls
└── widgets/
    └── user_card.dart         # Widget hiển thị thông tin người dùng
```

## Tính năng

- ✅ Kế thừa từ BaseController và BaseScreen
- ✅ Kết nối API JSONPlaceholder để lấy danh sách người dùng
- ✅ Hiển thị danh sách người dùng với UI đẹp
- ✅ Xử lý loading, error states
- ✅ Pull to refresh
- ✅ Responsive design

## Cách sử dụng

1. Import module:
```dart
import 'features/users/users_module.dart';
```

2. Sử dụng trong app:
```dart
GetMaterialApp(
  home: UsersScreen(),
)
```

## API Endpoints

- `GET /users` - Lấy danh sách tất cả người dùng
- `GET /users/{id}` - Lấy thông tin người dùng theo ID

## Dependencies

- `common` package: BaseController, BaseScreen, RestClient
- `get` package: State management
- `flutter/material.dart`: UI components
