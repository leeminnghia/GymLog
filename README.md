# GymLog

Ứng dụng iPhone theo dõi lịch tập gym: ngày tập, thứ tự bài, set, rep, tạ và lịch sử buổi tập.

## Chạy trên Mac

1. Cài [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`.
2. Chạy `xcodegen generate`.
3. Mở `GymLog.xcodeproj` bằng Xcode, chọn iPhone Simulator hoặc thiết bị và Run.

## Xuất IPA không cần Mac cá nhân

Đẩy project lên GitHub, kết nối repository với Codemagic, rồi chạy workflow `ios-unsigned-ipa`. File `GymLog-unsigned.ipa` sẽ có trong Build artifacts. Chỉ ký/cài IPA bằng chứng chỉ mà bạn được phép dùng.

## Phạm vi bản đầu

- Ba lịch mẫu Push, Pull, Legs.
- Nhập rep và tạ thực tế theo từng set.
- Lưu lịch sử buổi tập cục bộ trên iPhone, kể cả sau khi đóng và mở lại app.
