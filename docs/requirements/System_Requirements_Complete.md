# Yêu Cầu Hệ Thống Quản Lý Quỹ - Tài Liệu Hoàn Chỉnh

## Tổng Quan Hệ Thống

### Mục Đích
Hệ thống quản lý quỹ là một nền tảng toàn diện cho phép các trường đại học quản lý quy trình tìm kiếm, nộp đơn và đánh giá các cơ hội tài trợ nghiên cứu. Hệ thống hỗ trợ đầy đủ quy trình từ việc tạo quỹ, nộp đơn ứng tuyển, đánh giá đến phê duyệt cuối cùng.

### Đối Tượng Người Dùng
1. **SuperAdmin**: Quản trị viên cấp cao, quản lý toàn bộ hệ thống
2. **Admin**: Quản trị viên trường đại học, quản lý danh mục và cấu hình
3. **Staff**: Nhân viên quản lý quỹ, tạo quỹ và điều phối đánh giá
4. **Professor**: Giáo sư/nhà nghiên cứu, nộp đơn ứng tuyển
5. **Reviewer**: Người đánh giá đơn ứng tuyển

## Kiến Trúc Hệ Thống

### Các Module Chính
1. **Authentication & Authorization**: Xác thực và phân quyền
2. **User Management**: Quản lý người dùng
3. **University Management**: Quản lý trường đại học
4. **Fund Management**: Quản lý quỹ
5. **Application Management**: Quản lý đơn ứng tuyển
6. **Review Management**: Quản lý đánh giá
7. **Chat System**: Hệ thống chat
8. **File Management**: Quản lý tài liệu
9. **Notification System**: Hệ thống thông báo

## Chi Tiết Các Vai Trò

### 1. SuperAdmin Role

#### Chức Năng Chính
- **Quản lý người dùng toàn hệ thống**: Tạo, chỉnh sửa, xóa, khóa tài khoản
- **Quản lý trường đại học**: Thêm, chỉnh sửa, xóa trường đại học
- **Quản lý quỹ toàn hệ thống**: Xem và quản lý tất cả quỹ
- **Cấu hình hệ thống**: Thiết lập cài đặt toàn hệ thống
- **Giám sát và báo cáo**: Thống kê tổng hợp, audit log

#### Quyền Truy Cập
- Truy cập tất cả dữ liệu trong hệ thống
- Quản lý tất cả người dùng và trường đại học
- Cấu hình hệ thống và bảo mật

### 2. Admin Role

#### Chức Năng Chính
- **Quản lý danh mục**: Tạo, chỉnh sửa, xóa danh mục quỹ
- **Quản lý trường đại học**: Cấu hình thông tin trường
- **Giám sát quỹ**: Xem danh sách và trạng thái quỹ
- **Quản lý người dùng**: Quản lý user trong trường đại học

#### Quyền Truy Cập
- Quản lý danh mục và cấu hình trường đại học
- Xem thống kê và báo cáo của trường

### 3. Staff Role

#### Chức Năng Chính
- **Tạo và quản lý quỹ**: Tạo quỹ mới với đầy đủ thông tin
- **Quản lý đơn ứng tuyển**: Xem, phân công reviewer
- **Quản lý reviewer**: Mời, theo dõi reviewer
- **Điều phối đánh giá**: Quản lý quy trình đánh giá
- **Chat và hỗ trợ**: Giao tiếp với Professor và Reviewer

#### Quyền Truy Cập
- Tạo và quản lý quỹ trong trường đại học
- Quản lý đơn ứng tuyển và reviewer
- Truy cập hệ thống chat

### 4. Professor Role

#### Chức Năng Chính
- **Tìm kiếm quỹ**: Duyệt và tìm kiếm cơ hội tài trợ
- **Nộp đơn ứng tuyển**: Tạo và nộp đơn với tài liệu
- **Quản lý đơn**: Theo dõi trạng thái và cập nhật đơn
- **Chat và giao tiếp**: Trao đổi với Staff và Reviewer
- **Quản lý hồ sơ**: Cập nhật thông tin cá nhân

