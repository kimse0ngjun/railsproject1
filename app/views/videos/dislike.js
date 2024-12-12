// 싫어요 카운트 업데이트
document.querySelector('.dislike-count').innerText = "<%= @video.dislike %>";

// 좋아요 버튼 상태 업데이트
document.querySelector('.like-button').classList.remove('active');

// 싫어요 버튼 상태 업데이트
document.querySelector('.dislike-button').classList.add('active');
