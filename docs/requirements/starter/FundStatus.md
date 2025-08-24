Fund Status				
				
1. Trạng thái fund (Admin/Staff)				
				
Trạng thái	Mô tả			
Draft	Mới tạo, chưa công bố	stt mặc định		下書き
Internal Public	Các giáo sư trong trường có thể thấy thông tin fund	Staff đổi		学内公開済み
Internal Application Period	Đang trong giai đoạn nạp hồ sơ trong trường	Auto	← bỏ	学内募集期間中
Internal Deadline Passed	Hạn nạp trong trường đã kết thúc	auto	tự động dựa trên thông tin ngày tháng / giờ của fund	学内締切済み
External Application Period	Đang trong giai đoạn nạp hồ sơ lên tổ chức fund	auto		学外募集期間中
External Deadline Passed	Hạn nạp lên tổ chức fund đã kết thúc	auto		学外締切済み
Cancelled	Quỹ đã bị hủy hoặc đống do lý do nội bộ (trạng thái này ít xảy ra)	Staff đổi		取消済み
				
2. Trạng thái fund (Giáo sư)				
				
Button & Trạng thái	Mô tả			
Will Apply	Button để feedback tới văn phòng sẽ apply fund			応募予定
Not Apply	Button để feedback tới văn phòng sẽ ko apply fund			
Considering	Button để feedback tới văn phòng đang đắn đo apply fund			検討中
				
Sau khi ấn 1 trong 3 button feedbacks ở trên thì vẫn có thể thay đổi quyết định cho tới deadline nội bộ (có 2 loại deadlines là deadline nội bộ trong trường và deadline của fund, có những fund ko có deadline nội bộ thì sẽ là null)				
Giáo sư khi thao tác upload hồ sơ lên thì dù đã ấn button nào ở trên thì trạng thái cũng sẽ chuyển thành [Internal] Submitted				
				
2.1 Trạng thái chung				
Trạng thái	Mô tả			
[Internal] Submitted (1)	Đã nạp hồ sơ nội bộ (số thể hiện lần nạp)	← Khi đã upload file thành công & bấm submit		学内提出済み
[Internal] Reviewer Invited	Đã mời ít nhất 1 reviewer			学内査読者招待済み
[Internal] Under Review	"Đang ở trạng thái chờ các reviewers gửi lại feedbacks (hiện thị cho từng reviewer)
"	→ Khi có ít nhất 1 người đồng ý thì tự động chuyển sang trạng thái này		学内査読中
[Internal] Ready for Resubmit	Sau khi trạng thái ở các reviewers chuyển thành Review Finished hoặc Review Cancelled. Sau khi nạp lại thì trạng thái lại quay lại Submitted (2)	← Tự động chuyển		学内再提出待ち
[Internal] Submitted (Final)	Mỗi lần submit hoặc resubmit thì sẽ có checkbox để đánh dấu đấy là bản cuối cùng, và không cần thiết phải review thêm nữa	← auto dựa vào checkbox bản final khi resubmit		学内最終版提出済み
[External] Submitted	Nếu không phải là fund nội bộ thì sẽ phải nạp tới tổ chức fund (tùy fund mà người nạp là giáo sư hay staff, nên status này có thể được updated by giáo sư hoặc staff)	"← thay đổi thủ công bởi staff / giáo sư
← Fund nội bộ thì k có status này"		学外提出済み
Accepted	Đã đỗ fund (status này có thể được updated by staff nếu là fund nội bộ, updated by staff hoặc giáo sư nếu là fund khác)	← thay đôổi thủ công		採択済み
Rejected	Đã trượt fund (status này có thể được updated by staff nếu là fund nội bộ, updated by staff hoặc giáo sư nếu là fund khác)	← thay đôổi thủ công		拒否済み
				
2.2 Trạng thái cho từng Reviewer		Xuất hiện ở màn hình chat		
[Internal] Reviewer Invited				学内査読者招待済み
[Internal] Under Review	"Đang ở trạng thái chờ reviewer này gửi lại feedback (hiện thị cho từng reviewer)
"			学内査読中
[Internal] Review Finished	Đã nhận feedbacks từ các reviewers (hiện thị cho từng reviewer)			学内査読完了
[Internal] Review Cancelled	Giáo sư hoặc reviewers hủy review (hiện thị cho từng reviewer)			学内査読取消済み
				
3. Trạng thái review (Reviewer)				
				
Trạng thái	Mô tả			
Invited	Đã được mời review hồ sơ (có kèm theo deadline review)	→ Tự động khi được mời		招待済み
Agreed	Đồng ý review	→ Tự động khi click link trong mail		査読承認済み
Declined	Không đồng ý review	→ Tự động khi click link trong mail		査読拒否済み
Review Submitted (1)	Đã gửi kết quả review (số thể hiện lần nạp)	→ Tự động thay đổi khi nạp feedback		査読完了 (1)
Document Updated (2)	Sau khi hồ sơ được sửa và gửi lại để review lần thiếp theo (số thể hiện lần nạp)	← Tự động chuyển theo stt của giáo sư		申請書再提出済み (2)
Document Updated (Final)	Bản cuối và không cần review nữa	← Tự động chuyển theo stt của giáo sư ← stt final		申請書提出済み (最終版)
