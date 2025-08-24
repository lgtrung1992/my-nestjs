# Phân Tích Vai Trò Professor - Hệ Thống Quản Lý Quỹ

## Tổng Quan
Tài liệu này phân tích chức năng của vai trò Professor (Giáo sư) trong hệ thống phần mềm quản lý quỹ. Vai trò Professor đại diện cho các nhà nghiên cứu và giáo sư đại học, những người tìm kiếm, nộp đơn và quản lý các đơn ứng tuyển quỹ nghiên cứu.

## Bối Cảnh Hệ Thống
Vai trò Professor trong hệ thống:
- Tìm kiếm và duyệt các cơ hội tài trợ phù hợp
- Nộp đơn ứng tuyển với tài liệu đầy đủ
- Quản lý trạng thái đơn ứng tuyển
- Tương tác với reviewer và staff qua chat
- Quản lý hồ sơ cá nhân và tài liệu tham khảo

## Chức Năng Vai Trò Professor

### 1. Danh Sách Quỹ và Tìm Kiếm

#### 1.1 Danh Sách Quỹ
**File:** `GS- list fund.png`

![Danh Sách Quỹ Professor](../ui_images/Professor/GS- list fund.png)

Màn hình danh sách quỹ cho phép Professor:
- **Xem danh sách quỹ**: Tất cả cơ hội tài trợ có sẵn với các trường thông tin cơ bản (Code, Organization, Fund Title, Program Type, Internal Deadline, Difficulty, Application Start Date, Application Deadline, Graduate Student)
- **Bộ lọc tìm kiếm**: Lọc theo danh mục, trường đại học, ngày hết hạn, độ khó, tính phù hợp
- **Tìm kiếm nâng cao**: Tìm kiếm theo từ khóa, lĩnh vực nghiên cứu, quốc gia
- **Sắp xếp**: Theo ngày, tên, trạng thái, độ khó
- **Phân trang**: Duyệt qua nhiều trang quỹ
- **Đánh dấu yêu thích**: Lưu quỹ quan tâm
- **Đánh giá tính phù hợp**: Xem mức độ phù hợp với profile cá nhân

#### 1.2 Tìm Kiếm Chi Tiết
**File:** `詳細検索.png`

![Tìm Kiếm Chi Tiết](../ui_images/Professor/詳細検索.png)

Giao diện tìm kiếm nâng cao với:
- **Bộ lọc đa tiêu chí**: Danh mục, trường đại học, ngân sách
- **Tìm kiếm theo từ khóa**: Tên quỹ, mô tả, yêu cầu
- **Lọc theo thời gian**: Ngày bắt đầu, ngày kết thúc
- **Lọc theo trạng thái**: Đang mở, đã đóng, sắp mở
- **Lưu tìm kiếm**: Lưu các bộ lọc thường dùng

#### 1.3 Danh Sách Quỹ Dạng Bảng
**File:** `Table list fund/Default.png`

![Danh Sách Quỹ Dạng Bảng](../ui_images/Professor/Table list fund/Default.png)

Hiển thị quỹ dạng bảng với:
- **Thông tin cơ bản**: Tên quỹ, trường đại học, ngân sách
- **Trạng thái**: Đang mở, đã đóng, đã nộp
- **Hành động**: Xem chi tiết, nộp đơn, lưu vào yêu thích
- **Thông tin thời gian**: Ngày hết hạn, thời gian còn lại

### 2. Quản Lý Yêu Thích

#### 2.1 Danh Sách Yêu Thích
**File:** `GS- お気に入り.png`

![Danh Sách Yêu Thích](../ui_images/Professor/GS- お気に入り.png)

Quản lý quỹ yêu thích:
- **Thêm vào yêu thích**: Lưu quỹ quan tâm
- **Xem danh sách yêu thích**: Tất cả quỹ đã lưu
- **Xóa khỏi yêu thích**: Loại bỏ quỹ không quan tâm
- **Chuyển đổi trạng thái**: Từ yêu thích sang nộp đơn

### 3. Chi Tiết Quỹ