#### Quyền Truy Cập
- Xem danh sách quỹ phù hợp
- Tạo và quản lý đơn ứng tuyển
- Truy cập hệ thống chat

### 5. Reviewer Role

#### Chức Năng Chính
- **Đánh giá đơn**: Xem và đánh giá đơn ứng tuyển
- **Upload đánh giá**: Tải lên file đánh giá
- **Chat với Professor**: Trao đổi về đơn ứng tuyển
- **Quản lý deadline**: Theo dõi thời hạn đánh giá

#### Quyền Truy Cập
- Xem đơn ứng tuyển được phân công
- Upload file đánh giá
- Truy cập hệ thống chat

## Chi Tiết Quản Lý Quỹ

### Cấu Trúc Thông Tin Quỹ

#### Thông Tin Cơ Bản (Staff Input)
1. **Recruitment Requirement**: File PDF mô tả chi tiết quỹ (EN/JP)
2. **Homepage**: Đường dẫn trang chủ quỹ (Optional)
3. **Internal Deadline**: Hạn nộp nội bộ (Optional)

#### Thông Tin Tự Động (AI + Editable)
1. **Category**: Danh mục (Internal, Government, Other)
2. **Country**: Quốc gia (cho quỹ quốc tế)
3. **Organization/Foundation**: Tên tổ chức
4. **Fund Title**: Tên quỹ
5. **Program Type**: Loại chương trình
6. **Difficulty**: Độ khó (Unknown, Normal, Hard, Very Hard)
7. **Application Start Date**: Ngày bắt đầu ứng tuyển
8. **Deadline**: Hạn chót ứng tuyển
9. **Result Announcement**: Ngày công bố kết quả
10. **Research Field**: Lĩnh vực nghiên cứu
11. **Description**: Mô tả quỹ
12. **Funding Period**: Thời gian tài trợ (Optional)
13. **Funding Amount**: Số tiền tài trợ (Optional)
14. **Funding Number**: Số dự án được tài trợ (Optional)
15. **Important Note**: Lưu ý quan trọng (Optional)
16. **Remark**: Ghi chú bổ sung (Optional)
17. **Format File**: File mẫu hồ sơ (Optional)
18. **Entry Example File**: File ví dụ điền (Optional)
19. **Graduated Student**: Có dành cho sinh viên cao học không
20. **Relevancy**: Mức độ phù hợp (AI xác định)
21. **Status**: Trạng thái quỹ
22. **Keyword**: Từ khóa tìm kiếm

### Trạng Thái Quỹ (Admin/Staff)

| Trạng Thái | Mô Tả | Người Thay Đổi | Ghi Chú |
|------------|-------|----------------|---------|
| Draft | Mới tạo, chưa công bố | Staff | Trạng thái mặc định |
| Internal Public | Các giáo sư trong trường có thể thấy | Staff | 学内公開済み |
| Internal Application Period | Đang trong giai đoạn nạp hồ sơ trong trường | Auto | 学内募集期間中 |
| Internal Deadline Passed | Hạn nạp trong trường đã kết thúc | Auto | 学内締切済み |
| External Application Period | Đang trong giai đoạn nạp hồ sơ lên tổ chức fund | Auto | 学外募集期間中 |
| External Deadline Passed | Hạn nạp lên tổ chức fund đã kết thúc | Auto | 学外締切済み |
| Cancelled | Quỹ đã bị hủy | Staff | 取消済み |

## Chi Tiết Quản Lý Đơn Ứng Tuyển

### Trạng Thái Đơn Ứng Tuyển (Professor)

#### Feedback Buttons (Cho quỹ chưa nộp)
- **Will Apply**: Xác nhận sẽ nộp đơn
- **Not Apply**: Xác nhận không nộp đơn
- **Considering**: Đang cân nhắc

