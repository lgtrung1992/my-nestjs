# Phân Tích Vai Trò Staff - Hệ Thống Quản Lý Quỹ

## Tổng Quan
Tài liệu này phân tích chức năng của vai trò Staff (Nhân viên) trong hệ thống phần mềm quản lý quỹ. Vai trò Staff đại diện cho nhân viên quản lý quỹ, những người tạo quỹ, quản lý đơn ứng tuyển, phân công reviewer và điều phối toàn bộ quy trình đánh giá.

## Bối Cảnh Hệ Thống
Vai trò Staff trong hệ thống:
- Tạo và quản lý các quỹ tài trợ mới
- Quản lý đơn ứng tuyển từ Professor
- Phân công và quản lý reviewer
- Điều phối quy trình đánh giá
- Quản lý tài liệu tham khảo và mẫu đơn
- Giao tiếp với Professor và Reviewer

## Chức Năng Vai Trò Staff

### 1. Dashboard và Tổng Quan

#### 1.1 Dashboard Staff
**File:** `ST-Dashboard.png`

![Dashboard Staff](../ui_images/Staff/ST-Dashboard.png)

Bảng điều khiển chính cho Staff:
- **Tổng quan quỹ**: Số lượng quỹ đang quản lý
- **Đơn ứng tuyển**: Thống kê đơn đã nhận, đang xử lý
- **Reviewer**: Số reviewer đang hoạt động
- **Thông báo**: Các thông báo quan trọng cần xử lý
- **Deadline**: Các deadline sắp tới
- **Biểu đồ thống kê**: Xu hướng đơn ứng tuyển

### 2. Quản Lý Quỹ

#### 2.1 Danh Sách Quỹ
**File:** `ST - list fund.png`

![Danh Sách Quỹ Staff](../ui_images/Staff/ST - list fund.png)

Quản lý tất cả quỹ được tạo:
- **Danh sách quỹ**: Tất cả quỹ đang quản lý
- **Trạng thái quỹ**: Đang mở, đã đóng, tạm dừng
- **Thống kê đơn**: Số đơn đã nhận cho mỗi quỹ
- **Hành động**: Chỉnh sửa, xóa, tạm dừng quỹ
- **Tìm kiếm**: Tìm quỹ theo tên, trạng thái

#### 2.2 Tạo Quỹ Mới
**File:** `ST-Create new fund.png`

![Tạo Quỹ Mới](../ui_images/Staff/ST-Create new fund.png)

Form tạo quỹ mới với các trường thông tin chi tiết:

**Thông tin cơ bản (Staff Input)**:
- **Recruitment Requirement**: File PDF mô tả chi tiết về quỹ (EN/JP)
- **Homepage**: Đường dẫn trang chủ quỹ (Optional)
- **Internal Deadline**: Hạn nộp nội bộ trong trường (Optional)

**Thông tin tự động (AI + Editable)**:
- **Category**: Danh mục quỹ (Internal, Government, Other)
- **Country**: Quốc gia (cho quỹ quốc tế)
- **Organization/Foundation**: Tên tổ chức cung cấp quỹ
- **Fund Title**: Tên quỹ
- **Program Type**: Loại chương trình
- **Difficulty**: Độ khó (Unknown, Normal, Hard, Very Hard)
- **Application Start Date**: Ngày bắt đầu ứng tuyển
- **Deadline**: Hạn chót ứng tuyển
- **Result Announcement**: Ngày công bố kết quả
- **Research Field**: Lĩnh vực nghiên cứu
- **Description**: Mô tả quỹ
- **Funding Period**: Thời gian tài trợ (Optional)
- **Funding Amount**: Số tiền tài trợ (Optional)
- **Funding Number**: Số dự án được tài trợ (Optional)
- **Important Note**: Lưu ý quan trọng (Optional)
- **Remark**: Ghi chú bổ sung (Optional)
- **Format File**: File mẫu hồ sơ (Optional)
- **Entry Example File**: File ví dụ điền (Optional)
- **Graduated Student**: Có dành cho sinh viên cao học không
- **Relevancy**: Mức độ phù hợp (AI xác định)
- **Status**: Trạng thái quỹ
- **Keyword**: Từ khóa tìm kiếm