#### 3.1 Chi Tiết Quỹ Cơ Bản
**File:** `GS-fund detail.png`

![Chi Tiết Quỹ Cơ Bản](../ui_images/Professor/GS-fund detail.png)

Thông tin chi tiết quỹ:
- **Mô tả quỹ**: Thông tin tổng quan, mục tiêu
- **Yêu cầu**: Điều kiện ứng tuyển, tài liệu cần thiết
- **Ngân sách**: Số tiền tài trợ, cách sử dụng
- **Thời gian**: Ngày bắt đầu, kết thúc, hạn nộp
- **Liên hệ**: Thông tin liên hệ ban quản lý quỹ

#### 3.2 Chi Tiết Quỹ - Chưa Nộp
**File:** `GS-fund detail - not submitted.png`

![Chi Tiết Quỹ Chưa Nộp](../ui_images/Professor/GS-fund detail - not submitted.png)

Giao diện cho quỹ chưa nộp đơn:
- **Nút nộp đơn**: Bắt đầu quy trình nộp đơn
- **Xem yêu cầu**: Chi tiết tài liệu cần thiết
- **Tải mẫu đơn**: Tải form đơn ứng tuyển
- **Lưu vào yêu thích**: Thêm vào danh sách quan tâm

#### 3.3 Chi Tiết Quỹ - Đã Nộp
**File:** `GS-fund detail - submitted.png`

![Chi Tiết Quỹ Đã Nộp](../ui_images/Professor/GS-fund detail - submitted.png)

Giao diện cho quỹ đã nộp đơn:
- **Trạng thái đơn**: Đang xử lý, đã duyệt, từ chối
- **Xem đơn đã nộp**: Chi tiết đơn ứng tuyển
- **Cập nhật đơn**: Chỉnh sửa thông tin nếu cần
- **Theo dõi tiến trình**: Xem quá trình đánh giá

### 4. Nộp Đơn Ứng Tuyển

#### 4.1 Popup Nộp Đơn
**File:** `GS-Submit-Popup.png`

![Popup Nộp Đơn](../ui_images/Professor/GS-Submit-Popup.png)

Xác nhận nộp đơn:
- **Xác nhận thông tin**: Kiểm tra thông tin trước khi nộp
- **Điều khoản**: Chấp nhận điều khoản ứng tuyển
- **Nút nộp đơn**: Hoàn tất việc nộp đơn
- **Hủy**: Quay lại để chỉnh sửa

#### 4.2 Thông Báo Thành Công
**File:** `Success Alert.png`

![Thông Báo Thành Công](../ui_images/Professor/Success Alert.png)

Xác nhận nộp đơn thành công:
- **Thông báo thành công**: Đơn đã được nộp
- **Số đơn**: Mã số đơn ứng tuyển
- **Hướng dẫn tiếp theo**: Các bước tiếp theo
- **Liên kết theo dõi**: Xem trạng thái đơn

### 5. Quản Lý Đơn Ứng Tuyển

#### 5.1 Trạng Thái Ứng Tuyển
**File:** `GS-応募状況.png`

![Trạng Thái Ứng Tuyển](../ui_images/Professor/GS-応募状況.png)

Quản lý tất cả đơn ứng tuyển:
- **Danh sách đơn**: Tất cả đơn đã nộp với các trạng thái chi tiết:
  - [Internal] Submitted (1) - Đã nộp hồ sơ nội bộ
  - [Internal] Reviewer Invited - Đã mời reviewer
  - [Internal] Under Review - Đang đánh giá
  - [Internal] Ready for Resubmit - Sẵn sàng nộp lại
  - [Internal] Submitted (Final) - Đã nộp bản cuối
  - [External] Submitted - Đã nộp bên ngoài
  - Accepted - Đã được chấp nhận
  - Rejected - Đã bị từ chối
- **Thông tin cơ bản**: Tên quỹ, ngày nộp, trạng thái, số lần nộp
- **Hành động**: Xem chi tiết, cập nhật, hủy
- **Feedback buttons**: Will Apply, Not Apply, Considering cho quỹ chưa nộp

