// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
// Bootstrap 관련
import $ from 'jquery';
import 'bootstrap/dist/js/bootstrap.bundle.min.js';  // 부트스트랩 JS 불러오기 (popper.js 포함)
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';  // 부트스트랩 CSS 불러오기
// jQuery는 필요하지 않으므로 주석 처리 또는 삭제
// import $ from 'jquery';  // jQuery를 먼저 import (불필요)
// 부트스트랩 JS는 bootstrap.bundle.min.js로 제대로 불러옴


import { createPopper } from '@popperjs/core';

// 다른 라이브러리나 기능이 있다면 추가로
const dropdownElementList = document.querySelectorAll('.dropdown-toggle')
const dropdownList = [...dropdownElementList].map(dropdownToggleEl => new bootstrap.Dropdown(dropdownToggleEl))