#### 2.3 Chi Tiết Quỹ
**File:** `ST - fund detail.png`

![Chi Tiết Quỹ Staff](../ui_images/Staff/ST - fund detail.png)

Thông tin chi tiết quỹ:
- **Thông tin tổng quan**: Mô tả, yêu cầu, ngân sách
- **Danh sách đơn**: Tất cả đơn ứng tuyển cho quỹ này
- **Trạng thái đơn**: Đang xử lý, đã duyệt, từ chối
- **Reviewer**: Danh sách reviewer được phân công
- **Thống kê**: Số đơn, tỷ lệ chấp nhận

### 3. Quản Lý Đơn Ứng Tuyển

#### 3.1 Danh Sách Đơn Ứng Tuyển
**File:** `ST - Professor has submitted.png`

![Danh Sách Đơn Ứng Tuyển](../ui_images/Staff/ST - Professor has submitted.png)

Quản lý tất cả đơn ứng tuyển:
- **Danh sách đơn**: Tất cả đơn đã nhận
- **Thông tin Professor**: Tên, trường đại học, chuyên môn
- **Trạng thái đơn**: Mới, đang đánh giá, đã hoàn thành
- **Deadline**: Thời hạn đánh giá
- **Hành động**: Phân công reviewer, xem chi tiết

#### 3.2 Chi Tiết Đơn Ứng Tuyển
**File:** `ST-fund detail.png`

![Chi Tiết Đơn Ứng Tuyển](../ui_images/Staff/ST-fund detail.png)

Xem chi tiết đơn ứng tuyển:
- **Thông tin Professor**: Hồ sơ cá nhân, chuyên môn
- **Đơn ứng tuyển**: Nội dung đơn, tài liệu đính kèm
- **Lịch sử đánh giá**: Các đánh giá đã nhận
- **Trạng thái**: Tiến trình xử lý
- **Hành động**: Phân công reviewer, phê duyệt, từ chối

### 4. Quản Lý Reviewer

#### 4.1 Danh Sách Reviewer
**File:** `ST - 研究者一覧.png`

![Danh Sách Reviewer](../ui_images/Staff/ST - 研究者一覧.png)

Quản lý tất cả reviewer:
- **Danh sách reviewer**: Tất cả reviewer trong hệ thống
- **Thông tin chuyên môn**: Lĩnh vực nghiên cứu, kinh nghiệm
- **Trạng thái**: Đang hoạt động, bận, không khả dụng
- **Hiệu suất**: Số đơn đã đánh giá, thời gian trung bình
- **Hành động**: Mời đánh giá, xem hồ sơ

#### 4.2 Chi Tiết Reviewer
**File:** `ST - 研究者一覧-detail.png`

![Chi Tiết Reviewer](../ui_images/Staff/ST - 研究者一覧-detail.png)

Thông tin chi tiết reviewer:
- **Hồ sơ cá nhân**: Thông tin cơ bản, chuyên môn
- **Lịch sử đánh giá**: Các đơn đã đánh giá
- **Hiệu suất**: Thống kê đánh giá, thời gian trung bình
- **Đánh giá**: Nhận xét về chất lượng đánh giá
- **Lịch**: Lịch làm việc, thời gian khả dụng

#### 4.3 Mời Reviewer
**File:** `ST_Invite reviewer.png`

![Mời Reviewer](../ui_images/Staff/ST_Invite reviewer.png)

Mời reviewer đánh giá đơn:
- **Chọn reviewer**: Tìm reviewer phù hợp với chuyên môn
- **Gửi lời mời**: Email mời đánh giá
- **Thông tin đơn**: Tóm tắt đơn cần đánh giá
- **Deadline**: Thời hạn đánh giá
- **Theo dõi**: Trạng thái lời mời

#### 4.4 Chi Tiết Mời Reviewer
**File:** `ST_Invite reviewer.2.png`