#### 5.2 Chi Tiết Trạng Thái
**File:** `GS-応募状況-1.png`

![Chi Tiết Trạng Thái](../ui_images/Professor/GS-応募状況-1.png)

Thông tin chi tiết đơn ứng tuyển:
- **Tiến trình đánh giá**: Các bước đã hoàn thành
- **Phản hồi reviewer**: Nhận xét và đánh giá
- **Tài liệu bổ sung**: Yêu cầu tài liệu thêm
- **Thời gian**: Thời gian xử lý dự kiến

### 6. Hệ Thống Chat

#### 6.1 Chat Manager
**File:** `GS-CHAT-Chat manager.png`

![Chat Manager](../ui_images/Professor/GS-CHAT-Chat manager.png)

Quản lý tất cả cuộc trò chuyện:
- **Danh sách chat**: Tất cả cuộc trò chuyện
- **Trạng thái**: Đang hoạt động, chờ phản hồi
- **Thông tin người chat**: Staff, reviewer liên quan
- **Tìm kiếm chat**: Tìm cuộc trò chuyện cụ thể

#### 6.2 Giao Diện Chat
**File:** `GS-チャット.png`

![Giao Diện Chat](../ui_images/Professor/GS-チャット.png)

Giao diện trò chuyện:
- **Lịch sử tin nhắn**: Tất cả tin nhắn đã trao đổi
- **Gửi tin nhắn**: Nhập và gửi tin nhắn mới
- **Tải file**: Gửi tài liệu qua chat
- **Emoji và định dạng**: Hỗ trợ emoji và định dạng văn bản

#### 6.3 Chat Đánh Giá
**File:** `GS-Review-チャット.png`

![Chat Đánh Giá](../ui_images/Professor/GS-Review-チャット.png)

Chat với reviewer:
- **Thảo luận đánh giá**: Trao đổi về đơn ứng tuyển
- **Phản hồi yêu cầu**: Trả lời câu hỏi của reviewer
- **Cung cấp thông tin**: Bổ sung thông tin cần thiết
- **Theo dõi tiến trình**: Cập nhật trạng thái đánh giá

### 7. Chức Năng Reviewer

#### 7.1 Trạng Thái Reviewer
**File:** `GS-Reviewer-応募状況.png`

![Trạng Thái Reviewer](../ui_images/Professor/GS-Reviewer-応募状況.png)

Khi Professor làm reviewer:
- **Danh sách đơn cần đánh giá**: Các đơn được phân công
- **Trạng thái đánh giá**: Đã đánh giá, đang đánh giá
- **Thời hạn**: Deadline đánh giá
- **Hành động**: Bắt đầu đánh giá, xem chi tiết

#### 7.2 Upload File Đánh Giá
**File:** `GS-Reviewer-Upload file review.png`

![Upload File Đánh Giá](../ui_images/Professor/GS-Reviewer-Upload file review.png)

Tải lên file đánh giá:
- **Form đánh giá**: Nhập nhận xét và điểm số
- **Tải file**: Upload file đánh giá chi tiết
- **Lưu bản nháp**: Lưu đánh giá chưa hoàn thành
- **Gửi đánh giá**: Hoàn tất và gửi đánh giá

#### 7.3 Chat Manager Reviewer
**File:** `GS-reviwer-Chat manager.png`

![Chat Manager Reviewer](../ui_images/Professor/GS-reviwer-Chat manager.png)

Quản lý chat khi làm reviewer:
- **Chat với Professor**: Trao đổi về đơn ứng tuyển
- **Chat với Staff**: Thảo luận về đánh giá
- **Lịch sử chat**: Xem lại các cuộc trò chuyện
- **Thông báo**: Nhận thông báo mới

### 8. Mời Reviewer

#### 8.1 Mời Reviewer
**File:** `GS_Invite reviewer.png`

![Mời Reviewer](../ui_images/Professor/GS_Invite reviewer.png)

Mời reviewer cho đơn ứng tuyển:
- **Tìm reviewer**: Tìm kiếm reviewer phù hợp
- **Gửi lời mời**: Gửi email mời đánh giá
- **Theo dõi trạng thái**: Xem ai đã chấp nhận
- **Quản lý reviewer**: Thêm/xóa reviewer

