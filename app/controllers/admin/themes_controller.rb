class Admin::ThemesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 관리자 인증 (관리자 인증 메서드를 구현하세요)
  before_action :set_theme, only: [:edit, :update, :destroy]

  # 테마 목록 보기 (선택사항)
  def index
    @themes = Theme.order(:name)
    @theme = Theme.new
  end

  # 새 테마 생성
  def create
    @theme = Theme.new(theme_params)
    if @theme.save
      redirect_to admin_themes_path, notice: "테마가 성공적으로 추가되었습니다."
    else
      render :new
    end
  end

  # 테마 수정 폼
  def edit
  end

  # 테마 수정 업데이트
  def update
    if @theme.update(theme_params)
      redirect_to admin_themes_path, notice: "테마가 성공적으로 수정되었습니다."
    else
      render :edit
    end
  end

  # 테마 삭제
  def destroy
    @theme.destroy
    redirect_to admin_themes_path, notice: "테마가 삭제되었습니다."
  end

  private

  def set_theme
    @theme = Theme.find(params[:id])
  end

  def theme_params
    params.require(:theme).permit(:name)
  end
end
