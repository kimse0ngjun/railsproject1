class CategoriesController < ApplicationController
  def create
    selected_category = params[:category]
    # 카테고리 값을 처리하는 로직 추가
    # 예: 카테고리 모델을 이용한 저장, 다른 작업 등
    render plain: "선택된 카테고리: #{selected_category}"
  end
end