#### 8.2 Chi Tiết Mời Reviewer
**File:** `GS_Invite reviewer.2.png`

![Chi Tiết Mời Reviewer](../ui_images/Professor/GS_Invite reviewer.2.png)

Chi tiết quy trình mời:
- **Thông tin reviewer**: Hồ sơ và chuyên môn
- **Lý do mời**: Giải thích tại sao mời reviewer này
- **Thời hạn**: Deadline đánh giá
- **Trạng thái**: Đã gửi, đã chấp nhận, từ chối

### 9. Quản Lý Hồ Sơ

#### 9.1 Hồ Sơ Cá Nhân
**File:** `GS-プロフィール.png`

![Hồ Sơ Cá Nhân](../ui_images/Professor/GS-プロフィール.png)

Thông tin hồ sơ cá nhân:
- **Thông tin cơ bản**: Họ tên, email, số điện thoại
- **Thông tin chuyên môn**: Lĩnh vực nghiên cứu, bằng cấp
- **Thông tin trường đại học**: Khoa, chức vụ
- **Tài liệu**: CV, giấy tờ xác minh

#### 9.2 Chỉnh Sửa Hồ Sơ
**File:** `GS-プロフィールを編集する.png`

![Chỉnh Sửa Hồ Sơ](../ui_images/Professor/GS-プロフィールを編集する.png)

Cập nhật thông tin hồ sơ:
- **Chỉnh sửa thông tin**: Cập nhật thông tin cá nhân
- **Tải lên tài liệu**: Cập nhật CV, giấy tờ
- **Lưu thay đổi**: Lưu thông tin đã cập nhật
- **Xem trước**: Xem hồ sơ sau khi cập nhật

#### 9.3 Đổi Mật Khẩu
**File:** `GS-プロフィール-update password.png`

![Đổi Mật Khẩu](../ui_images/Professor/GS-プロフィール-update password.png)

Thay đổi mật khẩu:
- **Mật khẩu hiện tại**: Xác nhận mật khẩu cũ
- **Mật khẩu mới**: Nhập mật khẩu mới
- **Xác nhận mật khẩu**: Nhập lại mật khẩu mới
- **Lưu thay đổi**: Hoàn tất đổi mật khẩu

### 10. Tài Liệu Tham Khảo

#### 10.1 Đơn Ứng Tuyển Tham Khảo
**File:** `GS-例年の参考申請書.png`

![Đơn Ứng Tuyển Tham Khảo](../ui_images/Professor/GS-例年の参考申請書.png)

Quản lý tài liệu tham khảo:
- **Danh sách đơn tham khảo**: Các đơn đã nộp trước đây
- **Tải xuống**: Tải đơn tham khảo
- **Phân loại**: Theo năm, lĩnh vực, trạng thái
- **Tìm kiếm**: Tìm đơn tham khảo cụ thể

### 11. Các Thành Phần UI Khác

#### 11.1 Nút Hành Động
**File:** `Action.png`

![Nút Hành Động](../ui_images/Professor/Action.png)

Các nút hành động chung:
- **Nút nộp đơn**: Bắt đầu nộp đơn
- **Nút lưu**: Lưu vào yêu thích
- **Nút chỉnh sửa**: Cập nhật thông tin
- **Nút xóa**: Xóa khỏi danh sách

#### 11.2 Nút Trạng Thái
**File:** `button-Will Apply- Considering.png`

![Nút Trạng Thái](../ui_images/Professor/button-Will Apply- Considering.png)

Nút thể hiện ý định:
- **Sẽ nộp**: Xác nhận sẽ nộp đơn
- **Đang cân nhắc**: Chưa quyết định
- **Không quan tâm**: Loại bỏ khỏi danh sách

#### 11.3 Thông Báo Hành Động
**File:** `action message.png`

![Thông Báo Hành Động](../ui_images/Professor/action message.png)

