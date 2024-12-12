// 댓글 삭제
$('#comment_<%= @comment.id %>').remove();

// 대댓글 삭제
$('#reply_<%= @reply.id %>').remove();
