document.addEventListener("turbolinks:load", function() {
  // 댓글 좋아요/싫어요 버튼 클릭 시 동작
  document.querySelectorAll('.btn-link').forEach(function(button) {
    button.addEventListener('ajax:success', function(event) {
      var data = event.detail[0]; // 서버에서 반환된 JSON 데이터
      var commentId = event.target.getAttribute('data-comment_id') || event.target.getAttribute('data-reply_id');
      var likeCountElement = document.getElementById('like-count-' + commentId);
      var dislikeCountElement = document.getElementById('dislike-count-' + commentId);

      // 좋아요와 싫어요 카운트를 업데이트
      if (likeCountElement) {
        likeCountElement.innerText = data.like_count;
      }
      if (dislikeCountElement) {
        dislikeCountElement.innerText = data.dislike_count;
      }
    });
  });

  // 댓글에 대댓글 폼 보이기/숨기기
  $(document).on('click', '.reply-button', function(e) {
    e.preventDefault();
    var commentId = $(this).data('comment-id');
    $('#reply-form-' + commentId).toggle();  // 해당 댓글의 대댓글 폼 토글
  });

  // 대댓글 작성 처리
  const replyForms = document.querySelectorAll('.reply-form');
  replyForms.forEach(replyForm => {
    replyForm.addEventListener('submit', (event) => {
      event.preventDefault();
      
      const formData = new FormData(replyForm);
      const commentId = replyForm.querySelector('input[name="comment[parent_id]"]').value;
      
      fetch(replyForm.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
      .then(response => response.json())
      .then(data => {
        if (data.replyHtml) {
          const repliesList = replyForm.closest('.comment').querySelector('.replies-list');
          const newReply = document.createElement('li');
          newReply.innerHTML = data.replyHtml; // 서버에서 전달받은 새 대댓글 HTML
          repliesList.appendChild(newReply);
          replyForm.reset();
          replyForm.closest('.reply-form-container').style.display = 'none'; // 대댓글 폼 숨기기
        }
      })
      .catch(error => console.error('대댓글 작성 오류:', error));
    });
  });

  // 대댓글 삭제 처리
  document.querySelectorAll('.delete-reply').forEach(deleteButton => {
    deleteButton.addEventListener('ajax:success', function(event) {
      const data = event.detail[0]; // 서버에서 반환된 데이터
      if (data.success) {
        const replyId = event.target.getAttribute('data-reply_id');
        const replyElement = document.getElementById('reply-' + replyId);
        replyElement.remove(); // 삭제된 대댓글을 DOM에서 제거
      }
    });
  });

  // 댓글 삭제 처리
  document.querySelectorAll('.delete-comment').forEach(deleteButton => {
    deleteButton.addEventListener('click', function(event) {
      event.preventDefault();
      const commentId = deleteButton.getAttribute('data-comment_id');
      const videoId = deleteButton.getAttribute('data-video_id');

      fetch(`/videos/${videoId}/comments/${commentId}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
        }
      })
        .then((response) => {
          if (response.ok) {
            alert('댓글이 삭제되었습니다.');
            location.reload();
          } else {
            alert('댓글 삭제에 실패했습니다.');
          }
        })
        .catch((error) => console.error('Error:', error));
    });
  });
});