Thông báo xác nhận hành động:
- **Xác nhận**: Xác nhận hành động quan trọng
- **Cảnh báo**: Thông báo về hậu quả
- **Hướng dẫn**: Hướng dẫn bước tiếp theo

## Tính Năng và Khả Năng Chính

### Quản Lý Quỹ
1. **Tìm kiếm quỹ**: Tìm kiếm cơ hội tài trợ phù hợp
2. **Lưu yêu thích**: Lưu quỹ quan tâm để theo dõi
3. **Xem chi tiết**: Thông tin đầy đủ về quỹ
4. **So sánh quỹ**: So sánh các quỹ khác nhau

### Nộp Đơn Ứng Tuyển
1. **Tạo đơn ứng tuyển**: Điền thông tin và tài liệu
2. **Tải lên tài liệu**: Upload CV, proposal, giấy tờ
3. **Xem trước đơn**: Kiểm tra trước khi nộp
4. **Nộp đơn**: Hoàn tất quy trình nộp đơn

### Quản Lý Đơn Ứng Tuyển
1. **Theo dõi trạng thái**: Xem tiến trình xử lý
2. **Cập nhật đơn**: Chỉnh sửa thông tin nếu cần
3. **Xem phản hồi**: Nhận xét từ reviewer
4. **Rút đơn**: Hủy đơn nếu cần

### Tương Tác và Giao Tiếp
1. **Chat với Staff**: Trao đổi về đơn ứng tuyển
2. **Chat với Reviewer**: Thảo luận về đánh giá
3. **Nhận thông báo**: Cập nhật trạng thái
4. **Gửi tin nhắn**: Liên hệ khi cần

### Chức Năng Reviewer
1. **Đánh giá đơn**: Đánh giá đơn ứng tuyển khác
2. **Upload đánh giá**: Tải lên file đánh giá
3. **Chat với Professor**: Trao đổi về đơn
4. **Quản lý deadline**: Theo dõi thời hạn đánh giá

## Tích Hợp Hệ Thống

### Với Các Vai Trò Khác
- **Staff**: Nhận thông báo và hướng dẫn
- **Reviewer**: Trao đổi về đánh giá
- **Admin**: Quản lý thông tin cá nhân

### Với Các Module Khác
- **File Management**: Quản lý tài liệu đơn ứng tuyển
- **Notification System**: Nhận thông báo cập nhật
- **Chat System**: Giao tiếp với các bên liên quan
- **Email System**: Nhận email thông báo

## Cân Nhắc Kỹ Thuật

### Bảo Mật
- **Bảo vệ tài liệu**: Mã hóa file đơn ứng tuyển
- **Xác thực người dùng**: Kiểm tra quyền truy cập
- **Audit trail**: Ghi nhật ký hoạt động
- **Data privacy**: Bảo vệ thông tin cá nhân

### Hiệu Suất
- **Caching**: Cache danh sách quỹ và trạng thái
- **Pagination**: Phân trang cho danh sách lớn
- **File upload**: Tối ưu upload tài liệu
- **Real-time chat**: WebSocket cho chat

### Trải Nghiệm Người Dùng
- **Responsive design**: Tương thích mọi thiết bị
- **Intuitive navigation**: Điều hướng dễ dàng
- **Progress indicators**: Hiển thị tiến trình
- **Error handling**: Xử lý lỗi thân thiện

## Cải Tiến Tương Lai

### Tính Năng Nâng Cao
1. **AI Recommendation**: Gợi ý quỹ phù hợp
2. **Template Management**: Quản lý mẫu đơn
3. **Collaboration Tools**: Công cụ làm việc nhóm
4. **Analytics Dashboard**: Thống kê đơn ứng tuyển

### Tích Hợp Nâng Cao
1. **ORCID Integration**: Tích hợp với ORCID
2. **Research Database**: Kết nối cơ sở dữ liệu nghiên cứu
3. **Calendar Integration**: Tích hợp lịch deadline
4. **Mobile App**: Ứng dụng di động

---

*Phân tích này dựa trên các mockup UI được cung cấp trong thư mục Professor và đại diện cho chức năng dự định cho vai trò Professor trong hệ thống quản lý quỹ.*