#### Trạng Thái Chi Tiết
1. **[Internal] Submitted (1)**: Đã nộp hồ sơ nội bộ (số thể hiện lần nộp)
2. **[Internal] Reviewer Invited**: Đã mời ít nhất 1 reviewer
3. **[Internal] Under Review**: Đang chờ reviewer gửi feedback
4. **[Internal] Ready for Resubmit**: Sẵn sàng nộp lại sau khi nhận feedback
5. **[Internal] Submitted (Final)**: Đã nộp bản cuối cùng
6. **[External] Submitted**: Đã nộp tới tổ chức fund (nếu không phải fund nội bộ)
7. **Accepted**: Đã được chấp nhận
8. **Rejected**: Đã bị từ chối

### Trạng Thái Reviewer (Cho từng Reviewer)
1. **[Internal] Reviewer Invited**: Đã mời reviewer
2. **[Internal] Under Review**: Đang chờ reviewer gửi feedback
3. **[Internal] Review Finished**: Đã nhận feedback từ reviewer
4. **[Internal] Review Cancelled**: Đã hủy review

## Chi Tiết Quản Lý Reviewer

### Trạng Thái Review (Reviewer)
1. **Invited**: Đã được mời review (có deadline)
2. **Agreed**: Đồng ý review
3. **Declined**: Không đồng ý review
4. **Review Submitted (1)**: Đã gửi kết quả review (số thể hiện lần nạp)
5. **Document Updated (2)**: Hồ sơ được sửa và gửi lại để review
6. **Document Updated (Final)**: Bản cuối và không cần review nữa

## Hệ Thống Chat

### Tính Năng Chat
- **Real-time messaging**: Tin nhắn real-time
- **File sharing**: Chia sẻ tài liệu
- **Emoji support**: Hỗ trợ emoji
- **Message history**: Lịch sử tin nhắn
- **Notification**: Thông báo tin nhắn mới

### Các Loại Chat
1. **Professor ↔ Staff**: Trao đổi về đơn ứng tuyển
2. **Professor ↔ Reviewer**: Thảo luận về đánh giá
3. **Staff ↔ Reviewer**: Hướng dẫn và nhận feedback

## Quản Lý Tài Liệu

### Loại Tài Liệu
1. **Recruitment Requirement**: File PDF mô tả quỹ
2. **Format File**: File mẫu hồ sơ
3. **Entry Example File**: File ví dụ điền
4. **Application Documents**: Tài liệu đơn ứng tuyển
5. **Review Documents**: Tài liệu đánh giá
6. **Reference Documents**: Tài liệu tham khảo

### Tính Năng File Management
- **Upload/Download**: Tải lên/tải xuống file
- **Version control**: Quản lý phiên bản
- **File preview**: Xem trước file
- **File validation**: Kiểm tra định dạng và kích thước
- **Access control**: Kiểm soát quyền truy cập

## Hệ Thống Thông Báo

### Loại Thông Báo
1. **Email notifications**: Thông báo qua email
2. **In-app notifications**: Thông báo trong ứng dụng
3. **System alerts**: Cảnh báo hệ thống
4. **Deadline reminders**: Nhắc nhở deadline

### Các Sự Kiện Thông Báo
- Đăng ký tài khoản mới
- Tạo quỹ mới
- Nộp đơn ứng tuyển
- Mời reviewer
- Nhận feedback từ reviewer
- Thay đổi trạng thái đơn
- Deadline sắp tới

## Yêu Cầu Kỹ Thuật

### Bảo Mật
1. **Authentication**: Xác thực người dùng
2. **Authorization**: Phân quyền theo vai trò
3. **Data encryption**: Mã hóa dữ liệu
4. **Audit logging**: Ghi nhật ký hoạt động
5. **Session management**: Quản lý phiên đăng nhập

### Hiệu Suất
1. **Database optimization**: Tối ưu cơ sở dữ liệu
2. **Caching**: Cache dữ liệu
3. **Pagination**: Phân trang
4. **File compression**: Nén file
5. **CDN**: Content Delivery Network

