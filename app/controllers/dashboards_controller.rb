class DashboardsController < ApplicationController
  def show
    start_of_week = Date.current.beginning_of_week
    end_of_week   = Date.current.end_of_week
    week_range    = start_of_week..end_of_week

    collections = current_user.collections
    documents   = current_user.documents

    @collections_count            = collections.where(created_at: week_range).count
    @recent_collections           = collections.where(updated_at: week_range).order(updated_at: :desc).limit(5)
    @empty_collections_count      = collections.left_outer_joins(:documents).where(documents: { id: nil }).count

    @documents_count              = documents.where(created_at: week_range).count
    @recent_documents             = documents.includes(:collection).where(created_at: week_range).order(created_at: :desc).limit(5)
    @unprocessed_documents_count  = documents.where(processed_at: nil).count
    @recent_unprocessed_documents = documents.where(processed_at: nil).order(created_at: :desc).limit(5)
  end
end