![Chi Tiết Mời Reviewer](../ui_images/Staff/ST_Invite reviewer.2.png)

Chi tiết quy trình mời:
- **Thông tin reviewer**: Hồ sơ và chuyên môn
- **Lý do mời**: Giải thích tại sao chọn reviewer này
- **Thông tin đơn**: Chi tiết đơn cần đánh giá
- **Deadline**: Thời hạn và hướng dẫn đánh giá
- **Trạng thái**: Đã gửi, đã chấp nhận, từ chối

### 5. Hệ Thống Chat

#### 5.1 Chat Manager
**File:** `ST-CHAT-Chat manager.png`

![Chat Manager Staff](../ui_images/Staff/ST-CHAT-Chat manager.png)

Quản lý tất cả cuộc trò chuyện:
- **Danh sách chat**: Tất cả cuộc trò chuyện với Professor và Reviewer
- **Phân loại**: Chat với Professor, chat với Reviewer
- **Trạng thái**: Đang hoạt động, chờ phản hồi
- **Tìm kiếm**: Tìm cuộc trò chuyện cụ thể
- **Thông báo**: Tin nhắn mới chưa đọc

#### 5.2 Chat với Professor
**File:** `ST - fund チャット.png`

![Chat với Professor](../ui_images/Staff/ST - fund チャット.png)

Giao diện chat với Professor:
- **Lịch sử tin nhắn**: Tất cả tin nhắn đã trao đổi
- **Thông tin đơn**: Liên kết đến đơn ứng tuyển
- **Gửi tin nhắn**: Nhập và gửi tin nhắn mới
- **Tải file**: Gửi tài liệu, hướng dẫn
- **Emoji và định dạng**: Hỗ trợ emoji và định dạng

#### 5.3 Chat với Reviewer
**File:** `ST - reviewer -fund チャット.png`

![Chat với Reviewer](../ui_images/Staff/ST - reviewer -fund チャット.png)

Giao diện chat với Reviewer:
- **Thảo luận đánh giá**: Trao đổi về quá trình đánh giá
- **Hướng dẫn**: Cung cấp hướng dẫn đánh giá
- **Nhận phản hồi**: Nhận báo cáo và nhận xét
- **Theo dõi tiến trình**: Cập nhật trạng thái đánh giá

#### 5.4 Reviewer Chat Manager
**File:** `ST-Reviewer-Chat manager.png`

![Reviewer Chat Manager](../ui_images/Staff/ST-Reviewer-Chat manager.png)

Quản lý chat với reviewer:
- **Danh sách reviewer**: Tất cả reviewer đang chat
- **Trạng thái đánh giá**: Đang đánh giá, đã hoàn thành
- **Deadline**: Thời hạn đánh giá
- **Thông báo**: Tin nhắn mới từ reviewer

### 6. Quản Lý Tài Liệu Tham Khảo

#### 6.1 Đơn Ứng Tuyển Tham Khảo
**File:** `ST - 例年の参考申請書.png`

![Đơn Ứng Tuyển Tham Khảo Staff](../ui_images/Staff/ST - 例年の参考申請書.png)

Quản lý tài liệu tham khảo:
- **Danh sách đơn tham khảo**: Các đơn đã được phê duyệt
- **Phân loại**: Theo năm, lĩnh vực, trường đại học
- **Tìm kiếm**: Tìm đơn tham khảo cụ thể
- **Tải xuống**: Tải đơn để tham khảo
- **Chia sẻ**: Chia sẻ với Professor khác

#### 6.2 Bảng Đơn Tham Khảo
**File:** `Staff-Table 例年の参考申請書.png`

![Bảng Đơn Tham Khảo](../ui_images/Staff/Staff-Table 例年の参考申請書.png)

Hiển thị dạng bảng:
- **Thông tin cơ bản**: Tên quỹ, Professor, năm
- **Trạng thái**: Đã phê duyệt, đang thực hiện
- **Đánh giá**: Điểm số, nhận xét
- **Hành động**: Xem chi tiết, tải xuống

#### 6.3 Thêm Đơn Tham Khảo
**File:** `ST_ Add new Reference application form.png`