### Khả Năng Mở Rộng
1. **Multi-tenant architecture**: Kiến trúc đa người thuê
2. **Scalable database**: Cơ sở dữ liệu có thể mở rộng
3. **API management**: Quản lý API
4. **Load balancing**: Cân bằng tải

## Yêu Cầu Database

### Các Entity Chính

#### 1. Users
- **id**: Primary key
- **email**: Email đăng nhập
- **username**: Tên đăng nhập
- **password_hash**: Mật khẩu đã mã hóa
- **first_name**: Tên
- **last_name**: Họ
- **role**: Vai trò (SuperAdmin, Admin, Staff, Professor, Reviewer)
- **university_id**: ID trường đại học
- **status**: Trạng thái tài khoản
- **created_at**: Ngày tạo
- **updated_at**: Ngày cập nhật

#### 2. Universities
- **id**: Primary key
- **name**: Tên trường đại học
- **code**: Mã trường
- **address**: Địa chỉ
- **email**: Email liên hệ
- **phone**: Số điện thoại
- **website**: Website
- **logo_url**: URL logo
- **status**: Trạng thái
- **created_at**: Ngày tạo
- **updated_at**: Ngày cập nhật

#### 3. Categories
- **id**: Primary key
- **name**: Tên danh mục
- **description**: Mô tả
- **university_id**: ID trường đại học
- **created_at**: Ngày tạo
- **updated_at**: Ngày cập nhật

#### 4. Funds
- **id**: Primary key
- **code**: Mã quỹ
- **title**: Tên quỹ
- **description**: Mô tả
- **category_id**: ID danh mục
- **university_id**: ID trường đại học
- **organization**: Tổ chức cung cấp
- **country**: Quốc gia
- **program_type**: Loại chương trình
- **difficulty**: Độ khó
- **application_start_date**: Ngày bắt đầu ứng tuyển
- **deadline**: Hạn chót ứng tuyển
- **internal_deadline**: Hạn nộp nội bộ
- **result_announcement_date**: Ngày công bố kết quả
- **research_field**: Lĩnh vực nghiên cứu
- **funding_period**: Thời gian tài trợ
- **funding_amount**: Số tiền tài trợ
- **funding_number**: Số dự án được tài trợ
- **important_note**: Lưu ý quan trọng
- **remark**: Ghi chú
- **graduated_student**: Có dành cho sinh viên cao học
- **relevancy**: Mức độ phù hợp
- **status**: Trạng thái quỹ
- **keywords**: Từ khóa
- **recruitment_requirement_url**: URL file yêu cầu
- **homepage_url**: URL trang chủ
- **format_file_url**: URL file mẫu
- **example_file_url**: URL file ví dụ
- **created_by**: Người tạo
- **created_at**: Ngày tạo
- **updated_at**: Ngày cập nhật

#### 5. Applications
- **id**: Primary key
- **fund_id**: ID quỹ
- **professor_id**: ID giáo sư
- **status**: Trạng thái đơn
- **submission_count**: Số lần nộp
- **is_final**: Có phải bản cuối không
- **feedback_will_apply**: Có ý định nộp
- **feedback_not_apply**: Không có ý định nộp
- **feedback_considering**: Đang cân nhắc
- **submitted_at**: Ngày nộp
- **created_at**: Ngày tạo
- **updated_at**: Ngày cập nhật

#### 6. ApplicationDocuments
- **id**: Primary key
- **application_id**: ID đơn ứng tuyển
- **document_type**: Loại tài liệu
- **file_url**: URL file
- **file_name**: Tên file
- **file_size**: Kích thước file
- **uploaded_at**: Ngày upload
- **created_at**: Ngày tạo

#### 7. Reviewers
- **id**: Primary key
- **application_id**: ID đơn ứng tuyển
- **reviewer_id**: ID reviewer
- **status**: Trạng thái review
- **deadline**: Deadline review
- **invited_at**: Ngày mời
- **agreed_at**: Ngày đồng ý
- **declined_at**: Ngày từ chối
- **submitted_at**: Ngày nộp review
- **created_at**: Ngày tạo
- **updated_at**: Ngày cập nhật

