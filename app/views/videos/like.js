// 좋아요 카운트 업데이트
document.querySelector('.like-count').innerText = "<%= @video.likes %>";

// 싫어요 버튼 상태 업데이트
document.querySelector('.dislike-button').classList.remove('active');

// 좋아요 버튼 상태 업데이트
document.querySelector('.like-button').classList.add('active');