![Thêm Đơn Tham Khảo](../ui_images/Staff/ST_ Add new Reference application form.png)

Thêm đơn vào danh sách tham khảo:
- **Chọn đơn**: Chọn đơn đã được phê duyệt
- **Thông tin bổ sung**: Mô tả, ghi chú
- **Phân loại**: Gán vào danh mục tham khảo
- **Quyền truy cập**: Ai có thể xem đơn này
- **Lưu**: Thêm vào danh sách tham khảo

### 7. Quản Lý Quỹ Phụ Trách

#### 7.1 Danh Sách Quỹ Phụ Trách
**File:** `ST - 担当公募一覧.png`

![Danh Sách Quỹ Phụ Trách](../ui_images/Staff/ST - 担当公募一覧.png)

Quản lý quỹ được phân công:
- **Danh sách quỹ**: Tất cả quỹ đang phụ trách
- **Trạng thái**: Đang mở, đã đóng, tạm dừng
- **Thống kê**: Số đơn đã nhận, đang xử lý
- **Deadline**: Thời hạn quan trọng
- **Hành động**: Quản lý, chỉnh sửa

### 8. Xem Kết Quả

#### 8.1 Xem Kết Quả Đánh Giá
**File:** `ST_View results.png`

![Xem Kết Quả Đánh Giá](../ui_images/Staff/ST_View results.png)

Xem kết quả đánh giá đơn:
- **Tổng hợp đánh giá**: Điểm số từ tất cả reviewer
- **Nhận xét chi tiết**: Phản hồi từ từng reviewer
- **Khuyến nghị**: Quyết định phê duyệt hay từ chối
- **Lý do**: Giải thích quyết định
- **Thông báo**: Gửi thông báo cho Professor

### 9. Thông Tin Trường Đại Học

#### 9.1 Thông Tin Trường Đại Học
**File:** `ST-機関情報.png`

![Thông Tin Trường Đại Học](../ui_images/Staff/ST-機関情報.png)

Quản lý thông tin trường đại học:
- **Thông tin cơ bản**: Tên trường, địa chỉ, liên hệ
- **Cài đặt**: Cấu hình cho trường đại học
- **Quyền truy cập**: Ai có thể quản lý thông tin
- **Lịch sử**: Các thay đổi đã thực hiện

### 10. Menu và Điều Hướng

#### 10.1 Menu Staff
**File:** `menu-ST.png`

![Menu Staff](../ui_images/Staff/menu-ST.png)

Menu điều hướng cho Staff:
- **Dashboard**: Bảng điều khiển chính
- **Quản lý quỹ**: Tạo và quản lý quỹ
- **Đơn ứng tuyển**: Quản lý đơn từ Professor
- **Reviewer**: Quản lý reviewer
- **Chat**: Hệ thống chat
- **Tài liệu tham khảo**: Quản lý đơn tham khảo
- **Báo cáo**: Thống kê và báo cáo

### 11. Các Thành Phần UI Khác

#### 11.1 Nút Hành Động
**File:** `Action.png`

![Nút Hành Động Staff](../ui_images/Staff/Action.png)

Các nút hành động chung:
- **Tạo mới**: Tạo quỹ, mời reviewer
- **Chỉnh sửa**: Cập nhật thông tin
- **Xóa**: Xóa quỹ, reviewer
- **Phân công**: Phân công reviewer

#### 11.2 Góc Nhìn Reviewer
**File:** `Góc nhin Reiewer.png`

![Góc Nhìn Reviewer](../ui_images/Staff/Góc nhin Reiewer.png)

Giao diện xem từ góc độ reviewer:
- **Danh sách đơn cần đánh giá**: Các đơn được phân công
- **Trạng thái đánh giá**: Đã đánh giá, đang đánh giá
- **Deadline**: Thời hạn đánh giá
- **Hành động**: Bắt đầu đánh giá, xem chi tiết

## Tính Năng và Khả Năng Chính

