// 댓글 싫어요 버튼 상태 업데이트
document.getElementById("comment-dislike-<%= @comment.id %>").classList.toggle('disliked');
