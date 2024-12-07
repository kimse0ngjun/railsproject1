class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home] 
  def home
    @videos = Video.all.order(created_at: :desc).limit(10) # 최근 10개의 비디오
  end
end