### Quản Lý Quỹ
1. **Tạo quỹ mới**: Thiết lập quỹ tài trợ với đầy đủ thông tin
2. **Quản lý quỹ**: Chỉnh sửa, tạm dừng, đóng quỹ
3. **Theo dõi hiệu suất**: Thống kê đơn ứng tuyển, tỷ lệ chấp nhận
4. **Quản lý deadline**: Theo dõi thời hạn quan trọng

### Quản Lý Đơn Ứng Tuyển
1. **Xem danh sách đơn**: Tất cả đơn đã nhận
2. **Phân công reviewer**: Gán reviewer phù hợp
3. **Theo dõi tiến trình**: Xem trạng thái đánh giá
4. **Phê duyệt/từ chối**: Quyết định cuối cùng

### Quản Lý Reviewer
1. **Tìm reviewer**: Tìm reviewer phù hợp với chuyên môn
2. **Mời đánh giá**: Gửi lời mời đánh giá
3. **Theo dõi hiệu suất**: Đánh giá chất lượng reviewer
4. **Quản lý lịch**: Theo dõi thời gian khả dụng

### Giao Tiếp và Hỗ Trợ
1. **Chat với Professor**: Hỗ trợ và hướng dẫn
2. **Chat với Reviewer**: Trao đổi về đánh giá
3. **Gửi thông báo**: Cập nhật trạng thái
4. **Hỗ trợ kỹ thuật**: Giải đáp thắc mắc

### Quản Lý Tài Liệu
1. **Tài liệu tham khảo**: Quản lý đơn đã phê duyệt
2. **Chia sẻ tài liệu**: Chia sẻ với Professor
3. **Tìm kiếm**: Tìm tài liệu cụ thể
4. **Phân loại**: Tổ chức tài liệu theo danh mục

## Tích Hợp Hệ Thống

### Với Các Vai Trò Khác
- **Professor**: Nhận đơn ứng tuyển, hỗ trợ
- **Reviewer**: Phân công đánh giá, theo dõi
- **Admin**: Báo cáo, quản lý hệ thống

### Với Các Module Khác
- **File Management**: Quản lý tài liệu đơn ứng tuyển
- **Notification System**: Gửi thông báo cập nhật
- **Chat System**: Giao tiếp với các bên liên quan
- **Email System**: Gửi email thông báo và lời mời

## Cân Nhắc Kỹ Thuật

### Bảo Mật
- **Phân quyền**: Kiểm soát quyền truy cập theo vai trò
- **Bảo vệ dữ liệu**: Mã hóa thông tin nhạy cảm
- **Audit trail**: Ghi nhật ký hoạt động
- **Data privacy**: Bảo vệ thông tin cá nhân

### Hiệu Suất
- **Caching**: Cache danh sách quỹ và đơn ứng tuyển
- **Pagination**: Phân trang cho danh sách lớn
- **Real-time updates**: Cập nhật trạng thái real-time
- **Search optimization**: Tối ưu tìm kiếm

### Trải Nghiệm Người Dùng
- **Dashboard intuitive**: Bảng điều khiển trực quan
- **Workflow automation**: Tự động hóa quy trình
- **Bulk operations**: Thao tác hàng loạt
- **Mobile responsive**: Tương thích thiết bị di động

## Cải Tiến Tương Lai

### Tính Năng Nâng Cao
1. **AI Assignment**: Tự động phân công reviewer
2. **Workflow Automation**: Tự động hóa quy trình đánh giá
3. **Advanced Analytics**: Phân tích nâng cao hiệu suất
4. **Integration APIs**: Tích hợp với hệ thống khác

### Quản Lý Nâng Cao
1. **Multi-language Support**: Hỗ trợ đa ngôn ngữ
2. **Advanced Reporting**: Báo cáo chi tiết và tùy chỉnh
3. **Calendar Integration**: Tích hợp lịch deadline
4. **Mobile App**: Ứng dụng di động cho Staff

---

*Phân tích này dựa trên các mockup UI được cung cấp trong thư mục Staff và đại diện cho chức năng dự định cho vai trò Staff trong hệ thống quản lý quỹ.*
