class Admin::ThemesController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!  # 관리자 인증 (관리자 인증 메서드를 구현하세요)
  before_action :set_theme, only: [:update, :destroy]


  def index
    @themes     = Theme.where.not(name: ["お部屋写真", "その他"])
    @edit_theme = Theme.find_by(id: params[:edit_id])
    @new_theme  = Theme.new
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

  def update
    if @theme.update(theme_params)
      redirect_to admin_themes_path, notice: "테마가 업데이트되었습니다."
    else
      @themes     = Theme.where.not(name: ["お部屋写真", "その他"])
      @edit_theme = @theme
      @new_theme  = Theme.new
      render :index
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
