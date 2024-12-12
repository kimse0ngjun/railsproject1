// 댓글 좋아요 버튼 상태 업데이트
document.getElementById("comment-like-<%= @comment.id %>").classList.toggle('liked');
