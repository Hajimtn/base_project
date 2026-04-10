# Hướng Dẫn Architecture

## Architecture Style

- Clean Architecture theo hướng feature-first.
- Dùng GetX cho routing, binding và presentation state.
- Dùng `Either<Failure, T>` để xử lý lỗi theo hướng functional.

## Feature Layout

```text
lib/features/<feature_name>/
  presentation/
    bindings/
    controllers/
    pages/
    widgets/
  domain/
    entities/
    repositories/
    usecases/
  data/
    datasources/
    models/
    repositories/
```

## Chiều Dependency

- `presentation` được phụ thuộc `domain`.
- `data` được phụ thuộc domain contract.
- `domain` không phụ thuộc `presentation` và `data`.

## Core Module Dùng Chung

- `lib/core/errors/`: failures và exceptions.
- `lib/core/types/`: result typedefs.
- `lib/core/utils/network/`: network client + interceptors.
- `lib/core/config/`: flavor + runtime env config.

## Route và Dependency Injection

- Mỗi feature nên có `Bindings` riêng.
- Route đăng ký tập trung trong `lib/core/utils/ui/app_router.dart`.
- Controller tạo qua binding của feature, không new trực tiếp ở app root.
