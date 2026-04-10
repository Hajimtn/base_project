# Automation

## Melos Scripts

Được định nghĩa trong `melos.yaml`:

- `bootstrap`: `flutter pub get`
- `format`: `dart format lib test tool`
- `analyze`: `flutter analyze`
- `test`: `flutter test`
- `l10n`: `flutter gen-l10n`
- `gen`: `build_runner build`
- `watch`: `build_runner watch`
- `feature:create`: chạy feature generator script

## Feature Generator

Lệnh:

```bash
dart run melos run feature:create -- --name <feature_name>
```

Ví dụ:

```bash
dart run melos run feature:create -- --name order_history
```

Cấu trúc được generate:

- domain: entity/repository/usecase
- data: model/datasource/repository_impl
- presentation: binding/state/controller/page/widget

Sau khi generate:

1. Đăng ký route trong `app_router.dart`.
2. Implement remote data source.
3. Thêm key localization.

## Asset Constants

`flutter_gen_runner` đã được bật trong `pubspec.yaml`.
Chạy `melos run gen` sẽ generate typed asset constants vào:

- `lib/core/gen/`

`build_runner` cũng regenerate code cho:

- `retrofit` clients (`*.g.dart`)
- `json_serializable` models
- `freezed`