#### 8. ReviewDocuments
- **id**: Primary key
- **reviewer_id**: ID reviewer
- **document_type**: Loại tài liệu
- **file_url**: URL file
- **file_name**: Tên file
- **file_size**: Kích thước file
- **uploaded_at**: Ngày upload
- **created_at**: Ngày tạo

#### 9. Messages
- **id**: Primary key
- **sender_id**: ID người gửi
- **receiver_id**: ID người nhận
- **application_id**: ID đơn ứng tuyển (optional)
- **content**: Nội dung tin nhắn
- **message_type**: Loại tin nhắn
- **is_read**: Đã đọc chưa
- **sent_at**: Ngày gửi
- **created_at**: Ngày tạo

#### 10. MessageAttachments
- **id**: Primary key
- **message_id**: ID tin nhắn
- **file_url**: URL file
- **file_name**: Tên file
- **file_size**: Kích thước file
- **uploaded_at**: Ngày upload
- **created_at**: Ngày tạo

#### 11. Notifications
- **id**: Primary key
- **user_id**: ID người dùng
- **type**: Loại thông báo
- **title**: Tiêu đề
- **content**: Nội dung
- **is_read**: Đã đọc chưa
- **related_id**: ID liên quan
- **sent_at**: Ngày gửi
- **created_at**: Ngày tạo

#### 12. UserProfiles
- **id**: Primary key
- **user_id**: ID người dùng
- **phone**: Số điện thoại
- **address**: Địa chỉ
- **department**: Khoa
- **position**: Chức vụ
- **research_field**: Lĩnh vực nghiên cứu
- **cv_url**: URL CV
- **avatar_url**: URL avatar
- **created_at**: Ngày tạo
- **updated_at**: Ngày cập nhật

### Relationships
1. **Users ↔ Universities**: Many-to-One
2. **Users ↔ UserProfiles**: One-to-One
3. **Universities ↔ Categories**: One-to-Many
4. **Universities ↔ Funds**: One-to-Many
5. **Categories ↔ Funds**: One-to-Many
6. **Funds ↔ Applications**: One-to-Many
7. **Users ↔ Applications**: One-to-Many (Professor)
8. **Applications ↔ ApplicationDocuments**: One-to-Many
9. **Applications ↔ Reviewers**: One-to-Many
10. **Users ↔ Reviewers**: One-to-Many (Reviewer)
11. **Reviewers ↔ ReviewDocuments**: One-to-Many
12. **Users ↔ Messages**: One-to-Many (Sender/Receiver)
13. **Messages ↔ MessageAttachments**: One-to-Many
14. **Users ↔ Notifications**: One-to-Many

### Indexes
1. **Users**: email, username, role, university_id
2. **Funds**: code, university_id, category_id, status, deadline
3. **Applications**: fund_id, professor_id, status
4. **Reviewers**: application_id, reviewer_id, status
5. **Messages**: sender_id, receiver_id, application_id
6. **Notifications**: user_id, type, is_read

## Kết Luận

Tài liệu này cung cấp cái nhìn toàn diện về yêu cầu hệ thống quản lý quỹ, bao gồm:
- Kiến trúc hệ thống và các vai trò người dùng
- Chi tiết quản lý quỹ và đơn ứng tuyển
- Trạng thái và quy trình làm việc
- Yêu cầu kỹ thuật và cấu trúc database

Tài liệu này có thể được sử dụng làm cơ sở để:
1. Thiết kế database chi tiết
2. Phát triển API và backend
3. Thiết kế giao diện người dùng
4. Lập kế hoạch triển khai và testing

---

*Tài liệu này được tạo dựa trên phân tích các mockup UI và yêu cầu nghiệp vụ chi tiết từ hệ thống quản lý quỹ.*
