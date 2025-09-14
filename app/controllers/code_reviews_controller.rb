class CodeReviewsController < ApplicationController
  before_action :development_only
  before_action :find_review_file, only: [:show]

  def index
    @reviews = ReviewFileFinder.new.grouped_reviews
  end

  def show
    @markdown_html = MarkdownRenderer.new(@review_file.path).render
    @filename = @review_file.filename
    @review_type = @review_file.display_type
  end

  private

  def development_only
    redirect_to root_path unless Rails.env.development?
  end

  def find_review_file
    @review_file = ReviewFile.find_by_filename(params[:filename])
    redirect_to_not_found unless @review_file
  end

  def redirect_to_not_found
    redirect_to code_reviews_path, alert: 'Review not found'
  end
end
